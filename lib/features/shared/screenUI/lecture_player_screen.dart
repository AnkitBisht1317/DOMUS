import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/ntet/presentation/viewmodels/lecture_player_view_model.dart';

class LecturePlayerScreen extends StatelessWidget {
  final String title;
  final String batchName;
  final String duration;
  final double progress;

  const LecturePlayerScreen({
    Key? key,
    required this.title,
    required this.batchName,
    required this.duration,
    required this.progress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) {
        final viewModel = LecturePlayerViewModel();
        viewModel.initWithLecture(
          duration: duration,
          progress: progress,
        );
        return viewModel;
      },
      child: _LecturePlayerContent(
        title: title,
        batchName: batchName,
      ),
    );
  }
}

class _LecturePlayerContent extends StatefulWidget {
  final String title;
  final String batchName;
  
  const _LecturePlayerContent({
    required this.title,
    required this.batchName,
  });

  @override
  State<_LecturePlayerContent> createState() => _LecturePlayerContentState();
}

class _LecturePlayerContentState extends State<_LecturePlayerContent> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _handleVideoTap() {
    setState(() {
      _showControls = !_showControls;
      if (_showControls) {
        _startHideControlsTimer();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<LecturePlayerViewModel>(context);
    
    // When video is playing and controls should be hidden
    if (viewModel.isPlaying && !_showControls) {
      _hideControlsTimer?.cancel();
    } else if (_showControls) {
      // Reset timer when controls are shown
      _startHideControlsTimer();
    }
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF002147), // Default blue color for notification bar
        toolbarHeight: 0,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Video player area with controls
              _buildVideoPlayer(context, viewModel, widget.title, widget.batchName),
              
              // Title and bookmark
              _buildTitleSection(context, viewModel, widget.title, widget.batchName),
              
              // Bottom buttons
              _buildActionButtons(),
              
              // Extra space at bottom for scrolling
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildVideoPlayer(BuildContext context, LecturePlayerViewModel viewModel, String title, String batchName) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onTap: _handleVideoTap,
          child: Container(
            color: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top bar with back button, title, and actions
                AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'from ${widget.batchName}',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, color: Colors.white),
                          onPressed: () {},
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: Icon(
                            viewModel.isMuted ? Icons.volume_off : Icons.volume_up, 
                            color: Colors.white
                          ),
                          onPressed: viewModel.toggleMute,
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.settings, color: Colors.white),
                          onPressed: () {},
                          iconSize: 20,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Video player content
                AspectRatio(
                  aspectRatio: 16 / 3, // Increased aspect ratio to make it shorter
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Video content would go here
                        
                        // Controls overlay - positioned in the center with padding
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: AnimatedOpacity(
                              opacity: _showControls ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Previous button
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.skip_previous, color: Colors.white),
                                      onPressed: viewModel.skipBackward,
                                      iconSize: 24,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Play/Pause button
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: IconButton(
                                      icon: Icon(
                                        viewModel.isPlaying ? Icons.pause : Icons.play_arrow,
                                        color: Colors.white
                                      ),
                                      onPressed: () {
                                        viewModel.togglePlay();
                                        if (viewModel.isPlaying) {
                                          _startHideControlsTimer();
                                        } else {
                                          setState(() {
                                            _showControls = true;
                                          });
                                        }
                                      },
                                      iconSize: 24,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  // Next button
                                  Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(color: Colors.white, width: 2),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.skip_next, color: Colors.white),
                                      onPressed: viewModel.skipForward,
                                      iconSize: 24,
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(
                                        minWidth: 40,
                                        minHeight: 40,
                                      ),
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
                ),
                
                // Progress bar and time
                AnimatedOpacity(
                  opacity: _showControls ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 300),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                viewModel.formatDuration(viewModel.currentPosition),
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                              IconButton(
                                icon: const Icon(Icons.fullscreen, color: Colors.white),
                                onPressed: () {},
                                iconSize: 20,
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                            ],
                          ),
                        ),
                        SliderTheme(
                          data: SliderThemeData(
                            thumbColor: Colors.blue,
                            activeTrackColor: Colors.blue,
                            inactiveTrackColor: Colors.grey[700],
                            trackHeight: 4.0,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                          ),
                          child: Slider(
                            value: viewModel.currentProgress,
                            onChanged: viewModel.seekTo,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildTitleSection(BuildContext context, LecturePlayerViewModel viewModel, String title, String batchName) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'from $batchName',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              viewModel.isBookmarked ? Icons.bookmark : Icons.bookmark_border, 
              color: Colors.black
            ),
            onPressed: viewModel.toggleBookmark,
          ),
        ],
      ),
    );
  }
  
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildActionButton('Chat Room'),
          _buildActionButton('Doubt'),
          _buildActionButton('Feedback'),
          _buildActionButton('Report'),
        ],
      ),
    );
  }
  
  Widget _buildActionButton(String label) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Text(
          label,
          style: const TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}