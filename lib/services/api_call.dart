import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:wallpaperapp/const.dart';
import 'package:wallpaperapp/models/wallpaper.dart';

class ApiCall {
  List<Wallpaper> wallpapers = List<Wallpaper>();
  Future<List<Wallpaper>> getApiWallpaper() async {
    var response = await http.get(
        Uri.encodeFull(editorChoiceEndPoint + perPageLimit),
        headers: {"Accept": "application/json", "Authorization": "$apiKey"});

    var data = jsonDecode(response.body)["photos"];
    //print(data.toString());
    wallpapers = List<Wallpaper>();
    for (var i = 0; i < data.length; i++) {
      wallpapers.add(Wallpaper.fromMap(data[i]));
    }
    return wallpapers;
  }

  Future<List<Wallpaper>> getApiCategoriesWallpaper(String category) async {
    var response = await http.get(
        Uri.encodeFull(searchEndPoint + category + perPageLimit),
        headers: {"Accept": "application/json", "Authorization": "$apiKey"});
    var data = jsonDecode(response.body)["photos"];
    wallpapers = List<Wallpaper>();
    for (var i = 0; i < data.length; i++) {
      wallpapers.add(Wallpaper.fromMap(data[i]));
    }
    return wallpapers;
  }
}
