/*
  -----------------------------
  FLUTTER BASED ECOM-SOLUTION BY
  SpiralClick Web Technologies
  -----------------------------
*/

import 'package:alico_tablet/Model/alico_model.dart';
import 'package:flutter/material.dart' hide Colors;

class ModelApi{

   static  Future<modelAlico> alicoData;
   static List<Categories> categoryAll = new List<Categories>();
   static List<Salesman> salesman = [];
   static List<Catimages> catimgs = [];
   static List<Categories> categories;

   static List<Colors> color = [];
   static String product_id= "";
   static String firstCategory_id= "";

   static String baseCatImages;
   static String categoryBaseLinks_home;
   static String productBaseLinkse;
   static String optionBaseLinkse;

   static List<String> region_id = [];
   static List<String> option_id = [];



}


