import 'package:flutter/material.dart';

import '../../domain/models/aim_academy_model.dart';

class AimAcademyViewModel extends ChangeNotifier {
  final List<VideoModel> _videos = [
    VideoModel(
      thumbnailUrl: 'https://via.placeholder.com/80x60',
      title: 'Title of the Video',
      videoUrl: 'https://example.com/video1',
    ),
    VideoModel(
      thumbnailUrl: 'https://via.placeholder.com/80x60',
      title: 'Title of the Video',
      videoUrl: 'https://example.com/video2',
    ),
    // Add more videos as needed
  ];

  List<VideoModel> get videos => _videos;
}
