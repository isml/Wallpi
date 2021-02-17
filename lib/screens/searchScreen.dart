import 'package:flutter/material.dart';
import 'package:wallpaperapp/models/wallpaper.dart';
import 'package:wallpaperapp/screens/wallpaperDetailPage.dart';
import 'package:wallpaperapp/services/api_call.dart';
import 'package:wallpaperapp/widgets/spinkit.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Wallpaper> wallpapers = List<Wallpaper>();
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool bodyControl = false;
  String searchWord = "";
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    // TODO: implement build
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: TextField(
          autofocus: true,
          focusNode: _focusNode,
          controller: searchController,
          decoration: InputDecoration(
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.green),
              ),
              hintText: "Search..",
              hintStyle: TextStyle(color: Colors.white, fontSize: 20),
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      bodyControl = true;
                      searchWord = searchController.text.toString();
                    });
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.green,
                  ))),
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white),
          textInputAction: TextInputAction.search,
          onEditingComplete: () {
            print(searchController.text);
            //burada api işlemi yaptıracağım
            setState(() {
              bodyControl = true;
              searchWord = searchController.text.toString();
            });
          },
        ),
      ),
      body: bodyControl == true ? buildSearchPageWidget(screenSize) : Text(""),
    );
  }

  buildSearchPageWidget(Size screenSize) {
    return FutureBuilder<Object>(
        future: _apiCallCategoriesAddWallpaperList(),
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
    wallpapers = await ApiCall().getApiCategoriesWallpaper(searchWord);
  }
}
