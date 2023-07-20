import 'dart:convert';
import 'package:cometnews/auth.dart';
import 'package:cometnews/screens/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import '../components/utils.dart';
import 'mybookmarks.dart';
import 'news_detail_screen.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> news = [];
  List<dynamic> filteredNews = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  late String userId ;

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    try {
      var response = await http.get(Uri.parse('https://newsapi.org/v2/top-headlines?country=in&apiKey=4845725d3676429c960bf154b42a8321'));
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        setState(() {
          userId = Auth().currentUser!.uid;
          news = jsonData['articles'];
          news.sort((a, b) => DateTime.parse(b['publishedAt'])
              .compareTo(DateTime.parse(a['publishedAt'])));
          filteredNews = List.from(news);
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch news');
      }
    } catch (error) {
      print('Error: $error');
      throw Exception('Failed to fetch news');
    }
  }

  void showNewsDetails(dynamic article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailsScreen(article: article),
      ),
    );
  }

  void filterNews(String keyword) {
    setState(() {
      filteredNews = news.where((article) {
        String title = article['title'] ?? '';
        String description = article['description'] ?? '';
        return title.toLowerCase().contains(keyword.toLowerCase()) ||
            description.toLowerCase().contains(keyword.toLowerCase());
      }).toList();
    });
  }

  void navigateToMyBookmarks(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MyBookmarksScreen(userId: Auth().currentUser!.uid),
      ),
    );
  }

  void navigateToProfile(BuildContext context) {
    final String email = Auth().currentUser?.email ?? 'N/A'; // Provide a default email value if currentUser is null
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProfileScreen(email: email),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Latest News'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => navigateToProfile(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchNews,
          ),
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () => navigateToMyBookmarks(context),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: TextField(
                  controller: searchController,
                  decoration: const InputDecoration(
                    labelText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: filterNews,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredNews.length,
                  itemBuilder: (context, index) {
                    var article = filteredNews[index];
                    return GestureDetector(
                      onTap: () => showNewsDetails(article),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                if (article['urlToImage'] != null)
                                  CachedNetworkImage(
                                    imageUrl: article['urlToImage'],
                                    fit: BoxFit.cover,
                                    height: 200,
                                    placeholder: (context, url) => const CircularProgressIndicator(),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                const SizedBox(height: 8),
                                Text(
                                  article['title'] ?? 'No title available',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Published on ${formatDate(article['publishedAt'])} at ${formatTime(article['publishedAt'])}',
                                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
    );
  }
}

