import 'package:cached_network_image/cached_network_image.dart';
import 'package:cometnews/auth.dart';
import 'package:flutter/material.dart';

import '../components/bookmarkservice.dart';

class NewsDetailsScreen extends StatefulWidget {
  final dynamic article;

  const NewsDetailsScreen({super.key, required this.article});

  @override
  State<NewsDetailsScreen> createState() => _NewsDetailsScreenState();
}

class _NewsDetailsScreenState extends State<NewsDetailsScreen> {
  bool isBookmarked = false;

  void toggleBookmark() async {
    if (isBookmarked) {
      // If the article is already bookmarked, remove it from bookmarks
      try {
        await BookmarkService(userId: Auth().currentUser!.uid)
            .removeFromBookmarks(widget.article['articleId']);
        setState(() {
          isBookmarked = false;
        });
      } catch (e) {
        print('Error removing article from bookmarks: $e');
      }
    } else {
      // If the article is not bookmarked, add it to bookmarks
      try {
        await BookmarkService(userId: Auth().currentUser!.uid)
            .addToBookmarks(widget.article);
        setState(() {
          isBookmarked = true;
        });
      } catch (e) {
        print('Error adding article to bookmarks: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Details'),
        actions: [
          IconButton(
            icon: Icon(isBookmarked ? Icons.bookmark : Icons.bookmark_border),
            onPressed: toggleBookmark,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (widget.article['urlToImage'] != null)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(
                      widget.article['urlToImage'],
                    ),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            const SizedBox(height: 16),
            Text(
              widget.article['title'] ?? 'No title available',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Author: ${widget.article['author'] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              widget.article['description'] ?? 'No description available',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
