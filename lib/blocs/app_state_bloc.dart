import 'package:bloc/bloc.dart';
import 'package:simple_webrtc/blocs/app_state.dart';
import 'package:simple_webrtc/blocs/app_state_events.dart';

class AppStateBloc extends Bloc<AppStateEvent, AppState>{
  @override
  AppState get initialState => AppState.initialState();

  @override
  Future<void> close() {
    return super.close();
  }

  @override
  Stream<AppState> mapEventToState(AppStateEvent event) {
    // if(event is ShowPickerEvent){
    //   event.heroes;
    // }else if(event is LoadingEvent){
      
    // }
    
    return null;
  }

}