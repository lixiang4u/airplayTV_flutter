import 'dart:convert';

class VideoSource {
  String? id;
  String? name;
  String? source;
  String? url;
  String? type;
  String? thumb;

  VideoSource({
    this.id,
    this.name,
    this.source,
    this.url,
    this.type,
    this.thumb,
  });

  // Named constructor
  VideoSource.fromJson(String _json) {
    print('[VideoSource.fromJson] $_json');
    var p = jsonDecode(_json);
    id = p['id'];
    name = p['name'];
    source = p['source'];
    url = p['url'];
    type = p['type'];
    thumb = p['thumb'];
  }
}
