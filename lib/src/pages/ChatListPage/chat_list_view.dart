import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trapp/config/config.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/keicy_text_form_field.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/pages/ErrorPage/index.dart';
import 'package:trapp/src/pages/SearchPage/index.dart';
import 'package:trapp/src/pages/StoreCategoriesPage/index.dart';
import 'package:trapp/src/providers/ChatProvider/index.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:flutter_slidable/flutter_slidable.dart';

import '../ChatPage/index.dart';
import 'index.dart';

class ChatListView extends StatefulWidget {
  final int? initIndex;

  ChatListView({Key? key, this.initIndex}) : super(key: key);

  @override
  _ChatListViewState createState() => _ChatListViewState();
}

class _ChatListViewState extends State<ChatListView> with SingleTickerProviderStateMixin {
  /// Responsive design variables
  double deviceWidth = 0;
  double deviceHeight = 0;
  double statusbarHeight = 0;
  double bottomBarHeight = 0;
  double appbarHeight = 0;
  double widthDp = 0;
  double heightDp = 0;
  double heightDp1 = 0;
  double fontSp = 0;
  ///////////////////////////////

  TextEditingController _controller = TextEditingController();
  FocusNode _focusNode = FocusNode();

  List<RefreshController> _refreshControllerList = [];

  int chatRoomTotalList = 0;
  List<ChatRoomModel> chatRoomList = [];
  int chatRoomNumbers = 0;

  bool searchBarShow = false;
  bool searchBarReadOnly = false;

  ChatProvider? _chatProvider;

  TabController? _tabController;

  @override
  void initState() {
    super.initState();

    /// Responsive design variables
    deviceWidth = 1.sw;
    deviceHeight = 1.sh;
    statusbarHeight = ScreenUtil().statusBarHeight;
    bottomBarHeight = ScreenUtil().bottomBarHeight;
    appbarHeight = AppBar().preferredSize.height;
    widthDp = ScreenUtil().setWidth(1);
    heightDp = ScreenUtil().setWidth(1);
    heightDp1 = ScreenUtil().setHeight(1);
    fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;
    ///////////////////////////////

    chatRoomTotalList = 0;
    chatRoomNumbers = 0;

    chatRoomList = [];

    searchBarShow = false;
    searchBarReadOnly = false;

    _chatProvider = ChatProvider.of(context);

    _tabController = TabController(length: 2, vsync: this, initialIndex: widget.initIndex!);

    _refreshControllerList.add(RefreshController(initialRefresh: false));
    _refreshControllerList.add(RefreshController(initialRefresh: false));

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onRefresh() async {
    chatRoomList = [];
    chatRoomNumbers = 0;
    setState(() {});
  }

  void _onLoading() async {
    chatRoomNumbers = chatRoomNumbers + AppConfig.countLimitForList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(),
        floatingActionButton: FloatingActionButton(
          child: IconButton(
            icon: Icon(Icons.add, size: heightDp * 30, color: Colors.white),
            onPressed: () async {
              FocusScope.of(context).requestFocus(FocusNode());
              searchBarReadOnly = true;

              if (_tabController!.index == 0) {
                var result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => StoreCategoriesPage(forSelection: true, onlyStore: true),
                  ),
                );
                searchBarReadOnly = false;

                if (result != null) {
                  result = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => SearchPage(
                        categoryData: result,
                        isFromCategory: true,
                        forSelection: true,
                        onlyStore: true,
                      ),
                    ),
                  );
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChatPage(
                        chatRoomType: ChatRoomTypes.b2c,
                        userData: result,
                      ),
                    ),
                  );
                }
              } else {
                // var result = await Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (BuildContext context) => BusinessStoresPage(
                //       status: ConnectionStatus.active,
                //       forSelection: true,
                //     ),
                //   ),
                // );
                // searchBarReadOnly = false;

                // if (result != null) {
                //   await Navigator.of(context).push(
                //     MaterialPageRoute(
                //       builder: (BuildContext context) => ChatPage(
                //         userData: result,
                //         chatRoomType: ChatRoomTypes.b2b,
                //       ),
                //     ),
                //   );
                // }
              }
            },
          ),
          onPressed: () {},
        ),
        body: DefaultTabController(
          length: 2,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (overScroll) {
                overScroll.disallowGlow();
                return true;
              },
              child: Container(
                width: deviceWidth,
                height: deviceHeight - statusbarHeight - appbarHeight,
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _tabBar(),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          _customerChatUsersPanel(),
                          _businessChatUsersPanel(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _appBar() {
    if (!searchBarShow)
      return AppBar(
        backgroundColor: config.Colors().mainColor(1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: Text("Chats", style: TextStyle(fontSize: fontSp * 18, color: Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: heightDp * 25, color: Colors.white),
            onPressed: () {
              setState(() {
                searchBarShow = true;
              });
            },
          ),
        ],
      );
    else
      return AppBar(
        backgroundColor: config.Colors().mainColor(1),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        centerTitle: true,
        title: _searchField(),
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: heightDp * 25, color: Colors.white),
            onPressed: () {
              setState(() {
                searchBarShow = false;
              });
            },
          ),
        ],
      );
  }

  Widget _tabBar() {
    return Container(
      decoration: BoxDecoration(
        color: config.Colors().mainColor(1),
        boxShadow: [
          BoxShadow(color: Colors.grey.withOpacity(0.5), offset: Offset(0, 2), blurRadius: 4),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelStyle: TextStyle(fontSize: fontSp * 20, color: Colors.white),
        unselectedLabelStyle: TextStyle(fontSize: fontSp * 20, color: Colors.white),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        indicatorColor: Colors.white,
        indicatorWeight: 5,
        tabs: [
          Tab(text: "Stores"),
          Tab(text: "Deliveries"),
        ],
        onTap: (int index) {
          setState(() {});
        },
      ),
    );
  }

  Widget _searchField() {
    return KeicyTextFormField(
      controller: _controller,
      focusNode: _focusNode,
      width: null,
      height: heightDp * 40,
      border: Border.all(color: Colors.white.withOpacity(1)),
      errorBorder: Border.all(color: Colors.white.withOpacity(1)),
      borderRadius: heightDp * 6,
      contentHorizontalPadding: widthDp * 10,
      contentVerticalPadding: heightDp * 8,
      textStyle: TextStyle(fontSize: fontSp * 14, color: Colors.white),
      hintStyle: TextStyle(fontSize: fontSp * 14, color: Colors.white.withOpacity(0.6)),
      hintText: _tabController!.index == 0 ? "Search for store" : "Search for delivery user",
      prefixIcons: [Icon(Icons.search, size: heightDp * 20, color: Colors.white.withOpacity(0.6))],
      readOnly: searchBarReadOnly,
      suffixIcons: [
        GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            _controller.clear();
            _onRefresh();
          },
          child: Icon(Icons.close, size: heightDp * 20, color: Colors.white.withOpacity(0.6)),
        ),
      ],
      textInputAction: TextInputAction.search,
      onFieldSubmittedHandler: (input) {
        if (searchBarReadOnly) return;
        FocusScope.of(context).requestFocus(FocusNode());
        _onRefresh();
      },
    );
  }

  Widget _customerChatUsersPanel() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: ChatRoomFirestoreProvider.getChatRoomsStream(
        chatRoomType: ChatRoomTypes.b2c,
        customerId: AuthProvider.of(context).authState.userModel!.id,
        limit: chatRoomNumbers + AppConfig.countLimitForList,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CupertinoActivityIndicator());
        }

        chatRoomList = [];
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data!.length; i++) {
            if (snapshot.data![i]["firstUserData"]["_id"] != AuthProvider.of(context).authState.userModel!.id &&
                snapshot.data![i]["firstUserName"].toString().toLowerCase().contains(_controller.text.trim().toLowerCase())) {
              chatRoomList.add(ChatRoomModel.fromJson(snapshot.data![i]));
            } else if (snapshot.data![i]["firstUserData"]["_id"] == AuthProvider.of(context).authState.userModel!.id &&
                snapshot.data![i]["secondUserName"].toString().toLowerCase().contains(_controller.text.trim().toLowerCase())) {
              chatRoomList.add(ChatRoomModel.fromJson(snapshot.data![i]));
            }
          }
        }

        if (chatRoomList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
            child: Center(
              child: Text("No Chats", style: TextStyle(fontSize: fontSp * 16)),
            ),
          );
        }

        chatRoomList.sort((a, b) {
          if (a.lastMessageDate == null) return 1;
          if (b.lastMessageDate == null) return -1;

          if (a.lastMessageDate!.isAfter(b.lastMessageDate!))
            return -1;
          else
            return 1;
        });

        _refreshControllerList[0].loadComplete();
        _refreshControllerList[0].refreshCompleted();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: (chatRoomTotalList > chatRoomList.length),
                header: WaterDropHeader(),
                footer: ClassicFooter(),
                controller: _refreshControllerList[0],
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: chatRoomList.length == 0
                    ? Center(
                        child: Text(
                          "No Store Available",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        itemCount: chatRoomList.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = chatRoomList[index];

                          return GestureDetector(
                            onTap: () async {
                              if (chatRoomModel == null) return;

                              searchBarReadOnly = true;

                              FocusScope.of(context).requestFocus(FocusNode());

                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => ChatPage(
                                    chatRoomType: ChatRoomTypes.b2c,
                                    chatRoomModel: chatRoomModel,
                                  ),
                                ),
                              );

                              searchBarReadOnly = false;
                            },
                            child: Column(
                              children: [
                                index == 0 ? Divider(color: Colors.grey.withOpacity(0.3), height: heightDp * 1, thickness: 1) : SizedBox(),
                                Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.2,
                                  child: ChatUserWidget(
                                    chatRoomModel: chatRoomModel,
                                    loadingStatus: chatRoomModel == null,
                                    isFirstUser: chatRoomModel.firstUserData!["_id"] != AuthProvider.of(context).authState.userModel!.id,
                                  ),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'More',
                                      color: Colors.black45,
                                      icon: Icons.more_horiz,
                                      onTap: () {
                                        _moreHandler(chatRoomModel);
                                      },
                                    ),
                                    IconSlideAction(
                                      caption: chatRoomModel.isBlocked! ? 'UnBlock' : 'Block',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        NormalAskDialog.show(
                                          context,
                                          title: "Chat Action",
                                          content: chatRoomModel.isBlocked! ? "Do you unblock this chat?" : "Do you block this chat?",
                                          callback: () async {
                                            _blockHandler(chatRoomModel);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.grey.withOpacity(0.3), height: heightDp * 1, thickness: 1),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _businessChatUsersPanel() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: ChatRoomFirestoreProvider.getChatRoomsStream(
        chatRoomType: ChatRoomTypes.d2c,
        customerId: AuthProvider.of(context).authState.userModel!.id,
        limit: chatRoomNumbers + AppConfig.countLimitForList,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CupertinoActivityIndicator());
        }

        chatRoomList = [];
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data!.length; i++) {
            if (snapshot.data![i]["firstUserData"]["_id"] != AuthProvider.of(context).authState.userModel!.id &&
                snapshot.data![i]["firstUserName"].toString().toLowerCase().contains(_controller.text.trim().toLowerCase())) {
              chatRoomList.add(ChatRoomModel.fromJson(snapshot.data![i]));
            } else if (snapshot.data![i]["firstUserData"]["_id"] == AuthProvider.of(context).authState.userModel!.id &&
                snapshot.data![i]["secondUserName"].toString().toLowerCase().contains(_controller.text.trim().toLowerCase())) {
              chatRoomList.add(ChatRoomModel.fromJson(snapshot.data![i]));
            }
          }
        }

        if (chatRoomList.isEmpty) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: widthDp * 20),
            child: Center(
              child: Text("No Chats", style: TextStyle(fontSize: fontSp * 16)),
            ),
          );
        }

        chatRoomList.sort((a, b) {
          if (a.lastMessageDate == null) return 1;
          if (b.lastMessageDate == null) return -1;

          if (a.lastMessageDate!.isAfter(b.lastMessageDate!))
            return -1;
          else
            return 1;
        });

        _refreshControllerList[1].loadComplete();
        _refreshControllerList[1].refreshCompleted();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SmartRefresher(
                enablePullDown: true,
                enablePullUp: (chatRoomTotalList > chatRoomList.length),
                header: WaterDropHeader(),
                footer: ClassicFooter(),
                controller: _refreshControllerList[1],
                onRefresh: _onRefresh,
                onLoading: _onLoading,
                child: chatRoomList.length == 0
                    ? Center(
                        child: Text(
                          "No Business Available",
                          style: TextStyle(fontSize: fontSp * 14, color: Colors.black),
                        ),
                      )
                    : ListView.builder(
                        itemCount: chatRoomList.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel? chatRoomModel = chatRoomList[index];

                          return GestureDetector(
                            onTap: () async {
                              if (chatRoomModel == null) return;

                              searchBarReadOnly = true;

                              FocusScope.of(context).requestFocus(FocusNode());

                              await Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => ChatPage(
                                    chatRoomType: ChatRoomTypes.d2c,
                                    chatRoomModel: chatRoomModel,
                                  ),
                                ),
                              );

                              searchBarReadOnly = false;
                            },
                            child: Column(
                              children: [
                                index == 0 ? Divider(color: Colors.grey.withOpacity(0.3), height: heightDp * 1, thickness: 1) : SizedBox(),
                                Slidable(
                                  actionPane: SlidableDrawerActionPane(),
                                  actionExtentRatio: 0.2,
                                  child: ChatUserWidget(
                                    chatRoomModel: chatRoomModel,
                                    loadingStatus: chatRoomModel == null,
                                    isFirstUser: chatRoomModel.firstUserData!["_id"] != AuthProvider.of(context).authState.userModel!.id,
                                  ),
                                  secondaryActions: <Widget>[
                                    IconSlideAction(
                                      caption: 'More',
                                      color: Colors.black45,
                                      icon: Icons.more_horiz,
                                      onTap: () {
                                        _moreHandler(chatRoomModel);
                                      },
                                    ),
                                    IconSlideAction(
                                      caption: chatRoomModel.isBlocked! ? 'UnBlock' : 'Block',
                                      color: Colors.red,
                                      icon: Icons.delete,
                                      onTap: () {
                                        NormalAskDialog.show(
                                          context,
                                          title: "Chat Action",
                                          content: chatRoomModel.isBlocked! ? "Do you unblock this chat?" : "Do you block this chat?",
                                          callback: () async {
                                            _blockHandler(chatRoomModel);
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Divider(color: Colors.grey.withOpacity(0.3), height: heightDp * 1, thickness: 1),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _blockHandler(ChatRoomModel chatRoomModel) {
    ChatRoomModel newChatRoomModel = ChatRoomModel.copy(chatRoomModel);
    newChatRoomModel.isBlocked = !newChatRoomModel.isBlocked!;

    _chatProvider!.updateChatRoom(chatRoomModel: newChatRoomModel, changeUpdateAt: false);
  }

  void _moreHandler(ChatRoomModel chatRoomModel) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            isDefaultAction: true,
            child: const Text('Clear Chat'),
            onPressed: () {
              _clearChatHandler(chatRoomModel);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            child: const Text('Delete Chat'),
            onPressed: () {
              _deleteChatRoomHandler(chatRoomModel);
              Navigator.pop(context);
            },
          )
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: false,
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  void _clearChatHandler(ChatRoomModel chatRoomModel) async {
    var result = await ChatFirestoreProvider.getChatsData(
      chatRoomType: chatRoomModel.type,
      chatRoomId: chatRoomModel.id,
    );
    if (result["success"]) {
      for (var i = 0; i < result["data"].length; i++) {
        ChatFirestoreProvider.deleteChat(
          chatRoomType: chatRoomModel.type,
          chatRoomId: chatRoomModel.id,
          id: result["data"][i]["id"],
        );
      }
    }

    ChatRoomModel newChatRoomModel = ChatRoomModel.copy(chatRoomModel);
    newChatRoomModel.lastMessage = "";
    newChatRoomModel.lastAdditionalData = {};
    newChatRoomModel.lastMessageType = 0;
    newChatRoomModel.lastSenderId = "";
    newChatRoomModel.newMessageCount = 0;
    _chatProvider!.updateChatRoom(chatRoomModel: newChatRoomModel, changeUpdateAt: false);
  }

  void _deleteChatRoomHandler(ChatRoomModel chatRoomModel) async {
    var result = await ChatRoomFirestoreProvider.deleteChatRoom(
      chatRoomType: chatRoomModel.type,
      id: chatRoomModel.id,
    );
  }
}
