import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/news_model.dart';

// NewsApiService handles fetching news data from the News API.
class NewsApiService {
  // Your News API key
  static const String _apiKey = '24d157bc7ae846809c60de028feddeed';
  // Base URL for the News API
  static const String _baseUrl = 'https://newsapi.org/v2/everything';

  // Fetches news articles based on a query (e.g., 'technology')
  Future<List<NewsModel>> fetchNews({String query = 'technology'}) async {
    final url = Uri.parse('$_baseUrl?q=$query&apiKey=$_apiKey&pageSize=20');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data == null || data['articles'] == null) {
          throw Exception('Malformed response from server.');
        }
        final List articles = data['articles'];
        // Map each article JSON to a NewsModel
        return articles.map((json) => NewsModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Invalid API key or unauthorized access.');
      } else if (response.statusCode == 429) {
        throw Exception('API rate limit exceeded. Please try again later.');
      } else {
        // If the API call was not successful, throw an error with details
        throw Exception(
          'Failed to load news: ${response.statusCode} ${response.reasonPhrase}',
        );
      }
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } on FormatException {
      throw Exception('Bad response format.');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
