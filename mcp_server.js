const readline = require('readline');

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: false
});

rl.on('line', (line) => {
  // Strip BOM (Byte Order Mark) if present (common on Windows)
  if (line.charCodeAt(0) === 0xFEFF) {
    line = line.slice(1);
  }
  if (!line.trim()) return;
  try {
    const request = JSON.parse(line);
    const response = handleRequest(request);
    if (response) {
      process.stdout.write(JSON.stringify(response) + '\n');
    }
  } catch (err) {
    // Send error logs to stderr so they don't corrupt stdout JSON-RPC stream
    console.error('Error parsing line:', err);
  }
});

function handleRequest(req) {
  if (req.id === undefined) {
    return null;
  }

  const response = {
    jsonrpc: '2.0',
    id: req.id
  };

  switch (req.method) {
    case 'initialize':
      response.result = {
        protocolVersion: '2024-11-05',
        capabilities: {
          tools: {}
        },
        serverInfo: {
          name: 'local-dummy-mcp',
          version: '1.0.0'
        }
      };
      break;

    case 'tools/list':
      response.result = {
        tools: [
          {
            name: 'dummy_tool',
            description: 'Dummy tool untuk testing MCP lokal.',
            inputSchema: {
              type: 'object',
              properties: {
                input: {
                  type: 'string',
                  description: 'Input teks sembarang'
                }
              },
              required: ['input']
            }
          }
        ]
      };
      break;

    case 'tools/call':
      if (req.params.name === 'dummy_tool') {
        const inputVal = req.params.arguments?.input || 'kosong';
        response.result = {
          content: [
            {
              type: 'text',
              text: `Halo dari MCP dummy! Input Anda: "${inputVal}"`
            }
          ]
        };
      } else {
        response.error = {
          code: -32601,
          message: `Tool ${req.params.name} tidak ditemukan`
        };
      }
      break;

    default:
      response.error = {
        code: -32601,
        message: `Method ${req.method} tidak ditemukan`
      };
  }

  return response;
}
