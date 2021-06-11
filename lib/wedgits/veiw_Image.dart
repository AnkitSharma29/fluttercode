import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImagePage extends StatefulWidget {
  final String imgUrl;
  ShowImagePage({this.imgUrl, Key key}) : super(key: key);

  @override
  _ShowImagePageState createState() => _ShowImagePageState();
}

class _ShowImagePageState extends State<ShowImagePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
          child: PhotoView(imageProvider: NetworkImage(widget.imgUrl))),
    );
  }
}
