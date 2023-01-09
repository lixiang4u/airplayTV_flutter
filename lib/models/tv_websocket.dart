import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:airplay/config/api.dart';
import 'package:airplay/config/routers.dart';
import 'package:airplay/events/control_event.dart';
import 'package:airplay/events/socket_info.dart';
import 'package:airplay/main.dart';
import 'package:airplay/models/video_source.dart';
import 'package:web_socket_channel/io.dart';

class TVSocket {
  late final IOWebSocketChannel _socketChannel;

  TVSocket.init(IOWebSocketChannel socketChannel) {
    print('TVSocket.init');
    socketChannel.stream.handleError((Object o) {
      print('[socketChannel.stream.handleError] $o');
    });

    socketChannel.stream.listen((event) {
      print('[socketChannel.stream.listen] $event');

      handleWebsocketEvent(jsonDecode(event));
    }, onDone: () {
      print('[socketChannel.onDone]');
      if (_socketChannel.closeCode != null) {
        connectLost();
      }
    }, onError: (Object error, StackTrace stack) {
      print('[socketChannel.onError] ${error.toString()}');
    });

    _socketChannel = socketChannel;
  }

  void addListen() {}

  void send(dynamic data) {
    reConnect();
    _socketChannel.sink.add(data);
  }

  // 获取客户端信息
  void getClientInfo() {
    reConnect();
    _socketChannel.sink.add('{"event":"info"}');
  }

  void reConnect() {
    if (_socketChannel.closeCode != null) {
      gApp.tvSocket = TVSocket.init(
        IOWebSocketChannel.connect(ApiUrl.websocket()),
      );
    }
  }

  void connectLost() {
    gApp.eventBus.fire(SocketInfo(
      clientId: null,
      timestamp: null,
    ));
  }

  void handleWebsocketEvent(dynamic json) {
    switch (json['event']) {
      case 'info': //连接信息
        gApp.eventBus.fire(SocketInfo(
          clientId: json['client_id'],
          timestamp: json['timestamp'],
        ));
        break;
      case 'play': // 播放
        var tmpQuery = Uri(queryParameters: {
          "playId": json['video']['id'],
          "videoId": '',
          "videoName": json['video']['name'],
          "source": json['video']['source'],
          "url": json['video']['url'],
          "type": json['video']['type'],
          "thumb": json['video']['thumb'],
        }).query;

        var context = gApp.globalNavigatorKey.currentContext!;
        var u = '${Routers.videoPlayRoute}?$tmpQuery';

        // https://stackoverflow.com/questions/66139776/get-the-global-context-in-flutter
        gApp.router.navigateTo(context, u, replace: true).then((value) {
          print('[navigateTo gApp.globalNavigatorKey.currentState!.context]');
        });

        // gApp.eventBus.fire(VideoSource(
        //   id: json['id'],
        //   name: json['name'],
        //   source: json['source'],
        //   url: json['url'],
        //   type: json['type'],
        //   thumb: json['thumb'],
        // ));

        break;
      case 'video_controls': //遥控器
        gApp.eventBus.fire(ControlEvent(
          clientId: json['clientId'],
          control: json['control'],
          event: json['event'],
          value: json['value'],
          timestamp: json['timestamp'],
        ));
        break;
      default:
        break;
    }
  }
}
