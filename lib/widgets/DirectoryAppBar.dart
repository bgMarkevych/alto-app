import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/bloc/Blocc.dart';
import 'package:test_app/events/MainEvent.dart';

class DirectoryAppBar {

  static AppBar build(BuildContext context, String header) {
    final bloc = BlocProvider.of<Blocc>(context);
    return AppBar(
      actions: <Widget>[
        IconButton(
            icon: Icon(
              Icons.supervised_user_circle,
              color: Colors.white,
            ),
            onPressed: () {})
      ],
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 8),
        child: Center(
          child: header == null
              ? Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: InkWell(
                    splashColor: Colors.teal[800],
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                    onTap: () {
                      bloc..dispatch(MainEvent());
                    },
                  ),
                )
              : IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
      title: Text(
        header == null ? "Choose document" : header,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      elevation: 0,
    );
  }
}
