import 'package:alico_tablet/views/Home.dart';
import 'package:alico_tablet/views/myDrawer.dart';
import 'package:flutter/material.dart';

import '../commonUtils/constants.dart';

class ThankYou extends StatefulWidget {
  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankYou> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpen = false;
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
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/lines.png"),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.white, BlendMode.colorBurn)),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Image(
                        image: AssetImage("assets/images/tick-icon.png"),
                        fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Text("THANK YOU!",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40.0,
                            fontWeight: FontWeight.bold)),
                  ),
                  Text("Your request has been submitted successfuly",
                      style: TextStyle(color: Colors.black, fontSize: 19.0)),
                  Padding(
                    padding: const EdgeInsets.only(top: 90),
                    child: FlatButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      color: Constants.blackBackbtn,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0)),
                      child: Text('GO BACK TO HOME',
                          style:
                              TextStyle(color: Colors.white, fontSize: 21.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
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
