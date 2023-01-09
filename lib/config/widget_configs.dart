import 'package:flutter/material.dart';

BorderRadius getBorderRadiusConfig() {
  return const BorderRadius.all(Radius.circular(6));
}

Widget defaultImageErrorHandler(
    BuildContext context, Object error, StackTrace? stackTrace) {
  print('[Image.network.error] ${error.toString()}');

  return Image.asset('assets/images/default-thumb.png', height: 200);
}

Widget getFooter() {
  return const SizedBox(
    width: double.maxFinite,
    child: Text(
      '本站仅作学习案例展示，切勿用作任何其他用途！\n本站资源均来源网络，侵权即删！',
      textAlign: TextAlign.center,
      style: TextStyle(
        height: 1.5,
        fontSize: 12,
        color: Colors.grey,
      ),
    ),
  );
}
