import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simple_webrtc/blocs/app_state.dart';
import 'package:simple_webrtc/blocs/app_state_bloc.dart';
import 'package:simple_webrtc/blocs/app_state_events.dart';

class ShowPicker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appStateBlock = BlocProvider.of<AppStateBloc>(context);

    return BlocBuilder<AppStateBloc, AppState>(
      builder: (BuildContext context, AppState state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Selecione seu herói',
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Wrap(
              children: appStateBlock.state.heroes.values.map((hero) {
                return AbsorbPointer(
                  absorbing: hero.isTaken,
                  child: Opacity(
                    opacity: hero.isTaken ? 0.3 : 1,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        onTap: () {
                          appStateBlock.add(PickHeroEvent(hero.name));
                        },
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: Image.network(
                            hero.avatar,
                            width: 100,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            )
          ],
        );
      },
    );
  }
}
