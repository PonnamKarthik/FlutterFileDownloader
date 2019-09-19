import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter File Download',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _downloadUrlController = TextEditingController();

  double downloadProgress = 0.0;
  String taskId = "";

  _doActionDownload() async {
    taskId = await FlutterDownloader.enqueue(
      url: _downloadUrlController.text,
      savedDir: '/sdcard/Download/',
      showNotification: true,
      openFileFromNotification: false,
    );

    FlutterDownloader.registerCallback((id, status, progress) {
      setState(() {
       downloadProgress = progress/100; 
       print(downloadProgress);
      });
    });
  }

  _pauseDownload() async {
    await FlutterDownloader.pause(taskId: taskId);
  }

  _resumeDownload() async {
    taskId = await FlutterDownloader.resume(taskId: taskId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("File Download"),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _downloadUrlController.text = "https://unsplash.com/photos/eS7HrvG0mcA/download?force=true";
        },
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _downloadUrlController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Download Url",
                  labelText: "Downlaod Url"
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  _doActionDownload();
                },
                child: Text("Download"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(
                value: downloadProgress.toDouble(),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("PAUSE"),
                onPressed: () {
                  _pauseDownload();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text("RESUME"),
                onPressed: () {
                  _resumeDownload();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

