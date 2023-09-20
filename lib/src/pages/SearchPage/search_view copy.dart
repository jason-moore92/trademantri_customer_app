// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:trapp/config/config.dart';
// import 'package:provider/provider.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// import 'package:trapp/src/elements/category_widget.dart';
// import 'package:trapp/src/elements/keicy_text_form_field.dart';
// import 'package:trapp/src/elements/store_widget.dart';
// import 'package:trapp/src/models/store_model.dart';
// import 'package:trapp/src/pages/StorePage/index.dart';
// import 'package:trapp/src/pages/ErrorPage/index.dart';
// import 'package:trapp/src/providers/index.dart';

// import 'index.dart';

// class SearchView extends StatefulWidget {
//   Map<String, dynamic>? categoryData;
//   final bool forSelection;

//   SearchView({
//     Key? key,
//     this.categoryData,
//     this.forSelection = false,
//   }) : super(key: key);

//   @override
//   _SearchViewState createState() => _SearchViewState();
// }

// class _SearchViewState extends State<SearchView> {
//   /// Responsive design variables
//   double deviceWidth = 0;
//   double deviceHeight = 0;
//   double statusbarHeight = 0;
//   double bottomBarHeight = 0;
//   double appbarHeight = 0;
//   double widthDp = 0;
//   double heightDp = 0;
//   double fontSp = 0;
//   ///////////////////////////////

//   AppDataProvider? _appDataProvider;
//   SearchProvider? _searchProvider;

//   TextEditingController _controller = TextEditingController();
//   FocusNode _focusNode = FocusNode();

//   RefreshController _refreshController = RefreshController(initialRefresh: false);
//   String? _categoryId;

//   @override
//   void initState() {
//     super.initState();

//     /// Responsive design variables
//     deviceWidth = 1.sw;
//     deviceHeight = 1.sh;
//     statusbarHeight = ScreenUtil().statusBarHeight;
//     bottomBarHeight = ScreenUtil().bottomBarHeight;
//     appbarHeight = AppBar().preferredSize.height;
//     widthDp = ScreenUtil().setWidth(1);
//     heightDp = ScreenUtil().setWidth(1);
//     fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
//     ///////////////////////////////

//     _appDataProvider = AppDataProvider.of(context);
//     _searchProvider = SearchProvider.of(context);

//     _categoryId = widget.categoryData!["categoryId"];

//     if (_searchProvider!.searchState.storeList![_categoryId] == null || _searchProvider!.searchState.storeList![_categoryId]!.isEmpty) {
//       _searchProvider!.setSearchState(
//         _searchProvider!.searchState.update(progressState: 1),
//         isNotifiable: false,
//       );
//     }

//     WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
//       _searchProvider!.addListener(_searchProviderListener);

//       if ((_searchProvider!.searchState.storeList![_categoryId] == null || _searchProvider!.searchState.storeList![_categoryId]!.isEmpty)) {
//         _searchProvider!.getStoreList(
//           categoryId: _categoryId,
//           location: _appDataProvider!.appDataState.currentLocation!["location"],
//           distance: _appDataProvider!.appDataState.distance,
//         );
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchProvider!.removeListener(_searchProviderListener);
//     super.dispose();
//   }

//   void _searchProviderListener() async {
//     if (_searchProvider!.searchState.progressState == -1) {
//       if (_searchProvider!.searchState.isStoreRefresh!) {
//         _refreshController.refreshFailed();
//         _searchProvider!.setSearchState(
//           _searchProvider!.searchState.update(isStoreRefresh: false),
//           isNotifiable: false,
//         );
//       } else {
//         _refreshController.loadFailed();
//       }
//     } else if (_searchProvider!.searchState.progressState == 2) {
//       if (_searchProvider!.searchState.isStoreRefresh!) {
//         _refreshController.refreshCompleted();
//         _searchProvider!.setSearchState(
//           _searchProvider!.searchState.update(isStoreRefresh: false),
//           isNotifiable: false,
//         );
//       } else {
//         _refreshController.loadComplete();
//       }
//     }
//   }

//   void _onRefresh() async {
//     // monitor network fetch
//     _searchProvider!.setSearchState(
//       _searchProvider!.searchState.update(
//         progressState: 1,
//         storeList: {_categoryId!: []},
//         storeMetaData: {_categoryId!: Map<String, dynamic>()},
//         isStoreRefresh: true,
//       ),
//     );
//     await _searchProvider!.getStoreList(
//       categoryId: _categoryId,
//       location: _appDataProvider!.appDataState.currentLocation!["location"],
//       distance: _appDataProvider!.appDataState.distance,
//     );
//   }

//   void _onLoading() async {
//     await _searchProvider!.getStoreList(
//       categoryId: _categoryId,
//       location: _appDataProvider!.appDataState.currentLocation!["location"],
//       distance: _appDataProvider!.appDataState.distance,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         return true;
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           elevation: 0,
//           centerTitle: true,
//           title: Text(
//             "Search Store",
//             style: TextStyle(fontSize: fontSp * 18, color: Colors.black),
//           ),
//         ),
//         body: Consumer<SearchProvider>(builder: (context, searchProvider, _) {
//           if (searchProvider.searchState.progressState == -1) {
//             return ErrorPage(
//               message: searchProvider.searchState.message,
//               callback: () {
//                 if (_searchProvider!.searchState.storeList![_categoryId] == null ||
//                     _searchProvider!.searchState.storeList![_categoryId]!.isEmpty) {
//                   _searchProvider!.setSearchState(_searchProvider!.searchState.update(progressState: 1));
//                   _searchProvider!.getStoreList(
//                     categoryId: _categoryId,
//                     location: _appDataProvider!.appDataState.currentLocation!["location"],
//                     distance: _appDataProvider!.appDataState.distance,
//                   );
//                 }
//               },
//             );
//           }

//           return GestureDetector(
//             onTap: () {
//               FocusScope.of(context).requestFocus(FocusNode());
//             },
//             child: NotificationListener<OverscrollIndicatorNotification>(
//               onNotification: (overScroll) {
//                 overScroll.disallowGlow();
//                 return true;
//               },
//               child: SingleChildScrollView(
//                 child: Container(
//                   width: deviceWidth,
//                   height: deviceHeight - statusbarHeight - appbarHeight,
//                   // height: deviceHeight - statusbarHeight - appbarHeight - (widget.forSelection ? 0 : kBottomNavigationBarHeight),
//                   color: Colors.transparent,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _searchField(),
//                       SizedBox(height: heightDp * 10),
//                       Expanded(
//                         child: _storeListPanel(),
//                       ),
//                       SizedBox(height: heightDp * 10),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   Widget _searchField() {
//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: widthDp * 25),
//       child: KeicyTextFormField(
//         controller: _controller,
//         focusNode: _focusNode,
//         width: null,
//         height: heightDp * 50,
//         border: Border.all(color: Colors.grey.withOpacity(0.3)),
//         errorBorder: Border.all(color: Colors.grey.withOpacity(0.3)),
//         borderRadius: heightDp * 6,
//         contentHorizontalPadding: widthDp * 10,
//         textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.black),
//         hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.grey.withOpacity(0.6)),
//         hintText: SearchPageString.searchStoreHint,
//         prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.grey.withOpacity(0.6))],
//         suffixIcons: [
//           GestureDetector(
//             onTap: () {
//               _controller.clear();

//               setState(() {});
//             },
//             child: Icon(Icons.close, size: heightDp * 20, color: Colors.grey.withOpacity(0.6)),
//           ),
//         ],
//         onFieldSubmittedHandler: (input) {
//           FocusScope.of(context).requestFocus(FocusNode());
//           _getCategoryHandler(input.trim());
//           setState(() {});
//         },
//       ),
//     );
//   }

//   Widget _storeListPanel() {
//     List<StoreModel> storeList = [];
//     bool loadingStatus = false;

//     if (_searchProvider!.searchState.progressState == 1) {
//       loadingStatus = true;
//     } else if (_searchProvider!.searchState.progressState == -1) {
//       return Padding(
//         padding: EdgeInsets.all(widthDp * 20),
//         child: Center(
//           child: Text(
//             _searchProvider!.searchState.message!,
//             style: TextStyle(fontSize: fontSp * 12, color: Colors.transparent),
//           ),
//         ),
//       );
//     } else if (_searchProvider!.searchState.progressState == 2) {
//       storeList = _searchProvider!.searchState.storeList![_categoryId]!;
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
//           child: Text(
//             loadingStatus ? "0 Store" : "${storeList.length}/${_searchProvider!.searchState.storeMetaData![_categoryId]["totalDocs"]} Stores",
//             style: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold, color: Colors.black),
//           ),
//         ),
//         SizedBox(height: heightDp * 10),
//         Expanded(
//           child: SmartRefresher(
//             enablePullDown: true,
//             enablePullUp: (_searchProvider!.searchState.storeMetaData![_categoryId] == null ||
//                 _searchProvider!.searchState.storeMetaData![_categoryId]["nextPage"] != null),
//             header: WaterDropHeader(),
//             footer: ClassicFooter(),
//             controller: _refreshController,
//             onRefresh: _onRefresh,
//             onLoading: _onLoading,
//             child: ListView.separated(
//               itemCount: loadingStatus ? 10 : storeList.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> storeData = loadingStatus ? Map<String, dynamic>() : storeList[index];

//                 return GestureDetector(
//                   onTap: () {
//                     if (loadingStatus) return;
//                     if (widget.forSelection) {
//                       Navigator.of(context).pop(storeData);
//                       return;
//                     }

//                     Navigator.of(context).push(
//                       MaterialPageRoute(
//                         builder: (BuildContext context) => StorePage(storeModel: StoreModel.fromJson(storeData)),
//                       ),
//                     );
//                   },
//                   child: StoreWidget(storeModel: StoreModel.fromJson(storeData), loadingStatus: loadingStatus),
//                 );
//               },
//               separatorBuilder: (context, index) {
//                 return Divider(color: Colors.grey.withOpacity(0.3), height: heightDp * 12, thickness: 1);
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   void _getCategoryHandler(String searchKey) {
//     _searchProvider!.setSearchState(_searchProvider!.searchState.update(progressState: 1));

//     _searchProvider!.getCategoryList(
//       appDataProvider: _appDataProvider,
//       distance: _appDataProvider!.appDataState.distance,
//       currentLocation: _appDataProvider!.appDataState.currentLocation!,
//       searchKey: searchKey,
//       userId: AuthProvider.of(context).authState.userModel!.id,
//     );
//   }
// }
