import 'dart:convert';

import 'package:airplay/models/link.dart';

class VideoDetail {
  String? id;
  String? name;
  String? thumb;
  String? intro;
  String? url;
  String? actors;
  String? tag;
  String? resolution;
  List<Link>? links;

  VideoDetail({
    this.id,
    this.name,
    this.thumb,
    this.intro,
    this.url,
    this.actors,
    this.tag,
    this.resolution,
    this.links,
  });

  // Named constructor
  VideoDetail.fromJson(String _json) {
    var p = jsonDecode(_json);

    id = p['id'];
    name = p['name'];
    thumb = p['thumb'];
    intro = p['intro'];
    url = p['url'];
    actors = p['actors'];
    tag = p['tag'];
    resolution = p['resolution'];

    links = <Link>[];
    p['links'].map((item) {
      links?.add(Link(
        id: item['id'],
        name: item['name'],
        url: item['url'],
        group: item['group'],
      ));
    }).toList();
  }
}
