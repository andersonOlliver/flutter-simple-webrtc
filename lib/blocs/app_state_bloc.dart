import 'package:bloc/bloc.dart';
import 'package:flutter_webrtc/media_stream.dart';
import 'package:flutter_webrtc/rtc_video_view.dart';
import 'package:simple_webrtc/blocs/app_state.dart';
import 'package:simple_webrtc/blocs/app_state_events.dart';
import 'package:simple_webrtc/libs/signaling.dart';
import 'package:simple_webrtc/models/hero.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppState> {
  @override
  AppState get initialState => AppState.initialState();

  Signaling _signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();

  RTCVideoRenderer get localRenderer => _localRenderer;
  RTCVideoRenderer get remoteRenderer => _remoteRenderer;

  AppStateBloc() {
    _init();
  }

  _init() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();

    _signaling.init();
    _signaling.onLocalStream = (MediaStream stream) {
      _localRenderer.srcObject = stream;
      _localRenderer.mirror = true;
    };

    _signaling.onRemoteStream = (MediaStream stream) {
      _remoteRenderer.srcObject = stream;
      _remoteRenderer.mirror = true;
    };

    _signaling.onConnected = (Map<String, Hero> heroes) {
      add(ShowPickerEvent(heroes));
    };
    _signaling.onAssigned = (String heroName) {
      if (heroName == null) {
        add(ShowPickerEvent(state.heroes));
      } else {
        print('Sucesso $heroName');
        final myHero = state.heroes[heroName];
        add(ConnectedEvent(hero: myHero));
      }
    };
    _signaling.onTaken = (String heroName) {
      add(TakenEvent(heroName: heroName, isTaken: true));
    };

    _signaling.onDisconnected = (String heroName) {
      add(TakenEvent(heroName: heroName, isTaken: false));
    };

    _signaling.onCancelRequest = () {
      add(ConnectedEvent(hero: state.me));
    };

    _signaling.onFinishCall = () {
      add(ConnectedEvent(hero: state.me));
    };

    _signaling.onResponse = (dynamic answer) {
      if (answer != null) {
        add(InCallingEvent());
      } else {
        add(ConnectedEvent(hero: state.me));
      }
    };
    _signaling.onRequest = (dynamic data) {
      add(InCommingEvent(data['superHeroName']));
    };
  }

  @override
  Future<void> close() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    _signaling.dispose();
    return super.close();
  }

  @override
  Stream<AppState> mapEventToState(AppStateEvent event) async* {
    if (event is ShowPickerEvent) {
      yield AppState(status: Status.showPicker, heroes: event.heroes);
    } else if (event is PickHeroEvent) {
      _signaling.emit('pick', event.heroName);
      yield state.copyWith(status: Status.loading);
    } else if (event is ConnectedEvent) {
      yield state.copyWith(status: Status.connected, me: event.hero, him: null, mute: false);
      // yield AppState(status: Status.connected, heroes: state.heroes);

    } else if (event is TakenEvent) {
      Map<String, Hero> newHeroes = Map();
      newHeroes.addAll(state.heroes);
      final heroTaken =
          newHeroes[event.heroName].copyWith(isTaken: event.isTaken);
      newHeroes[heroTaken.name] = heroTaken;

      yield state.copyWith(heroes: newHeroes);
    } else if (event is CallingEvent) {
      _signaling.callTo(event.hero.name);
      yield state.copyWith(status: Status.calling, him: event.hero);
    } else if (event is InCallingEvent) {
      yield state.copyWith(status: Status.inCalling);
    } else if (event is InCommingEvent) {
      final him = state.heroes[event.heroName];
      yield state.copyWith(status: Status.incomming, him: him);
    } else if (event is AcceptOrDeclineEvent) {
      if (event.accept) {
        await _signaling.acceptOrDecline(true);
        yield state.copyWith(status: Status.inCalling);
      } else {
        await _signaling.acceptOrDecline(false);
        yield state.copyWith(status: Status.connected, him: null);
      }
    } else if (event is CancelRequestEvent) {
      _signaling.cancelRequest();
      yield state.copyWith(status: Status.connected, him: null);
    } else if (event is FinishCallEvent) {
      _signaling.finishCurrentCall();
      yield state.copyWith(
          status: Status.connected, him: null, isFrontCamera: true);
    } else if (event is SwitchCameraEvent) {
      _signaling.changeCamera();
      yield state.copyWith(isFrontCamera: event.isFrontCamera);
    } else if (event is MuteEvent) {
      _signaling.setMicrophoneMute(event.mute);
      yield state.copyWith(mute: event.mute);
    }
  }
}
