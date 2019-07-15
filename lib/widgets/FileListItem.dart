import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/material.dart';

class FileListItem extends StatelessWidget {
  final File file;

  FileListItem(this.file);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          color: Color(0xFFf5f5f5),
        ),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 16, left: 16, bottom: 24, right: 16),
            child: getImageIconByFileExtension(extension(file.path)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                basename(file.path),
                style: TextStyle(
                  color: Color(0xFF666666),
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  file.lastModifiedSync().toString(),
                  style: TextStyle(
                    color: Color(0xFFa3a3a3),
                    fontWeight: extension(file.path) != "pdf" ? FontWeight.w300 : FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

Image getImageIconByFileExtension(String extension) {
  String path = "assets/images/";
  if (extension == "pdf") {
    path = path + "pdf.png";
  } else if (extension == "doc" || extension == "docx") {
    path = path + "word.png";
  } else if (extension == "ppt" || extension == "pptx") {
    path = path + "pw.png";
  } else if (extension == "xls" || extension == "xlsx") {
    path = path + "xls.png";
  } else if (extension == "jpg" || extension == "jpeg" || extension == "png") {
    path = path + "image.png";
  } else {
    path = path + "none.png";
  }
  return Image.asset(
    path,
    width: 25,
    height: 25,
  );
}
