import 'dart:ui' as ui;

import 'package:blurhash/blurhash.dart' as blurhash;
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter blurhash',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter blurhash'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // A correct blurhash
  static const hash =
      r"q.NK3Mt7WrofayazbHj[.TkCWBWCj[j@f6azIUWXjZWBWCjsoLayM{ofazayjZa#Wqj[kCWBj[bHWXj[jZWVt7WCs:ofa}axjZay";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<ui.Image>(
          future: blurhash.Encoder.decodeAsImage(hash, 300, 200),
          builder: (context, AsyncSnapshot<ui.Image> snapshot) {
            if (snapshot.hasData) {
              return CustomPaint(
                // Passing our generated blurry image
                painter: BlurhashPainter(image: snapshot.data),
                child: Container(
                  width: 300,
                  height: 200,
                ),
              );
            } else if (snapshot.hasError) {
              print(snapshot.error);
            }
            return Container();
          },
        ),
      ),
    );
  }
}

class BlurhashPainter extends CustomPainter {
  ui.Image image;

  BlurhashPainter({this.image});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawImage(image, Offset.zero, Paint());
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
