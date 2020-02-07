import 'dart:convert';

Manga mangaFromJson(String str) => Manga.fromJson(json.decode(str));

String mangaToJson(Manga data) => json.encode(data.toJson());

class MangaHandler {
  List<Manga> lista = new List<Manga>();

  MangaHandler();

  MangaHandler.fromJsonList(List<dynamic> jsonList) {
    if (jsonList == null) return;
    jsonList.forEach((item) {
      final manga = new Manga.fromJson(item);
      lista.add(manga);
    });
  }
}

class Manga {
    String label;
    String link;
    String imgs;
    Manga({
        this.label,
        this.link,
        this.imgs,
    });

    factory Manga.fromJson(Map<String, dynamic> json) => Manga(
        label: json["label"],
        link: json["link"],
        imgs: json["imgs"],
    );

    Map<String, dynamic> toJson() => {
        "label": label,
        "link": link,
        "imgs": imgs,
    };
}

