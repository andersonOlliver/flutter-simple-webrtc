import 'package:socket_io_client/socket_io_client.dart' as IO;

class Signaling {
  IO.Socket _socket;

  _connect() {
    IO.Socket socket = IO
        .io('http://backend-super-hero-call.herokuapp.com/', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on('connected', (data) {

    });
  }
}
