class modelAlico {
  ImgLinks imgLinks;
  Records records;

  modelAlico({this.imgLinks, this.records});

  modelAlico.fromJson(Map<String, dynamic> json) {
    imgLinks = json['img_links'] != null
        ? new ImgLinks.fromJson(json['img_links'])
        : null;
    records =
        json['Records'] != null ? new Records.fromJson(json['Records']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.imgLinks != null) {
      data['img_links'] = this.imgLinks.toJson();
    }
    if (this.records != null) {
      data['Records'] = this.records.toJson();
    }
    return data;
  }
}

class ImgLinks {
  String categoryImg;
  String productsImg;
  String previewImg;
  String optionsImg;
  String colorsImg;
  String defaulttitleimage;
  String optionsImgs;
  String categoryImgs;

  ImgLinks(
      {this.categoryImg,
      this.productsImg,
      this.previewImg,
      this.optionsImg,
      this.colorsImg,
      this.defaulttitleimage,
      this.optionsImgs,
      this.categoryImgs});

  ImgLinks.fromJson(Map<String, dynamic> json) {
    categoryImg = json['category_img'];
    productsImg = json['products_img'];
    previewImg = json['preview_img'];
    optionsImg = json['options_img'];
    colorsImg = json['colors_img'];
    defaulttitleimage = json['defaulttitleimage'];
    optionsImgs = json['options_imgs'];
    categoryImgs = json['category_imgs'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_img'] = this.categoryImg;
    data['products_img'] = this.productsImg;
    data['preview_img'] = this.previewImg;
    data['options_img'] = this.optionsImg;
    data['colors_img'] = this.colorsImg;
    data['defaulttitleimage'] = this.defaulttitleimage;
    data['options_imgs'] = this.optionsImgs;
    data['category_imgs'] = this.categoryImgs;
    return data;
  }
}

class Records {
  List<Categories> categories;
  List<Catimages> catimages;
  List<Products> products;
  List<ProductOptions> productOptions;
  List<ProductPreview> productPreview;
  List<Options> options;
  List<OptionCustomFields> optionCustomFields;
  List<Colors> colors;
  List<Optimages> optimages;
  List<Salesman> salesman;
  Settings settings;

  Records(
      {this.categories,
      this.catimages,
      this.products,
      this.productOptions,
      this.productPreview,
      this.options,
      this.optionCustomFields,
      this.colors,
      this.optimages,
      this.salesman,
      this.settings});

  Records.fromJson(Map<String, dynamic> json) {
    if (json['categories'] != null) {
      categories = new List<Categories>();
      json['categories'].forEach((v) {
        categories.add(new Categories.fromJson(v));
      });
    }
    if (json['catimages'] != null) {
      catimages = new List<Catimages>();
      json['catimages'].forEach((v) {
        catimages.add(new Catimages.fromJson(v));
      });
    }
    if (json['products'] != null) {
      products = new List<Products>();
      json['products'].forEach((v) {
        products.add(new Products.fromJson(v));
      });
    }
    if (json['product_options'] != null) {
      productOptions = new List<ProductOptions>();
      json['product_options'].forEach((v) {
        productOptions.add(new ProductOptions.fromJson(v));
      });
    }
    if (json['product_preview'] != null) {
      productPreview = new List<ProductPreview>();
      json['product_preview'].forEach((v) {
        productPreview.add(new ProductPreview.fromJson(v));
      });
    }
    if (json['options'] != null) {
      options = new List<Options>();
      json['options'].forEach((v) {
        options.add(new Options.fromJson(v));
      });
    }
    if (json['option_custom_fields'] != null) {
      optionCustomFields = new List<OptionCustomFields>();
      json['option_custom_fields'].forEach((v) {
        optionCustomFields.add(new OptionCustomFields.fromJson(v));
      });
    }
    if (json['colors'] != null) {
      colors = new List<Colors>();
      json['colors'].forEach((v) {
        colors.add(new Colors.fromJson(v));
      });
    }
    if (json['optimages'] != null) {
      optimages = new List<Optimages>();
      json['optimages'].forEach((v) {
        optimages.add(new Optimages.fromJson(v));
      });
    }
    if (json['salesman'] != null) {
      salesman = new List<Salesman>();
      json['salesman'].forEach((v) {
        salesman.add(new Salesman.fromJson(v));
      });
    }
    settings = json['settings'] != null
        ? new Settings.fromJson(json['settings'])
        : null;

    /*catimages.forEach((ci){
      if(ci.catId == )
    });*/
    options.forEach((o) {
      optionCustomFields.forEach((oC) {
        if (oC.optionId == o.optionId) o.dimensions = (oC);
      });
    });
    products.forEach((p) {
      Map<String, List<Options>> regions = Map();
      productOptions.forEach((pO) {
        if (pO.productId == p.productId) {
          if (regions.containsKey(pO.regionId)) {
            options.forEach((o) {
              if (o.optionId == pO.optionId) regions[pO.regionId].add(o);
            });
          } else {
            regions[pO.regionId] = List<Options>();
            options.forEach((o) {
              if (o.optionId == pO.optionId) regions[pO.regionId].add(o);
            });
          }
        }
      });
      p.options = Map();
      p.options = regions;
    });
    List<Categories> removeCats= [];
    categories.forEach((c) {
      products.forEach((p) {
        if (p.catId == c.id) {
          if(c.products== null)
            c.products = [];
          c.products.add(p);
        }
      });
      if (c.parentId != "0") {
        categories.forEach((cc) {
          if (cc.id == c.parentId) {
            if (cc.subCategory == null) cc.subCategory = [];
            cc.subCategory.add(c);
            removeCats.add(c);
          }
        });
      }
    });
    removeCats.forEach((q){
      categories.remove(q);
    });
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.categories != null) {
      data['categories'] = this.categories.map((v) => v.toJson()).toList();
    }
    if (this.catimages != null) {
      data['catimages'] = this.catimages.map((v) => v.toJson()).toList();
    }
    if (this.products != null) {
      data['products'] = this.products.map((v) => v.toJson()).toList();
    }
    if (this.productOptions != null) {
      data['product_options'] =
          this.productOptions.map((v) => v.toJson()).toList();
    }
    if (this.productPreview != null) {
      data['product_preview'] =
          this.productPreview.map((v) => v.toJson()).toList();
    }
    if (this.options != null) {
      data['options'] = this.options.map((v) => v.toJson()).toList();
    }
    if (this.optionCustomFields != null) {
      data['option_custom_fields'] =
          this.optionCustomFields.map((v) => v.toJson()).toList();
    }
    if (this.colors != null) {
      data['colors'] = this.colors.map((v) => v.toJson()).toList();
    }
    if (this.optimages != null) {
      data['optimages'] = this.optimages.map((v) => v.toJson()).toList();
    }
    if (this.salesman != null) {
      data['salesman'] = this.salesman.map((v) => v.toJson()).toList();
    }
    if (this.settings != null) {
      data['settings'] = this.settings.toJson();
    }
    return data;
  }
}

class Categories {
  String id;
  String parentId;
  String image;
  String titleImg;
  String showMenu;
  String showOnhome;
  String sortOrder;
  String status;
  String name;
  String colorcode;
  String shortDescription;
  List<Products> products;
  List<Categories> subCategory;
  List<Catimages> catimg;


  Categories(
      {this.id,
      this.parentId,
      this.image,
      this.titleImg,
      this.showMenu,
      this.showOnhome,
      this.sortOrder,
      this.status,
      this.name,
      this.colorcode,
      this.shortDescription});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    parentId = json['parent_id'];
    image = json['image'];
    titleImg = json['title_img'];
    showMenu = json['show_menu'];
    showOnhome = json['show_onhome'];
    sortOrder = json['sort_order'];
    status = json['status'];
    name = json['name'];
    colorcode = json['colorcode'];
    shortDescription = json['short_description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['parent_id'] = this.parentId;
    data['image'] = this.image;
    data['title_img'] = this.titleImg;
    data['show_menu'] = this.showMenu;
    data['show_onhome'] = this.showOnhome;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    data['name'] = this.name;
    data['colorcode'] = this.colorcode;
    data['short_description'] = this.shortDescription;
    return data;
  }
}

class Catimages {
  String id;
  String catId;
  String fileName;
  String sortOrder;
  String status;

  Catimages({this.id, this.catId, this.fileName, this.sortOrder, this.status});

  Catimages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    catId = json['cat_id'];
    fileName = json['file_name'];
    sortOrder = json['sort_order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['cat_id'] = this.catId;
    data['file_name'] = this.fileName;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    return data;
  }
}

class Products {
  String productId;
  String catId;
  String name;
  String sdescription;
  String productImage;
  String titleImg;
  String colorcode;
  String colors;
  String sortOrder;
  String status;
  Map<String, List<Options>> options;

  Products(
      {this.productId,
      this.catId,
      this.name,
      this.sdescription,
      this.productImage,
      this.titleImg,
      this.colorcode,
      this.colors,
      this.sortOrder,
      this.status});

  Products.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    catId = json['cat_id'];
    name = json['name'];
    sdescription = json['sdescription'];
    productImage = json['product_image'];
    titleImg = json['title_img'];
    colorcode = json['colorcode'];
    colors = json['colors'];
    sortOrder = json['sort_order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.productId;
    data['cat_id'] = this.catId;
    data['name'] = this.name;
    data['sdescription'] = this.sdescription;
    data['product_image'] = this.productImage;
    data['title_img'] = this.titleImg;
    data['colorcode'] = this.colorcode;
    data['colors'] = this.colors;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    return data;
  }
}

class ProductOptions {
  String id;
  String productId;
  String regionId;
  String optionId;
  String defaultOption;

  ProductOptions(
      {this.id,
      this.productId,
      this.regionId,
      this.optionId,
      this.defaultOption});

  ProductOptions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    regionId = json['region_id'];
    optionId = json['option_id'];
    defaultOption = json['default_option'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['region_id'] = this.regionId;
    data['option_id'] = this.optionId;
    data['default_option'] = this.defaultOption;
    return data;
  }
}

class ProductPreview {
  String id;
  String productId;
  String previewImage;
  String collection;

  ProductPreview({this.id, this.productId, this.previewImage, this.collection});

  ProductPreview.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    previewImage = json['preview_image'];
    collection = json['collection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    data['preview_image'] = this.previewImage;
    data['collection'] = this.collection;
    return data;
  }
}

class Options {
  String optionId;
  String name;
  String description;
  String catId;
  String regionId;
  String image;
  String sortOrder;
  String status;
  OptionCustomFields dimensions;

  Options(
      {this.optionId,
      this.name,
      this.description,
      this.catId,
      this.regionId,
      this.image,
      this.sortOrder,
      this.status});

  Options.fromJson(Map<String, dynamic> json) {
    optionId = json['option_id'];
    name = json['name'];
    description = json['description'];
    catId = json['cat_id'];
    regionId = json['region_id'];
    image = json['image'];
    sortOrder = json['sort_order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['option_id'] = this.optionId;
    data['name'] = this.name;
    data['description'] = this.description;
    data['cat_id'] = this.catId;
    data['region_id'] = this.regionId;
    data['image'] = this.image;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    return data;
  }
}

class OptionCustomFields {
  String customFieldId;
  String optionId;
  String label;
  String value;
  String sortOrder;

  OptionCustomFields(
      {this.customFieldId,
      this.optionId,
      this.label,
      this.value,
      this.sortOrder});

  OptionCustomFields.fromJson(Map<String, dynamic> json) {
    customFieldId = json['custom_field_id'];
    optionId = json['option_id'];
    label = json['label'];
    value = json['value'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['custom_field_id'] = this.customFieldId;
    data['option_id'] = this.optionId;
    data['label'] = this.label;
    data['value'] = this.value;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}

class Colors {
  String id;
  String color;
  String image;
  String status;
  String sortOrder;

  Colors({this.id, this.color, this.image, this.status, this.sortOrder});

  Colors.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    color = json['color'];
    image = json['image'];
    status = json['status'];
    sortOrder = json['sort_order'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['color'] = this.color;
    data['image'] = this.image;
    data['status'] = this.status;
    data['sort_order'] = this.sortOrder;
    return data;
  }
}

class Optimages {
  String id;
  String optId;
  String fileName;
  String colorId;
  String sortOrder;
  String status;

  Optimages(
      {this.id,
      this.optId,
      this.fileName,
      this.colorId,
      this.sortOrder,
      this.status});

  Optimages.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    optId = json['opt_id'];
    fileName = json['file_name'];
    colorId = json['color_id'];
    sortOrder = json['sort_order'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['opt_id'] = this.optId;
    data['file_name'] = this.fileName;
    data['color_id'] = this.colorId;
    data['sort_order'] = this.sortOrder;
    data['status'] = this.status;
    return data;
  }
}

class Salesman {
  String id;
  String name;
  String email;
  String pNo;
  String status;

  Salesman({this.id, this.name, this.email, this.pNo, this.status});

  Salesman.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    pNo = json['p_no'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['p_no'] = this.pNo;
    data['status'] = this.status;
    return data;
  }
}

class Settings {
  String baseURL;
  String uploadFolder;
  String fPLIMIT;
  Regions regions;
  String colorMsg;

  Settings(
      {this.baseURL,
      this.uploadFolder,
      this.fPLIMIT,
      this.regions,
      this.colorMsg});

  Settings.fromJson(Map<String, dynamic> json) {
    baseURL = json['baseURL'];
    uploadFolder = json['uploadFolder'];
    fPLIMIT = json['FP_LIMIT'];
    regions =
        json['Regions'] != null ? new Regions.fromJson(json['Regions']) : null;
    colorMsg = json['colorMsg'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseURL'] = this.baseURL;
    data['uploadFolder'] = this.uploadFolder;
    data['FP_LIMIT'] = this.fPLIMIT;
    if (this.regions != null) {
      data['Regions'] = this.regions.toJson();
    }
    data['colorMsg'] = this.colorMsg;
    return data;
  }
}

class Regions {
  String s1;
  String s2;
  String s3;
  String s4;
  String s5;

  Regions({this.s1, this.s2, this.s3, this.s4, this.s5});

  Regions.fromJson(Map<String, dynamic> json) {
    s1 = json['1'];
    s2 = json['2'];
    s3 = json['3'];
    s4 = json['4'];
    s5 = json['5'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['1'] = this.s1;
    data['2'] = this.s2;
    data['3'] = this.s3;
    data['4'] = this.s4;
    data['5'] = this.s5;
    return data;
  }
}
