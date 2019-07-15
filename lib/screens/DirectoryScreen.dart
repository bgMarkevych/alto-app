import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/bloc/Blocc.dart';
import 'package:test_app/bloc/DirectoryBlocc.dart';
import 'package:test_app/events/AbsEvent.dart';
import 'package:test_app/events/FilesEvent.dart';
import 'package:test_app/events/MainEvent.dart';
import 'package:test_app/events/RootEvent.dart';
import 'package:test_app/model/FilePicker.dart';
import 'package:test_app/model/StorageFilePicker.dart';
import 'package:test_app/model/data/ImportType.dart';
import 'package:test_app/states/AbsState.dart';
import 'package:test_app/states/LoadingState.dart';
import 'package:test_app/states/RootState.dart';
import 'package:test_app/states/SubDirectoryState.dart';
import 'package:test_app/widgets/DirectoryAppBar.dart';
import 'package:test_app/widgets/FilesScreen.dart';

import 'LoadingScreen.dart';

class DirectoryScreen extends StatelessWidget {
  final int type;

  DirectoryScreen(this.type);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<Blocc>(context);
    return BlocProvider<DirectoryBlocc>(
      builder: (context) {
        return DirectoryBlocc(getFilePickerByType(type), bloc)..dispatch(RootEvent());
      },
      child: InnerScreen(),
    );
  }
}

class InnerScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AbsEvent, AbsState>(
      bloc: BlocProvider.of<DirectoryBlocc>(context),
      builder: (BuildContext context, AbsState state) {
        if (state is RootState) {
          print("ROOT");
          print(state.directory.path);
          return FilesScreen(null, state.directory);
        }
        if (state is SubDirectoryState) {
          return FilesScreen(state.name, state.directory);
        }
        if (state is LoadingState) {
          print("LOADING");
          return LoadingScreen();
        }
      },
    );
  }
}

FilePicker getFilePickerByType(int type) {
  if (type == ImportType.STORAGE) {
    return StorageFilePicker();
  }
}
