import 'package:http/http.dart';
import 'package:html/parser.dart';
import 'package:html/dom.dart';
import 'package:manga/src/models/manga_model.dart';

class HomeProvider {
  static final baseUrl = 'https://tvymanga.com/portada/';
  final client = Client();

  Future loadBody() async {
    Response response = await client.get(baseUrl);
    final data = parse(response.body);
    List<Element> links =
        data.querySelectorAll('div.rt-holder > div.rt-img-holder > a');
    List<Element> labels = data
        .querySelectorAll('div.rt-holder > div.rt-detail > h2.entry-title > a');
    List<Element> imgs = data.querySelectorAll(
        'div.rt-holder > div.rt-img-holder > a > img.img-responsive');
    final total = (links.length + labels.length + imgs.length) / 3;
    MangaHandler mangas;
    List<Map<String, dynamic>> items = new List<Map<String, dynamic>>();
    if ((total % 2) == 0) {
      for (var i = 0; i < total; i++) {
        items.add({
          'label': labels[i].text,
          'link': links[i].attributes['href'],
          'imgs': imgs[i].attributes['src'],
        });
      }
      mangas = new MangaHandler.fromJsonList(items);
    } else {
      return false;
    }
    return mangas.lista;
  }

  Future<List<String>> loadDetail(String link) async {
    Response response = await client.get(link);
    final data = parse(response.body);
    List<Element> pagesData = data
        .querySelectorAll('div.entry-content')[0]
        .children[5]
        .querySelectorAll('img');
    List<String> pages = new List<String>();
    pagesData.forEach((item) {
      pages.add(item.attributes['src']);
    });
    return pages;
  }
}
