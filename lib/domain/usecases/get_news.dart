import '../entities/news.dart';
import '../repositories/news_repository.dart';

// GetNews use case encapsulates the logic for fetching news articles.
class GetNews {
  final NewsRepository repository;

  // Constructor takes a NewsRepository implementation.
  GetNews(this.repository);

  // Call method to execute the use case.
  Future<List<News>> call({String query = 'technology'}) {
    return repository.getNews(query: query);
  }
}
