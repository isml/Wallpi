import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:wallpaperapp/models/category.dart';
import 'package:wallpaperapp/models/wallpaper.dart';
import 'package:wallpaperapp/screens/categoryHomePage.dart';
import 'package:wallpaperapp/screens/searchScreen.dart';
import 'package:wallpaperapp/screens/wallpaperDetailPage.dart';
import 'package:wallpaperapp/services/api_call.dart';
import 'package:wallpaperapp/widgets/spinkit.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Wallpaper> wallpapers = List<Wallpaper>();
  int selectedToggle = 0;
  List<Category> categoryNamelist = Category().getCategoryList();

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // TODO: implement build
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.black54,
            child: Icon(Icons.search),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchScreen()));
            }),
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            "W a l l P i".toUpperCase(),
            style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.grey),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
        ),
        body: buildHomePagewidget(screenSize));
  }

  buildHomePagewidget(Size screenSize) {
    return selectedToggle == 0
        ? Stack(
            alignment: Alignment.bottomLeft,
            children: [
              FutureBuilder<Object>(
                  future: _apiCallAddWallpaperList(),
                  builder: (context, snapshot) {
                    final orientation = MediaQuery.of(context).orientation;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: Spinkit().spinkit());
                    } else {
                      if (snapshot.hasError) {
                        return Center(
                            child: Text('Connection Error',
                                style: TextStyle(color: Colors.white)));
                      } else {
                        return GridView.builder(
                          itemCount: wallpapers.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: 0.55,
                                  crossAxisCount:
                                      (orientation == Orientation.portrait)
                                          ? 2
                                          : 3),
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              onTap: () {
                                print("basıldı");
                                print(wallpapers[index].id.toString());
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            WallpaperDetailPage(
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
                  }),
              _choiceButton(),
            ],
          )
        : buildCategoryWidget(screenSize);
  }

  _apiCallAddWallpaperList() async {
    wallpapers = await ApiCall().getApiWallpaper();
  }

  _choiceButton() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        child: ToggleSwitch(
          activeBgColors: [Colors.teal[700], Colors.pink[900]],
          initialLabelIndex: selectedToggle,
          minHeight: 50.0,
          minWidth: 150.0,
          cornerRadius: 20.0,
          activeBgColor: Colors.teal[700],
          activeFgColor: Colors.white,
          inactiveFgColor: Colors.white,
          labels: ['Editor Choice', 'Categories'],
          icons: [Icons.edit, Icons.category],
          onToggle: (index) {
            print('switched to: $index');
            setState(() {
              selectedToggle = index;
            });
          },
        ),
      ),
    );
  }

  buildCategoryWidget(Size screenSize) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        buildLisCategoryElement(screenSize),
        _choiceButton(),
      ],
    );
  }

  buildLisCategoryElement(Size screenSize) {
    return ListView.builder(
        itemCount: categoryNamelist.length,
        itemBuilder: (context, index) {
          var list =
              categoryNamelist[index].name.toString().toUpperCase().split("");
          String name = "";
          for (var i = 0; i < list.length; i++) {
            if (i != list.length) {
              name += list[i] + " ";
            } else {
              name += list[list.length];
            }
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                print(categoryNamelist[index].name);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CategoryHomePage(
                            category: categoryNamelist[index].name)));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: screenSize.height / 3,
                    width: screenSize.width,
                    child: Card(
                      semanticContainer: true,
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Hero(
                        tag: "${categoryNamelist[index].image}",
                        child: FadeInImage.assetNetwork(
                          image: "${categoryNamelist[index].image}",
                          fit: BoxFit.cover,
                          placeholder: "image/loading.png",
                          imageScale: 1,
                        ),
                      ),
                    ),
                  ),
                  SafeArea(
                                      child: Text(
                      name,
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: screenSize.width/8,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
