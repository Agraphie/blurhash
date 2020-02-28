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
        child: Image.memory(blurhash.Decoder.decode(hash, 300, 200)),
      ),
    );
  }
}
