import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_webrtc/blocs/app_state.dart';
import 'package:simple_webrtc/blocs/app_state_bloc.dart';
import 'package:simple_webrtc/blocs/app_state_events.dart';

class InCalling extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appStateBlock = BlocProvider.of<AppStateBloc>(context);

    return BlocBuilder<AppStateBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        return Stack(
          alignment: Alignment.center,
          children: [
            Text('Chamada em Andamento'),
          ],
        );
      },
    );
  }
}
