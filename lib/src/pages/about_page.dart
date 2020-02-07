import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static final pageName = 'about';
  static final pageList = 'Acerca de esta app';
  final TextStyle estilo = TextStyle(fontWeight: FontWeight.w500, fontSize: 15);
  final SizedBox separacion = SizedBox(height: 10);
  final String urlWeb = 'https://tvymanga.com/portada/';
  final String urlFace = 'https://www.facebook.com/pmunozroa/';
  final String urlGit = 'https://github.com/pmunozroa';
  final String urlIg = 'https://www.instagram.com/_ashesofdreams/';
  final String urlPp =
      'https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=STGMFBK48QX4J&source=url';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pageList),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Acerca de esta app:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                  ),
                ],
              ),
              separacion,
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      'Esta app se desarrolló sin fines de lucro, por lo que no contará con ads, el contenido mostrado corresponde a tvymanga.com.',
                      style: estilo,
                    ),
                  ),
                ],
              ),
              separacion,
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                        elevation: 5,
                        onPressed: () => _launchURL(urlWeb, context),
                        color: Theme.of(context).primaryColor,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Ir a tvymanga'),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(FontAwesomeIcons.chrome)
                          ],
                        )),
                  ),
                ],
              ),
              separacion,
              Row(
                children: <Widget>[
                  Text(
                    'Acerca de mi:',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                  ),
                ],
              ),
              separacion,
              Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    'Analista programador, Chileno, 27 años, desarrollé esta app porque en la página de tvymanga se ve super mal todo, las imagenes están muy pegadas, muchos ads, no hay zoom y me molestaba, así que el día 02 de febrero del 2020 me decidí a programar esto, con mi vago conocimiento en scraping, flutter y deploy de apps en Google Play Store, pero lo logré, así que espero que disfruten y les sirva, cualquier comentario constructivo y destructivo es bienvenido, a continuación dejo mis redes sociales:',
                    style: estilo,
                  )),
                ],
              ),
              separacion,
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                            elevation: 5,
                            onPressed: () => _launchURL(urlFace, context),
                            color: Color.fromRGBO(0, 82, 204, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Facebook',
                                  style: estilo,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(FontAwesomeIcons.facebookSquare)
                              ],
                            )),
                        RaisedButton(
                            elevation: 5,
                            onPressed: () => _launchURL(urlGit, context),
                            color: Color.fromRGBO(153, 255, 153, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Github',
                                  style: estilo,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(FontAwesomeIcons.githubAlt)
                              ],
                            )),
                        RaisedButton(
                            elevation: 5,
                            onPressed: () => _launchURL(urlIg, context),
                            color: Color.fromRGBO(255, 102, 102, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Instagram',
                                  style: estilo,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(FontAwesomeIcons.instagram)
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              ),
              separacion,
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                            'Ya que esta app es sin fines de lucro, cualquier donación será de gran ayuda para seguir creciendo :)',
                            style: estilo),
                        separacion,
                        RaisedButton(
                            elevation: 5,
                            onPressed: () => _launchURL(urlPp, context),
                            color: Color.fromRGBO(156, 218, 241, 1),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Paypal',
                                  style: estilo,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(FontAwesomeIcons.paypal)
                              ],
                            )),
                      ],
                    ),
                  )
                ],
              )
            ],
          )),
    );
  }

  _launchURL(url, context) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                  title: Text('Error al abrir la url'),
                  content: Text(
                      'Se ha producido un error al abrir la URL, verifica tu conexión.'),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('Ok'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]));
    }
  }
}
