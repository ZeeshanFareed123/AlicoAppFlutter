import 'package:alico_tablet/Model/alico_model.dart' hide Colors;
import 'package:alico_tablet/commonUtils/constants.dart';
import 'package:alico_tablet/commonUtils/model.dart';
import 'package:alico_tablet/views/AI_images.dart';
import 'package:alico_tablet/views/ProductDetail.dart';
import 'package:alico_tablet/views/SubCategory.dart';
import 'package:alico_tablet/views/Types.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ExpandableListView extends StatefulWidget {
  // final String title;
  final Categories categories;
  final int index;

  const ExpandableListView({Key key, this.categories, this.index})
      : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              setState(() {
                expandFlag = !expandFlag;
              });
            },
            child: new Container(
              height: 80,
              color: Constants.greenDark,
              padding: new EdgeInsets.symmetric(horizontal: 5.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Text(
                        widget.categories.name,
                        style: new TextStyle(fontSize: 25, color: Colors.white),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AlImages(
                                ModelApi.categoryAll[widget.index].id)),
                      );
                    },
                   /* child: Padding(
                      padding: const EdgeInsets.only(right: 35),
                      child: SizedBox.fromSize(
                        child:  SvgPicture.asset(
                          'assets/images/photo.svg',
                          color: Colors.white,
                        ),
                        size: Size(32.0, 32.0),
                      ),
                    ),*/
                    child: Padding(
                      padding: const EdgeInsets.only(right: 35),
                      child:  new SvgPicture.asset(
                        'assets/images/photo.svg',
                        color: Colors.white,
                        height: 30.0,
                        width:30.0,
                        allowDrawingOutsideViewBox: true,
                      ),

                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (ModelApi.categories[widget.index].subCategory ==
                              null ||
                          ModelApi
                              .categories[widget.index].subCategory.isEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Types(
                                    int.parse(ModelApi
                                        .categories[widget.index].colorcode
                                        .replaceAll(new RegExp(r'#'), '0xFF')),
                                    products: ModelApi
                                        .categories[widget.index].products,
                                  )),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SubCategory(
                                    int.parse(ModelApi
                                        .categories[widget.index].colorcode
                                        .replaceAll(new RegExp(r'#'), '0xFF')),
                                    subCat: ModelApi
                                        .categories[widget.index].subCategory,
                                  )),
                        );
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child:
                      new SvgPicture.asset(
                        'assets/images/wheel.svg',
                        color: Colors.white,
                        height: 30.0,
                        width:30.0,
                        allowDrawingOutsideViewBox: true,
                      ),


                    ),
                  ),
                ],
              ),
            ),
          ),
          new ExpandableContainer(
              expanded: expandFlag,
              child: new ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return GestureDetector(
                    onTap: () {
                      widget.categories.subCategory == null ||
                              widget.categories.subCategory.isEmpty
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductDetail(
                                      widget.categories.products[index].options)
                                  /*Types(
                                        int.parse(widget.categories
                                            .colorcode
                                            .replaceAll(
                                                new RegExp(r'#'), '0xFF')),
                                        products: widget.categories.products,
                                      )*/
                                  ),
                            )
                          : Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SubCategory(
                                        int.parse(widget.categories.colorcode
                                            .replaceAll(
                                                new RegExp(r'#'), '0xFF')),
                                        subCat: widget.categories.subCategory,
                                      )
                                  /* Types(
                                    int.parse(widget.categories
                                        .colorcode
                                        .replaceAll(
                                        new RegExp(r'#'), '0xFF')),
                                    products: widget.categories.products,
                                  )*/
                                  ),
                            );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40, right: 40),
                      child: new Container(
                        decoration: new BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                                width: 1.0,
                                color: Constants.grey200Color.withOpacity(0.9)),
                          ),
                        ),
                        child: new ListTile(
                          title: Padding(
                            padding: const EdgeInsets.only(top: 5.0),
                            child: new Text(
                              widget.categories.subCategory == null ||
                                      widget.categories.subCategory.isEmpty
                                  ? widget.categories.products[index].name
                                  : widget.categories.subCategory[index].name,
                              //   "Cool $index",
                              style: new TextStyle(
                                  fontSize: 22, color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                itemCount: widget.categories.subCategory == null ||
                        widget.categories.subCategory.isEmpty
                    ? widget.categories.products.length
                    : widget.categories.subCategory.length,
              ))
        ],
      ),
    );
  }
}

class ExpandableContainer extends StatelessWidget {
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    @required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 300.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
        decoration: new BoxDecoration(
            border: new Border.all(width: 1.0, color: Colors.transparent)),
      ),
    );
  }
}
