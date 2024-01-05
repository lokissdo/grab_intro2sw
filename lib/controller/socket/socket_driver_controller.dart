import 'package:grab/controller/socket/socket.dart';

class SocketDriverController extends Socket {
  void initSocket() {
    super.initSocket();

    socket?.on('ride_request', (data) {
      getRequestRide();
    });
  }

  void getRequestRide() {
    socket?.emit('accept_ride');
  }
}
