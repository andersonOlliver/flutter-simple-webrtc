import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_webrtc/blocs/app_state.dart';
import 'package:simple_webrtc/blocs/app_state_bloc.dart';
import 'package:simple_webrtc/widgets/calling.dart';
import 'package:simple_webrtc/widgets/connected.dart';
import 'package:simple_webrtc/widgets/in_calling.dart';
import 'package:simple_webrtc/widgets/incomming.dart';
import 'package:simple_webrtc/widgets/show_picker.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AppStateBloc, AppState>(
            builder: (BuildContext context, AppState state) {
          switch (state.status) {
            case Status.loading:
              return CircularProgressIndicator();
            case Status.showPicker:
              return ShowPicker();
            case Status.connected:
              return Connected();
            case Status.calling:
              return Calling();
            case Status.inCalling:
              return InCalling();
            case Status.incomming:
              return InComming();
            default:
              return Container();
          }
        }),
      ),
    );
  }
}
