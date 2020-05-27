import 'package:equatable/equatable.dart';
import 'package:simple_webrtc/models/hero.dart';

class AppStateEvent extends Equatable {
  final List _props;

  AppStateEvent([this._props = const []]);

  @override
  List<Object> get props => _props;
}

class LoadingEvent extends AppStateEvent {}

class ShowPickerEvent extends AppStateEvent {
  final Map<String, dynamic> heroes;

  ShowPickerEvent(this.heroes) : super([heroes]);
}

class PickHeroEvent extends AppStateEvent {
  final String heroName;

  PickHeroEvent(this.heroName) : super([heroName]);
}

class ConnectedEvent extends AppStateEvent {
  final Hero hero;

  ConnectedEvent({this.hero}) : super([hero]);
}

class TakenEvent extends AppStateEvent {
  final String heroName;
  final bool isTaken;

  TakenEvent({this.heroName, this.isTaken}) : super([heroName, isTaken]);
}

class CallingEvent extends AppStateEvent {
  final Hero hero;

  CallingEvent(this.hero) : super([hero]);
}

class InCallingEvent extends AppStateEvent {}

class InCommingEvent extends AppStateEvent {
  final String heroName;

  InCommingEvent(this.heroName) : super([heroName]);
}

class AcceptOrDeclineEvent extends AppStateEvent {
  final bool accept;

  AcceptOrDeclineEvent(this.accept) : super([accept]);
}

