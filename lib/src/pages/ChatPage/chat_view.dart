import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:trapp/config/app_config.dart' as config;
import 'package:trapp/config/config.dart';
import 'package:trapp/environment.dart';
import 'package:trapp/src/ApiDataProviders/index.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/chat_message_widget.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/date_time_convert.dart';
import 'package:trapp/src/helpers/string_helper.dart';
import 'package:trapp/src/models/chat_room_model.dart';
import 'package:trapp/src/services/keicy_fcm_for_mobile.dart';
import 'package:trapp/src/services/keicy_storage_for_mobile.dart';

import '../../models/chat_model.dart';
import '../../providers/ChatProvider/index.dart';
import '../../providers/index.dart';

class ChatView extends StatefulWidget {
  final String? chatRoomType;
  final ChatRoomModel? chatRoomModel;

  ChatView({Key? key, this.chatRoomType, this.chatRoomModel}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
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

  ChatProvider? _chatProvider;
  RefreshProvider? _refreshProvider;

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<ChatModel> _chatModelList = [];

  ChatRoomModel? _chatRoomModel;
  String? userImageUrl;
  String? _userName;
  bool? _userLiveIn;
  Widget? storeWidget;
  String? myUserId;
  Map<String, dynamic>? _userData;
  String? _userType;

  bool isEnd = false;
  String? date;

  List<File>? _imageFileList = [];

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

    _chatProvider = ChatProvider.of(context);
    _refreshProvider = RefreshProvider.of(context);
    _chatModelList = [];
    isEnd = false;

    myUserId = AuthProvider.of(context).authState.userModel!.id;

    if (myUserId != widget.chatRoomModel!.firstUserData!["_id"]) {
      _userData = widget.chatRoomModel!.firstUserData;
    } else {
      _userData = widget.chatRoomModel!.secondUserData;
    }

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _initHandler();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initHandler() {
    _liveInHandler();
  }

  void _liveInHandler() {
    ChatRoomModel chatRoomModel = ChatRoomModel.copy(widget.chatRoomModel!);
    if (chatRoomModel.lastSenderId != myUserId && chatRoomModel.newMessageCount != 0) {
      chatRoomModel.newMessageCount = 0;
    }
    if (myUserId == widget.chatRoomModel!.firstUserData!["_id"]) {
      chatRoomModel.firstUserLiveIn = true;
    } else {
      chatRoomModel.secondUserLiveIn = true;
    }

    _chatProvider!.updateChatRoom(chatRoomModel: chatRoomModel, changeUpdateAt: false);
  }

  void _notLiveInHandler() {
    ChatRoomModel chatRoomModel = ChatRoomModel.copy(_chatRoomModel!);

    if (myUserId == widget.chatRoomModel!.firstUserData!["_id"]) {
      chatRoomModel.firstUserLiveIn = false;
    } else {
      chatRoomModel.secondUserLiveIn = false;
    }

    _chatProvider!.updateChatRoom(chatRoomModel: chatRoomModel, changeUpdateAt: false);
  }

  void _sendMessageHandler({
    @required int? messageType,
    @required String? message,
    @required dynamic additionalData,
  }) async {
    if (_chatRoomModel!.isBlocked!) return;

    date = null;
    ChatModel chatModel = ChatModel();
    chatModel.senderId = myUserId;
    chatModel.messageType = messageType ?? MessageType.text;
    chatModel.message = message;
    chatModel.additionalData = additionalData;
    _controller.clear();
    _refreshProvider!.refresh();
    if (_chatModelList.isEmpty) {
      chatModel.isFirst = true;
    }
    var result = await _chatProvider!.addChatData(
      chatRoomType: _chatRoomModel!.type,
      chatRoomId: _chatRoomModel!.id,
      chatModel: chatModel,
    );
    if (result["success"]) {
      _updateChatRoom(chatModel, result);
    }
  }

  void _updateChatRoom(ChatModel chatModel, Map<String, dynamic> result) {
    ChatRoomModel chatRoomModel = ChatRoomModel.copy(_chatRoomModel!);
    if (myUserId != chatRoomModel.firstUserData!["_id"]) {
      if (chatRoomModel.firstUserLiveIn!) {
        chatRoomModel.newMessageCount = 0;
      } else {
        if (chatRoomModel.lastSenderId == myUserId) {
          chatRoomModel.newMessageCount = chatRoomModel.newMessageCount! + 1;
        } else {
          chatRoomModel.newMessageCount = 1;
        }
      }
    } else {
      if (chatRoomModel.secondUserLiveIn!) {
        chatRoomModel.newMessageCount = 0;
      } else {
        if (chatRoomModel.lastSenderId == myUserId) {
          chatRoomModel.newMessageCount = chatRoomModel.newMessageCount! + 1;
        } else {
          chatRoomModel.newMessageCount = 1;
        }
      }
    }

    chatRoomModel.lastMessage = chatModel.message;
    chatRoomModel.lastMessageType = chatModel.messageType;
    chatRoomModel.lastSenderId = chatModel.senderId;
    chatRoomModel.lastMessageDate = result["data"]["createAt"] != null ? result["data"]["createAt"].toDate() : null;
    chatRoomModel.lastAdditionalData = chatModel.additionalData;

    _chatProvider!.updateChatRoom(chatRoomModel: chatRoomModel, changeUpdateAt: true);

    /// notification
    List<dynamic> tokens = _userData!["tokens"];

    List<String> fcmTokenList = [];
    for (var i = 0; i < tokens.length; i++) {
      fcmTokenList.add(tokens[tokens.length - 1 - i]);
    }

    if (fcmTokenList.isNotEmpty) {
      KeicyFCMForMobile.sendMessage(
        "A new message from ${AuthProvider.of(context).authState.userModel!.firstName} ${AuthProvider.of(context).authState.userModel!.lastName}",
        "A New Message in Chats",
        fcmTokenList,
        data: {
          "type": "new_chat",
          "chatRoomModelId": chatRoomModel.id,
          "chatRoomType": chatRoomModel.type,
          "userId": _userData!["_id"],
        },
      );
    }
  }

  void _sendFileMessageHandler({
    @required int? messageType,
    @required File? file,
    @required dynamic additionalData,
  }) async {
    if (_chatRoomModel!.isBlocked!) return;

    date = null;
    if (messageType == MessageType.image) {
      var decodedImage = await decodeImageFromList(file!.readAsBytesSync());
      additionalData["rate"] = decodedImage.width / decodedImage.height;
    }
    ChatModel chatModel = ChatModel();
    chatModel.senderId = myUserId;
    chatModel.messageType = messageType ?? MessageType.text;
    chatModel.message = "uploading";
    chatModel.additionalData = additionalData;
    _controller.clear();
    if (_chatModelList.isEmpty) {
      chatModel.isFirst = true;
    }
    var result = await _chatProvider!.addChatData(
      chatRoomType: _chatRoomModel!.type,
      chatRoomId: _chatRoomModel!.id,
      chatModel: chatModel,
    );
    if (!result["success"]) return;

    setState(() {});

    chatModel = ChatModel.fromJson(result["data"]);

    /// file uploading
    chatModel.additionalData["uploadStatus"] = "uploading";
    chatModel.additionalData["fileName"] = file!.path.split('/').last;

    String subDir = messageType == MessageType.image
        ? "images/"
        : messageType == MessageType.file
            ? "files/"
            : "";

    String chatRoomName = widget.chatRoomType == ChatRoomTypes.b2c
        ? "B_C_ChatRooms"
        : widget.chatRoomType == ChatRoomTypes.b2b
            ? "B_B_ChatRooms"
            : widget.chatRoomType == ChatRoomTypes.d2c
                ? "D_C_ChatRooms"
                : "";
    String? path = await KeicyStorageForMobile.instance.uploadFileObject(
      path: "$chatRoomName-${_chatRoomModel!.id}/$subDir",
      fileName: file.path.split('/').last,
      file: file,
    );
    if (path != null) {
      chatModel.additionalData["uploadStatus"] = "uploaded";
      chatModel.additionalData["fileName"] = file.path.split('/').last;
      chatModel.message = path;
      var result = await ChatProvider.of(context).updateChatData(
        chatRoomType: _chatRoomModel!.type,
        chatRoomId: _chatRoomModel!.id,
        chatModel: chatModel,
      );
      _imageFileList!.clear();
      if (result["success"]) {
        _updateChatRoom(chatModel, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
        stream: ChatRoomFirestoreProvider.getChatRoomStream(
          chatRoomType: widget.chatRoomType,
          wheres: [
            {
              "key": "id",
              "val": widget.chatRoomModel!.id,
            },
          ],
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.isEmpty) {
            return Scaffold(body: Center(child: CupertinoActivityIndicator()));
          }

          _chatRoomModel = ChatRoomModel.fromJson(snapshot.data![0]);

          if (myUserId != _chatRoomModel!.firstUserData!["_id"]) {
            _userData = _chatRoomModel!.firstUserData;
            _userType = _chatRoomModel!.firstUserType;
            _userLiveIn = _chatRoomModel!.firstUserLiveIn;
            _userName = _chatRoomModel!.firstUserName;
          } else {
            _userData = widget.chatRoomModel!.secondUserData;
            _userType = _chatRoomModel!.secondUserType;
            _userLiveIn = _chatRoomModel!.secondUserLiveIn;
            _userName = _chatRoomModel!.secondUserName;
          }

          if (_userType == ChatUserTypes.customer) {
            userImageUrl = _userData!["imageUrl"];
          } else if (_userType == ChatUserTypes.business) {
            userImageUrl = _userData!["profile"]["image"];
            storeWidget = ClipRRect(
              borderRadius: BorderRadius.circular(widthDp * 60),
              child: Image.asset(
                "img/store-icon/${_userData!["subType"].toString().toLowerCase()}-store.png",
                width: widthDp * 60,
                height: widthDp * 60,
                fit: BoxFit.fill,
              ),
            );
          } else if (_userType == ChatUserTypes.delivery) {
            userImageUrl = _userData!["imageUrl"];
          }

          return WillPopScope(
            onWillPop: () async {
              _notLiveInHandler();
              return true;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back_ios, size: heightDp * 20, color: Colors.black),
                  onPressed: () {
                    _notLiveInHandler();
                    FocusScope.of(context).requestFocus(FocusNode());
                    Navigator.of(context).pop();
                  },
                ),
                elevation: 1,
                centerTitle: true,
                title: Row(
                  children: [
                    Stack(
                      children: [
                        KeicyAvatarImage(
                          url: userImageUrl,
                          width: widthDp * 40,
                          height: widthDp * 40,
                          backColor: Colors.grey.withOpacity(0.4),
                          borderRadius: widthDp * 40,
                          userName: StringHelper.getUpperCaseString(_userName!),
                          textStyle: TextStyle(fontSize: fontSp * 14, fontWeight: FontWeight.bold),
                          errorWidget: storeWidget,
                        ),
                        Positioned(
                          top: heightDp * 1,
                          right: heightDp * 1,
                          child: Container(
                            width: heightDp * 10,
                            height: heightDp * 10,
                            padding: EdgeInsets.all(heightDp * 5),
                            decoration: BoxDecoration(
                              color: _userLiveIn! ? Colors.green : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: widthDp * 15),
                    Expanded(
                      child: Text(
                        StringHelper.getUpperCaseString(_userName!),
                        style: TextStyle(fontSize: fontSp * 16, color: Colors.black, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              body: Column(
                children: [
                  Expanded(child: _messagePanel()),
                  _senderMessageWidget(),
                ],
              ),
            ),
          );
        });
  }

  Widget _messagePanel() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: ChatFirestoreProvider.getChatsStream(
        chatRoomType: _chatRoomModel!.type,
        chatRoomId: _chatRoomModel!.id,
        orderby: [
          {"key": "createAt", "desc": true}
        ],
        limit: _chatModelList.length + AppConfig.countLimitForList,
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CupertinoActivityIndicator());
        _chatModelList = [];

        for (var i = 0; i < snapshot.data!.length; i++) {
          _chatModelList.add(ChatModel.fromJson(snapshot.data![i]));
          if (snapshot.data![i]["isFirst"]) {
            isEnd = true;
          }
        }

        _refreshController.loadComplete();
        date = null;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: widthDp * 15),
          child: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (notification) {
              notification.disallowGlow();
              return true;
            },
            child: SmartRefresher(
              enablePullDown: false,
              enablePullUp: !isEnd,
              header: WaterDropHeader(),
              footer: ClassicFooter(),
              controller: _refreshController,
              onLoading: _onLoading,
              child: ListView.separated(
                reverse: true,
                itemCount: _chatModelList.length,
                itemBuilder: (context, index) {
                  ChatModel chatModel = _chatModelList[index];

                  Widget? dateWidget;
                  Widget? firstDateWidget;

                  if (chatModel.createAt != null && index == _chatModelList.length - 1) {
                    firstDateWidget = Text(
                      KeicyDateTime.convertDateTimeToDateString(
                        dateTime: chatModel.createAt,
                        isUTC: false,
                      ),
                      style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                    );
                    // dateWidget = Text(
                    //   KeicyDateTime.convertDateTimeToDateString(dateTime: chatModel.createAt),
                    //   style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                    // );
                  }

                  if (date != null &&
                      chatModel.createAt != null &&
                      date !=
                          KeicyDateTime.convertDateTimeToDateString(
                            dateTime: chatModel.createAt,
                            isUTC: false,
                          )) {
                    dateWidget = Text(
                      date!,
                      style: TextStyle(fontSize: fontSp * 12, color: Colors.black),
                    );
                    date = KeicyDateTime.convertDateTimeToDateString(
                      dateTime: chatModel.createAt,
                      isUTC: false,
                    );
                  }
                  if (chatModel.createAt != null) {
                    date = KeicyDateTime.convertDateTimeToDateString(
                      dateTime: chatModel.createAt,
                      isUTC: false,
                    );
                  }

                  return Column(
                    children: [
                      if (firstDateWidget != null)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 20),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                          decoration: BoxDecoration(
                            color: config.Colors().mainColor(0.3),
                            borderRadius: BorderRadius.circular(heightDp * 10),
                          ),
                          child: firstDateWidget,
                        ),
                      ChatMessageWidget(
                        chatRoomModel: _chatRoomModel,
                        chatModel: chatModel,
                        myUserId: myUserId,
                        isLoading: index == 0 && _chatProvider!.chatState.progressState == 1,
                        imageFileList: _imageFileList,
                        file: _imageFileList!.isNotEmpty && index == 0 && chatModel.messageType == MessageType.image ? _imageFileList!.first : null,
                      ),
                      if (index != 0 && dateWidget != null)
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 20),
                          padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
                          decoration: BoxDecoration(
                            color: config.Colors().mainColor(0.3),
                            borderRadius: BorderRadius.circular(heightDp * 10),
                          ),
                          child: dateWidget,
                        ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return SizedBox(height: heightDp * 3);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _onLoading() async {
    setState(() {});
  }

  Widget _senderMessageWidget() {
    return Consumer<RefreshProvider>(builder: (context, refreshProvider, _) {
      return Container(
        width: deviceWidth,
        padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 5),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(0, 0), blurRadius: 1, color: Colors.grey.withOpacity(0.4))],
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            GestureDetector(
              onTap: _additionalComponentsHandler,
              child: Container(
                padding: EdgeInsets.only(right: widthDp * 5),
                color: Colors.transparent,
                child: Icon(
                  Icons.add_box_outlined,
                  size: heightDp * 30,
                  color: _chatRoomModel!.isBlocked! ? Colors.grey : config.Colors().mainColor(1),
                ),
              ),
            ),
            SizedBox(width: widthDp * 10),
            Expanded(
              child: _chatRoomModel!.isBlocked!
                  ? Container(
                      padding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(heightDp * 8),
                        color: Color(0xFFE6E6E6).withOpacity(0.6),
                      ),
                      child: Center(
                        child: Text(
                          "This chat is blocked",
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.red),
                        ),
                      ),
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(heightDp * 8),
                      child: Container(
                        constraints: BoxConstraints(maxHeight: heightDp * 80, minHeight: heightDp * 35),
                        child: TextFormField(
                          controller: _controller,
                          focusNode: _focusNode,
                          style: TextStyle(fontSize: fontSp * 16, color: Colors.black),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            filled: true,
                            fillColor: Color(0xFFE6E6E6).withOpacity(0.6),
                            hintStyle: TextStyle(fontSize: fontSp * 16, color: Colors.grey.withOpacity(0.8)),
                            hintText: "Please enter a message",
                            contentPadding: EdgeInsets.symmetric(horizontal: widthDp * 10, vertical: heightDp * 10),
                          ),
                          maxLines: null,
                          readOnly: _chatRoomModel!.isBlocked!,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          onChanged: (input) {
                            refreshProvider.refresh();
                          },
                        ),
                      ),
                    ),
            ),
            GestureDetector(
              onTap: _chatRoomModel!.isBlocked! || _controller.text.isEmpty || _chatProvider!.chatState.progressState == 1
                  ? null
                  : () {
                      _sendMessageHandler(
                        messageType: MessageType.text,
                        message: _controller.text,
                        additionalData: {
                          "messageType": MessageType.text,
                        },
                      );
                    },
              child: Container(
                padding: EdgeInsets.only(left: widthDp * 5),
                child: Icon(
                  Icons.send_sharp,
                  size: heightDp * 30,
                  color: _chatRoomModel!.isBlocked! || _controller.text.isEmpty || _chatProvider!.chatState.progressState == 1
                      ? Colors.grey
                      : config.Colors().mainColor(1),
                ),
              ),
            ),
            SizedBox(width: widthDp * 10),
            GestureDetector(
              onTap: () {
                if (_chatRoomModel!.isBlocked!) return;
                ImageFilePickDialog.show(
                  context,
                  callback: (File file) {
                    setState(() {
                      _imageFileList!.add(file);
                      _sendFileMessageHandler(
                        messageType: MessageType.image,
                        file: file,
                        additionalData: {
                          "messageType": MessageType.image,
                          "uploadStatus": "ready",
                          "imageIndex": 0,
                        },
                      );
                    });
                  },
                );
              },
              child: Icon(
                Icons.camera_alt_outlined,
                color: _chatRoomModel!.isBlocked! ? Colors.grey : config.Colors().mainColor(1),
                size: heightDp * 30,
              ),
            ),
          ],
        ),
      );
    });
  }

  void _additionalComponentsHandler() async {
    if (_chatRoomModel!.isBlocked!) return;
    FocusScope.of(context).requestFocus(FocusNode());

    String? result = await AdditionalChatComponentsDialog.show(context);
    switch (result) {
      case "photo":
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          // allowedExtensions: ['jpg', 'pdf', 'doc'],
        );

        if (result != null) {
          _imageFileList!.add(File(result.files.single.path!));
          _sendFileMessageHandler(
            messageType: MessageType.image,
            file: File(result.files.single.path!),
            additionalData: {
              "messageType": MessageType.image,
              "uploadStatus": "ready",
              "imageIndex": 0,
            },
          );
        }
        break;
      case "file":
        FilePickerResult? result = await FilePicker.platform.pickFiles(
          type: FileType.any,
          // allowedExtensions: ['jpg', 'pdf', 'doc'],
        );
        if (result != null) {
          _imageFileList!.add(File(result.files.single.path!));
          String fileType = result.files.single.path!.split('.').last;
          _sendFileMessageHandler(
            messageType: "jpg,png,jpeg".contains(fileType) ? MessageType.image : MessageType.file,
            file: File(result.files.single.path!),
            additionalData: {
              "messageType": "jpg,png,jpeg".contains(fileType) ? MessageType.image : MessageType.file,
              "uploadStatus": "ready",
              "imageIndex": 0,
            },
          );
        }
        break;
      default:
    }
  }
}
