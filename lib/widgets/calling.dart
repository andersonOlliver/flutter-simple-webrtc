import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_webrtc/blocs/app_state.dart';
import 'package:simple_webrtc/blocs/app_state_bloc.dart';

class Calling extends StatelessWidget {
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
            Text('Chamando'),
            SizedBox(
              height: 20,
            ),
            FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.redAccent,
              child: Icon(Icons.call_end),
            )
          ],
        );
      },
    );
  }
}
