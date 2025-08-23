import 'package:flutter/material.dart';

class LecturePlayerViewModel extends ChangeNotifier {
  bool _isPlaying = false;
  bool _isMuted = false;
  bool _isBookmarked = false;
  double _currentProgress = 0.0;
  Duration _totalDuration = const Duration(minutes: 1, seconds: 15);
  Duration _currentPosition = Duration.zero;

  // Getters
  bool get isPlaying => _isPlaying;
  bool get isMuted => _isMuted;
  bool get isBookmarked => _isBookmarked;
  double get currentProgress => _currentProgress;
  Duration get totalDuration => _totalDuration;
  Duration get currentPosition => _currentPosition;

  // Initialize with lecture data
  void initWithLecture({
    required String duration,
    required double progress,
    bool isBookmarked = false,
  }) {
    _totalDuration = _parseDuration(duration);
    _currentProgress = progress;
    _currentPosition = Duration(seconds: (progress * _totalDuration.inSeconds).round());
    _isBookmarked = isBookmarked;
    notifyListeners();
  }

  // Toggle play/pause
  void togglePlay() {
    _isPlaying = !_isPlaying;
    notifyListeners();
    
    // If playing, start a timer to update progress
    if (_isPlaying) {
      _simulatePlayback();
    }
  }

  // Toggle mute
  void toggleMute() {
    _isMuted = !_isMuted;
    notifyListeners();
  }

  // Toggle bookmark
  void toggleBookmark() {
    _isBookmarked = !_isBookmarked;
    notifyListeners();
    
    // Here you would typically save the bookmark status to a database or shared preferences
  }

  // Seek to position
  void seekTo(double progress) {
    _currentProgress = progress;
    _currentPosition = Duration(seconds: (progress * _totalDuration.inSeconds).round());
    notifyListeners();
  }

  // Skip forward
  void skipForward() {
    final newPosition = _currentPosition + const Duration(seconds: 10);
    if (newPosition < _totalDuration) {
      _currentPosition = newPosition;
      _currentProgress = _currentPosition.inSeconds / _totalDuration.inSeconds;
    } else {
      _currentPosition = _totalDuration;
      _currentProgress = 1.0;
    }
    notifyListeners();
  }

  // Skip backward
  void skipBackward() {
    final newPosition = _currentPosition - const Duration(seconds: 10);
    if (newPosition > Duration.zero) {
      _currentPosition = newPosition;
      _currentProgress = _currentPosition.inSeconds / _totalDuration.inSeconds;
    } else {
      _currentPosition = Duration.zero;
      _currentProgress = 0.0;
    }
    notifyListeners();
  }

  // Helper method to parse duration string
  Duration _parseDuration(String durationString) {
    List<String> parts = durationString.split(':');
    if (parts.length == 3) {
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2]),
      );
    } else if (parts.length == 2) {
      return Duration(
        minutes: int.parse(parts[0]),
        seconds: int.parse(parts[1]),
      );
    }
    return const Duration(minutes: 1, seconds: 15);
  }

  // Simulate playback (in a real app, this would be handled by the video player)
  void _simulatePlayback() {
    // This is just a simulation for demo purposes
    // In a real app, you would connect to an actual video player
    Future.delayed(const Duration(seconds: 1), () {
      if (_isPlaying && _currentProgress < 1.0) {
        // Increment by a small amount
        final increment = 1.0 / _totalDuration.inSeconds;
        _currentProgress = _currentProgress + increment;
        _currentPosition = Duration(seconds: (_currentProgress * _totalDuration.inSeconds).round());
        
        if (_currentProgress >= 1.0) {
          _currentProgress = 1.0;
          _isPlaying = false;
        }
        
        notifyListeners();
        
        // Continue simulation if still playing
        if (_isPlaying) {
          _simulatePlayback();
        }
      }
    });
  }

  // Format duration for display
  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    if (duration.inHours > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    }
    return '$twoDigitMinutes:$twoDigitSeconds';
  }
}