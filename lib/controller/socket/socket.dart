import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class Socket {
  IO.Socket? socket;
  String? roomId;
  void initSocket() {
    print('Init socket');
    socket = IO.io(
        'http://192.168.1.3:3000',
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .disableAutoConnect()
            .build());

    socket?.connect();
    socket?.onConnect((_) {
      print('Connected to server');
    });

    socket?.onDisconnect((_) => print('Disconnected from server'));
  }

  void disconnect() {
    socket?.disconnect();
  }

  void connect() {
    socket?.connect();
  }

  void sendLocation(GeoPoint pos) {
    socket?.emit('send_location', {
      'room_id': roomId,
      'latitude': pos.latitude,
      'longitude': pos.longitude,
    });
  }

  void cancel() {
    socket?.emit('cancel_ride', {
      'room_id': roomId,
    });
  }
}
