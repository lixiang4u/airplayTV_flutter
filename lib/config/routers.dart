import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:airplay/components/video/about_component.dart';
import 'package:airplay/components/video/detail_component.dart';
import 'package:airplay/components/video/list_component.dart';
import 'package:airplay/components/video/play_component.dart';
import 'package:airplay/components/video/qr_component.dart';

var defaultHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, List<String>> parameters,
) {
  print(['defaultHandler']);
});

var homeHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, List<String>> parameters,
) {
  print('[homeHandler]');
});

var videoListHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, List<String>> parameters,
) {
  return const VideoListComponent();
});

var videoDetailHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, List<String>> parameters,
) {
  print('[videoDetailHandler.parameters] $parameters');
  String? id = parameters['id']?.first;
  return VideoDetailComponent(id: id);
});

var videoPlayHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, List<String>> parameters,
) {
  print('[videoPlayHandler.parameters] $parameters');
  var id = parameters['playId']?.first;
  var videoId = parameters['videoId']?.first;
  var videoName = parameters['videoName']?.first;
  var source = parameters['source']?.first;
  var url = parameters['url']?.first;
  var type = parameters['type']?.first;
  return VideoPlayComponent(
    id: id,
    vid: videoId,
    name: videoName,
    source: source,
    url: url,
    type: type,
  );
});

var qrHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, List<String>> parameters,
) {
  print('[QrComponent]');
  return const QrComponent();
});

var aboutHandler = Handler(handlerFunc: (
  BuildContext? context,
  Map<String, List<String>> parameters,
) {
  print('[aboutHandler]');
  return const AboutComponent();
});

class Routers {
  static String rootRoute = '/';
  static String videoListRoute = '/list';
  static String videoDetailRoute = '/detail';
  static String videoPlayRoute = '/play';
  static String aboutRoute = '/about';
  static String qrRoute = '/qr';

  static void configureRouters(FluroRouter router) {
    router.notFoundHandler = defaultHandler;

    router.define(
      rootRoute,
      handler: videoListHandler,
      transitionType: TransitionType.none,
    );
    router.define(
      videoListRoute,
      handler: videoListHandler,
      transitionType: TransitionType.none,
    );
    router.define(
      videoDetailRoute,
      handler: videoDetailHandler,
      transitionType: TransitionType.none,
    );
    router.define(
      videoPlayRoute,
      handler: videoPlayHandler,
      transitionType: TransitionType.none,
    );
    router.define(
      aboutRoute,
      handler: aboutHandler,
      transitionType: TransitionType.none,
    );
    router.define(
      qrRoute,
      handler: qrHandler,
      transitionType: TransitionType.none,
    );
  }
}
