import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:airplay/config/api.dart';
import 'package:airplay/config/routers.dart';
import 'package:airplay/main.dart';
import 'package:airplay/models/tv_websocket.dart';
import 'package:web_socket_channel/io.dart';

class AppComponent extends StatefulWidget {
  const AppComponent({super.key});

  @override
  State<StatefulWidget> createState() => _AppComponentState();
}

class _AppComponentState extends State<AppComponent> {
  _AppComponentState() {
    var router = FluroRouter();
    Routers.configureRouters(router);
    gApp.router = router;
    gApp.tvSocket = TVSocket.init(
      IOWebSocketChannel.connect(ApiUrl.websocket()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter-airplayTV',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      onGenerateRoute: gApp.router.generator,
      initialRoute: Routers.rootRoute,
      // https://stackoverflow.com/questions/66139776/get-the-global-context-in-flutter
      navigatorKey: gApp.globalNavigatorKey,
    );
  }
}
