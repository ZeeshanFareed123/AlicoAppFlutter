import 'dart:convert';
import 'dart:io';
import 'package:alico_tablet/Model/alico_model.dart';
import 'package:alico_tablet/commonUtils/model.dart';
import 'package:alico_tablet/views/AI_images.dart';
import 'package:alico_tablet/views/myDrawer.dart';
import 'package:alico_tablet/views/thankYou.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import '../commonUtils/constants.dart';
import 'FullScreenImg.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class ProductDetail extends StatefulWidget {
  ProductDetail(this.options);

  final Map<String, List<Options>> options;

  @override
  _ProductDetailState createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail>
    with TickerProviderStateMixin {
  final _validator = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpen = false;
  bool expandFlag = false;
  List<bool> _visible = [];
  List<bool> pressAttention = [];
  List<int> currentPage = [];
  List<PageController> c = [];

  List<Options> _region1 = [];
  List<Options> _region2 = [];
  List<Options> _region3 = [];
  List<Options> _region4 = [];
  List<Options> _region5 = [];

  int _viewPagePositionSAved = 0;
  List<int> _pageViewSize = [];

  String optionBaseLinkse;
  List<List<Options>> listmain = [];

  final List<String> _dropdownValues = ["1", "2", "3", "4", "5"];
  List<DropdownMenuItem<Salesman>> saleman;
  List<DropdownMenuItem<Colors>> color;
  Salesman _selectedSalesman;
  Colors _selectedColor;
  String _selectedqty;

  String customer_name;
  String email;
  String color_id;
  String saleman_id;
  String qty;
  String _details;
  int type;
  String product_id;
  String region_id;
  String option_id;

  Directory dir;
  File jsonFile;
  bool fileExists;
  AnimationController controller;

  @override
  void initState() {
    saleman = buildDropdownSalesman(ModelApi.salesman);
    color = buildDropdownColor(ModelApi.color);
    isShowing = false;
    controller = AnimationController(
        duration: const Duration(milliseconds:0), vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          setState(() {
            isShowing = !isShowing;
            if (isShowing)
              WidgetsBinding.instance.addPostFrameCallback((c){
                Scrollable.ensureVisible(endKey.currentContext,duration: Duration(milliseconds: 250));
              });
          });
        }
      });
    optionBaseLinkse = ModelApi.optionBaseLinkse;

    widget.options.forEach((a, v) {
      if (a == "1") {
        _region1 = v;
      } else if (a == "2") {
        _region2 = v;
      } else if (a == "3") {
        _region3 = v;
      } else if (a == "4") {
        _region4 = v;
      } else if (a == "5") {
        _region5 = v;
      }
    });
    setState(() {
      if (_region1.length != 0) {
        for (int i = 0; i < _region1.length; i++) {
          ModelApi.region_id.add(_region1[i].regionId);
          ModelApi.option_id.add(_region1[i].optionId);
        }
        _pageViewSize.add(_region1.length);
        listmain.add(_region1);
      }
      if (_region2.length != 0) {
        for (int i = 0; i < _region1.length; i++) {
          ModelApi.region_id.add(_region1[i].regionId);
          ModelApi.option_id.add(_region1[i].optionId);
        }
        _pageViewSize.add(_region2.length);
        listmain.add(_region2);
      }
      if (_region3.length != 0) {
        for (int i = 0; i < _region1.length; i++) {
          ModelApi.region_id.add(_region1[i].regionId);
          ModelApi.option_id.add(_region1[i].optionId);
        }
        _pageViewSize.add(_region3.length);
        listmain.add(_region3);
      }
      if (_region4.length != 0) {
        for (int i = 0; i < _region1.length; i++) {
          ModelApi.region_id.add(_region1[i].regionId);
          ModelApi.option_id.add(_region1[i].optionId);
        }
        _pageViewSize.add(_region4.length);
        listmain.add(_region4);
      }
      if (_region5.length != 0) {
        for (int i = 0; i < _region1.length; i++) {
          ModelApi.region_id.add(_region1[i].regionId);
          ModelApi.option_id.add(_region1[i].optionId);
        }
        _pageViewSize.add(_region5.length);
        listmain.add(_region5);
      }
    });
    super.initState();
  }

  List<DropdownMenuItem<Salesman>> buildDropdownSalesman(List salesmans) {
    List<DropdownMenuItem<Salesman>> items = List();
    for (Salesman salesman in salesmans) {
      items.add(
        DropdownMenuItem(
          value: salesman,
          child: Text(salesman.name),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<Colors>> buildDropdownColor(List colors) {
    List<DropdownMenuItem<Colors>> items = List();
    for (Colors color in colors) {
      items.add(
        DropdownMenuItem(
          value: color,
          child: Text(color.color),
        ),
      );
    }
    return items;
  }

  void changeSalesman(Salesman value) {
    setState(() {
      _selectedSalesman = value;
      saleman_id = value.id;
    });
  }

  void changeColor(Colors value) {
    setState(() {
      _selectedColor = value;
      color_id = value.color;
    });
  }

  void changeQty(String value) {
    setState(() {
      _selectedqty = value;
      qty = value;
    });
  }

  GlobalKey endKey = GlobalKey();
  bool isShowing;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,resizeToAvoidBottomPadding: true,
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
            key: _scaffoldKey, resizeToAvoidBottomInset: true,resizeToAvoidBottomPadding: true,
            endDrawer: MyDrawer(
              callback: () {
                drawerCallback();
              },
            ),
            body: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage("assets/images/lines.png"),
                              fit: BoxFit.contain)),height: MediaQuery.of(context).size.height*0.93-140,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: listmain.length,
                        itemBuilder: (context, index) {
                          for (int i = 0; i < listmain.length; i++) {
                            _visible.add(false);
                            pressAttention.add(false);
                            currentPage.add(0);
                            c.add(PageController());
                          }
                          return Card(
                            shape: Border(
                                bottom: BorderSide(color: Constants.blackColor)),
                            color: Constants.transparentColor,
                            elevation: 0,
                            child: Container(
                              height: 370,
                              color: Constants.transparentColor,
                              child: Column(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Stack(
                                      children: <Widget>[
                                        Container(
                                          child: PageView.builder(
                                            onPageChanged: (page) {
                                              currentPage[index] = page;
                                            },
                                            controller: c[index],
                                            physics:
                                            new NeverScrollableScrollPhysics(),
                                            itemCount: _pageViewSize[index],
                                            itemBuilder: (context, position) {
                                              _viewPagePositionSAved = position;
                                              return Stack(
                                                children: <Widget>[
                                                  Container(
                                                    child: Row(
                                                      mainAxisSize:
                                                      MainAxisSize.max,
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                      children: <Widget>[
                                                        CachedNetworkImage(
                                                          imageUrl:
                                                          Constants.BASE_URL +
                                                              optionBaseLinkse +
                                                              listmain[index]
                                                              [position]
                                                                  .image,
                                                        ),
                                                        Column(
                                                          mainAxisSize:
                                                          MainAxisSize.max,
                                                          mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.end,
                                                          children: <Widget>[
                                                            Text(
                                                              listmain[index]
                                                              [position]
                                                                  .name,
                                                              textAlign:
                                                              TextAlign.justify,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .w700,
                                                                  fontSize: 25.0,
                                                                  color: Constants
                                                                      .blackColor),

                                                            ),
                                                            Row(
                                                              children: <Widget>[
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 1),
                                                                  child: Text(
                                                                    listmain[index][position]
                                                                        ?.dimensions
                                                                        ?.label ==
                                                                        null
                                                                        ? ' '
                                                                        : listmain[index][position]
                                                                        ?.dimensions
                                                                        ?.label +
                                                                        (":  "),
                                                                    textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        19.0,
                                                                        color: Constants
                                                                            .blackColor),
                                                                  ),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 1),
                                                                  child: Text(
                                                                    (listmain[index]
                                                                    [
                                                                    position]
                                                                        ?.dimensions
                                                                        ?.value ??
                                                                        ''),
                                                                    textAlign:
                                                                    TextAlign
                                                                        .justify,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                        18.0,
                                                                        color: Constants
                                                                            .blackColor),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            Padding(
                                                              padding:
                                                              const EdgeInsets
                                                                  .only(
                                                                  top: 14),
                                                              child: Text(
                                                                listmain[index]
                                                                [position]
                                                                    .description,
                                                                textAlign:
                                                                TextAlign.justify,
                                                                style: TextStyle(
                                                                    fontSize: 16.0,
                                                                    color: Constants
                                                                        .blackColor),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    maintainSize: true,
                                                    maintainAnimation: true,
                                                    maintainState: true,
                                                    visible: _visible[index],
                                                    child: Padding(
                                                      padding: const EdgeInsets.only(top: 160),
                                                      child: Container(

                                                        width: MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                        color: Constants.orangeDark
                                                            .withOpacity(0.9),
                                                        child: ListView.builder(
                                                            shrinkWrap: true,
                                                            scrollDirection:
                                                            Axis.horizontal,
                                                            itemCount: listmain[index]
                                                                .length,
                                                            itemBuilder:
                                                                (context, _index) {
                                                              return Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                  top: 20,
                                                                  left: 10,
                                                                  right: 10,
                                                                  bottom: 20,
                                                                ),
                                                                child: InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      c[index]
                                                                          .jumpToPage(
                                                                          _index);
                                                                      _toggle(index);
                                                                    });
                                                                  },
                                                                  child: Card(
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                        BorderRadius
                                                                            .circular(
                                                                            10.0)),
                                                                    color: Constants
                                                                        .whiteColor70,
                                                                    child: Padding(
                                                                      padding:
                                                                      const EdgeInsets
                                                                          .only(
                                                                          left: 0,
                                                                          right:
                                                                          0),
                                                                      child:
                                                                      Container(
                                                                        width: 150,
                                                                        height: 120,
                                                                        child: Center(
                                                                          child:
                                                                          CachedNetworkImage(
                                                                            imageUrl: Constants
                                                                                .BASE_URL +
                                                                                optionBaseLinkse +
                                                                                listmain[index][_index]
                                                                                    .image,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            }),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    color: Constants.transparentColor,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) => FullScreen(
                                                        img: Constants.BASE_URL +
                                                            optionBaseLinkse +
                                                            listmain[index][
                                                            _viewPagePositionSAved]
                                                                .image)));
                                          },
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(left: 70),
                                            child: Container(
                                              height: 50,
                                              width: 50,
                                              child: Padding(
                                                padding: const EdgeInsets.all(7.0),
                                                child: new SvgPicture.asset(
                                                  'assets/images/photo.svg',
                                                  color: Constants.blackColor,
                                                  height: 5.0,
                                                  width:5.0,
                                                  allowDrawingOutsideViewBox: true,
                                                ),
                                              ),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Constants.blackColor),
                                                 ),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          color: Constants.transparentColor,
                                          child: Row(
                                            children: <Widget>[
                                              InkWell(
                                                onTap: () {
                                                  if (currentPage[index] != 0) {
                                                    currentPage[index] =
                                                        currentPage[index] - 1;
                                                    c[index].animateToPage(currentPage[index],
                                                      curve: Curves.easeIn,duration: Duration(milliseconds: 800),);
                                                  }
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                          Constants.blackColor),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/ArrowBack.png"),
                                                          fit: BoxFit.none)),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  if (currentPage[index] <
                                                      _pageViewSize[index] - 1) {
                                                    currentPage[index] =
                                                        currentPage[index] + 1;
                                                    c[index].animateToPage(currentPage[index],
                                                      curve: Curves.easeIn,duration: Duration(milliseconds: 800),);
                                                  }
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color:
                                                          Constants.blackColor),
                                                      image: DecorationImage(
                                                          image: AssetImage(
                                                              "assets/images/ArrowForwrd.png"),
                                                          fit: BoxFit.none)),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  _toggle(index);
                                                },
                                                child: Container(
                                                  height: 50,
                                                  width: 50,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                        color:
                                                        Constants.blackColor),
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/menu_icon_black.png"),
                                                        fit: BoxFit.none),
                                                    color: pressAttention[index]
                                                        ? Constants.orangeDark
                                                        : Constants.whiteColor70,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      )),
                  Container(
                    //  height: 380,
                    // height: MediaQuery.of(context).size.height* 0.10,
                    width: MediaQuery.of(context).size.width,                    height: MediaQuery.of(context).size.height * 0.08,

                    color: Constants.blackBackbtn,
                    child: Row(
                      children: <Widget>[
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.10,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.80,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                     Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => AlImages( ModelApi.firstCategory_id )),
                                            );
                                  },
                                  child: Container(
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: Constants.blackBackbtn,
                                        border: Border.all(
                                            color: Constants.whiteColor70),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "PREVIEW",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Constants.whiteColor70,
                                              fontSize: 19.0),
                                        ),
                                      )),
                                ),
                              ),
                              !isShowing? SizedBox(width: 40,):SizedBox(),
                              !isShowing
                                  ? Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    controller.forward();
                                  },
                                  child: Container(
                                      height: 38,
                                      decoration: BoxDecoration(
                                        color: Constants.blackBackbtn,
                                        border: Border.all(
                                            color:
                                            Constants.whiteColor70),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "SEND ME A QUOTE",
                                          style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                              color: Constants
                                                  .whiteColor70,
                                              fontSize: 19.0),
                                        ),
                                      )),
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                        !isShowing
                            ? SizedBox(
                          width:
                          MediaQuery.of(context).size.width * 0.10,
                        )
                            : InkWell(
                          onTap: () {
                            controller.reverse();
                          },
                          child: Container(
                              width: MediaQuery.of(context).size.width *
                                  0.10,
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  color: Color(0xffffffff),size: 37,
                                ),
                              )),
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                  ),
                  Container(
                    color: Constants.blackBackbtn,
                    child: SizeTransition(
                      sizeFactor: CurvedAnimation(
                        curve: Curves.linear,
                        parent: controller,
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Container(
                                  height: 30,
                                  width:
                                  MediaQuery.of(context).size.width * 0.80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.transparentColor),
                                  ),
                                  child: Text(
                                    "SEND ME A QUOTE",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Constants.whiteColor70,
                                        fontSize: 27.0),
                                  )),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Container(
                                  color: Constants.transparentColor,
                                  height: 35,
                                  width:
                                  MediaQuery.of(context).size.width * 0.80,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        height: 35,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        color: Constants.whiteColor70,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 10),
                                          child: DropdownButton(
                                            value: _selectedSalesman,
                                            items: saleman,
                                            onChanged: changeSalesman,
                                            isExpanded: true,
                                            iconEnabledColor:
                                            Constants.blackColor,
                                            iconSize: 30,
                                            hint: Text(
                                              'Select Salesman',
                                              style: TextStyle(
                                                  color: Constants.blackColor,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        color: Constants.whiteColor70,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 10),
                                          child: DropdownButton(
                                            value: _selectedqty,
                                            items: _dropdownValues
                                                .map(
                                                    (value) => DropdownMenuItem(
                                                  child: Text(value),
                                                  value: value,
                                                ))
                                                .toList(),
                                            onChanged: changeQty,
                                            isExpanded: true,
                                            iconEnabledColor:
                                            Constants.blackColor,
                                            iconSize: 30,
                                            hint: Text(
                                              'Select Quantity',
                                              style: TextStyle(
                                                  color: Constants.blackColor,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        height: 35,
                                        width:
                                        MediaQuery.of(context).size.width *
                                            0.25,
                                        color: Constants.whiteColor70,
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(left: 10),
                                          child: DropdownButton(
                                            value: _selectedColor,
                                            items: color,
                                            onChanged: changeColor,
                                            isExpanded: true,
                                            iconEnabledColor:
                                            Constants.blackColor,
                                            iconSize: 30,
                                            hint: Text(
                                              'Choose Color',
                                              style: TextStyle(
                                                  color: Constants.blackColor,
                                                  fontSize: 17),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ),
                            Form(
                              key: _validator,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Container(
                                    color: Constants.transparentColor,
                                    height: 35,
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Container(
                                          height: 35,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.39,
                                          color: Constants.whiteColor70,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10),
                                            child: TextFormField(
                                              validator: (value) =>
                                              value.isEmpty ? null : null,
                                              onSaved: (value) =>
                                              customer_name = value.trim(),
                                              style: TextStyle(
                                                  color: Constants.blackColor,
                                                  fontSize: 16.0),
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              cursorColor:
                                              Constants.orangeColor,
                                              decoration: InputDecoration(
                                                  hintText: 'Client Name',
                                                  hintStyle: TextStyle(
                                                      fontSize: 17.0,
                                                      color:
                                                      Constants.blackColor),
                                                  //labelText: 'Client Name',
                                                  labelStyle: TextStyle(
                                                      color:
                                                      Constants.blackColor,
                                                      fontSize: 19.0)),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          width: MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.39,
                                          color: Constants.whiteColor70,
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(left: 10),
                                            child: TextFormField(
                                              validator: (value) =>
                                              value.isEmpty ? null : null,
                                              onSaved: (value) =>
                                              email = value.trim(),
                                              style: TextStyle(
                                                  color: Constants.blackColor,
                                                  fontSize: 16.0),
                                              keyboardType:
                                              TextInputType.emailAddress,
                                              cursorColor:
                                              Constants.orangeColor,
                                              decoration: InputDecoration(
                                                  hintText: 'Client Email',
                                                  hintStyle: TextStyle(
                                                      fontSize: 17.0,
                                                      color:
                                                      Constants.blackColor),
                                                  //labelText: 'Client Name',
                                                  labelStyle: TextStyle(
                                                      color:
                                                      Constants.blackColor,
                                                      fontSize: 19.0)),
                                            ),
                                          ),
                                        )
                                      ],
                                    )),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Container(
                                color: Constants.whiteColor70,
                                height: 70,
                                width: MediaQuery.of(context).size.width * 0.80,
                                child: Padding(
                                  padding:
                                  const EdgeInsets.only(top: 8, left: 10),
                                  child: TextFormField(
                                    validator: (value) =>
                                    value.isEmpty ? null : null,
                                    onSaved: (value) => _details = value.trim(),
                                    style: TextStyle(
                                        color: Constants.blackColor,
                                        fontSize: 16.0),
                                    keyboardType: TextInputType.emailAddress,
                                    cursorColor: Constants.orangeColor,
                                    decoration: InputDecoration(
                                        hintText: 'Comment',
                                        border: InputBorder.none,
                                        hintStyle: TextStyle(
                                            fontSize: 17.0,
                                            color: Constants.blackColor),
                                        //labelText: 'Client Name',
                                        labelStyle: TextStyle(
                                            color: Constants.blackColor,
                                            fontSize: 19.0)),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                var res = SaveAndSubmit();
                              },
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Container(
                                    height: 38,
                                    width: MediaQuery.of(context).size.width *
                                        0.80,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants.whiteColor70),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "SAVE & SUBMIT",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Constants.whiteColor70,
                                            fontSize: 19.0),
                                      ),
                                    )),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                              key: endKey,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )

            /////////

//          CustomScrollView(
//      slivers: <Widget>[
//      SliverList(
//      delegate: SliverChildListDelegate([
//      Container(
//      decoration: BoxDecoration(
//          image: DecorationImage(
//          image: AssetImage("assets/images/lines.png"),
//        fit: BoxFit.contain)),height: MediaQuery.of(context).size.height*0.92-90,
//    child: ListView.builder(
//    scrollDirection: Axis.vertical,
//    shrinkWrap: true,
//    physics: const ClampingScrollPhysics(),
//    itemCount: listmain.length,
//    itemBuilder: (context, index) {
//    for (int i = 0; i < listmain.length; i++) {
//    _visible.add(false);
//    pressAttention.add(false);
//    currentPage.add(0);
//    c.add(PageController());
//    }
//    return Card(
//    shape: Border(
//    bottom: BorderSide(color: Constants.blackColor)),
//    color: Constants.transparentColor,
//    elevation: 0,
//    child: Container(
//    height: 300,
//    color: Constants.transparentColor,
//    child: Column(
//    children: <Widget>[
//    Expanded(
//    flex: 1,
//    child: Stack(
//    children: <Widget>[
//    Container(
//    child: PageView.builder(
//    onPageChanged: (page) {
//    currentPage[index] = page;
//    },
//    controller: c[index],
//    physics:
//    new NeverScrollableScrollPhysics(),
//    itemCount: _pageViewSize[index],
//    itemBuilder: (context, position) {
//    _viewPagePositionSAved = position;
//    return Stack(
//    children: <Widget>[
//    Container(
//    child: Row(
//    mainAxisSize:
//    MainAxisSize.max,
//    mainAxisAlignment:
//    MainAxisAlignment
//        .spaceAround,
//    children: <Widget>[
//    CachedNetworkImage(
//    imageUrl:
//    Constants.BASE_URL +
//    optionBaseLinkse +
//    listmain[index]
//    [position]
//        .image,
//    ),
//    Column(
//    mainAxisSize:
//    MainAxisSize.max,
//    mainAxisAlignment:
//    MainAxisAlignment
//        .center,
//    children: <Widget>[
//    Text(
//    listmain[index]
//    [position]
//        .name,
//    textAlign:
//    TextAlign.end,
//    style: TextStyle(
//    fontWeight:
//    FontWeight
//        .w700,
//    fontSize: 28.0,
//    color: Constants
//        .blackColor),
//    ),
//    Row(
//    children: <Widget>[
//    Padding(
//    padding:
//    const EdgeInsets
//        .only(
//    top: 5),
//    child: Text(
//    listmain[index][position]
//        ?.dimensions
//        ?.label ==
//    null
//    ? ' '
//        : listmain[index][position]
//        ?.dimensions
//        ?.label +
//    (":  "),
//    textAlign:
//    TextAlign
//        .end,
//    style: TextStyle(
//    fontSize:
//    22.0,
//    color: Constants
//        .blackColor),
//    ),
//    ),
//    Padding(
//    padding:
//    const EdgeInsets
//        .only(
//    top: 5),
//    child: Text(
//    (listmain[index]
//    [
//    position]
//        ?.dimensions
//        ?.value ??
//    ''),
//    textAlign:
//    TextAlign
//        .end,
//    style: TextStyle(
//    fontSize:
//    22.0,
//    color: Constants
//        .blackColor),
//    ),
//    ),
//    ],
//    ),
//    Padding(
//    padding:
//    const EdgeInsets
//        .only(
//    top: 25),
//    child: Text(
//    listmain[index]
//    [position]
//        .description,
//    textAlign:
//    TextAlign.end,
//    style: TextStyle(
//    fontSize: 18.0,
//    color: Constants
//        .blackColor),
//    ),
//    ),
//    ],
//    ),
//    ],
//    ),
//    ),
//    Visibility(
//    maintainSize: true,
//    maintainAnimation: true,
//    maintainState: true,
//    visible: _visible[index],
//    child: Container(
//    width: MediaQuery.of(context)
//        .size
//        .width,
//    color: Constants.orangeDark
//        .withOpacity(0.9),
//    child: ListView.builder(
//    shrinkWrap: true,
//    scrollDirection:
//    Axis.horizontal,
//    itemCount: listmain[index]
//        .length,
//    itemBuilder:
//    (context, _index) {
//    return Padding(
//    padding:
//    const EdgeInsets
//        .only(
//    top: 50,
//    left: 10,
//    right: 10,
//    bottom: 50,
//    ),
//    child: InkWell(
//    onTap: () {
//    setState(() {
//    c[index]
//        .jumpToPage(
//    _index);
//    _toggle(index);
//    });
//    },
//    child: Card(
//    shape: RoundedRectangleBorder(
//    borderRadius:
//    BorderRadius
//        .circular(
//    10.0)),
//    color: Constants
//        .whiteColor70,
//    child: Padding(
//    padding:
//    const EdgeInsets
//        .only(
//    left: 0,
//    right:
//    0),
//    child:
//    Container(
//    width: 150,
//    height: 120,
//    child: Center(
//    child:
//    CachedNetworkImage(
//    imageUrl: Constants
//        .BASE_URL +
//    optionBaseLinkse +
//    listmain[index][_index]
//        .image,
//    ),
//    ),
//    ),
//    ),
//    ),
//    ),
//    );
//    }),
//    ),
//    ),
//    ],
//    );
//    },
//    ),
//    ),
//    ],
//    ),
//    ),
//    Container(
//    height: 40,
//    color: Constants.transparentColor,
//    child: Row(
//    mainAxisSize: MainAxisSize.max,
//    mainAxisAlignment:
//    MainAxisAlignment.spaceBetween,
//    children: <Widget>[
//    InkWell(
//    onTap: () {
//    Navigator.push(
//    context,
//    MaterialPageRoute(
//    builder: (context) => FullScreen(
//    img: Constants.BASE_URL +
//    optionBaseLinkse +
//    listmain[index][
//    _viewPagePositionSAved]
//        .image)));
//    },
//    child: Padding(
//    padding:
//    const EdgeInsets.only(left: 70),
//    child: Container(
//    height: 50,
//    width: 50,
//    decoration: BoxDecoration(
//    border: Border.all(
//    color: Constants.blackColor),
//    image: DecorationImage(
//    image: AssetImage(
//    "assets/images/menu_icon_black.png"),
//    fit: BoxFit.none)),
//    ),
//    ),
//    ),
//    Container(
//    color: Constants.transparentColor,
//    child: Row(
//    children: <Widget>[
//    InkWell(
//    onTap: () {
//    if (currentPage[index] != 0) {
//    currentPage[index] =
//    currentPage[index] - 1;
//    c[index].jumpToPage(
//    currentPage[index]);
//    }
//    },
//    child: Container(
//    height: 50,
//    width: 180,
//    decoration: BoxDecoration(
//    border: Border.all(
//    color:
//    Constants.blackColor),
//    image: DecorationImage(
//    image: AssetImage(
//    "assets/images/ArrowBack.png"),
//    fit: BoxFit.none)),
//    ),
//    ),
//    InkWell(
//    onTap: () {
//    if (currentPage[index] <
//    _pageViewSize[index] - 1) {
//    currentPage[index] =
//    currentPage[index] + 1;
//    c[index].jumpToPage(
//    currentPage[index]);
//    }
//    },
//    child: Container(
//    height: 50,
//    width: 180,
//    decoration: BoxDecoration(
//    border: Border.all(
//    color:
//    Constants.blackColor),
//    image: DecorationImage(
//    image: AssetImage(
//    "assets/images/ArrowForwrd.png"),
//    fit: BoxFit.none)),
//    ),
//    ),
//    InkWell(
//    onTap: () {
//    _toggle(index);
//    },
//    child: Container(
//    height: 50,
//    width: 50,
//    decoration: BoxDecoration(
//    border: Border.all(
//    color:
//    Constants.blackColor),
//    image: DecorationImage(
//    image: AssetImage(
//    "assets/images/menu_icon_black.png"),
//    fit: BoxFit.none),
//    color: pressAttention[index]
//    ? Constants.orangeDark
//        : Constants.whiteColor70,
//    ),
//    ),
//    ),
//    ],
//    ),
//    )
//    ],
//    ),
//    )
//    ],
//    ),
//    ),
//    );
//    },
//    )),
//    Container(
//    //  height: 380,
//    // height: MediaQuery.of(context).size.height* 0.10,
//    width: MediaQuery.of(context).size.width,                    height: MediaQuery.of(context).size.height * 0.08,
//
//    color: Constants.blackBackbtn,
//    child: Row(
//    children: <Widget>[
//    SizedBox(
//    width: MediaQuery.of(context).size.width * 0.10,
//    ),
//    Container(
//    width: MediaQuery.of(context).size.width * 0.80,
//    child: Row(
//    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//    children: <Widget>[
//    Expanded(
//    child: GestureDetector(
//    onTap: () {
//    /* Navigator.push(
//                                            context,
//                                            MaterialPageRoute(
//                                                builder: (context) => AlImages()),
//                                          );*/
//    },
//    child: Container(
//    height: 38,
//    decoration: BoxDecoration(
//    color: Constants.blackBackbtn,
//    border: Border.all(
//    color: Constants.whiteColor70),
//    ),
//    child: Center(
//    child: Text(
//    "PREVIEW",
//    style: TextStyle(
//    fontWeight: FontWeight.bold,
//    color: Constants.whiteColor70,
//    fontSize: 19.0),
//    ),
//    )),
//    ),
//    ),
//    !isShowing? SizedBox(width: 40,):SizedBox(),
//    !isShowing
//    ? Expanded(
//    child: GestureDetector(
//    onTap: () {
//    controller.forward();
//    },
//    child: Container(
//    height: 38,
//    decoration: BoxDecoration(
//    color: Constants.blackBackbtn,
//    border: Border.all(
//    color:
//    Constants.whiteColor70),
//    ),
//    child: Center(
//    child: Text(
//    "Send Me a QUote",
//    style: TextStyle(
//    fontWeight:
//    FontWeight.bold,
//    color: Constants
//        .whiteColor70,
//    fontSize: 19.0),
//    ),
//    )),
//    ),
//    )
//        : Container(),
//    ],
//    ),
//    ),
//    !isShowing
//    ? SizedBox(
//    width:
//    MediaQuery.of(context).size.width * 0.10,
//    )
//        : InkWell(
//    onTap: () {
//    controller.reverse();
//    },
//    child: Container(
//    width: MediaQuery.of(context).size.width *
//    0.10,
//    child: Center(
//    child: Icon(
//    Icons.close,
//    color: Color(0xffffffff),size: 32,
//    ),
//    )),
//    )
//    ],
//    mainAxisAlignment: MainAxisAlignment.center,
//    ),
//    ),
//    Container(
//    color: Constants.blackBackbtn,
//    child: SizeTransition(
//    sizeFactor: CurvedAnimation(
//    curve: Curves.linear,
//    parent: controller,
//    ),
//    child: Center(
//    child: Column(
//    mainAxisAlignment: MainAxisAlignment.center,
//    children: <Widget>[
//    Padding(
//    padding: const EdgeInsets.only(top: 14),
//    child: Container(
//    height: 30,
//    width:
//    MediaQuery.of(context).size.width * 0.80,
//    decoration: BoxDecoration(
//    border: Border.all(
//    color: Constants.transparentColor),
//    ),
//    child: Text(
//    "SEND ME A QUOTE",
//    style: TextStyle(
//    fontWeight: FontWeight.bold,
//    color: Constants.whiteColor70,
//    fontSize: 27.0),
//    )),
//    ),
//    Padding(
//    padding: const EdgeInsets.only(top: 14),
//    child: Container(
//    color: Constants.transparentColor,
//    height: 35,
//    width:
//    MediaQuery.of(context).size.width * 0.80,
//    child: Row(
//    mainAxisSize: MainAxisSize.max,
//    mainAxisAlignment:
//    MainAxisAlignment.spaceBetween,
//    children: <Widget>[
//    Container(
//    height: 35,
//    width:
//    MediaQuery.of(context).size.width *
//    0.25,
//    color: Constants.whiteColor70,
//    child: Padding(
//    padding:
//    const EdgeInsets.only(left: 10),
//    child: DropdownButton(
//    value: _selectedSalesman,
//    items: saleman,
//    onChanged: changeSalesman,
//    isExpanded: true,
//    iconEnabledColor:
//    Constants.blackColor,
//    iconSize: 30,
//    hint: Text(
//    'Select Salesman',
//    style: TextStyle(
//    color: Constants.blackColor,
//    fontSize: 17),
//    ),
//    ),
//    ),
//    ),
//    Container(
//    height: 35,
//    width:
//    MediaQuery.of(context).size.width *
//    0.25,
//    color: Constants.whiteColor70,
//    child: Padding(
//    padding:
//    const EdgeInsets.only(left: 10),
//    child: DropdownButton(
//    value: _selectedqty,
//    items: _dropdownValues
//        .map(
//    (value) => DropdownMenuItem(
//    child: Text(value),
//    value: value,
//    ))
//        .toList(),
//    onChanged: changeQty,
//    isExpanded: true,
//    iconEnabledColor:
//    Constants.blackColor,
//    iconSize: 30,
//    hint: Text(
//    'Select Quality',
//    style: TextStyle(
//    color: Constants.blackColor,
//    fontSize: 17),
//    ),
//    ),
//    ),
//    ),
//    Container(
//    height: 35,
//    width:
//    MediaQuery.of(context).size.width *
//    0.25,
//    color: Constants.whiteColor70,
//    child: Padding(
//    padding:
//    const EdgeInsets.only(left: 10),
//    child: DropdownButton(
//    value: _selectedColor,
//    items: color,
//    onChanged: changeColor,
//    isExpanded: true,
//    iconEnabledColor:
//    Constants.blackColor,
//    iconSize: 30,
//    hint: Text(
//    'Choose Color',
//    style: TextStyle(
//    color: Constants.blackColor,
//    fontSize: 17),
//    ),
//    ),
//    ),
//    )
//    ],
//    )),
//    ),
//    Form(
//    key: _validator,
//    child: Padding(
//    padding: const EdgeInsets.only(top: 12),
//    child: Container(
//    color: Constants.transparentColor,
//    height: 35,
//    width: MediaQuery.of(context).size.width *
//    0.80,
//    child: Row(
//    mainAxisSize: MainAxisSize.max,
//    mainAxisAlignment:
//    MainAxisAlignment.spaceBetween,
//    children: <Widget>[
//    Container(
//    height: 35,
//    width: MediaQuery.of(context)
//        .size
//        .width *
//    0.39,
//    color: Constants.whiteColor70,
//    child: Padding(
//    padding:
//    const EdgeInsets.only(left: 10),
//    child: TextFormField(
//    validator: (value) =>
//    value.isEmpty ? null : null,
//    onSaved: (value) =>
//    customer_name = value.trim(),
//    style: TextStyle(
//    color: Constants.blackColor,
//    fontSize: 16.0),
//    keyboardType:
//    TextInputType.emailAddress,
//    cursorColor:
//    Constants.orangeColor,
//    decoration: InputDecoration(
//    hintText: 'Client Name',
//    hintStyle: TextStyle(
//    fontSize: 17.0,
//    color:
//    Constants.blackColor),
//    //labelText: 'Client Name',
//    labelStyle: TextStyle(
//    color:
//    Constants.blackColor,
//    fontSize: 19.0)),
//    ),
//    ),
//    ),
//    Container(
//    height: 35,
//    width: MediaQuery.of(context)
//        .size
//        .width *
//    0.39,
//    color: Constants.whiteColor70,
//    child: Padding(
//    padding:
//    const EdgeInsets.only(left: 10),
//    child: TextFormField(
//    validator: (value) =>
//    value.isEmpty ? null : null,
//    onSaved: (value) =>
//    email = value.trim(),
//    style: TextStyle(
//    color: Constants.blackColor,
//    fontSize: 16.0),
//    keyboardType:
//    TextInputType.emailAddress,
//    cursorColor:
//    Constants.orangeColor,
//    decoration: InputDecoration(
//    hintText: 'Client Email',
//    hintStyle: TextStyle(
//    fontSize: 17.0,
//    color:
//    Constants.blackColor),
//    //labelText: 'Client Name',
//    labelStyle: TextStyle(
//    color:
//    Constants.blackColor,
//    fontSize: 19.0)),
//    ),
//    ),
//    )
//    ],
//    )),
//    ),
//    ),
//    Padding(
//    padding: const EdgeInsets.only(top: 12),
//    child: Container(
//    color: Constants.whiteColor70,
//    height: 70,
//    width: MediaQuery.of(context).size.width * 0.80,
//    child: Padding(
//    padding:
//    const EdgeInsets.only(top: 8, left: 10),
//    child: TextFormField(
//    validator: (value) =>
//    value.isEmpty ? null : null,
//    onSaved: (value) => _details = value.trim(),
//    style: TextStyle(
//    color: Constants.blackColor,
//    fontSize: 16.0),
//    keyboardType: TextInputType.emailAddress,
//    cursorColor: Constants.orangeColor,
//    decoration: InputDecoration(
//    hintText: 'Comment',
//    border: InputBorder.none,
//    hintStyle: TextStyle(
//    fontSize: 17.0,
//    color: Constants.blackColor),
//    //labelText: 'Client Name',
//    labelStyle: TextStyle(
//    color: Constants.blackColor,
//    fontSize: 19.0)),
//    ),
//    ),
//    ),
//    ),
//    InkWell(
//    onTap: () {
//    var res = SaveAndSubmit();
//    },
//    child: Padding(
//    padding: const EdgeInsets.only(top: 10),
//    child: Container(
//    height: 38,
//    width: MediaQuery.of(context).size.width *
//    0.80,
//    decoration: BoxDecoration(
//    border: Border.all(
//    color: Constants.whiteColor70),
//    ),
//    child: Center(
//    child: Text(
//    "SAVE & SUBMIT",
//    style: TextStyle(
//    fontWeight: FontWeight.bold,
//    color: Constants.whiteColor70,
//    fontSize: 19.0),
//    ),
//    )),
//    ),
//    ),
//    SizedBox(
//    height: 20,
//    key: endKey,
//    )
//    ],
//    ),
//    ),
//    ),
//    )
//    ],
//    ),
//    )])
          ////
//        CustomScrollView(
//          slivers: <Widget>[
//            SliverList(
//              delegate: SliverChildListDelegate([
//                Container(
//                    decoration: BoxDecoration(
//                        image: DecorationImage(
//                            image: AssetImage("assets/images/lines.png"),
//                            fit: BoxFit.contain)),
//                    height: MediaQuery.of(context).size.height * 0.85,
//                    child: ListView.builder(
//                      scrollDirection: Axis.vertical,
//                      shrinkWrap: true,
//                      physics: const ClampingScrollPhysics(),
//                      itemCount: listmain.length,
//                      itemBuilder: (context, index) {
//                        for (int i = 0; i < listmain.length; i++) {
//                          _visible.add(false);
//                          pressAttention.add(false);
//                          currentPage.add(0);
//                          c.add(PageController());
//                        }
//                        return Card(
//                          shape: Border(
//                              bottom: BorderSide(color: Constants.blackColor)),
//                          color: Constants.transparentColor,
//                          elevation: 0,
//                          child: Container(
//                            height: 300,
//                            color: Constants.transparentColor,
//                            child: Column(
//                              children: <Widget>[
//                                Expanded(
//                                  flex: 1,
//                                  child: Stack(
//                                    children: <Widget>[
//                                      Container(
//                                        child: PageView.builder(
//                                          onPageChanged: (page) {
//                                            currentPage[index] = page;
//                                          },
//                                          controller: c[index],
//                                          physics:
//                                          new NeverScrollableScrollPhysics(),
//                                          itemCount: _pageViewSize[index],
//                                          itemBuilder: (context, position) {
//                                            _viewPagePositionSAved = position;
//                                            return Stack(
//                                              children: <Widget>[
//                                                Container(
//                                                  child: Row(
//                                                    mainAxisSize:
//                                                    MainAxisSize.max,
//                                                    mainAxisAlignment:
//                                                    MainAxisAlignment
//                                                        .spaceAround,
//                                                    children: <Widget>[
//                                                      CachedNetworkImage(
//                                                        imageUrl: Constants
//                                                            .BASE_URL +
//                                                            optionBaseLinkse +
//                                                            listmain[index]
//                                                            [position]
//                                                                .image,
//                                                      ),
//                                                      Column(
//                                                        mainAxisSize:
//                                                        MainAxisSize.max,
//                                                        mainAxisAlignment:
//                                                        MainAxisAlignment
//                                                            .center,
//                                                        children: <Widget>[
//                                                          Text(
//                                                            listmain[index]
//                                                            [position]
//                                                                .name,
//                                                            textAlign:
//                                                            TextAlign.end,
//                                                            style: TextStyle(
//                                                                fontWeight:
//                                                                FontWeight
//                                                                    .w700,
//                                                                fontSize: 28.0,
//                                                                color: Constants
//                                                                    .blackColor),
//                                                          ),
//                                                          Row(
//                                                            children: <Widget>[
//                                                              Padding(
//                                                                padding:
//                                                                const EdgeInsets
//                                                                    .only(
//                                                                    top: 5),
//                                                                child: Text(
//                                                                  listmain[index][position]
//                                                                      ?.dimensions
//                                                                      ?.label ==
//                                                                      null
//                                                                      ? ' '
//                                                                      : listmain[index][position]
//                                                                      ?.dimensions
//                                                                      ?.label +
//                                                                      (":  "),
//                                                                  textAlign:
//                                                                  TextAlign
//                                                                      .end,
//                                                                  style: TextStyle(
//                                                                      fontSize:
//                                                                      22.0,
//                                                                      color: Constants
//                                                                          .blackColor),
//                                                                ),
//                                                              ),
//                                                              Padding(
//                                                                padding:
//                                                                const EdgeInsets
//                                                                    .only(
//                                                                    top: 5),
//                                                                child: Text(
//                                                                  (listmain[index]
//                                                                  [
//                                                                  position]
//                                                                      ?.dimensions
//                                                                      ?.value ??
//                                                                      ''),
//                                                                  textAlign:
//                                                                  TextAlign
//                                                                      .end,
//                                                                  style: TextStyle(
//                                                                      fontSize:
//                                                                      22.0,
//                                                                      color: Constants
//                                                                          .blackColor),
//                                                                ),
//                                                              ),
//                                                            ],
//                                                          ),
//                                                          Padding(
//                                                            padding:
//                                                            const EdgeInsets
//                                                                .only(
//                                                                top: 25),
//                                                            child: Text(
//                                                              listmain[index]
//                                                              [position]
//                                                                  .description,
//                                                              textAlign:
//                                                              TextAlign.end,
//                                                              style: TextStyle(
//                                                                  fontSize:
//                                                                  18.0,
//                                                                  color: Constants
//                                                                      .blackColor),
//                                                            ),
//                                                          ),
//                                                        ],
//                                                      ),
//                                                    ],
//                                                  ),
//                                                ),
//
//
//                                                Visibility(
//                                                  maintainSize: true,
//                                                  maintainAnimation: true,
//                                                  maintainState: true,
//                                                  visible: _visible[index],
//                                                  child: Container(
//                                                    width:
//                                                    MediaQuery.of(context)
//                                                        .size
//                                                        .width,
//                                                    color: Constants.orangeDark
//                                                        .withOpacity(0.9),
//                                                    child: ListView.builder(
//                                                        shrinkWrap: true,
//                                                        scrollDirection:
//                                                        Axis.horizontal,
//                                                        itemCount:
//                                                        listmain[index]
//                                                            .length,
//                                                        itemBuilder:
//                                                            (context, _index) {
//                                                          return Padding(
//                                                            padding:
//                                                            const EdgeInsets
//                                                                .only(
//                                                              top: 50,
//                                                              left: 10,
//                                                              right: 10,
//                                                              bottom: 50,
//                                                            ),
//                                                            child: InkWell(
//                                                              onTap: (){
//                                                                setState(() {
//                                                                  c[index].jumpToPage(_index);
//                                                                  _toggle(index);
//                                                                });
//                                                              },
//                                                              child: Card(
//                                                                shape: RoundedRectangleBorder(
//                                                                    borderRadius:
//                                                                    BorderRadius
//                                                                        .circular(
//                                                                        10.0)),
//                                                                color: Constants
//                                                                    .whiteColor70,
//                                                                child: Padding(
//                                                                  padding:
//                                                                  const EdgeInsets
//                                                                      .only(
//                                                                      left: 0,
//                                                                      right:
//                                                                      0),
//                                                                  child:
//                                                                  Container(
//                                                                    width: 150,
//                                                                    height: 120,
//                                                                    child: Center(
//                                                                      child:
//                                                                      CachedNetworkImage(
//                                                                        imageUrl: Constants
//                                                                            .BASE_URL +
//                                                                            optionBaseLinkse +
//                                                                            listmain[index][_index]
//                                                                                .image,
//                                                                      ),
//                                                                    ),
//                                                                  ),
//                                                                ),
//                                                              ),
//                                                            ),
//                                                          );
//                                                        }),
//                                                  ),
//                                                ),
//                                              ],
//                                            );
//                                          },
//                                        ),
//                                      ),
//                                    ],
//                                  ),
//                                ),
//                                Container(
//                                  height: 40,
//                                  color: Constants.transparentColor,
//                                  child: Row(
//                                    mainAxisSize: MainAxisSize.max,
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      InkWell(
//                                        onTap: () {
//                                          Navigator.push(
//                                              context,
//                                              MaterialPageRoute(
//                                                  builder: (context) => FullScreen(
//                                                      img: Constants.BASE_URL +
//                                                          optionBaseLinkse +
//                                                          listmain[index][
//                                                          _viewPagePositionSAved]
//                                                              .image)));
//                                        },
//                                        child: Padding(
//                                          padding:
//                                          const EdgeInsets.only(left: 70),
//                                          child: Container(
//                                            height: 50,
//                                            width: 50,
//                                            decoration: BoxDecoration(
//                                                border: Border.all(
//                                                    color:
//                                                    Constants.blackColor),
//                                                image: DecorationImage(
//                                                    image: AssetImage(
//                                                        "assets/images/menu_icon_black.png"),
//                                                    fit: BoxFit.none)),
//                                          ),
//                                        ),
//                                      ),
//                                      Container(
//                                        color: Constants.transparentColor,
//                                        child: Row(
//                                          children: <Widget>[
//                                            InkWell(
//                                              onTap: () {
//                                                if (currentPage[index] != 0) {
//                                                  currentPage[index] =
//                                                      currentPage[index] - 1;
//                                                  c[index].jumpToPage(
//                                                      currentPage[index]);
//                                                }
//                                              },
//                                              child: Container(
//                                                height: 50,
//                                                width: 180,
//                                                decoration: BoxDecoration(
//                                                    border: Border.all(
//                                                        color: Constants
//                                                            .blackColor),
//                                                    image: DecorationImage(
//                                                        image: AssetImage(
//                                                            "assets/images/ArrowBack.png"),
//                                                        fit: BoxFit.none)),
//                                              ),
//                                            ),
//                                            InkWell(
//                                              onTap: () {
//                                                if (currentPage[index] <
//                                                    _pageViewSize[index] - 1) {
//                                                  currentPage[index] =
//                                                      currentPage[index] + 1;
//                                                  c[index].jumpToPage(
//                                                      currentPage[index]);
//                                                }
//                                              },
//                                              child: Container(
//                                                height: 50,
//                                                width: 180,
//                                                decoration: BoxDecoration(
//                                                    border: Border.all(
//                                                        color: Constants
//                                                            .blackColor),
//                                                    image: DecorationImage(
//                                                        image: AssetImage(
//                                                            "assets/images/ArrowForwrd.png"),
//                                                        fit: BoxFit.none)),
//                                              ),
//                                            ),
//                                            InkWell(
//                                              onTap: () {
//                                                _toggle(index);
//                                              },
//                                              child: Container(
//                                                height: 50,
//                                                width: 50,
//                                                decoration: BoxDecoration(
//                                                  border: Border.all(
//                                                      color:
//                                                      Constants.blackColor),
//                                                  image: DecorationImage(
//                                                      image: AssetImage(
//                                                          "assets/images/menu_icon_black.png"),
//                                                      fit: BoxFit.none),
//                                                  color: pressAttention[index]
//                                                      ? Constants.orangeDark
//                                                      : Constants.whiteColor70,
//                                                ),
//                                              ),
//                                            ),
//                                          ],
//                                        ),
//                                      )
//                                    ],
//                                  ),
//                                )
//                              ],
//                            ),
//                          ),
//                        );
//                      },
//                    )),
//                ConfigurableExpansionTile(
//
//                  borderColorStart: Constants.blueColor,
//                  borderColorEnd: Constants.orangeAccentColor,
//                  animatedWidgetFollowingHeader: const Icon(
//                    Icons.expand_more,
//                    color: const Color(0xFF707070),
//                  ),
//                  headerExpanded: Flexible(
//                      child: Center(
//                          child: Padding(
//                            padding: const EdgeInsets.all(14.0),
//                            child: Text("Expanded", style: TextStyle(fontSize: 25)),
//                          ))),
//                  header: Container(
//                      color: Constants.transparentColor,
//                      child: Center(
//                          child: Padding(
//                            padding: const EdgeInsets.all(14.0),
//                            child: Text("Send me a Quote",
//                                style: TextStyle(fontSize: 25)),
//                          ))),
//                  headerBackgroundColorStart: Constants.greyColor,
//                  expandedBackgroundColor: Constants.orangeAccentColor,
//                  headerBackgroundColorEnd: Constants.black45Color,
//                  children: <Widget>[
//                    Container(
//                      //  height: 380,
//                      // height: MediaQuery.of(context).size.height* 0.10,
//                      width: MediaQuery.of(context).size.width,
//                      color: Constants.blackBackbtn,
//                      child: Column(
//                        mainAxisSize: MainAxisSize.max,
//                        mainAxisAlignment: MainAxisAlignment.start,
//                        children: <Widget>[
//                          Padding(
//                            padding: const EdgeInsets.only(top: 23),
//                            child: GestureDetector(
//                              onTap: () {
//                                /* Navigator.push(
//                                  context,
//                                  MaterialPageRoute(
//                                      builder: (context) => AlImages()),
//                                );*/
//                              },
//                              child: Container(
//                                  height: 38,
//                                  width:
//                                  MediaQuery.of(context).size.width * 0.80,
//                                  decoration: BoxDecoration(
//                                    border: Border.all(
//                                        color: Constants.whiteColor70),
//                                  ),
//                                  child: Center(
//                                    child: Text(
//                                      "PREVIEW",
//                                      style: TextStyle(
//                                          fontWeight: FontWeight.bold,
//                                          color: Constants.whiteColor70,
//                                          fontSize: 19.0),
//                                    ),
//                                  )),
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.only(top: 14),
//                            child: Container(
//                                height: 30,
//                                width: MediaQuery.of(context).size.width * 0.80,
//                                decoration: BoxDecoration(
//                                  border: Border.all(
//                                      color: Constants.transparentColor),
//                                ),
//                                child: Text(
//                                  "SEND ME A QUOTE",
//                                  style: TextStyle(
//                                      fontWeight: FontWeight.bold,
//                                      color: Constants.whiteColor70,
//                                      fontSize: 27.0),
//                                )),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.only(top: 14),
//                            child: Container(
//                                color: Constants.transparentColor,
//                                height: 35,
//                                width: MediaQuery.of(context).size.width * 0.80,
//                                child: Row(
//                                  mainAxisSize: MainAxisSize.max,
//                                  mainAxisAlignment:
//                                  MainAxisAlignment.spaceBetween,
//                                  children: <Widget>[
//                                    Container(
//                                      height: 35,
//                                      width: MediaQuery.of(context).size.width *
//                                          0.25,
//                                      color: Constants.whiteColor70,
//                                      child: Padding(
//                                        padding:
//                                        const EdgeInsets.only(left: 10),
//                                        child: DropdownButton(
//                                          value: _selectedSalesman,
//                                          items: saleman,
//                                          onChanged: changeSalesman,
//                                          isExpanded: true,
//                                          iconEnabledColor: Constants.blackColor,
//                                          iconSize: 30,
//                                          hint: Text('Select Salesman' , style: TextStyle(color: Constants.blackColor, fontSize: 17),),
//                                        ),
//                                      ),
//                                    ),
//                                    Container(
//                                      height: 35,
//                                      width: MediaQuery.of(context).size.width *
//                                          0.25,
//                                      color: Constants.whiteColor70,
//                                      child: Padding(
//                                        padding:
//                                        const EdgeInsets.only(left: 10),
//                                        child: DropdownButton(
//                                          value: _selectedqty,
//                                          items: _dropdownValues
//                                              .map((value) =>
//                                              DropdownMenuItem(
//                                                child: Text(value),
//                                                value: value,
//                                              ))
//                                              .toList(),
//                                          onChanged: changeQty,
//                                          isExpanded: true,
//                                          iconEnabledColor: Constants.blackColor,
//                                          iconSize: 30,
//                                          hint: Text('Select Quality' , style: TextStyle(color: Constants.blackColor, fontSize: 17),),
//                                        ),
//                                      ),
//                                    ),
//                                    Container(
//                                      height: 35,
//                                      width: MediaQuery.of(context).size.width *
//                                          0.25,
//                                      color: Constants.whiteColor70,
//                                      child: Padding(
//                                        padding:
//                                        const EdgeInsets.only(left: 10),
//                                        child: DropdownButton(
//                                          value: _selectedColor,
//                                          items: color,
//                                          onChanged: changeColor,
//                                          isExpanded: true,
//                                          iconEnabledColor: Constants.blackColor,
//                                          iconSize: 30,
//                                          hint: Text('Choose Color' , style: TextStyle(color: Constants.blackColor, fontSize: 17),),
//                                        ),
//                                      ),
//                                    )
//                                  ],
//                                )),
//                          ),
//                          Form(
//                               key: _validator,
//                            child: Padding(
//                              padding: const EdgeInsets.only(top: 12),
//                              child: Container(
//                                  color: Constants.transparentColor,
//                                  height: 35,
//                                  width: MediaQuery.of(context).size.width * 0.80,
//                                  child: Row(
//                                    mainAxisSize: MainAxisSize.max,
//                                    mainAxisAlignment:
//                                    MainAxisAlignment.spaceBetween,
//                                    children: <Widget>[
//                                      Container(
//                                        height: 35,
//                                        width: MediaQuery.of(context).size.width *
//                                            0.39,
//                                        color: Constants.whiteColor70,
//                                        child: Padding(
//                                          padding: const EdgeInsets.only(left: 10),
//                                          child: TextFormField(
//                                            validator: (value) =>
//                                            value.isEmpty ? null : null,
//                                            onSaved: (value) => customer_name = value.trim(),
//                                            style: TextStyle(
//                                                color: Constants.blackColor,
//                                                fontSize: 16.0),
//                                            keyboardType:
//                                            TextInputType.emailAddress,
//                                            cursorColor: Constants.orangeColor,
//                                            decoration: InputDecoration(
//                                                hintText: 'Client Name',
//                                                hintStyle: TextStyle(fontSize: 17.0, color: Constants.blackColor),
//                                                //labelText: 'Client Name',
//                                                labelStyle: TextStyle(
//                                                    color: Constants.blackColor,
//                                                    fontSize: 19.0)),
//                                          ),
//                                        ),
//                                      ),
//                                      Container(
//                                        height: 35,
//                                        width: MediaQuery.of(context).size.width *
//                                            0.39,
//                                        color: Constants.whiteColor70,
//                                        child: Padding(
//                                          padding:
//                                          const EdgeInsets.only(left: 10),
//                                          child: TextFormField(
//                                            validator: (value) =>
//                                            value.isEmpty ? null : null,
//                                            onSaved: (value) => email = value.trim(),
//                                            style: TextStyle(
//                                                color: Constants.blackColor,
//                                                fontSize: 16.0),
//                                            keyboardType:
//                                            TextInputType.emailAddress,
//                                            cursorColor: Constants.orangeColor,
//                                            decoration: InputDecoration(
//                                                hintText: 'Client Email',
//                                                hintStyle: TextStyle(fontSize: 17.0, color: Constants.blackColor),
//                                                //labelText: 'Client Name',
//                                                labelStyle: TextStyle(
//                                                    color: Constants.blackColor,
//                                                    fontSize: 19.0)),
//                                          ),
//                                        ),
//                                      )
//                                    ],
//                                  )),
//                            ),
//                          ),
//                          Padding(
//                            padding: const EdgeInsets.only(top: 12),
//                            child: Container(
//                              color: Constants.whiteColor70,
//                              height: 70,
//                              width: MediaQuery.of(context).size.width * 0.80,
//                              child: Padding(
//                                padding:
//                                const EdgeInsets.only(top: 8, left: 10),
//                                child:  TextFormField(
//                                  validator: (value) =>
//                                  value.isEmpty ? null : null,
//                                  onSaved: (value) => _details = value.trim(),
//                                  style: TextStyle(
//                                      color: Constants.blackColor,
//                                      fontSize: 16.0),
//                                  keyboardType:
//                                  TextInputType.emailAddress,
//                                  cursorColor: Constants.orangeColor,
//                                  decoration: InputDecoration(
//                                      hintText: 'Comment',
//                                      border: InputBorder.none,
//                                      hintStyle: TextStyle(fontSize: 17.0, color: Constants.blackColor),
//                                      //labelText: 'Client Name',
//                                      labelStyle: TextStyle(
//                                          color: Constants.blackColor,
//                                          fontSize: 19.0)),
//                                ),
//                              ),
//                            ),
//                          ),
//                          InkWell(
//                            onTap: ()  {
//                              var res =  SaveAndSubmit();
//                            },
//                            child: Padding(
//                              padding: const EdgeInsets.only(top: 10),
//                              child: Container(
//                                  height: 38,
//                                  width:
//                                  MediaQuery.of(context).size.width * 0.80,
//                                  decoration: BoxDecoration(
//                                    border: Border.all(
//                                        color: Constants.whiteColor70),
//                                  ),
//                                  child: Center(
//                                    child: Text(
//                                      "SAVE & SUBMIT",
//                                      style: TextStyle(
//                                          fontWeight: FontWeight.bold,
//                                          color: Constants.whiteColor70,
//                                          fontSize: 19.0),
//                                    ),
//                                  )),
//                            ),
//                          ),
//                        ],
//                      ),
//                    ),
//                  ],
//                ),
//              ]),
//            ),
//          ],
//        ),
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

  void _toggle(int index) {
    setState(() {
      _visible[index] = !_visible[index];
      pressAttention[index] = !pressAttention[index];
    });
  }

  Future<modelAlico> SaveAndSubmit() async {
    if (_validateLogin()) {
      /* Map params = {
        "customer_name": customer_name,
        "email": email,
        "color_id": "#333333",
        "saleman_id": saleman_id,
        "qty": 1,
        "details": details,
        "type": 1,
        "product_id": ModelApi.product_id,
        "region": {"region_id":  ModelApi.region_id, "option_id": ModelApi.option_id}
      };*/
      Map params = {
        "customer_name": customer_name,
        "email": email,
        "color_id": color_id,
        "saleman_id": saleman_id,
        "qty": qty,
        "details": _details.toString(),
        "type": 1,
        "product_id": ModelApi.product_id,
        "region": {
          "region_id": ModelApi.region_id,
          "option_id": ModelApi.option_id
        }
      };
      try {
        final response = await http.post('http://aco.lbatechnologies.com/quotes',
            body: json.encode(params));
        if (response.statusCode == 200) {
          var jsonData = json.decode(response.body);
          if (jsonData['status'] == 1) {
            print("Fetched Quotation");
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ThankYou()),
            );
          } else {
            Toast.show(jsonData['Response_msg'].toString(), context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
            print(response.body);
          }

          return null;
        }
      } on Exception catch (exception) {
        Toast.show("Something went wrong", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
        print('Failed to load Quotation');
      } catch (error) {
      }




    }
  }

  bool _validateLogin() {
    final form = _validator.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
