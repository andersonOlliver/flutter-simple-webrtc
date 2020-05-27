import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_webrtc/blocs/app_state.dart';
import 'package:simple_webrtc/blocs/app_state_bloc.dart';
import 'package:simple_webrtc/blocs/app_state_events.dart';

class InComming extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appStateBlock = BlocProvider.of<AppStateBloc>(context);

    return BlocBuilder<AppStateBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.network(
                state.him.avatar,
                width: 100,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Text('Chamada Recebida'),
            Text(state.him.name),
            SizedBox(
              height: 80,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: () {
                    appStateBlock.add(AcceptOrDeclineEvent(true));
                  },
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.call,
                  ),
                ),
                SizedBox(
                  width: 80,
                ),
                FloatingActionButton(
                  onPressed: () {
                    appStateBlock.add(AcceptOrDeclineEvent(false));
                  },
                  backgroundColor: Colors.redAccent,
                  child: Icon(
                    Icons.call_end,
                  ),
                )
              ],
            )
          ],
        );
      },
    );
  }
}
