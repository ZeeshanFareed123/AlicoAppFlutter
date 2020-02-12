import 'package:alico_tablet/Model/alico_model.dart';
import 'package:alico_tablet/commonUtils/model.dart';
import 'package:alico_tablet/views/ProductDetail.dart';
import 'package:alico_tablet/views/Types.dart';
import 'package:alico_tablet/views/myDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import '../commonUtils/constants.dart';

class SubCategory extends StatefulWidget {
  int _sub_cat_color;
  final List<Categories> subCat;

  SubCategory(this._sub_cat_color, {Key key, this.subCat}) : super(key: key);

  @override
  _SubCategoryState createState() => _SubCategoryState();
}

class _SubCategoryState extends State<SubCategory> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpen = false;
  String catBaseLinks;

  @override
  void initState() {
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
        endDrawer: MyDrawer(callback: (){drawerCallback();},),
        body: Center(
          child: FutureBuilder<modelAlico>(
            future: ModelApi.alicoData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                //to get Cat_Image data
                catBaseLinks = snapshot.data.imgLinks.categoryImg;

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

  void drawerCallback(){
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
        itemCount: widget.subCat.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context,
                  PageTransition(type:
                  PageTransitionType.leftToRightWithFade,
                      child: Types(     widget._sub_cat_color,
                        products: widget.subCat[index].products,)));
            /*  Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Types(
                          widget._sub_cat_color,
                          products: widget.subCat[index].products,
                        )),
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
                              catBaseLinks +
                              widget.subCat[index].image,
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
                                Color(widget._sub_cat_color).withOpacity(0.6),
                                BlendMode.colorBurn)),
                      ),
                      child: Center(
                        child: Text(
                          widget.subCat[index].name,
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
