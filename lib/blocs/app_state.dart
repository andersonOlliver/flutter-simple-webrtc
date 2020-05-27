import 'package:equatable/equatable.dart';
import 'package:simple_webrtc/models/hero.dart';

enum Status { loading, showPicker, connected, calling, inCalling, incomming }

class AppState extends Equatable {
  final Status status;
  final Map<String, Hero> heroes;
  final Hero me, him;

  AppState({this.status = Status.loading, this.heroes, this.me, this.him});

  @override
  List<Object> get props => [status, heroes, me, him];

  factory AppState.initialState() => AppState(heroes: Map<String, Hero>());

  AppState copyWith({
    Status status,
    Map<String, Hero> heroes,
    Hero me,
    Hero him,
  }) {
    return AppState(
      status: status ?? this.status,
      heroes: heroes ?? this.heroes,
      me: me ?? this.me,
      him: him ?? this.him,
    );
  }
}
