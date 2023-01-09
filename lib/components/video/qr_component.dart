import 'dart:async';

import 'package:flutter/material.dart';
import 'package:airplay/components/common/app_bar_component.dart';
import 'package:airplay/config/api.dart';
import 'package:airplay/events/socket_info.dart';
import 'package:airplay/helpers/format_helpers.dart';
import 'package:airplay/main.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrComponent extends StatefulWidget {
  const QrComponent({super.key});

  @override
  State<StatefulWidget> createState() => _QrComponentState();
}

class _QrComponentState extends State<QrComponent> {
  String clientTime = '';
  StreamSubscription<SocketInfo>? clientIdSubscription;

  @override
  void initState() {
    super.initState();

    clientIdSubscription = gApp.eventBus.on<SocketInfo>().listen((event) {
      setState(() {
        gApp.clientId = event.clientId;
        clientTime = formatTime(event.timestamp ?? 0);
      });
    });
    if (gApp.clientId == null) {
      gApp.tvSocket.getClientInfo();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarComponent(title: '投射'),
      body: Center(child: showQrCode()),
    );
  }

  Widget showQrCode() {
    if (gApp.clientId == null) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: Text('loading'),
          ),
          reConectButton(),
        ],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: QrImage(
            data: ApiUrl.qrCodeUrl('${gApp.clientId}'),
            version: QrVersions.auto,
            size: 260,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '扫码投射',
              style: getTextHeight(),
            ),
            reConectButton(),
          ],
        ),
        RichText(
          text: TextSpan(
            children: [
              // TextSpan(text: 'ID: ', style: getTextHeight()),
              TextSpan(
                text: '${gApp.clientId} ($clientTime)',
                style: getTextHeight(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget reConectButton() {
    return IconButton(
      onPressed: () {
        gApp.tvSocket.getClientInfo();
      },
      icon: const Icon(Icons.sync),
    );
  }

  TextStyle getTextHeight() {
    return const TextStyle(height: 2, color: Colors.black);
  }

  @override
  void dispose() {
    super.dispose();

    clientIdSubscription?.cancel();
  }
}
