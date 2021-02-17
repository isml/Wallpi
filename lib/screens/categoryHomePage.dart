import 'package:flutter/material.dart';
import 'package:wallpaperapp/models/wallpaper.dart';
import 'package:wallpaperapp/screens/wallpaperDetailPage.dart';
import 'package:wallpaperapp/services/api_call.dart';
import 'package:wallpaperapp/widgets/spinkit.dart';

class CategoryHomePage extends StatefulWidget {
  String category;
  CategoryHomePage({this.category});
  @override
  _CategoryHomePageState createState() => _CategoryHomePageState();
}

class _CategoryHomePageState extends State<CategoryHomePage> {
  List<Wallpaper> wallpapers = List<Wallpaper>();
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            widget.category.toString().toUpperCase(),
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: buildCategoryHomePagewidget(screenSize));
  }

  buildCategoryHomePagewidget(Size screenSize) {
    return FutureBuilder<Object>(
        future: _apiCallCategoriesAddWallpaperList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Spinkit().spinkit());
          } else {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Connection Error',
                      style: TextStyle(color: Colors.white)));
            } else {
              final orientation = MediaQuery.of(context).orientation;
              return GridView.builder(
                itemCount: wallpapers.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.55,
                    crossAxisCount:
                        (orientation == Orientation.portrait) ? 2 : 3),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      print("basıldı");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WallpaperDetailPage(
                                  wallpaper: wallpapers[index])));
                    },
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Hero(
                        tag: wallpapers[index].portrait,
                        child: FadeInImage.assetNetwork(
                          image: wallpapers[index].portrait,
                          fit: BoxFit.cover,
                          placeholder: "image/loading2h.png",
                          imageScale: 1,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        });
  }

  _apiCallCategoriesAddWallpaperList() async {
    wallpapers = await ApiCall().getApiCategoriesWallpaper(widget.category);
  }
}
