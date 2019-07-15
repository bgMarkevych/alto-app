import 'package:test_app/events/AbsEvent.dart';

import 'AbsState.dart';
import 'RootState.dart';

class SubDirectoryState extends RootState {
  final String name;

  SubDirectoryState(this.name, directory) : super(directory);
}
