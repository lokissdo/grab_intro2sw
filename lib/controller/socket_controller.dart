import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketController {
  IO.Socket? socket;
  void initSocket() {
    socket = IO.io(
        'http://192.168.1.63:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());
    socket?.onConnect((_) {
      print('Connected to server');
      socket?.emit('msg', 'test');
    });
    socket?.on('event', (data) => print(data));
    socket?.onDisconnect((_) => print('Disconnected from server'));
    socket?.on('fromServer', (data) => print(data));
    socket?.connect();
  }

  void sendPosition(LatLng pos) {
    socket?.emit('position', pos);
  }
}
