# FinAI Backend API Integration

## Overview
This document describes the integration between the Flutter frontend and the FastAPI backend deployed on Render.

## Architecture

```
lib/
├── config/
│   └── api_config.dart          # API configuration (base URL, endpoints)
├── services/
│   └── finai_api_service.dart   # API service layer
└── features/
    └── chat/
        └── presentation/
            └── chat_page.dart   # Chat UI with API integration
```

## Setup Instructions

### 1. Configure Your Render URL

Open `lib/config/api_config.dart` and replace `YOUR_RENDER_URL_HERE` with your actual Render deployment URL:

```dart
class ApiConfig {
  static const String baseUrl = 'https://your-app.onrender.com';
  // ...
}
```

### 2. Dependencies

The following package has been added to `pubspec.yaml`:
- `http: ^1.2.0` - For making HTTP requests

Run `flutter pub get` to install (already done).

## API Service Usage

### Basic Usage

```dart
import 'package:finai/services/finai_api_service.dart';

// Create service instance
final apiService = FinAIApiService();

// Send a prompt
try {
  final response = await apiService.sendPrompt(
    prompt: 'What is my spending trend?',
  );
  print(response); // AI-generated response
} catch (e) {
  print('Error: $e');
}

// Don't forget to dispose when done
apiService.dispose();
```

### With Financial Context

```dart
final response = await apiService.sendPrompt(
  prompt: 'How can I save more money?',
  context: {
    'currency': 'USD',
    'financial_health_score': 78,
    'monthly_spending': 2450.00,
    'monthly_savings': 850.00,
    'spending_by_category': {
      'Bills': 890.00,
      'Food': 650.00,
      'Shopping': 480.00,
    },
    'recent_transactions': [
      {'merchant': 'Starbucks', 'amount': 12.50, 'category': 'Food'},
    ],
  },
);
```

## API Endpoint

### POST /generate

**Request:**
```json
{
  "prompt": "User question here",
  "context": {
    "currency": "USD",
    "monthly_spending": 2450.00,
    "financial_health_score": 78
  }
}
```

**Response (Success):**
```json
{
  "success": true,
  "response": "Based on your spending patterns...",
  "error": null
}
```

**Response (Error):**
```json
{
  "success": false,
  "response": null,
  "error": "Error message here"
}
```

## Chat Page Integration

The chat page (`lib/features/chat/presentation/chat_page.dart`) now uses the real API:

1. **User sends message** → Added to chat
2. **Loading indicator shown** → "FinAI is thinking..."
3. **API call with financial context** → Includes user's spending data
4. **Response displayed** → AI-generated message added to chat
5. **Error handling** → Graceful error messages

### Financial Context Builder

The `_buildFinancialContext()` method in `chat_page.dart` constructs the context object:

```dart
Map<String, dynamic> _buildFinancialContext(UserData userData) {
  return {
    'currency': userData.currencyCode,
    'financial_health_score': 78,
    'monthly_spending': 2450.00,
    'monthly_savings': 850.00,
    'spending_by_category': { /* ... */ },
    'recent_transactions': [ /* ... */ ],
    'user_name': userData.userName,
  };
}
```

**To integrate real data:** Replace the hardcoded values with actual data from your app:
- Pull from database/storage
- Calculate from transaction history
- Use Provider state management

## Error Handling

The API service handles multiple error types:

1. **Network Errors** - Connection issues
2. **Format Errors** - Invalid JSON response
3. **API Errors** - Backend returns `success: false`
4. **HTTP Errors** - Non-200 status codes
5. **Timeout Errors** - Request takes too long (30s timeout)

All errors are wrapped in `ApiException` with descriptive messages.

## Features

### ✅ Implemented
- Clean API service layer
- Configuration management
- Real-time chat with API
- Loading indicators
- Error handling
- Financial context passing
- Null-safe implementation
- Material 3 UI

### 🎯 Customization Points

1. **Adjust timeout:** Modify `ApiConfig.timeout` (default: 30s)
2. **Add headers:** Update `ApiConfig.headers` for authentication
3. **Enhance context:** Add more financial data in `_buildFinancialContext()`
4. **Custom error handling:** Modify error messages in chat_page.dart
5. **Retry logic:** Add retry mechanism in api_service.dart

## Testing

### Test the Integration

1. **Update the URL:**
   ```dart
   // lib/config/api_config.dart
   static const String baseUrl = 'https://your-actual-render-url.onrender.com';
   ```

2. **Run the app:**
   ```bash
   flutter run
   ```

3. **Navigate to AI Assistant tab**

4. **Send a message** and verify:
   - Loading indicator appears
   - Response comes from your backend
   - Error handling works (try with wrong URL)

### Debug Mode

To see API requests/responses, add print statements in `finai_api_service.dart`:

```dart
print('Request: $body');
print('Response: ${response.body}');
```

## Production Considerations

### Security
- Store API URL in environment variables (not in code)
- Add authentication headers if needed
- Use HTTPS only

### Performance
- Implement response caching for repeated queries
- Add request debouncing for rapid messages
- Consider pagination for long conversations

### User Experience
- Add retry button on errors
- Show network status indicator
- Implement offline mode with queued messages

## Example: Adding Authentication

If your backend requires authentication:

```dart
// lib/config/api_config.dart
static Map<String, String> headers(String? token) => {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  if (token != null) 'Authorization': 'Bearer $token',
};

// lib/services/finai_api_service.dart
final response = await _client.post(
  Uri.parse(ApiConfig.generateUrl),
  headers: ApiConfig.headers(userToken),
  body: jsonEncode(body),
);
```

## Support

If you encounter issues:
1. Check `ApiConfig.baseUrl` is correct
2. Verify backend is running on Render
3. Test endpoint with Postman/curl first
4. Check Flutter console for detailed error messages
5. Ensure `http` package is installed

---

**Ready to use!** Just add your Render URL and start chatting with your AI-powered financial advisor.
