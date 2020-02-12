import 'dart:io';
import 'package:alico_tablet/Model/alico_model.dart';
import 'package:alico_tablet/commonUtils/constants.dart';
import 'package:alico_tablet/commonUtils/model.dart';
import 'package:alico_tablet/views/myDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'ProductDetail.dart';

class Types extends StatefulWidget {
  int color_home;
  final List<Products> products;

  Types(this.color_home, {Key key, this.products}) : super(key: key);

  @override
  _TypesState createState() => _TypesState();
}

class _TypesState extends State<Types> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpen = false;

  @override
  Future<void> initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        body: Center(
          child: FutureBuilder<modelAlico>(
            future: ModelApi.alicoData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return DataSubCategory();
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
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
  Widget DataSubCategory() {
    return Scaffold(
      body: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemCount: widget.products.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              ModelApi.product_id = widget.products[index].productId;
              Navigator.push(context,
                  PageTransition(type:
                  PageTransitionType.leftToRightWithFade,
                      child: ProductDetail(    widget.products[index].options)));
             /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProductDetail(widget.products[index].options)),
              );*/
            },
            child: Card(
              child: Container(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: Constants.BASE_URL +
                              ModelApi.productBaseLinkse +
                              widget.products[index].productImage,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.fill,
                                  colorFilter: ColorFilter.mode(
                                      Constants.transparentColor,
                                      BlendMode.colorBurn)),
                            ),
                          ),
                          placeholder: (context, url) =>
                            CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation(Constants.whiteColor70),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Container(
                      height: 65,
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: new AssetImage('assets/images/back.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Color(widget.color_home).withOpacity(0.6),
                                BlendMode.colorBurn)),
                      ),
                      child: Center(
                        child: Text(
                          widget.products[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 26.0,
                              color: Constants.whiteColor70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
