import 'package:test_app/events/AbsEvent.dart';

class FilesEvent extends AbsEvent {
  final int type;

  FilesEvent(this.type);

}
