import 'dart:convert';

class Video {
  // https://air.artools.cc/api/video/tag?tagName=movie_bt&_source=nn&_cache=Open
  String? id;
  String? name;
  String? thumb;
  String? intro;
  String? url;
  String? tag;
  String? resolution;

  Video({
    this.id,
    this.name,
    this.thumb,
    this.intro,
    this.url,
    this.tag,
    this.resolution,
  });

  // Named constructor
  Video.fromJson(String _json) {}
}
