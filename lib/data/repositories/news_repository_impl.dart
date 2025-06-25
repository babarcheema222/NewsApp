import '../../domain/entities/news.dart';
import '../../domain/repositories/news_repository.dart';
import '../data_sources/news_api_service.dart';
import '../models/news_model.dart';

// NewsRepositoryImpl implements the NewsRepository contract.
// It fetches data from the NewsApiService and maps NewsModel to News entity.
class NewsRepositoryImpl implements NewsRepository {
  final NewsApiService apiService;

  // Constructor takes an instance of NewsApiService
  NewsRepositoryImpl(this.apiService);

  @override
  Future<List<News>> getNews({String query = 'technology'}) async {
    // Fetch raw NewsModel list from the API service
    final List<NewsModel> newsModels = await apiService.fetchNews(query: query);
    // Map NewsModel to News entity for the domain layer
    return newsModels
        .map(
          (model) => News(
            title: model.title,
            description: model.description,
            url: model.url,
            urlToImage: model.urlToImage,
            author: model.author,
            publishedAt: model.publishedAt,
            content: model.content,
            sourceName: model.sourceName,
          ),
        )
        .toList();
  }
}
