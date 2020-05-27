import 'package:simple_webrtc/models/hero.dart';
import 'package:simple_webrtc/utils/webrtc_conf.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_webrtc/webrtc.dart';

typedef OnConnected(Map<String, Hero> heroes);
typedef OnAssigned(String heroName);
typedef OnTaken(String heroName);
typedef OnDisconnected(String heroName);
typedef OnLocalStream(MediaStream stream);
typedef OnResponse(dynamic data);
typedef OnRequest(dynamic data);

class Signaling {
  IO.Socket _socket;
  OnConnected onConnected;
  OnAssigned onAssigned;
  OnTaken onTaken;
  OnDisconnected onDisconnected;
  RTCPeerConnection _peer;
  OnLocalStream onLocalStream;
  OnResponse onResponse;
  OnRequest onRequest;

  MediaStream _localStream;
  String _him, _requestId;

  Future<void> init() async {
    _localStream = await navigator.getUserMedia(WebRTCConfig.mediaConstraints);
    onLocalStream(_localStream);
    _connect();
  }

  _connect() {
    _socket = IO
        .io('https://backend-super-hero-call.herokuapp.com/', <String, dynamic>{
      'transports': ['websocket'],
    });

    _socket.on('on-connected', (data) {
      final tmp = Map.from(data);
      final Map<String, Hero> heroes = tmp.map(
        (key, value) => MapEntry<String, Hero>(key, Hero.fromJson(value)),
      );
      onConnected(heroes);
    });

    _socket.on('on-assigned', (heroName) => onAssigned(heroName));

    _socket.on('on-taken', (heroName) => onTaken(heroName));

    _socket.on('on-disconnected', (heroName) => onDisconnected(heroName));

    _socket.on('on-request', (data) {
      _him = data['superHeroName'];
      _requestId = data['requestId'];
      onRequest(data);
    });

    _socket.on('on-response', (answer) async {
      if (answer == null) {
        _him = null;
        _peer?.close();
        _peer = null;
      } else {
        RTCSessionDescription tmp =
            RTCSessionDescription(answer['sdp'], answer['type']);

        await _peer.setRemoteDescription(tmp);
      }
      onResponse(answer);
    });
  }

  emit(String event, dynamic data) {
    _socket?.emit(event, data);
  }

  Future<void> _createPeer() async {
    _peer = await createPeerConnection(WebRTCConfig.configuration, {});
    _peer.addStream(_localStream);
    _peer.onAddStream = (MediaStream stream) {};
  }

  callTo(String heroName) async {
    _him = heroName;
    await _createPeer();
    final RTCSessionDescription offer =
        await _peer.createOffer(WebRTCConfig.offerSdpConstraints);
    await _peer.setLocalDescription(offer);
    emit('request', {'superHeroName': heroName, 'offer': offer.toMap()});
  }

  acceptOrDecline(bool accept) {
    if (accept) {
    } else {
      emit('response', {'requestId': _requestId, 'answer': null});
      _him = null;
      _requestId = null;
    }
  }

  dispose() {
    _socket?.disconnect();
    _socket.destroy();
    _socket = null;
    _localStream?.dispose();
    _peer?.close();
    _peer.dispose();
  }
}
