import 'package:cloud_firestore/cloud_firestore.dart';

class BookmarkService {
  final String userId;

  BookmarkService({required this.userId});

  // Add article to bookmarks
  Future<void> addToBookmarks(Map<String, dynamic> article) async {

    print(userId);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(article['articleId'])
        .set(article);
  }

  // Remove article from bookmarks
  Future<void> removeFromBookmarks(String articleId) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .doc(articleId)
        .delete();
  }

  // Get user's bookmarked articles
  Stream<QuerySnapshot<Map<String, dynamic>>> getBookmarkedArticles() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('bookmarks')
        .snapshots();

  }
}
