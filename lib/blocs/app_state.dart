import 'package:equatable/equatable.dart';

enum Status { loading, showPicker, connected }

class AppState extends Equatable {
  final Status status;
  final Map<String, dynamic> heroes;

  AppState({this.status = Status.loading, this.heroes});

  @override
  List<Object> get props => [status, heroes];

  factory AppState.initialState() => AppState(heroes: Map<String, dynamic>());
}
