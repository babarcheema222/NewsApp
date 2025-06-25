import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/data_sources/news_api_service.dart';
import '../../data/repositories/news_repository_impl.dart';
import '../../domain/usecases/get_news.dart';
import '../../domain/entities/news.dart';

const List<String> categories = [
  'All',
  'Sports',
  'Crypto',
  'Technology',
  'Health',
  'Business',
  'Science',
  'Entertainment',
];

// HomeScreen is the main UI for displaying news articles.
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Set up the use case and repository
  final GetNews _getNews = GetNews(NewsRepositoryImpl(NewsApiService()));

  late Future<List<News>> _newsFuture;
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _showSearch = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Fetch news when the screen loads
    _newsFuture = _getNews();
  }

  // Method to refresh news articles
  Future<void> _refreshNews() async {
    setState(() {
      _newsFuture = _getNews(query: _getQuery());
    });
  }

  String _getQuery() {
    if (_searchQuery.isNotEmpty) return _searchQuery;
    if (_selectedCategory != 'All') return _selectedCategory;
    return 'technology'; // Default
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _searchQuery = '';
      _searchController.clear();
      _newsFuture = _getNews(query: _getQuery());
    });
  }

  void _onSearchSubmitted(String value) {
    setState(() {
      _searchQuery = value.trim();
      _selectedCategory = 'All';
      _newsFuture = _getNews(query: _getQuery());
    });
  }

  @override
  Widget build(BuildContext context) {
    final Color appBarColor = const Color.fromARGB(
      255,
      23,
      11,
      148,
    ); // Deep blue for modern look
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: _showSearch
              ? TextField(
                  controller: _searchController,
                  autofocus: true,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: const InputDecoration(
                    hintText: 'Search news...',
                    hintStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                  onSubmitted: _onSearchSubmitted,
                  textInputAction: TextInputAction.search,
                )
              : const Text(
                  'Latest News',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 27,
                    color: Colors.white,

                    letterSpacing: 1.2,
                  ),
                ),
          centerTitle: true,
          backgroundColor: appBarColor,
          actions: [
            // Search button
            IconButton(
              icon: Icon(
                _showSearch ? Icons.close : Icons.search,
                color: Colors.white,
              ),
              tooltip: _showSearch ? 'Close Search' : 'Search',
              onPressed: () {
                setState(() {
                  _showSearch = !_showSearch;
                  if (!_showSearch) {
                    _searchController.clear();
                  }
                });
              },
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                color: appBarColor,
                padding: const EdgeInsets.only(
                  top: 48,
                  left: 24,
                  right: 24,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.newspaper,
                          color: Color.fromARGB(255, 159, 209, 146),
                          size: 32,
                        ),
                        SizedBox(width: 2),
                        Text(
                          'Latest News',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Stay updated with the latest headlines from around World Wide. Powered by newsapi.org',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.public),
                title: const Text(
                  'Worldwide',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                onTap: () {},
                selected: _selectedCategory == 'Worldwide',
                selectedTileColor: Colors.grey[200],
              ),
              // ListTile(
              //   leading: const Icon(Icons.flag),
              //   title: const Text(
              //     'Pakistan',
              //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              //   ),
              //   onTap: () {
              //     Navigator.pop(context);
              //     _onCategorySelected('Pakistan');
              //   },
              //   selected: _selectedCategory == 'Pakistan',
              //   selectedTileColor: Colors.grey[200],
              // ),
              const Divider(),
              // You can add more sections here
              Spacer(),
              Padding(
                padding: EdgeInsets.only(bottom: 20),
                child: Center(
                  child: RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                      children: [
                        TextSpan(text: 'Developed by '),
                        TextSpan(
                          text: "Xcite's © ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Column(
          children: [
            // Category chips
            SizedBox(
              height: 62,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                itemCount: categories.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final cat = categories[index];
                  final bool selected = cat == _selectedCategory;
                  return ChoiceChip(
                    label: Text(
                      cat,
                      style: TextStyle(
                        color: selected ? Colors.white : appBarColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    selected: selected,
                    selectedColor: appBarColor,
                    backgroundColor: const Color.fromARGB(255, 235, 232, 232),
                    showCheckmark: false,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24), // pill shape
                    ),
                    labelPadding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 2,
                    ),
                    onSelected: (_) => _onCategorySelected(cat),
                  );
                },
              ),
            ),
            // News list
            Expanded(
              child: FutureBuilder<List<News>>(
                future: _newsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    // Show a user-friendly error message and a retry button
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.red[400],
                              size: 48,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Oops!\n${snapshot.error}'.replaceAll(
                                'Exception: ',
                                '',
                              ),
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red[400],
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _refreshNews,
                            ),
                          ],
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No news found.'));
                  }
                  var newsList = snapshot.data!
                      .where(
                        (news) =>
                            news.urlToImage != null &&
                            news.urlToImage!.isNotEmpty &&
                            !(news.urlToImage!.contains('gizmodo.com')),
                      )
                      .toList();
                  // Only shuffle if a search query is active
                  if (_searchQuery.isNotEmpty) {
                    newsList.shuffle();
                  }
                  return RefreshIndicator(
                    onRefresh: _refreshNews,
                    child: ListView.separated(
                      padding: const EdgeInsets.all(16),
                      itemCount: newsList.length,
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 16),
                      itemBuilder: (context, index) {
                        final news = newsList[index];
                        return NewsCard(news: news, appBarColor: appBarColor);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// NewsCard displays a single news article in a professional card style.
class NewsCard extends StatelessWidget {
  final News news;
  final Color appBarColor;
  const NewsCard({Key? key, required this.news, required this.appBarColor})
    : super(key: key);

  // Open the article URL in the browser
  void _openArticle(BuildContext context) async {
    if (news.url != null && await canLaunch(news.url!)) {
      await launch(
        news.url!,
        forceSafariVC: false,
        forceWebView: false,
        enableJavaScript: true,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open article.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _openArticle(context), // Open article in browser
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show image if available
            if (news.urlToImage != null)
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Image.network(
                  news.urlToImage!,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  // Show a loading spinner while the image loads
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      height: 180,
                      color: Colors.grey[200],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                  // Show a placeholder if the image fails to load
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Center(child: Icon(Icons.broken_image)),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    news.title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                      color: appBarColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (news.description != null)
                    Text(
                      news.description!,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (news.sourceName != null)
                        Text(
                          news.sourceName!,
                          style: TextStyle(
                            color: appBarColor,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      if (news.publishedAt != null)
                        Text(
                          news.publishedAt!.split('T').first,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
