import 'package:flutter/material.dart';
import 'package:test_app/events/FilesEvent.dart';
import 'package:test_app/events/RootEvent.dart';
import 'package:test_app/model/data/ImportType.dart';
import 'package:test_app/widgets/MainGridItem.dart';
import 'package:test_app/bloc/Blocc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {


  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<Blocc>(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Convert PDF Documents  to Excel files Online",
                      style: TextStyle(
                        letterSpacing: 0,
                        color: Color(0xFF333333),
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 68),
                      child: Text(
                        "Choose file to convert from:",
                        style: TextStyle(
                          color: Color(0xFF666666),
                          fontSize: 16,
                          letterSpacing: 0,
                          fontWeight: FontWeight.w300,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 1.2,
                      shrinkWrap: true,
                      children: <Widget>[
                        MainGridItem(
                          "assets/images/icon_folder.png", "My Device", () {
                          bloc..dispatch(FilesEvent(ImportType.STORAGE));
                        },),
                        MainGridItem(
                            "assets/images/google_drive.png",
                            "Google Drive", () {}),
                        MainGridItem(
                            "assets/images/dropbox.png", "Dropbox", () {}),
                        MainGridItem(
                            "assets/images/onedrive.png", "OneDrive", () {}),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    "© 2018 Crafted by PDFfiller Inc. All rights reserved.",
                    style: TextStyle(
                      color: Color(0xFF666666),
                      fontSize: 10,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
