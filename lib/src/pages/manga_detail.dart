import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:manga/src/models/manga_model.dart';
import 'package:manga/src/providers/home_provider.dart';
import 'package:photo_view/photo_view.dart';

class MangaDetail extends StatefulWidget {
  static final pageName = 'detail';
  final Manga manga;

  MangaDetail({this.manga});

  @override
  _MangaDetailState createState() => _MangaDetailState(manga: manga);
}

class _MangaDetailState extends State<MangaDetail> {
  static var httpClient = new HttpClient();
  HomeProvider prov = HomeProvider();
  Manga manga;
  int curr = 0;
  bool controls = false;
  double viewPortZoom = 1;
  double containerHeight;
  int currentSelectedValue = 0;
  bool scrollDirection = true;
  PhotoViewController _photoViewController = PhotoViewController();
  SwiperController _controller = SwiperController();
  _MangaDetailState({this.manga});
  @override
  Widget build(BuildContext context) {
    containerHeight = (controls) ? 0.7 : 0.87;
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            createHomeAppBar(),
            FutureBuilder(
              future: prov.loadDetail(manga.link),
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData) {
                  return createMangaView(snapshot.data);
                } else if (snapshot.hasError) {
                  return SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                            ),
                            Text(
                                'Ha ocurrido un error al obtener las páginas :(',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    )
                  ]));
                } else {
                  return SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.35,
                            ),
                            SpinKitFadingCube(color: Theme.of(context).primaryColor,),
                            SizedBox(
                              height: 25,
                            ),
                            Text('Cargando :)',
                                style: TextStyle(
                                    fontSize: 25,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    )
                  ]));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget createMangaView(List<String> pages) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Container(
            child: Stack(
              children: <Widget>[
                createBackground(),
                createSwiper(pages),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget createBackground() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(manga.imgs),
          fit: BoxFit.fill,
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.894,
      width: MediaQuery.of(context).size.width,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Container(
          color: Colors.black.withOpacity(0.4),
        ),
      ),
    );
  }

  Widget createNavigation(List<String> pages) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          RaisedButton(
            onPressed: (curr == 0) ? null : () => _controller.move(0),
            elevation: 3,
            child: Icon(Icons.first_page),
            color: Theme.of(context).primaryColor,
          ),
          Text('Ir a página:'),
          DropdownButton<String>(
            isDense: true,
            value: currentSelectedValue.toString(),
            items: pages.map((String e) {
              return DropdownMenuItem<String>(
                child: Text((pages.indexOf(e) + 1).toString()),
                value: (pages.indexOf(e)).toString(),
              );
            }).toList(),
            onChanged: (item) {
              setState(() {
                currentSelectedValue = int.parse(item);
              });
              _controller.move(int.parse(item));
            },
          ),
          RaisedButton(
              onPressed: (curr == pages.length - 1)
                  ? null
                  : () => _controller.move(pages.length - 1),
              elevation: 3,
              child: Icon(Icons.last_page),
              color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }

  Widget createSwiper(List<String> pages) {
    final cont = (controls) ?  Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          createNavigation(pages),
          createViewer(pages),
          createPagination(pages),
          createFooter(pages)
        ],
      ),
    ) : Container(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        children: <Widget>[
          createViewer(pages),
          // createFooter()
        ],
      ),
    );
    return cont;

  }

  Widget createViewer(List<String> pages) {
    return Container(
      height: MediaQuery.of(context).size.height * containerHeight,
      width: MediaQuery.of(context).size.width * 1,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Swiper(
        index: curr,
        onIndexChanged: (index) {
          setState(() {
            curr = index;
          });
        },
        loop: false,
        scrollDirection: (!scrollDirection) ? Axis.vertical : Axis.horizontal,
        controller: _controller,
        duration: 700,
        control: (controls) ? SwiperControl(
            color: Colors.white60,
            iconNext: (curr == pages.length - 1)
                ? null
                : Icons.arrow_forward_ios,
            iconPrevious: (curr == 0) ? null : Icons.arrow_back_ios) : null,
        itemBuilder: (BuildContext context, int index) {
          return PhotoView(
            backgroundDecoration: BoxDecoration(color: Colors.transparent),
            controller: _photoViewController,
            filterQuality: FilterQuality.high,
            initialScale: PhotoViewComputedScale.contained * viewPortZoom,
            imageProvider: NetworkImage(pages[index]),
            loadingChild: Image.asset('assets/img/loader.gif'),
          );
        },
        itemCount: pages.length,
        viewportFraction: 1,
        scale: 0.5,
      ),
    );
  }

  Widget createPagination(List<String> pages) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('${curr + 1}',
              style: TextStyle(fontSize: 20, color: Colors.white)),
          Text(' / ', style: TextStyle(fontSize: 20, color: Colors.white)),
          Text('${pages.length}',
              style: TextStyle(fontSize: 30, color: Colors.lightBlueAccent))
        ],
      ),
    );
  }

  Widget createZoomer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Slider(
          max: 2,
          min: 1,
          value: viewPortZoom,
          onChanged: (val) => setState(() => _photoViewController.scale = val)),
    );
  }

  Widget createFooter(List<String> pages) {
    return Container(
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
                onPressed: () => _save(pages[curr]),
                elevation: 3,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.insert_drive_file),
                    Text(
                      ' Descargar página',
                    )
                  ],
                ),
                color: Colors.lightGreenAccent),
            SizedBox(
              width: 10,
            ),
            RaisedButton(
                onPressed: () => _save(pages, true),
                elevation: 3,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.cloud_download),
                    Text(' Descargar episodio')
                  ],
                ),
                color: Theme.of(context).primaryColor)
          ],
        ),
      ),
    );
  }

  Widget createHomeAppBar() {
    return SliverAppBar(
      actions: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            // IconButton(icon: Icon((scrollDirection) ? Icons.swap_vert : Icons.swap_horiz), onPressed: () => setState(() => (scrollDirection) ? scrollDirection = false : scrollDirection = true)),
            IconButton(icon: Icon((controls) ? Icons.visibility : Icons.visibility_off) , onPressed: () => setState(() => (controls) ? controls = false : controls = true)),
          ],
        ),
      ],
      title: Text(manga.label),
      floating: true,
      pinned: true,
      elevation: 10,
      forceElevated: true,
    );
  }
  _save(dynamic url, [bool multi = false]) async {
    if(multi){
      url.forEach((e) async {
        var response = await Dio().get(e, options: Options(responseType: ResponseType.bytes));
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
      });
    }else{
      var response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));
      await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    }
    Scaffold.of(context).showSnackBar(SnackBar(content: Text('Imagen guardada'), backgroundColor: Theme.of(context).primaryColor, duration: Duration(seconds: 2),));
  }

}
