import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:airplay/components/common/app_bar_component.dart';
import 'package:airplay/config/api.dart';
import 'package:airplay/config/widget_configs.dart';
import 'package:airplay/main.dart';
import 'package:airplay/models/video_source.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:airplay/events/control_event.dart';

class VideoPlayComponent extends StatefulWidget {
  final String? id; // 播放id
  final String? vid; // 视频id
  final String? name; // 视频名称，防止获取不到
  final String? url;
  final String? source;
  final String? type;
  final String? thumb;

  const VideoPlayComponent({
    Key? key,
    required this.id,
    this.vid,
    this.name,
    this.url,
    this.source,
    this.type,
    this.thumb,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoPlayComponentState();
}

class _VideoPlayComponentState extends State<VideoPlayComponent> {
  late VideoSource videoSource = VideoSource();
  late String videoName = widget.name!;

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  StreamSubscription<VideoSource>? videoSourceSubscription;

  StreamSubscription<ControlEvent>? controlEventSubscription;

  @override
  void initState() {
    super.initState();

    addEventListener();

    getVideoAndPlay();
  }

  void getVideoAndPlay() {
    if (widget.url != null) {
      initVideoPlayer('${widget.url}');
      setState(() {
        videoSource = VideoSource(
          id: widget.id,
          name: widget.name,
          source: widget.source,
          url: widget.url,
          type: widget.type,
          thumb: widget.thumb,
        );
        if (videoSource.name != null) {
          videoName = videoSource.name!;
        }
      });
    } else {
      print('[play_shot_tv] getVideoSource loading.....');

      getVideoSource().then((value) {
        initVideoPlayer('${value.url}');
        setState(() {
          videoSource = value;
          if (videoSource.name != null) {
            videoName = videoSource.name!;
          }
        });
      });
    }
  }

  void initVideoPlayer(String playUrl) {
    videoPlayerController?.dispose();

    videoPlayerController = VideoPlayerController.network(
      ApiUrl.withHost(playUrl),
      // 'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
    )..initialize().then((value) {
        setState(() {});
      });
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController!,
      autoPlay: true,
      // looping: true,
      // autoInitialize: true,
      errorBuilder: (BuildContext context, String errorMessage) {
        return Center(
          child: Text(errorMessage),
        );
      },
    );
  }

  void addEventListener() {
    // gApp.eventBus.on<VideoSource>().listen((event) {
    //   print('[gApp.eventBus.on] ${ApiUrl.withHost('${event.url}')}');
    //   videoPlayerController = VideoPlayerController.network(
    //     ApiUrl.withHost('${event.url}'),
    //   )..initialize().then((value) {
    //       setState(() {});
    //     });
    // });

    gApp.eventBus.on<ControlEvent>().listen((event) {
      print('[gApp.eventBus.on] ${event.control}: ${event.value}');
      switch (event.control) {
        case 'fast_forward':
          chewieController?.seekTo(
            videoPlayerController!.value.duration + const Duration(seconds: 20),
          );
          break;
        case 'fast_rewind':
          chewieController?.seekTo(
            videoPlayerController!.value.duration - const Duration(seconds: 20),
          );
          break;
        case 'fullscreen':
          if (chewieController?.isFullScreen == true) {
            chewieController?.exitFullScreen();
          } else {
            chewieController?.enterFullScreen();
          }
          break;
        case 'last_play':
          break;
        case 'pause':
          chewieController?.pause();
          break;
        case 'play':
          chewieController?.play();
          break;
        case 'qr_code':
          break;
        case 'show_info':
          break;
        case 'video_progress':
          break;
        case 'volume_0':
          chewieController?.setVolume(0);
          break;
        case 'volume_down':
          break;
        case 'volume_progress':
          break;
        case 'volume_up':
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(title: '正在播放 $videoName'),
      body: getFrame(),
    );
  }

  Widget getFrame() {
    if (videoSource.id == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // print('[chewieController] $chewieController');
    return SingleChildScrollView(
      child: Column(
        children: [
          getVideoTitle(videoName),
          Center(
            child: (videoPlayerController != null &&
                    videoPlayerController!.value.isInitialized)
                ? AspectRatio(
                    aspectRatio: videoPlayerController!.value.aspectRatio,
                    child: Chewie(controller: chewieController!),
                  )
                : const SizedBox(
                    height: 360,
                    child: Center(child: Text('loading')),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(ApiUrl.withHost('${videoSource.url}')),
          ),
          getFooter(),
        ],
      ),
    );
  }

  Widget getVideoTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
      child: Text(
        title,
        style: const TextStyle(fontSize: 28),
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Future<VideoSource> getVideoSource() async {
    var dio = Dio();
    var response = await dio.get(
      ApiUrl.videoSource('${widget.id}', '${widget.vid}'),
    );

    return VideoSource.fromJson(response.toString());
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();

    videoSourceSubscription?.cancel();
    controlEventSubscription?.cancel();
    super.dispose();
  }
}
