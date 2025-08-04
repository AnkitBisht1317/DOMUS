import 'package:flutter/material.dart';

class Bookmark extends StatefulWidget {
  const Bookmark({super.key});

  @override
  State<Bookmark> createState() => _BookmarkState();
}

class _BookmarkState extends State<Bookmark> {
  bool _isBookmarked = false;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
        color: Colors.white,
      ),
      onPressed: () {
        // Toggle bookmark state
        setState(() {
          _isBookmarked = !_isBookmarked;
        });
        // No snackbar message as per requirement
      },
    );
  }
}
