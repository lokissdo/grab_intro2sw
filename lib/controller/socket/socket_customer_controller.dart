import 'package:grab/controller/socket/socket.dart';

class SocketCustomerController extends Socket {
  @override
  void initSocket() {
    super.initSocket();
    socket?.on('accept_ride', (data) {
      print(data);
    });
  }

  void sendRequestRide() {
    socket?.emit('ride_request', {
      
    });
  }
}
