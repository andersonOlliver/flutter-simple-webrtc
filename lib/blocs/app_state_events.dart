import 'package:equatable/equatable.dart';

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
