import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_logs/flutter_logs.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:freshchat_sdk/freshchat_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/elements/DrawerFooter.dart';
import 'package:trapp/src/elements/keicy_avatar_image.dart';
import 'package:trapp/src/helpers/encrypt.dart';
import 'package:trapp/src/pages/AboutUsPage/index.dart';
import 'package:trapp/src/pages/AnnouncementListForALLPage/index.dart';
import 'package:trapp/src/pages/BargainRequestListPage/index.dart';
import 'package:trapp/src/pages/BookAppointmentListPage/index.dart';
import 'package:trapp/src/pages/InvoiceListPage/index.dart';
import 'package:trapp/src/pages/MyJobListPage/index.dart';
import 'package:trapp/src/pages/OrderDetailNewPage/index.dart';
import 'package:trapp/src/pages/PaymentLinkListPage/index.dart';
import 'package:trapp/src/pages/ReverseAuctionListPage/index.dart';
import 'package:trapp/src/pages/HelpSupportPage/index.dart';
import 'package:trapp/src/pages/OrderListPage/index.dart';
import 'package:trapp/src/pages/RewardPointsPage/index.dart';
import 'package:trapp/src/pages/ChatListPage/chat_list_page.dart';
import 'package:trapp/src/pages/ScratchCardListPage/index.dart';
import 'package:trapp/src/pages/StoreJobPostingsListPage/index.dart';
import 'package:trapp/src/pages/StorePage/index.dart';
import 'package:trapp/src/pages/dashboard.dart';
import 'package:trapp/src/pages/home.dart';
import 'package:trapp/src/pages/login.dart';
import 'package:trapp/src/providers/index.dart';
import 'package:trapp/src/pages/ContactUsPage/index.dart';
import 'package:trapp/src/pages/LegalResourcesPage/index.dart';
import 'package:trapp/src/pages/ReferEarnPage/index.dart';
import 'package:trapp/config/app_config.dart' as config;

import 'keicy_progress_dialog.dart';

class DrawerWidget extends StatefulWidget {
  @override
  _DrawerWidgetState createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  KeicyProgressDialog? keicyProgressDialog;

  double widthDp = ScreenUtil().setWidth(1);

  double heightDp = ScreenUtil().setWidth(1);

  double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

  List<dynamic> menuList = [];

  Widget _menuItem(BuildContext context, Map<String, dynamic> menu) {
    if ((AuthProvider.of(context).authState.userModel!.id == null) && menu["title"] == "Log out") return SizedBox();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            if (menu["haveChild"] != null && menu["haveChild"] && menu["subMenus"] != null) {
              menu["isOpened"] = !menu["isOpened"];
              setState(() {});
            } else {
              if (menu["tapHandler"] != null) menu["tapHandler"]();
            }
          },
          child: Container(
            height: heightDp * 50,
            padding: EdgeInsets.symmetric(horizontal: widthDp * 15, vertical: heightDp * 10),
            decoration: BoxDecoration(color: Colors.transparent, border: Border.all(color: Colors.transparent)),
            alignment: Alignment.center,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: heightDp * 50,
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        SizedBox(width: widthDp * 10),
                        Row(
                          children: [
                            menu["iconWidget"] ?? SizedBox(),
                            SizedBox(width: widthDp * 20),
                          ],
                        ),
                        Expanded(
                          child: Text(
                            menu["title"],
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                        ),
                        menu["tailerWidget"] ?? SizedBox(),
                      ],
                    ),
                  ),
                ),
                if (menu["haveChild"] != null && menu["haveChild"] && menu["subMenus"] != null)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: widthDp * 5, vertical: heightDp * 5),
                    color: Colors.transparent,
                    child: Transform.rotate(
                      angle: menu["isOpened"] ? -pi / 2 : pi / 2,
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: heightDp * 20,
                        // color: Theme.of(context).iconTheme.color,
                        color: Colors.black,
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
        if (menu["haveChild"] != null && menu["haveChild"] && menu["subMenus"] != null && menu["isOpened"] != null && menu["isOpened"])
          Column(
            children: List.generate(menu["subMenus"].length, (index) {
              return Row(
                children: [
                  SizedBox(width: widthDp * 20),
                  Expanded(child: _menuItem(context, menu["subMenus"][index])),
                ],
              );
            }),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    keicyProgressDialog = KeicyProgressDialog.of(context);
    if (menuList.isEmpty) {
      menuList = [
        {
          "title": "Home",
          "iconWidget": Icon(
            Icons.home,
            color: Theme.of(context).focusColor.withOpacity(1),
            // color: Theme.of(context).iconTheme.color,
          ),
          "haveChild": true,
          "isOpened": false,
          "tapHandler": () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/Pages',
              ModalRoute.withName('/'),
              arguments: {"currentTab": 2},
            );
          },
        },
        {
          "title": "Personal",
          "iconWidget": Icon(
            Icons.person,
            color: Theme.of(context).focusColor.withOpacity(1),
            // color: Theme.of(context).iconTheme.color,
          ),
          "haveChild": true,
          "isOpened": false,
          "subMenus": [
            {
              "title": "Dashboard",
              "iconWidget": Icon(
                Icons.dashboard,
                color: Theme.of(context).focusColor.withOpacity(1),
                // color: Theme.of(context).iconTheme.color,
              ),
              "haveChild": false,
              "isOpened": false,
              "tapHandler": () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => DashboardPage(),
                    ),
                  );
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => DashboardPage(),
                      ),
                    );
                  });
                }
              },
            },
            {
              "title": "My Appointments",
              "iconWidget": Icon(
                Icons.event,
                color: Theme.of(context).focusColor.withOpacity(1),
              ),
              "haveChild": true,
              "isOpened": false,
              "tapHandler": () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => BookAppointmentListPage(),
                    ),
                  );
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => BookAppointmentListPage(),
                      ),
                    );
                  });
                }
              },
            },
            {
              "title": "Favorite",
              "iconWidget": Icon(
                Icons.favorite,
                color: Theme.of(context).focusColor.withOpacity(1),
                // color: Theme.of(context).iconTheme.color,
              ),
              "haveChild": false,
              "isOpened": false,
              "tapHandler": () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 4});
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 4});
                  });
                }
              },
            },
            {
              "title": "My Chats",
              "iconWidget": Icon(
                Icons.chat,
                color: Theme.of(context).focusColor.withOpacity(1),
                // color: Theme.of(context).iconTheme.color,
              ),
              "haveChild": false,
              "isOpened": false,
              "tapHandler": () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => ChatListPage()),
                  );
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => ChatListPage()),
                    );
                  });
                }
              },
            },
            {
              "title": "QR Code",
              "iconWidget": Image.asset(
                "img/qrcode_scan.png",
                width: 25,
                height: 25,
                color: Theme.of(context).focusColor.withOpacity(1),
                // color: Theme.of(context).iconTheme.color,
              ),
              "haveChild": false,
              "isOpened": false,
              "tapHandler": () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  qrcodeHandler(context);
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    qrcodeHandler(context);
                  });
                }
              },
            },
            {
              "title": "My Jobs",
              "iconWidget": Image.asset(
                "img/jobs.png",
                width: 25,
                height: 25,
                // color: Theme.of(context).iconTheme.color,
                color: Theme.of(context).focusColor.withOpacity(1),
              ),
              "haveChild": false,
              "isOpened": false,
              "tapHandler": () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MyJobListPage()));
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => MyJobListPage()));
                  });
                }
              },
            },
            {
              "title": "My Scratch Cards",
              "iconWidget": Image.asset(
                "img/reward_points_icon.png",
                width: 25,
                height: 25,
                // color: Theme.of(context).iconTheme.color,
                color: Theme.of(context).focusColor.withOpacity(1),
              ),
              "haveChild": false,
              "isOpened": false,
              "tapHandler": () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ScratchCardListPage()));
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ScratchCardListPage()));
                  });
                }
              },
            },
            {
              "title": "My Invoices",
              "iconWidget": Image.asset(
                "img/payment.png",
                width: 25,
                height: 25,
                // color: Theme.of(context).iconTheme.color,
                color: Theme.of(context).focusColor.withOpacity(1),
              ),
              "haveChild": false,
              "isOpened": false,
              "tapHandler": () {
                if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
                  Navigator.of(context).pop();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) => InvoiceListPage()),
                  );
                } else {
                  LoginAskDialog.show(context, callback: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) => InvoiceListPage()),
                    );
                  });
                }
              },
            }
          ],
        },
        {
          "title": "My Orders",
          "iconWidget": Icon(
            Icons.fastfood,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
              );
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => OrderListPage(haveAppBar: true)),
                );
              });
            }
          },
        },
        {
          "title": "Notifications",
          "iconWidget": Icon(
            Icons.notifications,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": true,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed("/Notifications");
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed("/Notifications");
              });
            }
          },
        },
        // {
        //   "title": "Payment Links",
        //   "iconWidget": Image.asset(
        //     "img/payment.png",
        //     width: 25,
        //     height: 25,
        //     color: Theme.of(context).iconTheme.color,
        //   ),
        //   "haveChild": true,
        //   "isOpened": false,
        //   "tapHandler": () {
        //     if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
        //       Navigator.of(context).pop();
        //       Navigator.of(context).push(
        //         MaterialPageRoute(builder: (BuildContext context) => PaymentLinkListPage()),
        //       );
        //     } else {
        //       LoginAskDialog.show(context, callback: () {
        //         Navigator.of(context).pop();
        //         Navigator.of(context).push(
        //           MaterialPageRoute(builder: (BuildContext context) => PaymentLinkListPage()),
        //         );
        //       });
        //     }
        //   },
        // },
        {
          "title": "Bargain Request",
          "iconWidget": Image.asset(
            "img/bargain-icon.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": true,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (BuildContext context) => BargainRequestListPage(
                    haveAppBar: true,
                  ),
                ),
              );
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => BargainRequestListPage(
                      haveAppBar: true,
                    ),
                  ),
                );
              });
            }
          },
        },
        {
          "title": "Reverse Auction",
          "iconWidget": Image.asset(
            "img/reverse_auction-icon.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": true,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => ReverseAuctionListPage(haveAppBar: true)),
              );
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => ReverseAuctionListPage(haveAppBar: true)),
                );
              });
            }
          },
        },
        {
          "title": "Announcements",
          "iconWidget": Image.asset(
            "img/announcements_grey.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": true,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(builder: (BuildContext context) => AnnouncementListForALLPage()),
              );
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (BuildContext context) => AnnouncementListForALLPage()),
                );
              });
            }
          },
        },
        {
          "title": "Reward Points",
          "iconWidget": Image.asset(
            "img/reward_points_icon.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RewardPointsPage()));
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => RewardPointsPage()));
              });
            }
          },
        },
        {
          "title": "Find Jobs",
          "iconWidget": Image.asset(
            "img/jobs.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": true,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StoreJobPostingsListPage()));
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => StoreJobPostingsListPage()));
              });
            }
          },
        },
        {
          "title": "Refer & Earn",
          "iconWidget": Image.asset(
            "img/reward_points_icon.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ReferEarnPage()));
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => ReferEarnPage()));
              });
            }
          },
        },
        {
          "title": "Profile",
          "iconWidget": Icon(
            Icons.settings,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('/Profile');
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed('/Profile');
              });
            }
          },
        },
        {
          "title": "Help",
          "iconWidget": Icon(
            Icons.help,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => HelpSupportPage()),
            );
          },
        },
        // {
        //   "title": "Community",
        //   "iconWidget": Icon(
        //     Icons.people,
        //     color: Theme.of(context).iconTheme.color,
        //   ),
        //   "haveChild": false,
        //   "isOpened": false,
        //   "tapHandler": () {
        //     if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
        //       Navigator.of(context).pop();
        //       _launchCommunity(context);
        //     } else {
        //       LoginAskDialog.show(context, callback: () {
        //         Navigator.of(context).pop();
        //         _launchCommunity(context);
        //       });
        //     }
        //   },
        // },
        {
          "title": "Customer Support",
          "iconWidget": Icon(
            Icons.chat_bubble,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "tailerWidget": SizedBox(
            width: 32,
            child: StreamBuilder<dynamic>(
              stream: Freshchat.onMessageCountUpdate,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.red[500]!,
                      ),
                      color: Colors.red[500],
                      borderRadius: BorderRadius.all(
                        Radius.circular(32),
                      ),
                    ),
                    child: FutureBuilder<Map<dynamic, dynamic>>(
                      future: Freshchat.getUnreadCountAsync,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text(
                            snapshot.data!["count"].toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          );
                        }
                        return Text(
                          "",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
              Navigator.of(context).pop();
              Freshchat.showConversations();
            } else {
              LoginAskDialog.show(context, callback: () {
                Navigator.of(context).pop();
                Freshchat.showConversations();
              });
            }
          },
        },
        {
          "title": "Languages",
          "iconWidget": Icon(
            Icons.translate,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('/Languages');
          },
        },
        {
          "title": "Legal Resources",
          "iconWidget": Image.asset(
            "img/lega.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            Navigator.of(context).pop();
            Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) => LegalResourcesPage()));
          },
        },
        {
          "title": "About us",
          "iconWidget": Image.asset(
            "img/aboutus.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => AboutUsPage()),
            );
          },
        },
        {
          "title": "Contact us",
          "iconWidget": Image.asset(
            "img/contactus.png",
            width: 25,
            height: 25,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
              MaterialPageRoute(builder: (BuildContext context) => ContactUsPage()),
            );
          },
        },
        {
          "title": "Log out",
          "iconWidget": Icon(
            Icons.logout,
            // color: Theme.of(context).iconTheme.color,
            color: Theme.of(context).focusColor.withOpacity(1),
          ),
          "haveChild": false,
          "isOpened": false,
          "tapHandler": () async {
            try {
              await keicyProgressDialog!.show();
              var result = await AuthProvider.of(context).logout(
                fcmToken: AuthProvider.of(context).authState.userModel!.fcmToken,
              );
              await keicyProgressDialog!.hide();

              if (result) {
                AppDataProvider.of(context).initProviderHandler(context);

                ///
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (BuildContext context) => LoginWidget()),
                  (route) => false,
                );
              }
            } catch (e) {
              FlutterLogs.logThis(
                tag: "DrawerWidget",
                level: LogLevel.ERROR,
                subTag: "tapHandler:LogOut",
                exception: e is Exception ? e : null,
                error: e is Error ? e : null,
                errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
              );
            }
          },
        },
      ];
    }

    return Drawer(
      child: ListView(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.of(context).pushNamed('/Pages', arguments: {"currentTab": 1});
            },
            child: UserAccountsDrawerHeader(
              margin: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: Theme.of(context).hintColor.withOpacity(0.1),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(35)),
              ),
              accountName: Text(
                AuthProvider.of(context).authState.userModel!.id == null
                    ? "Hi, Guest"
                    : AuthProvider.of(context).authState.userModel!.firstName! + " " + AuthProvider.of(context).authState.userModel!.lastName!,
                style: Theme.of(context).textTheme.caption!.copyWith(
                      fontSize: 20,
                      color: Colors.black,
                    ),
              ),
              accountEmail: AuthProvider.of(context).authState.userModel!.id == null
                  ? InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => LoginWidget(
                              callback: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  '/Pages',
                                  ModalRoute.withName('/'),
                                  arguments: {"currentTab": 2},
                                );
                              },
                            ),
                          ),
                        );
                      },
                      child: Text(
                        "login",
                        style: TextStyle(
                          color: config.Colors().mainColor(1),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    )
                  : Text(
                      AuthProvider.of(context).authState.userModel!.email ?? "",
                      style: Theme.of(context).textTheme.caption!.copyWith(
                            fontSize: 18,
                            color: Colors.black,
                          ),
                    ),
              currentAccountPicture: AuthProvider.of(context).authState.userModel!.id == null
                  ? Image.asset("img/logo_small.png", height: 150, fit: BoxFit.fitHeight)
                  : CircleAvatar(
                      child: ClipOval(
                        child: KeicyAvatarImage(
                          url: AuthProvider.of(context).authState.userModel!.imageUrl!,
                          userName: AuthProvider.of(context).authState.userModel!.firstName!,
                          width: 135,
                          height: 135,
                          backColor: Colors.grey.withOpacity(0.5),
                          textStyle: TextStyle(fontSize: 25, color: Colors.black),
                        ),
                      ),
                      radius: 50.0,
                      backgroundColor: Colors.transparent,
                    ),
              otherAccountsPictures: [
                if (AuthProvider.of(context).authState.userModel!.id != null)
                  IconButton(
                    onPressed: () async {
                      try {
                        await keicyProgressDialog!.show();
                        var result = await AuthProvider.of(context).logout(
                          fcmToken: AuthProvider.of(context).authState.userModel!.fcmToken,
                        );
                        await keicyProgressDialog!.hide();

                        if (result) {
                          AppDataProvider.of(context).initProviderHandler(context);

                          ///
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (BuildContext context) => LoginWidget()),
                            (route) => false,
                          );
                        }
                      } catch (e) {
                        FlutterLogs.logThis(
                          tag: "DrawerWidget",
                          level: LogLevel.ERROR,
                          subTag: "onPressed:otherAccountsPictures",
                          exception: e is Exception ? e : null,
                          error: e is Error ? e : null,
                          errorMessage: !(e is Exception || e is Error) ? e.toString() : "",
                        );
                      }
                    },
                    icon: Icon(
                      Icons.logout,
                    ),
                  )
              ],
            ),
          ),

          ///
          SizedBox(height: heightDp * 20),

          ///
          Column(
            children: List.generate(menuList.length, (int index) {
              Map<String, dynamic> menu = menuList[index];
              return _menuItem(context, menu);
            }),
          ),

          Divider(),
          DrawerFooterWidget(),
        ],
      ),
    );
  }

  void _launchCommunity(context) async {
    try {
      String? otherCreds = AppDataProvider.of(context).prefs!.getString("other_creds");
      if (otherCreds == null) {
        return;
      }
      Map<String, dynamic> otherCredsData = jsonDecode(otherCreds);

      if (!otherCredsData.containsKey('community')) {
        return;
      }
      await launch(
        otherCredsData['community']['login_url'],
        customTabsOption: CustomTabsOption(
          toolbarColor: config.Colors().mainColor(1),
          enableDefaultShare: true,
          enableUrlBarHiding: true,
          showPageTitle: true,
          extraCustomTabs: const <String>[
            'org.mozilla.firefox',
            'com.microsoft.emmx',
          ],
        ),
        safariVCOption: SafariViewControllerOption(
          preferredBarTintColor: Theme.of(context).primaryColor,
          preferredControlTintColor: Colors.white,
          barCollapsingEnabled: true,
          entersReaderIfAvailable: false,
          dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
        ),
      );
    } catch (e) {
      // An exception is thrown if browser app is not installed on Android device.
      debugPrint(e.toString());
    }
  }

  void qrcodeHandler(context) async {
    double widthDp = ScreenUtil().setWidth(1);
    double heightDp = ScreenUtil().setWidth(1);
    double fontSp = ScreenUtil().setSp(1) / ScreenUtil().textScaleFactor;

    var status = await Permission.camera.status;
    if (!status.isGranted) {
      var newStatus = await Permission.camera.request();
      if (!newStatus.isGranted) {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "Your camera permission isn't granted",
          isTryButton: false,
          callBack: () {
            Navigator.of(context).pop();
          },
        );
        return;
      }
    }
    NormalDialog.show(context, content: "Scan Store QR code to open the store directly, Scan Order QR-code to open the order details",
        callback: () async {
      var result = await FlutterBarcodeScanner.scanBarcode('#ff6666', 'Cancel', true, ScanMode.QR);
      if (result == "-1") return;
      String qrCodeString = Encrypt.decryptString(result);

      String type = qrCodeString.split("_").first;

      if (type == "Order") {
        String orderId = qrCodeString.split("_")[1];
        String storeId = qrCodeString.split("_")[2].split("-").last;
        String userId = qrCodeString.split("_")[3].split("-").last;
        if (userId == AuthProvider.of(context).authState.userModel!.id) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => OrderDetailNewPage(
                orderId: orderId,
                storeId: storeId,
                userId: userId,
              ),
            ),
          );
          return;
        } else {
          ErrorDialog.show(
            context,
            widthDp: widthDp,
            heightDp: heightDp,
            fontSp: fontSp,
            text: "This order does not belong to you, please try a different QR code",
            callBack: () {
              qrcodeHandler(context);
            },
            isTryButton: true,
          );
          return;
        }
      } else if (type == "Store") {
        String storeId = qrCodeString.split("_")[1];
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => StorePage(storeId: storeId),
          ),
        );
        return;
      } else {
        ErrorDialog.show(
          context,
          widthDp: widthDp,
          heightDp: heightDp,
          fontSp: fontSp,
          text: "This qr code is invalid. Please try again",
          callBack: () {
            qrcodeHandler(context);
          },
          isTryButton: true,
        );
      }
    });
  }
}
