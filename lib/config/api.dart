import 'package:airplay/main.dart';

class ApiUrl {
  static const String _host = 'https://air.artools.cc';
  static const String _wsHost = 'wss://air.artools.cc';

  static String withHost(String urlSegment) {
    if (!urlSegment.startsWith(_host)) {
      urlSegment = '$_host/${urlSegment.replaceFirst(RegExp('^/'), '')}';
    }
    return urlSegment;
  }

  static String websocket() {
    return '$_wsHost/api/ws';
  }

  static String qrCodeUrl(String clientId) {
    return '$_host/mobile/?tv_id=$clientId&t=${DateTime.now().millisecondsSinceEpoch.toString()}';
  }

  static String videoTagList(int page, {String tagName = 'movie_bt'}) {
    return '$_host/api/video/tag?tagName=$tagName&p=$page&_source=${gApp.sourceName}&_cache=${gApp.isCache}';
  }

  static String videoSearchList(int page, String search) {
    return '$_host/api/video/search?q=$search&p=$page&_source=${gApp.sourceName}&_cache=${gApp.isCache}';
  }

  static String videoDetail(String id) {
    return '$_host/api/video/detail?id=$id&_source=${gApp.sourceName}&_cache=${gApp.isCache}';
  }

  static String videoSource(String playId, String videoId) {
    return '$_host/api/video/source?id=$playId&vid=$videoId&_source=${gApp.sourceName}&_cache=${gApp.isCache}';
  }
}
