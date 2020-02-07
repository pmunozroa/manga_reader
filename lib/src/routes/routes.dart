import 'package:flutter/material.dart';
import 'package:manga/src/pages/about_page.dart';
import 'package:manga/src/pages/home_page.dart';
import 'package:manga/src/pages/manga_detail.dart';
export 'package:manga/src/pages/manga_detail.dart';
export 'package:manga/src/pages/home_page.dart';
export 'package:manga/src/pages/about_page.dart';


Map<String, WidgetBuilder> getAllRoutes(){
  return {
    HomePage.pageName : (BuildContext context) => HomePage(),
    MangaDetail.pageName : (BuildContext context) => MangaDetail(),
    AboutPage.pageName : (BuildContext context) => AboutPage(),

  };
}