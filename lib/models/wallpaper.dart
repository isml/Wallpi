class Wallpaper {
  String original;
  String portrait;
  int id;

  Wallpaper({
    this.original,
    this.portrait,
    this.id
  });

  Wallpaper.fromMap(Map<String, dynamic> map) {
    this.original = map["src"]["original"];
    this.portrait = map["src"]["portrait"];
     this.id = map["id"];
  }

  toJson() {
    return {
      "original": this.original,
      "portrait": this.portrait,
      "id": this.id,
    };
  }
}
