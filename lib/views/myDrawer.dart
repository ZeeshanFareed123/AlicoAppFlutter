import 'package:alico_tablet/Model/alico_model.dart';
import 'package:alico_tablet/commonUtils/constants.dart';
import 'package:alico_tablet/commonUtils/model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'DrawerItems.dart';

class MyDrawer extends StatefulWidget {
  final Function callback;

  const MyDrawer({Key key, this.callback}) : super(key: key);

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.callback,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Constants.transparentColor,
        child: Theme(
          data: Theme.of(context).copyWith(
            canvasColor: Constants.greenColor.withOpacity(0.8),
          ),
          child: Align(
            alignment: Alignment.topRight,
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height,
              child: Drawer(
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Constants.transparentColor,
                    child: new ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        return new ExpandableListView(
                          categories: ModelApi.categoryAll[index],
                          index: index,
                        );
                      },
                      itemCount: ModelApi.categoryAll.length,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
