import 'dart:convert';
import 'dart:io';
import 'package:alico_tablet/Model/alico_model.dart';
import 'package:alico_tablet/commonUtils/constants.dart';
import 'package:alico_tablet/commonUtils/model.dart';
import 'package:alico_tablet/views/Types.dart';
import 'package:alico_tablet/views/myDrawer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'SubCategory.dart';
import 'package:toast/toast.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _isOpen = false;

  // List<Categories> categories;

  @override
  void initState() {
    ModelApi.alicoData = getData();
    super.initState();
  }

  Future<modelAlico> getData() async {
    modelAlico snapshot = await fetchLocal();
    ModelApi.categoryAll = snapshot.records.categories;
    ModelApi.salesman = snapshot.records.salesman;
    ModelApi.catimgs = snapshot.records.catimages;
    ModelApi.baseCatImages = snapshot.imgLinks.categoryImgs;
    ModelApi.color = snapshot.records.colors;
    ModelApi.categoryBaseLinks_home = snapshot.imgLinks.categoryImg;
    ModelApi.productBaseLinkse = snapshot.imgLinks.productsImg;
    ModelApi.optionBaseLinkse = snapshot.imgLinks.optionsImg;
    ModelApi.categories = snapshot.records.categories;
    return snapshot;
  }

  Directory dir;
  File jsonFile;
  bool fileExists;

  Future<modelAlico> fetchLocal() async {
    print("Fetching Locally");
    return getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;
      jsonFile = new File(dir.path + "/" + Constants.fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        print("Fetched Locally");
        modelAlico d =
        modelAlico.fromJson(json.decode(jsonFile.readAsStringSync()));
        if (d != null)
          return d;
        else
          return fetchPost();
      } else
        return fetchPost();
    });
  }

  Future<modelAlico> fetchPost() async {
    try {
      final response = await http
          .post('http://aco.lbatechnologies.com/syncer?synct=2&did=79');
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        modelAlico data = modelAlico.fromJson(json.decode(response.body));
        writeToFile(response.body);
        print("Fetched Network");
        return data;
      }
    } on Exception catch (exception) {
      Toast.show("Something went wrong", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      print('Failed to load Quotation');
    } catch (error) {}
  }

  void writeToFile(String data) {
    print("Writing to file!");

    if (fileExists) {
      print("File exists");
      jsonFile.writeAsStringSync(data);
    } else {
      print("File does not exist!");
      createFile(data, dir, Constants.fileName);
    }
  }

  void createFile(String content, Directory dir, String fileName) {
    print("Creating file!");
    File file = new File(dir.path + "/" + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(content);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90.0),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Constants.greenColor,
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20),
                child: Image(
                  height: 60,
                  width: 60,
                  image: AssetImage("assets/images/icon.png"),
                  fit: BoxFit.contain,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25, right: 20),
                child: IconButton(
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
                print(snapshot.data.records.categories[2].name);
                return DataLoaded();
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

  Widget DataLoaded() {
    return Scaffold(
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 0.0,
            crossAxisSpacing: 0.0,
          ),
          itemCount: ModelApi.categories.length,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                if (ModelApi.categories[index].subCategory == null ||
                    ModelApi.categories[index].subCategory.isEmpty) {
                  ModelApi.firstCategory_id = ModelApi.categories[index].id;
                  Navigator.push(context,
                      PageTransition(type:
                      PageTransitionType.leftToRightWithFade,
                          child: Types( int.parse(ModelApi.categories[index].colorcode
                              .replaceAll(new RegExp(r'#'), '0xFF')),
                            products: ModelApi.categories[index].products,)));
                  /* Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Types(
                          int.parse(ModelApi.categories[index].colorcode
                              .replaceAll(new RegExp(r'#'), '0xFF')),
                          products: ModelApi.categories[index].products,
                        )),
              );*/
                } else {
                  ModelApi.firstCategory_id = ModelApi.categories[index].id;

                  Navigator.push(context,
                      PageTransition(type:
                      PageTransitionType.leftToRightWithFade,
                          child: SubCategory(   int.parse(ModelApi.categories[index].colorcode
                              .replaceAll(new RegExp(r'#'), '0xFF')),
                            subCat: ModelApi.categories[index].subCategory,)));
                  /*Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => SubCategory(
                          int.parse(ModelApi.categories[index].colorcode
                              .replaceAll(new RegExp(r'#'), '0xFF')),
                          subCat: ModelApi.categories[index].subCategory,
                        )),
              );*/
                }
              },
              child: Card(
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: Container(
                        child: CachedNetworkImage(
                          imageUrl: Constants.BASE_URL +
                              ModelApi.categoryBaseLinks_home +
                              ModelApi.categories[index].image,
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
                          placeholder: (context, url) => CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                            AlwaysStoppedAnimation(Constants.whiteColor70),
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      ),
                    ),
                    Container(
                      height: 65,
                      //  color: Color(0xFFFDD835),
                      decoration: new BoxDecoration(
                        image: DecorationImage(
                            image: new AssetImage('assets/images/back.png'),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Color(int.parse(ModelApi.categories[index].colorcode
                                    .replaceAll(new RegExp(r'#'), '0xFF')))
                                    .withOpacity(0.6),
                                BlendMode.colorBurn)),
                      ),
                      child: Center(
                        child: Text(
                          ModelApi.categories[index].name,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 28.0,
                              color: Constants.whiteColor70),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ));
  }
}
