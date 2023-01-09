import 'package:flutter/material.dart';
import 'package:airplay/components/common/app_bar_component.dart';
import 'package:airplay/config/api.dart';
import 'package:airplay/config/routers.dart';
import 'package:airplay/config/widget_configs.dart';
import 'package:airplay/main.dart';
import 'package:airplay/models/video.dart';
import 'package:airplay/models/video_result.dart';
import 'package:dio/dio.dart';
import 'package:airplay/helpers/util_helpers.dart';

class VideoListComponent extends StatefulWidget {
  final String? search;

  const VideoListComponent({
    Key? key,
    this.search,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _VideoListComponentState();
}

class _VideoListComponentState extends State<VideoListComponent> {
  late String _title;
  VideoResult videoResult = VideoResult();
  List<Video> videoList = <Video>[];
  int page = 1;
  bool loadMoreState = false;
  bool preSearch = false; // 上一步是搜索还是列表

  ScrollController scrollController = ScrollController();
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    super.initState();

    var tmpTitle = '';
    if (widget.search != null && widget.search!.isNotEmpty) {
      print('[search] ${widget.search}');
      tmpTitle = 'airplayTV - ${widget.search}';
    } else {
      print('[listByTag] ${widget.search}');
      tmpTitle = 'airplayTV';
    }

    setState(() {
      _title = tmpTitle;
    });

    scrollController.addListener(() {
      if (scrollController.position.atEdge && scrollController.offset > 0) {
        loadMore(page++, search: editingController.text.trim());
      }
    });

    loadMore(page++, search: editingController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(title: _title),
      // 让下面的所有组建表现的想像单个的可滚动组建
      body: getFrame(),
    );
  }

  Widget getFrame() {
    if (videoList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return SingleChildScrollView(
      controller: scrollController,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: getSearchBar(),
            ),
            getVideoListWidget(),
            loadMoreWidget(),
            const SizedBox(height: 40),
            getFooter(),
          ],
        ),
      ),
    );
  }

  Widget getSearchBar() {
    return Row(
      children: [
        const Expanded(flex: 1, child: Text('')),
        SizedBox(
          width: 240,
          child: TextField(
            controller: editingController,
            decoration: const InputDecoration(
              // border: OutlineInputBorder(),
              hintText: '搜索...',
            ),
          ),
        ),
        SizedBox(
          width: 50,
          child: IconButton(
            onPressed: () {
              print('[search] ${editingController.text}');

              if (editingController.text.trim().isNotEmpty && !preSearch) {
                // 从列表到搜索
                page = 1;
                videoList.clear();
              }
              if (editingController.text.trim().isEmpty && preSearch) {
                // 从搜索到列表
                page = 1;
                videoList.clear();
              }
              loadMore(page++, search: editingController.text.trim());

              preSearch =
                  editingController.text.trim().isNotEmpty ? true : false;
            },
            icon: const Icon(Icons.search),
          ),
        )
      ],
    );
  }

  Widget loadMoreWidget() {
    if (loadMoreState == true) {
      return const Center(child: CircularProgressIndicator());
    }
    return const SizedBox(height: 0);
  }

  Widget getVideoListWidget() {
    return GridView(
      physics: const NeverScrollableScrollPhysics(), // 让表格的表现的不滚动
      shrinkWrap: true,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: getCrossAxisCount(),
        mainAxisExtent: getMainAxisExtent(),
      ),
      children: getVideoResultToWidgets(),
    );
  }

  List<Widget> getVideoResultToWidgets() {
    List<Widget> childWidgets = videoList.map((item) {
      return GestureDetector(
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            ClipRRect(
              borderRadius: getBorderRadiusConfig(),
              child: Image.network(
                '${item.thumb}',
                fit: BoxFit.cover,
                height: getVideoImageHeight(),
                errorBuilder: defaultImageErrorHandler,
              ),
            ),
            const Padding(padding: EdgeInsets.symmetric(vertical: 5)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                '${item.name}',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        onTap: () {
          print('[onTap] ${item.id}, ${item.name}, ${item.url}');
          var tmpUri = '${Routers.videoDetailRoute}?id=${item.id}';
          gApp.router.navigateTo(context, tmpUri);
        },
      );
    }).toList();

    return childWidgets;
  }

  void loadMore(int p, {String search = ''}) {
    setState(() {
      loadMoreState = true;
    });
    getVideList2(p, search).then((value) {
      setState(() {
        loadMoreState = false;
        videoList.addAll(value.list!);
      });
    });
  }

  int getCrossAxisCount() {
    if (isMobile()) {
      return 2;
    }
    return 4;
  }

  double? getMainAxisExtent() {
    if (isMobile()) {
      return 300;
    }
    return 258;
  }

  double? getVideoImageHeight() {
    if (isMobile()) {
      return 250;
    }
    return 200;
  }

  Future<VideoResult> getVideList2(int page, String search) async {
    var dio = Dio();
    String requestUrl;
    if (search.isNotEmpty) {
      requestUrl = ApiUrl.videoSearchList(page, search);
    } else {
      requestUrl = ApiUrl.videoTagList(page);
    }
    print('[getVideList2.requestUrl] $requestUrl');
    var response = await dio.get(requestUrl);
    return VideoResult.fromJson(response.toString());
  }

  @override
  void dispose() {
    super.dispose();
    editingController.dispose();
    scrollController.dispose();
  }
}

// 页面内容超出后滚动问题
