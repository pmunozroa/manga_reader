import 'package:flutter/material.dart';
// import 'package:flutter_downloader/flutter_downloader.dart';
import 'src/routes/routes.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // await FlutterDownloader.initialize();
  runApp(MyApp());

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomePage.pageName,
      routes: getAllRoutes(),
    );
  }
}
