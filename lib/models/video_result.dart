import 'dart:convert';

import 'package:airplay/models/video.dart';

class VideoResult {
  // https://air.artools.cc/api/video/tag?tagName=movie_bt&_source=nn&_cache=Open
  int? total;
  int? current;
  int? limit;

  List<Video>? list;

  VideoResult({
    this.total,
    this.current,
    this.limit,
    this.list,
  });

  List<Video>? getList() {
    return list;
  }

  // Named constructor
  VideoResult.fromJson(String _json) {
    var p = jsonDecode(_json);
    total = p['total'];
    current = p['current'];
    limit = p['limit'];

    list = <Video>[];
    p['list'].map((item) {
      list?.add(Video(
        id: item['id'],
        name: item['name'],
        thumb: item['thumb'],
        intro: item['intro'],
        url: item['url'],
        tag: item['tag'],
        resolution: item['resolution'],
      ));
    }).toList();
  }
}
