import 'package:event_bus/event_bus.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:airplay/models/tv_websocket.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Application {
  late FluroRouter router;
  late TVSocket tvSocket;
  String? sourceName; // 关于-源
  String? isCache; // 关于-缓存
  String? clientId;
  EventBus eventBus = EventBus();
  GlobalKey<NavigatorState> globalNavigatorKey = GlobalKey<NavigatorState>();

  Future<String?> loadSourceName() async {
    sourceName ??=
        (await SharedPreferences.getInstance()).getString('sourceName');
    return sourceName;
  }

  Future<void> setSourceName(String sourceName) async {
    this.sourceName = sourceName;
    //保存到本地
    (await SharedPreferences.getInstance()).setString('sourceName', sourceName);
  }

  Future<String?> loadIsCache() async {
    isCache ??= (await SharedPreferences.getInstance()).getString('isCache');
    return isCache;
  }

  Future<void> setIsCache(String isCache) async {
    this.isCache = isCache;
    (await SharedPreferences.getInstance()).setString('isCache', isCache);
  }
}
