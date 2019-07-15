import 'dart:io';
import 'FileListItem.dart';
import 'package:flutter/material.dart';

import 'DirectoryAppBar.dart';
import 'FolderListItem.dart';

class FilesScreen extends StatelessWidget {
  final String header;
  final Directory directory;
  final List<Object> list = [];

  FilesScreen(this.header, this.directory);

  void initList() {
    final files = directory.listSync();
    files.sort((a, b) {
      // ignore: unnecessary_statements
      return !FileSystemEntity.isDirectorySync(a.path) ? 1 : 0;
    });
    list.add("Storage");
    list.addAll(files);
  }

  @override
  Widget build(BuildContext context) {
    initList();
    return Scaffold(
      appBar: DirectoryAppBar.build(context, header),
      body: ListView.builder(
        itemCount: list.length,
        itemBuilder: (context, position) {
          final object = list.elementAt(position);
          if (object is String) {
            return Container(
              decoration: BoxDecoration(color: Color(0xFFf5f5f5)),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5),
                child: Text(
                  object,
                  style: TextStyle(
                      color: Color(0xFF444444),
                      fontSize: 11,
                      fontWeight: FontWeight.w600),
                ),
              ),
            );
          } else if (object is File) {
            return FileListItem(object);
          } else if (object is Directory) {
            return FolderListItem(object);
          }
        },
      ),
    );
  }
}
