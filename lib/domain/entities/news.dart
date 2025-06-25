// News entity represents the core data structure for a news article in the domain layer.
// This is a pure Dart class, independent of any external packages or data sources.
class News {
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? author;
  final String? publishedAt;
  final String? content;
  final String? sourceName;

  // Constructor for News entity
  News({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.author,
    this.publishedAt,
    this.content,
    this.sourceName,
  });
}
