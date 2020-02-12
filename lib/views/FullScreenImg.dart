import 'package:alico_tablet/commonUtils/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FullScreen extends StatefulWidget {
  final String img;


  const FullScreen({Key key, this.img}) : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();

}

class _FullScreenState extends State<FullScreen> {

  @override
  Widget build(BuildContext context) {
    print("Full screen image..............");
    print(widget.img);
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(child: CachedNetworkImage(imageUrl: widget.img, fit: BoxFit.fill,)),

          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 100, right: 100),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 60,
                    child: Icon(
                      Constants.closeIcon,
                      size: 40,
                      color: Colors.white,
                    ),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Constants.greyColor),
                  ),
                ],
              ),
            ),
          ),

        ],

      ),
    );
  }
}
