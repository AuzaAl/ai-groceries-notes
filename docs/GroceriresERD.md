

# **Product Requirements Document (PRD): GroceryNotes Backend & Architecture**

**Project Name:** GroceryNotes – AI-Powered Grocery & Recipe Manager  
**Platform:** Backend Services (Firebase Cloud Functions, Firestore, Firebase Auth)  
**Version:** 1.0.0  
**Document Status:** Approved for Development

## **1\. Executive Summary**

GroceryNotes relies on a robust backend to handle AI-driven ingredient extraction, offline-first data synchronization, and automated daily data archiving. The backend architecture is entirely serverless, utilizing Firebase Firestore for real-time document storage and Node.js Cloud Functions to securely bridge the frontend with the Google Gemini AI API and external web scraping tasks.

## **2\. Backend System Architecture**

* **Database:** Firebase Firestore (NoSQL Document Store).  
* **Authentication:** Firebase Auth (Google Sign-In provider).  
* **Microservices:** Firebase Cloud Functions (Node.js).  
* **AI Engine:** Google Gemini 1.5 Flash API (Accessed strictly via Cloud Functions).  
* **External APIs:** YouTube Data API v3, TheMealDB API.

## **3\. Data Architecture & ERD**

Meskipun Firestore adalah database NoSQL, ERD berikut memvisualisasikan bentuk data (data shape) dan relasi logis antar koleksi (Collections) dan sub-koleksi (Sub-collections) untuk memudahkan pemahaman developer.

Code snippet  
erDiagram  
    USERS ||--o| TODAY\_NOTE : "has active (Sub-collection)"  
    USERS ||--o{ ARCHIVED\_NOTE : "archives (Sub-collection)"  
    USERS ||--o{ INGREDIENT\_HISTORY : "tracks (Sub-collection)"  
    TODAY\_NOTE ||--o{ GROCERY\_ITEM : "contains (Array of Maps)"  
    ARCHIVED\_NOTE ||--o{ GROCERY\_ITEM : "contains (Array of Maps)"

    USERS {  
        string uid PK "Firebase Auth ID"  
        string email  
        string displayName  
        string photoUrl  
        timestamp createdAt  
        string themeMode  
    }

    TODAY\_NOTE {  
        string id PK "Always 'active'"  
        string date "ISO String"  
        string status "always 'active'"  
        string recipeTitle  
        string recipeUrl  
        timestamp createdAt  
        timestamp updatedAt  
    }

    ARCHIVED\_NOTE {  
        string id PK "Auto-generated"  
        string date "ISO String"  
        string status "always 'archived'"  
        string source "ai | manual | mixed"  
        string recipeTitle  
        string recipeUrl  
        float completionRate "0.0 to 1.0"  
        timestamp archivedAt  
    }

    GROCERY\_ITEM {  
        string id "UUID"  
        string name   
        float quantity   
        string unit   
        string category   
        string notes   
        boolean isChecked   
        timestamp addedAt   
        string source "ai | manual | recipe"  
    }

    INGREDIENT\_HISTORY {  
        string id PK "Auto-generated"  
        string name   
        string category   
        int useCount   
        timestamp lastUsed   
    }

    RECIPES {  
        string id PK "Global Collection"  
        string title  
        string thumbnail  
        string category  
        int cookingTime  
        array ingredients  
        array steps  
        string sourceUrl  
        boolean isActive  
    }

### **Firestore Implementation Notes**

* GROCERY\_ITEM is not a standalone collection. It must be implemented as an Array of Maps inside both the TODAY\_NOTE and ARCHIVED\_NOTE documents.  
* Data synchronization logic must resolve conflicts using a "last-write-wins" strategy based on the updatedAt timestamp to support the frontend's offline-first Hive implementation.

## **4\. Cloud Functions & API Specifications**

The backend developer must implement the following serverless endpoints to securely process data without exposing API keys to the client application.

### **4.1. AI Extraction Endpoint: /extractIngredients**

* **Method:** POST  
* **Description:** Processes a YouTube or Blog URL, extracts the textual content, and utilizes the Gemini API to return a structured JSON array of ingredients.  
* **Request Body:**  
  JSON  
  {  
    "url": "https://...",  
    "userId": "string"  
  }

* **Backend Logic:**  
  1. Verify user authentication token.  
  2. Check user rate limits (Max 10 AI requests/day per user).  
  3. If URL is YouTube: Call YouTube Data API for transcript/description.  
  4. If URL is a Blog: Use cheerio or puppeteer (headless browser) to scrape raw HTML body text.  
  5. Construct Gemini Prompt demanding strict JSON output.  
  6. Parse Gemini response and normalize units/categories.  
* **Success Response (200 OK):**  
  JSON  
  {  
    "success": true,  
    "recipeTitle": "Ayam Goreng Mentega",  
    "recipeUrl": "https://...",  
    "ingredients": \[  
      { "name": "Ayam", "quantity": 500, "unit": "gram", "category": "Daging & Seafood" }  
    \]  
  }

* **Error Responses (4xx/5xx):** Must return specific error codes (no\_recipe\_detected, timeout, no\_transcript, network\_error) for the frontend to render the correct fallback UI.

### **4.2. Text Manual Extraction: /extractIngredientsFromText**

* **Method:** POST  
* **Description:** Fallback endpoint. Bypasses the scraping layer and sends user-provided raw text directly to the Gemini API.  
* **Request Body:** {"text": "...", "userId": "string"}  
* **Response:** Identical to /extractIngredients.

## **5\. Background Services & Cron Jobs**

### **5.1. Daily Archive Scheduler**

* **Trigger:** Scheduled Cloud Function (Pub/Sub) running daily at 00:00 WIB (or device local time via client trigger if preferred).  
* **Task:**  
  1. Query all users who have an active document in today\_note where the date does not match the current date.  
  2. Calculate the completionRate (checked items / total items).  
  3. Copy the data, generate a new document in the notes sub-collection with status archived.  
  4. Delete the document from today\_note/active to reset the user's checklist for the new day.

## **6\. Security, Rules, & Rate Limiting**

* **Firestore Security Rules:** Must strictly lock down data per user.  
  JavaScript  
  match /users/{userId}/{document\=\*\*} {  
    allow read, write: if request.auth \!= null && request.auth.uid \== userId;  
  }  
  match /recipes/{recipeId} {  
    allow read: if request.auth \!= null;  
    allow write: if false; // Admin only  
  }

* **API Key Management:** Gemini, YouTube, and TheMealDB API keys must be stored in Google Cloud Secret Manager or Firebase Environment Variables. They must never be hardcoded in the repository.  
* **Rate Limiting:** Implement a Firestore counter or Redis instance to track /extractIngredients usage to prevent Gemini API billing abuse.