import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_webrtc/blocs/app_state.dart';
import 'package:simple_webrtc/blocs/app_state_bloc.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: BlocBuilder<AppStateBloc, AppState>(
            builder: (BuildContext context, AppState state) {
              if(state.status == Status.loading){
                return CircularProgressIndicator();
              }
          return Text('Olá mundo');
        }),
      ),
    );
  }
}
