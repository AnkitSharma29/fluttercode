import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget myCachedNetworkImage(
  mediaUrl, {
  double myBorderRadius = 0,
  String defualtImage,
}) {
  String _defImg = (defualtImage == null) ? 'no-photo.png' : defualtImage;

  if (mediaUrl == null)
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage('assets/images/' + _defImg),
          fit: BoxFit.fill,
        ),
      ),
    );
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(myBorderRadius),
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
          // colorFilter:
          //     ColorFilter.mode(Colors.red, BlendMode.colorBurn)
        ),
      ),
    ),
    placeholder: (context, url) => Center(
      child: CircularProgressIndicator(),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );

  // return CachedNetworkImage(
  //   imageUrl: mediaUrl,
  //   fit: BoxFit.cover,
  //   placeholder: (context, url ) =>  Padding(
  //     child: CircularProgressIndicator(),
  //     padding: EdgeInsets.all(20.0),
  //   ),
  //   errorWidget: (context, url, error) => Icon(Icons.error) ,
  // );
}
