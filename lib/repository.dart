import 'dart:async';
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:native_pdf_renderer/native_pdf_renderer.dart';
import 'package:path/path.dart';
import 'constants.dart';

//import 'package:simple_permissions/simple_permissions.dart';
import 'package:path_provider/path_provider.dart';
import 'appBloc.dart';
import 'data.dart';
import 'package:utf/utf.dart';
import 'dart:collection';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:rxdart/rxdart.dart';
import 'events.dart';
import 'package:permission_handler/permission_handler.dart' as permissions;
import 'package:googleapis/oauth2/v2.dart';
import 'package:googleapis_auth/auth.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'storage.dart';

abstract class FilePicker {
  FilePicker(this.bloc, type) {
    storage = Storage(type);
  }

  Storage storage;
  final GlobalBloc bloc;
  final Queue backStack = new Queue();
  bool isRoot = true;
  FillerFile currentItem;
  String parentPath;
  Converter _converter = Converter();

  @protected
  Future<List<FillerFile>> _fetchRoot();

  Future<void> getToken(String data);

  @protected
  Future<List<FillerFile>> _fetchFiles(String path);

  Future<List<FillerFile>> onBackPress() async {
    if (isRoot) {
      bloc.dispatch(MainEvent());
      return null;
    }
    Future<List<FillerFile>> files;
    if (backStack.length == 1) {
      isRoot = true;
      backStack.clear();
      files = _fetchRoot();
    } else {
      backStack.removeLast();
      files = _fetchFiles(backStack.elementAt(backStack.length - 1));
    }
    return files;
  }

  Future<List<FillerFile>> routeToRoot() {
    isRoot = true;
    return _fetchRoot();
  }

  Future<List<FillerFile>> routeToNextFolder(FillerFile file) async {
    isRoot = false;
    currentItem = file;
    backStack.add(file.path);
    List<FillerFile> files = await _fetchFiles(file.path);
    return files;
  }

  Future<List<PDFPageImage>> renderPdfDocument(String path) async {
    print("start render");
    final document = await PDFDocument.openFile(path);
    print("file opened");
    final pagesCount = document.pagesCount;
    print("pages " + pagesCount.toString());
    final List<PDFPageImage> pages = [];
    for (var i = 1; i <= pagesCount; i++) {
      print("loop start");
      PDFPage page = await document.getPage(i);
      print("get page " + i.toString());
      PDFPageImage image = await page.render(width: 166, height: 235);
      print("rendered page " + i.toString());
      pages.add(image);
      page.close();
      print("page added " + i.toString());
    }
    print("stop render");
    return Future.value(pages);
  }

  void convert(File fillerFile, Subject progressListener) {
    _converter.uploadFile(fillerFile, progressListener);
  }

  void downloadFile(
      String url, String fileName, Subject<String> downloadListener) async {
    HttpClient client = HttpClient();
    var request = await client.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode != 200) {
      downloadListener.add("Ooops, Error occured while downloading");
      return;
    }
    String path;
    if (Platform.isAndroid) {
      Directory root = Directory("/storage/emulated/0");
      path = root.path + "/Download";
    } else {
      Directory root = await getApplicationDocumentsDirectory();
      path = root.path;
    }
    File file = File(path + "/" + fileName);
    var _downloadData = List<int>();
    response.listen((d) => _downloadData.addAll(d), onDone: () {
      file.writeAsBytes(_downloadData);
      downloadListener.add("File is downloaded successfully");
    });
  }

  void export(String packageName) async {}

  Future<bool> hasToken() {
    return storage.hasToken();
  }

  Future<bool> _checkPermissions() async {
    permissions.PermissionHandler permissionHandler =
        permissions.PermissionHandler();
    bool isGranted = await permissionHandler
            .checkPermissionStatus(permissions.PermissionGroup.storage) ==
        permissions.PermissionStatus.granted;
    if (!isGranted) {
      await permissionHandler.requestPermissions(
          [permissions.PermissionGroup.storage]).then((map) {
        var key = map.keys.firstWhere(
            (group) => group == permissions.PermissionGroup.storage,
            orElse: () => null);
        isGranted = map[key] == permissions.PermissionStatus.granted;
      });
    }
    return Future.value(isGranted);
  }
}

class FilePickerStorage extends FilePicker {
  FilePickerStorage(GlobalBloc bloc, EcoSystem type) : super(bloc, type);

  @override
  Future<List<FillerFile>> _fetchFiles(String path) async {
    final Directory directory = Directory(path);
    print(directory.path + " fetch");
    List<FillerFile> files = _mapFiles(directory.listSync());
    return Future.value(files);
  }

  @override
  Future<List<FillerFile>> _fetchRoot() async {
    Directory directory;
    if (Platform.isAndroid) {
      bool isGranted = await _checkPermissions();
      if (!isGranted) {
        bloc..dispatch(MainEvent());
        return null;
      }
      directory = await getExternalStorageDirectory() == null
          ? await getApplicationDocumentsDirectory()
          : Directory("/storage/emulated/0");
    } else {
      directory = await getApplicationDocumentsDirectory();
    }
    parentPath = directory.path;
    List<FillerFile> files = _mapFiles(directory.listSync());
    print(directory.listSync().length);
    print(directory.path);
    return Future.value(files);
  }

  List<FillerFile> _mapFiles(List<FileSystemEntity> entities) {
    List<FillerFile> files = [];
    entities.forEach((e) {
      print(FileSystemEntity.isDirectorySync(e.path));
      files.add(
        StorageFile(
          FileSystemEntity.isDirectorySync(e.path),
          e.path,
          basename(e.path),
          e is File ? e.lastModifiedSync().toString() : null,
          extension(e.path),
        ),
      );
    });
    return files;
  }

  @override
  Future<void> getToken(String data) {}
}

class FilePickerDropbox extends FilePicker {
  FilePickerDropbox(GlobalBloc bloc, EcoSystem type) : super(bloc, type);

  @override
  Future<List<FillerFile>> _fetchFiles(String path) {
    return getFiles(path);
  }

  @override
  Future<List<FillerFile>> _fetchRoot() async {
    return getFiles("");
  }

  Future<List<FillerFile>> getFiles(String path) async {
    var filesRequest = http.Request(
        "POST", Uri.parse("https://api.dropboxapi.com/2/files/list_folder"));
    print(await storage.hasToken());
    String token = await storage.getToken();
    filesRequest.headers.putIfAbsent("Authorization", () => "Bearer " + token);
    filesRequest.headers.putIfAbsent("Content-Type", () => "application/json");
    filesRequest.body = "{\"path\": \"" + path + "\"}";
    var filesResponse = await filesRequest.send();
    var filesJson = await filesResponse.stream.bytesToString();
    print(filesJson);
    var decodedFilesJson = jsonDecode(filesJson);
    Iterable list = decodedFilesJson["entries"];
    final List<FillerFile> files = [];
    list.forEach((decodedFile) {
      var path = decodedFile["path_display"];
      var date = decodedFile["client_modified"];
      var name = decodedFile["name"];
      var fileExtension = extension(name);
      var isFolder = decodedFile[".tag"] == "folder";
      files.add(DropboxFile(isFolder, path, name, date, fileExtension));
    });
    return Future.value(files);
  }

  @override
  Future<void> getToken(String data) async {
    print("start flow");
    var requestTemp = http.Request(
        "POST", Uri.parse("https://api.dropboxapi.com/oauth2/token"));
    var auth = utf8
        .encode(DropboxConstants.APP_KEY + ":" + DropboxConstants.APP_SECRET);
    var base64auth = base64.encode(auth);
    requestTemp.headers
        .putIfAbsent("Authorization", () => "Basic " + base64auth);
    Map<String, String> body = Map();
    requestTemp.headers
        .putIfAbsent("content-type", () => "application/x-www-form-urlencoded");
    body.putIfAbsent("code", () => data);
    body.putIfAbsent("grant_type", () => "authorization_code");
    body.putIfAbsent("redirect_uri", () => DropboxConstants.REDIRECT_URL);
    requestTemp.bodyFields = body;
    print(requestTemp.bodyFields);
    var response = await requestTemp.send();
    var json = await response.stream.bytesToString();
    print(json);
    var decodedJson = jsonDecode(json);
    String token = decodedJson["access_token"];
    print("end flow");
    print(token);
    await storage.saveToken(token);
    print(await storage.hasToken());
  }

  @override
  Future<List<PDFPageImage>> renderPdfDocument(String path) async {
    Directory directory;
    if (Platform.isAndroid) {
      bool isGranted = await _checkPermissions();
      if (!isGranted) {
        bloc..dispatch(MainEvent());
        return null;
      }
    }
    directory = await getApplicationDocumentsDirectory();
    HttpClient client = HttpClient();
    var request = await client
        .getUrl(Uri.parse("https://content.dropboxapi.com/2/files/download"));
    var token = await storage.getToken();
    print(token);
    request.headers.add("Authorization", "Bearer " + token);
    request.headers.add("Dropbox-API-Arg", "{\"path\": \"" + path + "\"}");
    var response = await request.close();
    print(response.statusCode.toString());
    File file = File(directory.path + "/" + basename(path));
    file.create();
    Completer completer = Completer();
    final List<int> bytes = [];
    response.listen((data) {
      bytes.addAll(data);
    }, onDone: () {
      print(decodeUtf8(bytes));
      completer.complete(file);
    });
    await completer.future;
    await file.writeAsBytes(bytes);
    print("File saved");
    return super.renderPdfDocument(file.path);
  }
}

class Converter {
  final HashMap<String, int> _progressMap = HashMap<String, int>();

  Converter() {
    _progressMap.putIfAbsent(Progress.UPLOAD, () => 10);
    _progressMap.putIfAbsent(Progress.WS_CONNECTION, () => 36);
    _progressMap.putIfAbsent(Progress.PENDING, () => 57);
    _progressMap.putIfAbsent(Progress.START, () => 78);
    _progressMap.putIfAbsent(Progress.FINISH, () => 99);
  }

  Future<File> createNewFile(List<int> pages, File file) async {
//    pdfRedactor.Document document = pdfRedactor.Document();
//    document.addPage(Page)
//    for(var i = 0; i < document.pagesCount; i++){
//
//    }
//    Directory directory = await getTemporaryDirectory();
  }

  void uploadFile(File fillerFile, Subject progressListener) async {
    progressListener.add(_progressMap[Progress.UPLOAD]);
    Uri uri = Uri.parse("https://altoconvertpdftoexcel.com/upload");
    http.MultipartRequest request = http.MultipartRequest("POST", uri);
    request.headers.putIfAbsent("Content-Type", () {
      return "multipart/form-data; boundary=Boundary-32SDSG23FGG";
    });
    request.files.add(await http.MultipartFile.fromPath(
        "pacckage", fillerFile.path,
        contentType: MediaType("application", "pdf")));
    var response = await request.send();
    String json = await response.stream.bytesToString();
    var decodedJson = jsonDecode(json);
    var payload = decodedJson["payload"];
    var token = payload["token"];
    progressListener.add(_progressMap[Progress.WS_CONNECTION]);
    _openWsConnection(token, progressListener, fillerFile);
  }

  void _openWsConnection(String token, Subject progressListener, File file) {
    var connection =
        IOWebSocketChannel.connect("wss://www.altoconvertpdftoexcel.com");
    String auth =
        "{\"group\": \"alto\", \"type\": \"CONVERT\",\"properties\" : { \"token\" : \"" +
            token +
            "\"}}";
    print(auth);
    connection.sink.add(auth);
    connection.stream.listen(
      (message) {
        print(message);
        if (message == "[]" || message == "{}") {
          return;
        }
        var decodedMessage = jsonDecode(message);
        var properties = decodedMessage["properties"];
        var fileStatus = properties["status"];
        print(fileStatus);
        if (fileStatus == null) {
          return;
        }
        progressListener.add(_progressMap[fileStatus]);
        if (fileStatus == "FINISH") {
          var payload = properties["payload"];
          var url = payload["localUrl"];
          var name = payload["name"];
          progressListener.add(ExportEvent(url, name, file.path));
          connection.sink.close(status.goingAway);
        }
      },
    );
  }
}
