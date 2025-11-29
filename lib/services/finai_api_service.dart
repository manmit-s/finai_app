import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:finai/config/api_config.dart';

/// Exception thrown when API request fails
class ApiException implements Exception {
  final String message;
  final int? statusCode;

  ApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'ApiException: $message${statusCode != null ? ' (Status: $statusCode)' : ''}';
}

/// Service class for interacting with the FinAI backend API
class FinAIApiService {
  final http.Client _client;

  FinAIApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Sends a prompt to the backend and returns the AI-generated response
  ///
  /// [prompt] - The user's question or message
  /// [context] - Optional financial data context (e.g., spending data, account info)
  ///
  /// Returns the AI-generated response as a String
  /// Throws [ApiException] if the request fails
  Future<String> sendPrompt({
    required String prompt,
    Map<String, dynamic>? context,
  }) async {
    try {
      // Prepare request body
      final Map<String, dynamic> body = {
        'prompt': prompt,
        if (context != null) 'context': context,
      };

      // Make POST request
      final response = await _client
          .post(
            Uri.parse(ApiConfig.generateUrl),
            headers: ApiConfig.headers,
            body: jsonEncode(body),
          )
          .timeout(ApiConfig.timeout);

      // Parse response
      final Map<String, dynamic> responseData = jsonDecode(response.body);

      // Handle successful response
      if (response.statusCode == 200) {
        final bool success = responseData['success'] ?? false;

        if (success) {
          final String? aiResponse = responseData['response'];

          if (aiResponse != null && aiResponse.isNotEmpty) {
            return aiResponse;
          } else {
            throw ApiException('Empty response received from API');
          }
        } else {
          // API returned success: false
          final String? error = responseData['error'];
          throw ApiException(error ?? 'Request failed without error message');
        }
      } else {
        // Non-200 status code
        throw ApiException(
          'Server error: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      throw ApiException('Network error: ${e.message}');
    } on FormatException catch (e) {
      throw ApiException('Invalid response format: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Unexpected error: $e');
    }
  }

  /// Disposes the HTTP client
  void dispose() {
    _client.close();
  }
}
