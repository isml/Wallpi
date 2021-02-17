import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Spinkit{



  Widget spinkit() {
    return Center(
        child: SpinKitChasingDots(
      duration: const Duration(milliseconds: 900),
      size: 50,
      itemBuilder: (BuildContext context, int index) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Colors.white60),
        );
      },
    ));
  }
}