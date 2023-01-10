import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:airplay/components/common/app_bar_component.dart';
import 'package:airplay/config/api.dart';
import 'package:airplay/config/routers.dart';
import 'package:airplay/config/widget_configs.dart';
import 'package:airplay/main.dart';
import 'package:airplay/models/link.dart';
import 'package:airplay/models/video_detail.dart';
import 'package:airplay/helpers/util_helpers.dart';

class VideoDetailComponent extends StatefulWidget {
  final String? id;

  const VideoDetailComponent({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoDetailComponentState();
}

class _VideoDetailComponentState extends State<VideoDetailComponent> {
  late VideoDetail videoDetail = VideoDetail();
  late String _title = '视频详情';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(title: _title),
      body: SingleChildScrollView(
        // 这里不能使用NeverScrollableScrollPhysics，因为当前就是滚动组建，使用后无法滚动
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
          child: Column(
            children: [
              FutureBuilder(
                future: getVideDetail('${widget.id}'),
                builder: (BuildContext context,
                    AsyncSnapshot<VideoDetail> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.connectionState == ConnectionState.done) {
                    videoDetail = snapshot.data as VideoDetail;

                    return getPlatformFrame();
                  }
                  return Center(child: Text('${snapshot.error.toString()}'));
                },
              ),
              getFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget getPlatformFrame() {
    if (isMobile()) {
      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: getVideoThumb(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitleLine('${videoDetail.name}'),
              // getVideoAirplayTips(),
              getVideoIntro(),
              getVideoSourceList(),
              const SizedBox(height: 60),
            ],
          )
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        getVideoThumb(),
        Expanded(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTitleLine('${videoDetail.name}'),
              // getVideoAirplayTips(),
              getVideoIntro(),
              getVideoSourceList(),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ],
    );
  }

  Widget getVideoThumb() {
    return Padding(
      padding: const EdgeInsets.only(right: 30),
      child: ClipRRect(
        borderRadius: getBorderRadiusConfig(),
        child: Image.network(
          '${videoDetail.thumb}',
          fit: BoxFit.cover,
          height: 250,
          width: 180,
          errorBuilder: defaultImageErrorHandler,
        ),
      ),
    );
  }

  Widget getTitleLine(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 28),
        textAlign: TextAlign.start,
      ),
    );
  }

  Widget getVideoAirplayTips() {
    return const Text(
      '如关联了设备，则投射到设备，否则直接播放',
      style: TextStyle(
        height: 2.6,
        color: Colors.red,
      ),
    );
  }

  Widget getVideoIntro() {
    return RichText(
      maxLines: 3,
      softWrap: true,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(text: '介绍：', style: getTextBoldStyle()),
          TextSpan(
            text: '${videoDetail.intro}',
            style: const TextStyle(
              color: Colors.black54,
              height: 1.8,
            ),
          )
        ],
      ),
    );
  }

  Widget getVideoSourceList() {
    Map<String, List<Link>> groupLinks = Map();
    videoDetail.links?.forEach((element) {
      if (groupLinks['${element.group}'] == null) {
        groupLinks['${element.group}'] = <Link>[];
      }
      groupLinks[element.group]?.add(element);
    });

    var index = 1;
    List<Widget> _children = [];
    groupLinks.forEach((key, value) {
      _children.add(Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Text('资源来源$index', style: getTextBoldStyle()),
      ));

      List<Widget> _btnChildren = [];

      value.map((tmpLink) {
        _btnChildren.add(TextButton(
          onPressed: () {
            var tmpUri =
                '${Routers.videoPlayRoute}?playId=${Uri.encodeComponent(tmpLink.id!)}&videoId=${Uri.encodeComponent(widget.id!)}&videoName=${Uri.encodeComponent(videoDetail.name!)}';
            print('[navigateTo] $tmpUri');

            gApp.router.navigateTo(context, tmpUri);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 2),
            child: Text('${tmpLink.name}'),
          ),
        ));
      }).toList();

      _children.add(Wrap(children: _btnChildren));

      index++;
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: _children,
    );
  }

  TextStyle getTextBoldStyle() {
    return const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w700,
      fontSize: 14,
    );
  }

  Future<VideoDetail> getVideDetail(String id) async {
    var dio = Dio();
    var response = await dio.get(ApiUrl.videoDetail(id));
    return VideoDetail.fromJson(response.toString());
  }
}
