import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:manga/src/models/manga_model.dart';
import 'package:manga/src/providers/home_provider.dart';
import 'package:manga/src/routes/routes.dart';
import 'package:package_info/package_info.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  static final pageName = 'home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HomeProvider prov = HomeProvider();
  final GlobalKey<ScaffoldState> _scaffoldkey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: createDrawer(),
      key: _scaffoldkey,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[createHomeAppBar(), createView()],
        ),
      ),
    );
  }

  Widget createDrawer(){
    return Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.only(top: 125, left: 10),
              child: Text(
                'Menú',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25),
              ),
              decoration: BoxDecoration(
                color: Colors.blue,
                image: DecorationImage(
                    image: AssetImage('assets/img/header.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
            ListTile(
              title: Row(
                children: <Widget>[
                  Text(AboutPage.pageList),
                  SizedBox(
                    width: 10,
                  ),
                  Icon(Icons.help_outline),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AboutPage();
                }));
              },
            ),
            ListTile(
              title: FutureBuilder(
                future: getAppVersion(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text('Version: ${snapshot.data}');
                  } else if (snapshot.hasError) {
                    return Text('Ha ocurrido un error :(');
                  } else {
                    return Text('Cargando...');
                  }
                },
              ),
            ),
          ],
        ),
      );
  }

  Widget createHomeAppBar() {
    return SliverAppBar(
      centerTitle: true,
      floating: true,
      pinned: true,
      elevation: 10,
      forceElevated: true,
      expandedHeight: 100,
      flexibleSpace: FlexibleSpaceBar(
        title: Text('Ultimos lanzamientos'),
        centerTitle: true,
        background: Image.asset('assets/img/header.jpg', fit: BoxFit.cover),
      ),
      actions: <Widget>[
        IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () =>
                setState(() => (_scaffoldkey.currentState.showSnackBar(SnackBar(
                      content: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onVerticalDragStart: (_) => null,
                        child: SpinKitFadingCube(
                        color: Colors.black54,
                        size: 50.0,
                        ),
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                    )))))
      ],
    );
  }

  Widget createView() {
    return FutureBuilder(
      future: prov.loadBody(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
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
                        'Ha ocurrido un error al conectar a la base de datos :(',
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            )
          ]));
        } else if (snapshot.hasData) {
          final lista = snapshot.data;
          return createGrid(lista);
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
    );
  }

  Widget createGrid(List<Manga> mangas) {
    final x = mangas.length % 2;
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (x == 1) ? 3 : 2, childAspectRatio: 0.7),
        delegate: SliverChildBuilderDelegate(
          (BuildContext context, i) {
            return Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GridTile(
                    child: InkResponse(
                      enableFeedback: true,
                      child: FadeInImage(
                        placeholder: AssetImage('assets/img/loader.gif'),
                        image: NetworkImage(mangas[i].imgs, scale: 0.5),
                      ),
                      onTap: () => openMangaView(mangas[i]),
                    ),
                    footer: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                        color: Colors.black87,
                        child: Center(
                          child: Text(
                            mangas[i].label,
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Colors.white),
                          ),
                        )),
                  ),
                ));
          },
          childCount: mangas.length,
        ));
  }

  openMangaView(Manga manga) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MangaDetail(
        manga: manga,
      );
    }));
  }

  Future<String> getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }
}
