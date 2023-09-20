import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:keyboard_utils/keyboard_aware/keyboard_aware.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/elements/keicy_raised_button.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/providers/index.dart';

class StoreCategoryBottomSheetDialog {
  static show(
    BuildContext context,
    List<dynamic>? productCatalogCategoryList,
    String? selectedCategory,
  ) {
    /// Responsive design variables
    double deviceWidth = 0;
    double deviceHeight = 0;
    double widthDp = 0;
    double heightDp = 0;
    double fontSp = 0;
    ///////////////////////////////

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    String? _selectedCategory = selectedCategory;

    TextEditingController _controller = TextEditingController();
    FocusNode _focusNode = FocusNode();

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
          List<dynamic> _productCatalogCategoryList = [];
          for (var i = 0; i < productCatalogCategoryList!.length; i++) {
            if (_controller.text.trim().isNotEmpty &&
                productCatalogCategoryList[i]["categoryDesc"].toString().toLowerCase().contains(_controller.text.trim().toLowerCase())) {
              _productCatalogCategoryList.add(productCatalogCategoryList[i]);
            } else if (_controller.text.trim().isEmpty) {
              _productCatalogCategoryList.add(productCatalogCategoryList[i]);
            }
          }

          return Material(
            color: Colors.transparent,
            child: KeyboardAware(builder: (context, keyboardConfig) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: deviceWidth,
                    height: deviceHeight / 2,
                    padding: EdgeInsets.symmetric(vertical: heightDp * 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(heightDp * 20), topRight: Radius.circular(heightDp * 20)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: heightDp * 10),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                          child: Text(
                            "Choose the Category",
                            style: TextStyle(fontSize: fontSp * 20, color: Colors.black),
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
                          child: KeicyTextFormField(
                            controller: _controller,
                            focusNode: _focusNode,
                            width: double.infinity,
                            height: heightDp * 40,
                            border: Border.all(color: Colors.grey.withOpacity(0.7)),
                            contentHorizontalPadding: widthDp * 10,
                            contentVerticalPadding: heightDp * 8,
                            textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                            hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey),
                            hintText: "Please enter a category",
                            onChangeHandler: (input) {
                              refreshProvider.refresh();
                            },
                          ),
                        ),
                        SizedBox(height: heightDp * 10),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _productCatalogCategoryList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    leading: IconButton(
                                      icon: Icon(
                                        _selectedCategory == _productCatalogCategoryList[index]["categoryId"]
                                            ? Icons.radio_button_checked_outlined
                                            : Icons.radio_button_off_outlined,
                                        size: heightDp * 25,
                                        color: config.Colors().mainColor(1),
                                      ),
                                      onPressed: () {
                                        if (_selectedCategory == _productCatalogCategoryList[index]["categoryId"]) {
                                          _selectedCategory = "";
                                        } else {
                                          _selectedCategory = _productCatalogCategoryList[index]["categoryId"];
                                        }

                                        refreshProvider.refresh();
                                      },
                                    ),
                                    title: Text("${_productCatalogCategoryList[index]["categoryDesc"]}", style: TextStyle(fontSize: fontSp * 16)),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        SizedBox(height: heightDp * 20),
                        KeicyRaisedButton(
                          width: widthDp * 120,
                          height: heightDp * 35,
                          color: config.Colors().mainColor(1),
                          // color: _selectedCategory != "" ? config.Colors().mainColor(1) : Colors.grey.withOpacity(0.6),
                          borderRadius: heightDp * 8,
                          child: Text(
                            "Choose",
                            style: TextStyle(fontSize: fontSp * 14, color: Colors.white),
                            // style: TextStyle(fontSize: fontSp * 14, color: _selectedCategory != "" ? Colors.white : Colors.black),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop(_selectedCategory);
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: keyboardConfig.keyboardHeight),
                ],
              );
            }),
          );
        });
      },
    );
  }
}
