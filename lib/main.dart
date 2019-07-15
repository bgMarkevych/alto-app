import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/screens/DirectoryScreen.dart';
import 'package:test_app/screens/LoadingScreen.dart';
import 'package:test_app/screens/MainScreen.dart';
import 'package:test_app/screens/SplashScreen.dart';
import 'package:test_app/events/AbsEvent.dart';
import 'package:test_app/states/FilesState.dart';
import 'package:test_app/states/RootState.dart';
import 'package:test_app/states/LoadingState.dart';
import 'package:test_app/states/MainState.dart';
import 'package:test_app/states/SplashState.dart';
import 'package:test_app/states/AbsState.dart';
import 'package:test_app/events/SplashEvent.dart';
import 'package:test_app/model/UserRepository.dart';
import 'package:test_app/bloc/Blocc.dart';

void main() {
  final userRepository = UserRepository();
  runApp(
    BlocProvider<Blocc>(
      builder: (context) {
        return Blocc(userRepository: userRepository)..dispatch(SplashEvent());
      },
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: BlocBuilder<AbsEvent, AbsState>(
        bloc: BlocProvider.of<Blocc>(context),
        builder: (BuildContext context, AbsState state) {
          if (state is FilesState) {
            return DirectoryScreen(state.type);
          }
          if (state is MainState) {
            return MainScreen();
          }
          if (state is LoadingState) {
            return LoadingScreen();
          }
          if (state is SplashState) {
            return SplashScreen();
          }
        },
      ),
    );
  }
}
