import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/appBloc.dart';
import 'package:test_app/events.dart';
import 'package:test_app/states.dart';
import 'package:test_app/widgets.dart';

void main() => runApp(
      BlocProvider<GlobalBloc>(
        builder: (context) {
          return GlobalBloc()..dispatch(SplashEvent());
        },
        child: MyApp(),
      ),
    );

final ThemeData themeData = ThemeData(
  primarySwatch: Colors.teal,
  accentColor: Colors.amber
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alto App',
      theme: themeData,
      debugShowCheckedModeBanner: false,
      home: BlocBuilder<BasicEvent, BasicState>(
        bloc: BlocProvider.of<GlobalBloc>(context),
        builder: (context, state) {
          if(state is SplashState){
            return SplashScreen();
          }
          if(state is MainState){
            return MainScreen();
          }
          if(state is FilesState){
            return FilesScreen(state.type);
          }
        },
      ),
    );
  }
}
