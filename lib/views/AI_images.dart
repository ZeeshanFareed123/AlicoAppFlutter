import 'package:alico_tablet/commonUtils/model.dart';
import 'package:alico_tablet/views/myDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../commonUtils/constants.dart';
import 'FullScreenImg.dart';

class AlImages extends StatefulWidget {
  final String id;
  AlImages(this.id);

  @override
  _AlImagesState createState() => _AlImagesState();
}

class _AlImagesState extends State<AlImages> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpen = false;
  List<String> Preview = [];
  List<String> _catimg = [];

  @override
  void initState() {
    for (int i = 0; i < ModelApi.catimgs.length; i++) {
      if (widget.id == ModelApi.catimgs[i].catId) {
        _catimg.add(ModelApi.catimgs[i].fileName);
      }
    }
    print("full imae");
    print(_catimg.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print("all image id");
    print(widget.id);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140.0),
        child: Container(
          height: 130,
          color: Constants.greenColor,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Center(
                child: Padding(
                  padding: const EdgeInsets.only( left: 25),
                  child: Image(
                    height: 110,
                    width: 110,
                    image: AssetImage("assets/images/icon.png"),
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only( right: 25),
                        child: IconButton(
                          iconSize: 40,
                          icon: Image(
                            image: AssetImage("assets/images/back-arrow.png"),
                            fit: BoxFit.cover,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only( right: 20),
                        child: IconButton(
                          iconSize: 40,
                          icon: Image(
                            image: AssetImage("assets/images/menu_icon.png"),
                            fit: BoxFit.cover,
                          ),
                          onPressed: () {
                            _isOpen = !_isOpen;
                            if (!_isOpen) {
                              Navigator.pop(context);
                            } else {
                              _scaffoldKey.currentState.openEndDrawer();
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Scaffold(
        key: _scaffoldKey,
        endDrawer: MyDrawer(
          callback: () {
            drawerCallback();
          },
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
          ),
          itemCount: _catimg.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => FullScreen(
                              img: Constants.BASE_URL +
                                  ModelApi.baseCatImages +
                                  _catimg[index],
                            )));
              },
              child: Card(
                child: Container(
                  child: CachedNetworkImage(
                    imageUrl: Constants.BASE_URL +
                        ModelApi.baseCatImages +
                        _catimg[index],
                    placeholder: (context, url) => CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation(Constants.whiteColor70),
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void drawerCallback() {
    _isOpen = !_isOpen;
    if (_isOpen) {
      _scaffoldKey.currentState.openEndDrawer();
    } else {
      Navigator.pop(context);
    }
  }
}
