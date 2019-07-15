import 'package:bloc/bloc.dart';
import 'package:test_app/events/FilesEvent.dart';
import 'package:test_app/events/MainEvent.dart';
import 'package:test_app/model/UserRepository.dart';
import 'package:test_app/events/AbsEvent.dart';
import 'package:test_app/model/data/ImportType.dart';
import 'package:test_app/screens/LoadingScreen.dart';
import 'package:test_app/events/RootEvent.dart';
import 'package:test_app/states/AbsState.dart';
import 'package:test_app/events/SplashEvent.dart';
import 'package:test_app/states/FilesState.dart';
import 'package:test_app/states/RootState.dart';
import 'package:test_app/states/SplashState.dart';
import 'package:test_app/states/MainState.dart';
import 'package:test_app/states/LoadingState.dart';

class Blocc extends Bloc<AbsEvent, AbsState> {

  final UserRepository userRepository;

  Blocc({this.userRepository});

  @override
  AbsState get initialState => SplashState();

  @override
  Stream<AbsState> mapEventToState(AbsEvent event) async* {
    if (event is SplashEvent) {
      await userRepository.splashDelay();
      yield MainState();
    }
    if(event is MainEvent){
      yield MainState();
    }
    if (event is FilesEvent){
      yield FilesState(event.type);
    }
  }
}