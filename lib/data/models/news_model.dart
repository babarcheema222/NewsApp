// NewsModel represents a single news article from the News API.
class NewsModel {
  final String title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final String? author;
  final String? publishedAt;
  final String? content;
  final String? sourceName;

  // Constructor for NewsModel
  NewsModel({
    required this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.author,
    this.publishedAt,
    this.content,
    this.sourceName,
  });

  // Factory constructor to create NewsModel from JSON
  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      title: json['title'] ?? '',
      description: json['description'],
      url: json['url'],
      urlToImage: json['urlToImage'],
      author: json['author'],
      publishedAt: json['publishedAt'],
      content: json['content'],
      sourceName: json['source'] != null ? json['source']['name'] : null,
    );
  }
}
