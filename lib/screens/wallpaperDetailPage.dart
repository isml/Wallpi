import 'dart:io';

import 'package:dio/dio.dart';
//import 'package:downloads_path_provider/downloads_path_provider.dart';
import 'package:easy_permission_validator/easy_permission_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wallpaperapp/models/wallpaper.dart';
import 'package:wallpaperapp/services/advert-service.dart';
import 'package:wallpaperplugin/wallpaperplugin.dart';
import 'package:wallpaperapp/screens/homePage.dart';
import 'package:ext_storage/ext_storage.dart';
class WallpaperDetailPage extends StatefulWidget {
  Wallpaper wallpaper;
  WallpaperDetailPage({this.wallpaper});
  @override
  _WallpaperDetailPageState createState() => _WallpaperDetailPageState();
}

class _WallpaperDetailPageState extends State<WallpaperDetailPage> {
  AdvertService _advertService = AdvertService();
  Directory _downloadsDirectory;
  String _downloadPath;

  bool alertCloseControl = true;
  bool alertControl = false;
  bool permission = false;
  bool downloadImage = false;
  String downPer = "0%";
  final String nAvail = "Not Available";
  @override
  void initState() {
    super.initState();
    initDownloadsDirectoryState();
  }

  _permissionRequest(Size screenSize, String frmt) async {
    final permissionValidator = EasyPermissionValidator(
      context: context,
      appName: 'Wallbay',
    );
    var result = await permissionValidator.storage();
    if (result) {
      setState(() {
        permission = true;
        setWallpaper(screenSize, frmt);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: <Widget>[
        Hero(
          tag: widget.wallpaper.portrait,
          child: Container(
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                widget.wallpaper.portrait,
                fit: BoxFit.cover,
              )),
        ),
        Positioned(
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: alertControl == false
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: downloadImage
                      ? Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white60,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              "Downloading.. $downPer",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              width: screenSize.width / 2.1,
                              child: InkWell(
                                onTap: () {
                                  if (permission == false) {
                                    print("Requesting Permission");
                                    _permissionRequest(screenSize, "portrait");
                                  } else {
                                    print("Permission Granted.");
                                    setWallpaper(screenSize, "portrait");
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Download Portrait",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Icon(Icons.crop_portrait)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: screenSize.width / 2.1,
                              child: InkWell(
                                onTap: () {
                                  if (permission == false) {
                                    print("Requesting Permission");
                                    _permissionRequest(screenSize, "original");
                                  } else {
                                    print("Permission Granted.");
                                    setWallpaper(screenSize, "original");
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white60,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Download Original",
                                          style: TextStyle(color: Colors.black),
                                        ),
                                        Icon(Icons.crop_original)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ))
              : Text(""),
        ),
      ]),
    );
  }

  void setWallpaper(Size screenSize, String format) async {
    String frmt;
    if (format == "portrait") {
      frmt = widget.wallpaper.portrait;
    } else {
      frmt = widget.wallpaper.original;
    }
    print(_downloadsDirectory.toString());
    final dir = _downloadsDirectory;
    print(dir);
    Dio dio = new Dio();
    print(widget.wallpaper.id.toString());
    dio.download(
      frmt,
      "${_downloadPath}/${widget.wallpaper.id.toString()}.png",
      onReceiveProgress: (received, total) {
        if (total != -1) {
          String downloadingPer =
              ((received / total * 100).toStringAsFixed(0) + "%");
          setState(() {
            downPer = downloadingPer;
          });
        }
        setState(() {
          downloadImage = true;
        });
      },
    ).whenComplete(() {
      setState(() {
        downloadImage = false;
        _showAlert(screenSize);
        if (alertCloseControl == false) {
          print("true");
        }
        //
      });
      setState(() {
        alertControl = true;
      });

      //initPlatformState("${dir.path}/wallbay.png");
    });
  }

  Future<void> initPlatformState(String path) async {
    String wallpaperStatus = "Unexpected Result";
    String _localFile = path;
    try {
      Wallpaperplugin.setWallpaperWithCrop(localFile: _localFile);
      wallpaperStatus = "Wallpaper set";
    } on PlatformException {
      print("Platform exception");
      wallpaperStatus = "Platform Error Occured";
    }
    if (!mounted) return;
  }

  //////////////////
  Future<void> initDownloadsDirectoryState() async {
    Directory downloadsDirectory;
   
    
 _downloadPath= await ExtStorage.getExternalStoragePublicDirectory(
        ExtStorage.DIRECTORY_DOWNLOADS);
    /*try {
      downloadsDirectory = await DownloadsPathProvider.downloadsDirectory;
    } on PlatformException {
      print('Could not get the downloads directory');
    }

    if (!mounted) return;

    setState(() {
      _downloadsDirectory = downloadsDirectory;
    });*/
  }

  _showAlert(Size screenSize) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (_) => AlertDialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              "Download Succesfully",
              style: TextStyle(
                  color: Colors.black, fontSize: (screenSize.width / 12)),
            ),
            Container(
                child: Icon(
              Icons.check_circle,
              color: Colors.green,
              size: (screenSize.width / 1.5),
            )),
            Container(
              decoration: BoxDecoration(
                  color: Colors.black, borderRadius: BorderRadius.circular(15)),
              child: FlatButton(
                  onPressed: () {
                    print(screenSize.width);
                    setState(() {
                      alertCloseControl = false;
                      _advertService.showInterstitial();
                      Navigator.pop(context);
                      Navigator.pop(context);
                    });
                  },
                  child: Text("OK", style: TextStyle(color: Colors.white))),
            )
          ],
        ),
      ),
    );
  }
}
