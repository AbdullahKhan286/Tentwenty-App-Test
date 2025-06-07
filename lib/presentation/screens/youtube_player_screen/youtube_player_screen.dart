import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:tentwenty_app_test/config/constants/colors.dart';
import 'package:tentwenty_app_test/presentation/custom/custom_text/custom_text.dart';

import '../../../model/movie_detail_model.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoId;
  final String videoTitle;

  const VideoPlayerScreen({
    super.key,
    required this.videoId,
    required this.videoTitle,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;
  bool _showControls = true;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
    _setOrientation();
  }

  void _initializePlayer() {
    _controller = YoutubePlayerController(
      initialVideoId: widget.videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
        showLiveFullscreenButton: false,
      ),
    );

    _controller.addListener(_playerListener);
  }

  void _playerListener() {
    if (_controller.value.isReady && !_isPlayerReady) {
      setState(() {
        _isPlayerReady = true;
      });
    }

    // Auto-close when video ends
    if (_controller.value.playerState == PlayerState.ended) {
      _closePlayer();
    }
  }

  void _setOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  void _resetOrientation() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  void _closePlayer() {
    _resetOrientation();
    Navigator.of(context).pop();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    // Auto-hide controls after 3 seconds
    if (_showControls) {
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (state, result) {
        if (state) {
          _closePlayer();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: GestureDetector(
          onTap: _toggleControls,
          child: Stack(
            children: [
              // Video Player
              Center(
                child: _isPlayerReady
                    ? YoutubePlayer(
                        controller: _controller,
                        showVideoProgressIndicator: true,
                        progressIndicatorColor: AppColors.skyBlue,
                        progressColors: ProgressBarColors(
                          playedColor: AppColors.skyBlue,
                          handleColor: AppColors.skyBlue,
                          bufferedColor: AppColors.lightSilver,
                          backgroundColor: AppColors.silverGray,
                        ),
                        onReady: () {
                          setState(() {
                            _isPlayerReady = true;
                          });
                        },
                      )
                    : Container(
                        color: Colors.black,
                        child: Center(
                          child: CircularProgressIndicator(
                            color: AppColors.skyBlue,
                          ),
                        ),
                      ),
              ),

              // Loading overlay
              if (!_isPlayerReady)
                Container(
                  color: Colors.black,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: AppColors.skyBlue,
                        ),
                        SizedBox(height: 16.h),
                        CustomText(
                          text: "Loading trailer...",
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ],
                    ),
                  ),
                ),

              // Controls overlay
              if (_showControls && _isPlayerReady)
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.7),
                        Colors.transparent,
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        // Top controls
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Row(
                            children: [
                              IconButton(
                                onPressed: _closePlayer,
                                icon: Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: CustomText(
                                  text: widget.videoTitle,
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const Spacer(),

                        // Bottom controls
                        Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Row(
                            children: [
                              // Play/Pause button
                              IconButton(
                                onPressed: () {
                                  if (_controller.value.isPlaying) {
                                    _controller.pause();
                                  } else {
                                    _controller.play();
                                  }
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(12.r),
                                  decoration: BoxDecoration(
                                    color: AppColors.skyBlue,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _controller.value.isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow,
                                    color: Colors.white,
                                    size: 24.sp,
                                  ),
                                ),
                              ),

                              SizedBox(width: 16.w),

                              // Time display
                              CustomText(
                                text:
                                    _formatDuration(_controller.value.position),
                                color: Colors.white,
                                fontSize: 14,
                              ),

                              SizedBox(width: 8.w),

                              CustomText(
                                text: "/",
                                color: Colors.white,
                                fontSize: 14,
                              ),

                              SizedBox(width: 8.w),

                              CustomText(
                                text: _formatDuration(
                                    _controller.metadata.duration),
                                color: Colors.white,
                                fontSize: 14,
                              ),

                              const Spacer(),

                              // Full screen toggle (already in fullscreen)
                              IconButton(
                                onPressed: () {
                                  // Could implement picture-in-picture or minimize
                                },
                                icon: Container(
                                  padding: EdgeInsets.all(8.r),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.fullscreen_exit,
                                    color: Colors.white,
                                    size: 20.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // // Buffering indicator
              // if (_controller.value.l)
              //   Center(
              //     child: CircularProgressIndicator(
              //       color: AppColors.skyBlue,
              //     ),
              //   ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  void dispose() {
    _controller.removeListener(_playerListener);
    _controller.dispose();
    _resetOrientation();
    super.dispose();
  }
}

// Extension to launch video player
extension VideoPlayerLauncher on MovieVideo {
  void launchFullScreenPlayer(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => VideoPlayerScreen(
          videoId: key,
          videoTitle: name,
        ),
        settings: const RouteSettings(name: '/video_player'),
      ),
    );
  }
}
