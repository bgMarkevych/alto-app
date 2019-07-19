import 'dart:io';

import 'package:rxdart/rxdart.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'appBloc.dart';
import 'data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'events.dart';
import 'main.dart';
import 'colors.dart';
import 'repository.dart';
import 'states.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'constants.dart';
import 'storage.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: themeData.primaryColor,
        child: Stack(
          children: <Widget>[
            Center(
              child: Image.asset(
                "assets/images/splash_logo.png",
                width: 250,
                height: 150,
              ),
            ),
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(bottom: 10),
              child: Text(
                "© 2018 Crafted by PDFfiller Inc. All rights reserved.",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<GlobalBloc>(context);
    return Scaffold(
      body: Material(
        color: Colors.white,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                top: 100,
              ),
              alignment: Alignment.topCenter,
              child: Column(
                children: <Widget>[
                  Text(
                    "Convert PDF Documents  to Excel files Online",
                    style: TextStyle(
                      letterSpacing: 0,
                      color: color333333,
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 64,
                    ),
                    child: Text(
                      "Choose file to convert from:",
                      style: TextStyle(
                        color: color666666,
                        fontSize: 16,
                        letterSpacing: 0,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Center(
                    child: GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 2,
//                      crossAxisSpacing: 2,
                      children: <Widget>[
                        MainGridItem(
                          "assets/images/icon_folder.png",
                          "My Device",
                          () {
                            bloc.dispatch(FilesEvent(EcoSystem.STORAGE));
                          },
                        ),
                        MainGridItem("assets/images/google_drive.png",
                            "Google Drive", () {}),
                        MainGridItem("assets/images/dropbox.png", "Dropbox",
                            () {
                          bloc.dispatch(FilesEvent(EcoSystem.DROPBOX));
                        }),
                        MainGridItem(
                            "assets/images/onedrive.png", "OneDrive", () {}),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
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
    );
  }
}

class MainGridItem extends StatelessWidget {
  final String icon;
  final String text;
  final VoidCallback tapAction;

  MainGridItem(this.icon, this.text, this.tapAction);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Material(
        color: Color(0xFFf8f8f8),
        child: InkWell(
          onTap: tapAction,
          splashColor: Colors.grey[300],
          highlightColor: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(
                Radius.circular(3),
              ),
              border: Border.all(
                color: Color(0xFFd5d5d5),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 45,
                vertical: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    icon,
                    width: 45,
                    height: 35,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Text(
                      text,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color666666,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

AppBar buildAppBar(
    BuildContext context,
    bool needToShowUserIcon,
    bool showConvertButton,
    String header,
    VoidCallback convertCallback,
    VoidCallback userIconCallback) {
  final bloc = BlocProvider.of<FilesBloc>(context);
  return AppBar(
    actions: <Widget>[
      !showConvertButton
          ? !needToShowUserIcon
              ? Container()
              : IconButton(
                  icon: Icon(
                    Icons.supervised_user_circle,
                    color: Colors.white,
                  ),
                  onPressed: userIconCallback)
          : Center(
              child: MaterialButton(
                color: themeData.primaryColor,
                elevation: 0,
                splashColor: Colors.transparent,
                highlightElevation: 0,
                onPressed: convertCallback,
                child: Text(
                  "Convert",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            )
    ],
    centerTitle: true,
    leading: Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Center(
          child: InkWell(
        onTap: () {
          bloc.dispatch(GoBackEvent());
        },
        child: header == null
            ? Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Text(
                  "Cancel",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w400),
                ),
              )
            : Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
//                  Text(
//                    "Back",
//                    style: TextStyle(
//                      color: Colors.white,
//                      fontSize: 12,
//                      fontWeight: FontWeight.w400,
//                    ),
//                  )
                ],
              ),
      )),
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

class FilesScreen extends StatelessWidget {
  final EcoSystem type;

  FilesScreen(this.type);

  @override
  Widget build(BuildContext context) {
    print("files screen");
    return BlocProvider<FilesBloc>(
      builder: (context) => FilesBloc(
        getFilePickerByType(context, type),
        context,
      )..dispatch(EcoSystemSelectedEvent(type)),
      child: Scaffold(
        body: FilesListContainer(type),
      ),
    );
  }

  FilePicker getFilePickerByType(context, type) {
    if (type == EcoSystem.STORAGE) {
      return FilePickerStorage(
        BlocProvider.of<GlobalBloc>(context),
        type,
      );
    }
    if (type == EcoSystem.DROPBOX) {
      return FilePickerDropbox(
        BlocProvider.of<GlobalBloc>(context),
        type,
      );
    }
  }
}

// ignore: must_be_immutable
class FilesListContainer extends StatelessWidget {
  final EcoSystem type;
  User user;

  FilesListContainer(this.type);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BasicEvent, BasicState>(
        bloc: BlocProvider.of<FilesBloc>(context),
        builder: (context, state) {
          if (state is LoginState) {
            return WebLoginView(type);
          }
          if (state is LoadingState) {
            return LoadingView();
          }
          if (state is EcoSystemSelectedState) {
            return Scaffold(
              appBar: buildAppBar(context, false, false, null, null, null),
            );
          }
          if (state is RootFolderState) {
            user = state.user;
            return FilesList(state.files, type, null, user);
          }
          if (state is SubFolderState) {
            return FilesList(state.files, type, state.name, user);
          }
          if (state is RenderPDFState) {
            return PdfViewer(state.pages, state.filePath);
          }
          if (state is ConvertState) {
            return ConvertView(state.fileName, state.progressListener);
          }
          if (state is ExportState) {
            return ExportView(state.url, state.fileName, state.oldPath);
          }
          if (state is ErrorState) {
            return ErrorView(
                "Something went wrong, please start again or pick another document",
                "Choose another file", () {
              BlocProvider.of<GlobalBloc>(context)..dispatch(MainEvent());
            });
          }
          return null;
        });
  }
}

// ignore: must_be_immutable
class FilesList extends StatelessWidget {
  List<FillerFile> files;
  final EcoSystem type;
  final String folderName;
  bool isFilesEmpty;
  final User user;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  FilesList(List<FillerFile> files, this.type, this.folderName, this.user) {
    isFilesEmpty = files == null || files.isEmpty;
    files.sort((a, b) {
      return a.isFolder == b.isFolder ? 0 : 1;
    });
    this.files = files;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FilesBloc>(context);
    return WillPopScope(
        child: Scaffold(
            key: _scaffoldKey,
            endDrawer: Drawer(
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xFF313131),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                    top: 35,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 35,
                        ),
                        child: CircleAvatar(
                          child: user.photoUrl != "empty"
                              ? Image.network(
                                  user.photoUrl,
                                  width: 64,
                                  height: 64,
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.grey[400],
                                  ),
                                  width: 64,
                                  height: 64,
                                  child: Center(
                                    child: Text(
                                      user.email.substring(
                                        0,
                                        1,
                                      ),
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 12,
                        ),
                        child: Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: Text(
                          getTitleByEcoSystem(type),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFFa0a0a0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          top: 35,
                        ),
                        child: Divider(
                          height: 1,
                          color: Colors.black,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 18,
                        ),
                        child: InkWell(
                          onTap: () {
                            final bloc = BlocProvider.of<FilesBloc>(context);
                            bloc.dispatch(LogoutEvent());
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 7,
                                ),
                                child: Text(
                                  "Logout",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            appBar: !isFilesEmpty
                ? buildAppBar(
                    context, type != EcoSystem.STORAGE, false, folderName, null,
                    () {
                    _scaffoldKey.currentState.openEndDrawer();
                  })
                : null,
            body: !isFilesEmpty
                ? buildFilesList(files, type)
                : ErrorView(
                    "Folder is Empty",
                    "Go back",
                    () {
                      bloc.dispatch(GoBackEvent());
                    },
                  )),
        onWillPop: () {
          bloc.dispatch(GoBackEvent());
          return Future<bool>.value(false);
        });
  }
}

String getTitleByEcoSystem(EcoSystem type) {
  String title = "";
  if (type == EcoSystem.STORAGE) {
    title = "Storage";
  } else if (type == EcoSystem.GOOGLE) {
    title = "Google Drive";
  } else if (type == EcoSystem.ONEDRIVE) {
    title = "One Drive";
  } else if (type == EcoSystem.DROPBOX) {
    title = "Dropbox";
  }
  return title;
}

ListView buildFilesList(List<FillerFile> files, type) {
  List<Object> list = [];
  files.sort((a, b) {
    // ignore: unnecessary_statements
    return !FileSystemEntity.isDirectorySync(a.path) ? 1 : 0;
  });
  var title = getTitleByEcoSystem(type);
  list.add(title);
  list.addAll(files);
  return ListView.builder(
    itemCount: list.length,
    itemBuilder: (context, position) {
      var item = list.elementAt(position);
      if (item is String) {
        return TitleListItem(item);
      } else if (item is FillerFile && item.isFolder) {
        return FolderListItem(item);
      } else if (item is FillerFile && !item.isFolder) {
        return FileListItem(item);
      }
//    return Container();
    },
  );
}

class TitleListItem extends StatelessWidget {
  final String title;

  TitleListItem(this.title);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFf5f5f5)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 5, bottom: 5),
        child: Text(
          title,
          style: TextStyle(
              color: Color(0xFF444444),
              fontSize: 11,
              fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}

class FileListItem extends StatelessWidget {
  final FillerFile file;

  FileListItem(this.file);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FilesBloc>(context);
    print(file.name);
    return InkWell(
      onTap: () {
        if (file.extension != ".pdf") {
          return;
        }
        bloc.dispatch(RenderPDFEvent(file.path));
      },
      child: Container(
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
              padding: const EdgeInsets.only(
                  top: 16, left: 16, bottom: 24, right: 16),
              child: getImageIconByFileExtension(file.extension),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  file.name,
                  style: TextStyle(
                    color: Color(0xFF666666),
                    fontWeight: file.extension != ".pdf"
                        ? FontWeight.w400
                        : FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    file.date,
                    style: TextStyle(
                      color: Color(0xFFa3a3a3),
                      fontWeight: FontWeight.w400,
                      fontSize: 12,
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Image getImageIconByFileExtension(String extension) {
    String path = "assets/images/";
    if (extension == ".pdf") {
      path = path + "pdf.png";
    } else if (extension == ".doc" || extension == ".docx") {
      path = path + "word.png";
    } else if (extension == ".ppt" || extension == ".pptx") {
      path = path + "pw.png";
    } else if (extension == ".xls" || extension == ".xlsx") {
      path = path + "xls.png";
    } else if (extension == ".jpg" ||
        extension == ".jpeg" ||
        extension == ".png") {
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
}

class FolderListItem extends StatelessWidget {
  final FillerFile file;

  FolderListItem(this.file);

  @override
  Widget build(BuildContext context) {
    print(file.name);
    final bloc = BlocProvider.of<FilesBloc>(context);
    return InkWell(
      onTap: () {
        bloc.dispatch(SubFolderEvent(file));
      },
      child: Container(
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
              padding: const EdgeInsets.only(
                  top: 16, left: 16, bottom: 24, right: 16),
              child: Image.asset(
                "assets/images/folder_picker.png",
                height: 25,
                width: 25,
              ),
            ),
            Text(
              file.name,
              style: TextStyle(
                color: Color(0xFF444444),
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ErrorView extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback buttonPressAction;

  ErrorView(this.message, this.buttonText, this.buttonPressAction);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 39,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Image.asset(
              "assets/images/error.png",
              height: 48,
              width: 48,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 21,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Uh oh!",
                  style: TextStyle(
                    color: color333333,
                    fontSize: 24,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 12,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  message,
                  style: TextStyle(
                    color: color666666,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 55,
                vertical: 48,
              ),
              child: MaterialButton(
                onPressed: buttonPressAction,
                splashColor: Colors.transparent,
                color: themeData.primaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(3),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: themeData.primaryColor),
      child: Stack(
        children: <Widget>[
          Center(
            child: Container(
              child: CircularProgressIndicator(),
              width: 50,
              height: 50,
            ),
          )
        ],
      ),
    );
  }
}

class PdfViewer extends StatefulWidget {
  final List<PDFPageImage> pages;
  bool isAllSelected = false;
  final List<int> selectedPages = [];
  String filePath;

  PdfViewer(this.pages, this.filePath);

  void setSelection(isAllSelected) {
    this.isAllSelected = isAllSelected;
    if (isAllSelected) {
      selectedPages.clear();
      for (var i = 0; i < pages.length; i++) {
        selectedPages.add(i);
      }
    } else {
      selectedPages.clear();
    }
  }

  void menageSelection(int index) {
    if (!selectedPages.contains(index)) {
      selectedPages.add(index);
    } else {
      selectedPages.remove(index);
    }
    if (selectedPages.length == pages.length) {
      isAllSelected = true;
    }
  }

  @override
  State<StatefulWidget> createState() => PdfViewerState();
}

class PdfViewerState extends State<PdfViewer> {
  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FilesBloc>(context);
    return Scaffold(
      backgroundColor: Color(0xFF313131),
      appBar: buildAppBar(
        context,
        false,
        true,
        "Select Pages",
        () {
          bloc.dispatch(ConvertEvent(widget.filePath));
        },
        null,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: GridPDFPagesList(
              widget.pages,
              widget.isAllSelected,
              widget.selectedPages,
              (index) {
                setState(
                  () {
                    widget.menageSelection(index);
                    print(widget.selectedPages.length);
                  },
                );
              },
            ),
          ),
          Material(
            elevation: 5,
            child: InkWell(
              onTap: () {
                setState(() {
                  widget.setSelection(widget.isAllSelected ? false : true);
                });
              },
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  child: Text(
                    widget.isAllSelected ? "Unselect All" : "Select All",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: color444444,
                        fontSize: 16,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridPDFPagesList extends StatelessWidget {
  final List<PDFPageImage> pages;
  final List<int> selectedPages;
  bool isAllSelected = false;
  final void Function(int) callback;

  GridPDFPagesList(
      this.pages, this.isAllSelected, this.selectedPages, this.callback);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.65,
      ),
      itemCount: pages.length,
      itemBuilder: (context, position) {
        return PDFPageView(pages.elementAt(position), position, callback,
            selectedPages.contains(position));
      },
    );
  }
}

class PDFPageView extends StatefulWidget {
  final PDFPageImage page;
  final int position;
  bool isSelected = false;
  final void Function(int) callback;

  PDFPageView(this.page, this.position, this.callback, this.isSelected);

  @override
  State<StatefulWidget> createState() => PDFPageViewState();
}

class PDFPageViewState extends State<PDFPageView> {
  final Color selectedColor = themeData.primaryColor;
  final Color unSelectedColor = color222222;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.callback(widget.position);
        });
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: widget.isSelected ? selectedColor : unSelectedColor,
            ),
            color: Colors.white,
          ),
          width: 166,
          height: 235,
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  decoration: BoxDecoration(
                      color:
                          widget.isSelected ? selectedColor : unSelectedColor),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.position.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Center(
                    child: Image(
                      image: MemoryImage(
                        widget.page.bytes,
                      ),
                    ),
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

class ConvertView extends StatefulWidget {
  String fileName;
  Subject progressListener;

  ConvertView(this.fileName, this.progressListener);

  @override
  State<StatefulWidget> createState() => ConvertViewState();
}

class ConvertViewState extends State<ConvertView> {
  final Animation<Color> progressColor =
      AlwaysStoppedAnimation<Color>(Colors.white);
  int _progress = 0;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FilesBloc>(context);
    widget.progressListener.listen((data) {
      if (data is int) {
        setState(() {
          _progress = data;
        });
      }
      if (data is ExportEvent) {
        bloc.dispatch(data);
        widget.progressListener.close();
      }
    }, onError: (e) {
      bloc.dispatch(ErrorEvent());
    });
    return Scaffold(
      backgroundColor: themeData.primaryColor,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 100,
            right: 32,
            left: 32,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Text(
                  "Convertion in progress…",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w300),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Text(
                    widget.fileName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    "assets/images/convert.png",
                    width: 197,
                    height: 74,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                    ),
                    child: LinearPercentIndicator(
                      progressColor: Colors.white,
                      lineHeight: 8,
                      percent: _progress / 100,
                      backgroundColor: colorPrimaryDark,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: Text(
                      _progress.toString() + "%",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 32,
            left: 128,
            right: 128,
            child: buildPrimaryDarkButton("Cancel", () {
              final globalBloc = BlocProvider.of<GlobalBloc>(context);
              globalBloc.dispatch(MainEvent());
            }),
          ),
        ],
      ),
    );
  }
}

class ExportView extends StatelessWidget {
  final String url;
  final String fileName;
  final String oldPath;
  Subject<String> downloadListener = PublishSubject<String>();

  ExportView(this.url, this.fileName, this.oldPath);

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<FilesBloc>(context);
    return Scaffold(
      backgroundColor: themeData.primaryColor,
      body: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 100),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                "Your document is compete!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w300),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 36,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Image.asset(
                    "assets/images/convert_complete.png",
                    height: 75,
                    width: 77,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 17,
                    ),
                    child: Text(
                      fileName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 44,
                      right: 32,
                      left: 32,
                    ),
                    child: Text(
                      "Edit, Sign, Email or eFax the  document you’ve just converted!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 32,
                    ),
                    child: buildWhiteButton("Open in PDFfiller",
                        "assets/images/pdffiller.png", () {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16,
                    ),
                    child: buildWhiteButton(
                        "Open in SingnNow", "assets/images/signnow.png", () {}),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 24,
                    ),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        color: Colors.blueGrey[100],
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Expanded(
                          child: buildPrimaryDarkButton("Download", () {
                        showLoadingDialog(context);
                        bloc.dispatch(
                            DownloadEvent(url, fileName, downloadListener));
                        downloadListener.listen((message) {
                          Navigator.of(context).pop();
                          final snackBar = SnackBar(content: Text(message));
                          Scaffold.of(context).showSnackBar(snackBar);
                          print(message);
                        });
                      })),
                      SizedBox(
                        width: 15,
                      ),
                      Expanded(
                          child: buildPrimaryDarkButton("Start over again", () {
                        var globalBloc = BlocProvider.of<GlobalBloc>(context);
                        globalBloc.dispatch(MainEvent());
                      })),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10,
            ),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                "© 2018 Crafted by PDFfiller Inc. All rights reserved.",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

MaterialButton buildPrimaryDarkButton(String buttonText, VoidCallback press) {
  return MaterialButton(
    elevation: 0,
    highlightElevation: 0,
    color: colorPrimaryDark,
    onPressed: press,
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 12,
      ),
      child: Text(
        buttonText,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w400,
        ),
      ),
    ),
  );
}

MaterialButton buildWhiteButton(
    String buttonText, String imagePath, VoidCallback press) {
  return MaterialButton(
    elevation: 0,
    highlightElevation: 0,
    color: Colors.white,
    onPressed: press,
    child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              imagePath,
              width: 24,
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              child: Text(
                buttonText,
                style: TextStyle(
                  color: color666666,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          ],
        )),
  );
}

void showLoadingDialog(context) {
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: <Widget>[
            Center(
              child: Container(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            )
          ],
        );
      });
}

// ignore: must_be_immutable
class WebLoginView extends StatelessWidget {
  WebViewController _controller;
  EcoSystem type;
  String loginUrl;
  String redirectUrl;

  WebLoginView(this.type) {
    if (type == EcoSystem.DROPBOX) {
      loginUrl = DropboxConstants.LOGIN_URL;
      redirectUrl = DropboxConstants.REDIRECT_URL;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () {
            final bloc = BlocProvider.of<GlobalBloc>(context);
            bloc.dispatch(MainEvent());
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
        title: Text("Login"),
        centerTitle: true,
      ),
      body: WebView(
        initialUrl: loginUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (c) {
          _controller = c;
        },
        onPageFinished: (string) {
          if (string.startsWith(redirectUrl)) {
            handleCodeResult(string, context);
          }
        },
      ),
    );
  }

  void handleCodeResult(String url, BuildContext context) {
    var uri = Uri.parse(url);
    var code = uri.queryParameters["code"];
    print(code);
    final bloc = BlocProvider.of<FilesBloc>(context);
    bloc.dispatch(LoginEvent(code));
  }
}
