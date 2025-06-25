import '../entities/news.dart';

// NewsRepository defines the contract for fetching news articles.
// The data layer will implement this interface.
abstract class NewsRepository {
  // Returns a list of news articles, optionally filtered by query.
  Future<List<News>> getNews({String query});
}
