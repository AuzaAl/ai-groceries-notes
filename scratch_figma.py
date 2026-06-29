import sys
import json
import subprocess
import time
import threading

def read_responses(process, queue):
    while True:
        line = process.stdout.readline()
        if not line:
            sys.stderr.write("SERVER STDOUT CLOSED\n")
            break
        sys.stderr.write(f"SERVER STDOUT: {line.decode('utf-8')}\n")
        try:
            msg = json.loads(line.decode('utf-8'))
            queue.append(msg)
        except Exception as e:
            sys.stderr.write(f"Error parsing line: {e}\n")

def main():
    if len(sys.argv) < 2:
        print("Usage: python scratch_figma.py <tool_name> [args_json_string]")
        sys.exit(1)
        
    tool_name = sys.argv[1]
    tool_args = {}
    if len(sys.argv) > 2:
        try:
            tool_args = json.loads(sys.argv[2])
        except Exception as e:
            print(f"Error parsing JSON arguments: {e}")
            sys.exit(1)

    # Spawn the process
    cmd = "npx -y @vkhanhqui/figma-mcp-go@latest"
    sys.stderr.write(f"Starting server: {cmd}\n")
    
    process = subprocess.Popen(
        cmd,
        stdin=subprocess.PIPE,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        bufsize=0,
        shell=True
    )
    
    # Read stderr in a separate thread to avoid blocking
    def log_stderr():
        while True:
            line = process.stderr.readline()
            if not line:
                sys.stderr.write("SERVER STDERR CLOSED\n")
                break
            sys.stderr.write(f"SERVER STDERR: {line.decode('utf-8')}")
            
    t_err = threading.Thread(target=log_stderr, daemon=True)
    t_err.start()
    
    responses = []
    t_out = threading.Thread(target=read_responses, args=(process, responses), daemon=True)
    t_out.start()
    
    sys.stderr.write("Sleeping 10s for server startup...\n")
    time.sleep(10) # Wait for startup
    
    # 1. Initialize
    init_msg = {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
            "protocolVersion": "2024-11-05",
            "capabilities": {},
            "clientInfo": {
                "name": "python-mcp-client",
                "version": "1.0"
            }
        }
    }
    
    sys.stderr.write("Sending initialize request...\n")
    process.stdin.write((json.dumps(init_msg) + "\n").encode('utf-8'))
    process.stdin.flush()
    
    time.sleep(2)
    
    # 2. Initialized Notification
    initialized_notification = {
        "jsonrpc": "2.0",
        "method": "notifications/initialized"
    }
    sys.stderr.write("Sending initialized notification...\n")
    process.stdin.write((json.dumps(initialized_notification) + "\n").encode('utf-8'))
    process.stdin.flush()
    
    time.sleep(1)
    
    # 3. Call Tool
    call_msg = {
        "jsonrpc": "2.0",
        "id": 2,
        "method": "tools/call",
        "params": {
            "name": tool_name,
            "arguments": tool_args
        }
    }
    sys.stderr.write(f"Calling tool: {tool_name} with {json.dumps(tool_args)}\n")
    process.stdin.write((json.dumps(call_msg) + "\n").encode('utf-8'))
    process.stdin.flush()
    
    # Wait for responses
    time.sleep(5)
    
    # Terminate process gently
    process.terminate()
    
    # Print the tool execution result
    found = False
    for r in responses:
        if r.get("id") == 2:
            print(json.dumps(r.get("result"), indent=2))
            found = True
            break
            
    if not found:
        print("No response received for the tool call. Responses received:")
        print(json.dumps(responses, indent=2))

if __name__ == "__main__":
    main()
