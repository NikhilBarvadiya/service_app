import 'dart:convert';
import 'dart:developer';
import 'package:get/get.dart';
import 'package:service_app/services/index.dart';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService extends GetxController {
  late Socket socket;
  String connectionStatus = "Not connected with server";

  void connectToServer() {
    try {
      socket = io(
        'http://admin.fastwhistle.com:3100',
        OptionBuilder().setTransports(['websocket']).enableAutoConnect().build(),
      );

      socket.connect();
      socket.onConnect((_) {
        connectionStatus = "Connected with server";
        socket.emit('init', 'service');
      });

      socket.on('play', (data) async {
        if (data != null && data != '') {
          data = jsonDecode(data);
          if (data!['type'] == 'notification') {
            notificationService.createNotificationOrder(
              data!["title"],
              data!["description"],
              json.encode(
                data!['data'],
              ),
            );
          }
        }
      });

      socket.onDisconnect((_) {
        connectionStatus = 'Disconnected with server';
      });
    } catch (e) {
      log(e.toString());
    }
  }
}
