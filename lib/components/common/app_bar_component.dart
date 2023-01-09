import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:airplay/config/routers.dart';
import 'package:airplay/main.dart';
import 'package:airplay/models/Application.dart';

// https://www.webascii.cn/history/article/5ef2cb9a071be112473166a3
class AppBarComponent extends StatelessWidget with PreferredSizeWidget {
  final String? title;
  final bool? showAbout;

  AppBarComponent({
    Key? key,
    this.title,
    this.showAbout = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title!),
      centerTitle: false,
      actions: getActions(context),
    );
  }

  List<Widget>? getActions(BuildContext context) {
    List<Widget>? actions = [];

    actions.add(TextButton(
      onPressed: () {
        // 这里使用FluroRouter就报错了，不知道为什么！！！
        gApp.router.navigateTo(
          context,
          Routers.videoListRoute,
          clearStack: true,
        );
      },
      child: const Text(
        '首页',
        style: TextStyle(color: Colors.white),
      ),
    ));

    actions.add(TextButton(
      onPressed: () {
        // 这里使用FluroRouter就报错了，不知道为什么！！！
        gApp.router.navigateTo(context, Routers.qrRoute);
      },
      child: const Text(
        '投射',
        style: TextStyle(color: Colors.white),
      ),
    ));

    if ((showAbout!) == true) {
      actions.add(TextButton(
        onPressed: () {
          // 这里使用FluroRouter就报错了，不知道为什么！！！
          gApp.router.navigateTo(context, Routers.aboutRoute);
        },
        child: const Text(
          '关于',
          style: TextStyle(color: Colors.white),
        ),
      ));
    }
    return actions;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
