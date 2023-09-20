import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trapp/src/dialogs/index.dart';
import 'package:trapp/src/providers/AuthProvider/auth_provider.dart';
import 'package:trapp/src/providers/index.dart';

import 'keicy_progress_dialog.dart';

class FavoriteIconWidget extends StatefulWidget {
  final double? size;
  final String? id;
  final String? storeId;
  final String? category;
  final Color? color;
  final Function? callback;

  FavoriteIconWidget({
    @required this.category,
    @required this.id,
    @required this.storeId,
    this.callback,
    this.color = Colors.red,
    this.size = 20,
  });

  @override
  _FavoriteIconWidgetState createState() => _FavoriteIconWidgetState();
}

class _FavoriteIconWidgetState extends State<FavoriteIconWidget> {
  AuthProvider? _authProvider;
  FavoriteProvider? _favoriteProvider;
  KeicyProgressDialog? _keicyProgressDialog;

  @override
  void initState() {
    super.initState();

    _authProvider = AuthProvider.of(context);
    _favoriteProvider = FavoriteProvider.of(context);
    _keicyProgressDialog = KeicyProgressDialog.of(context);

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _favoriteProvider!.addListener(_favoriteProviderListener);
    });
  }

  void _favoriteProviderListener() async {
    if (_favoriteProvider!.favoriteState.progressState != 1 && _keicyProgressDialog!.isShowing()) {
      await _keicyProgressDialog!.hide();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoriteProvider>(builder: (context, favoriteProvider, _) {
      bool isFavorite = false;
      if (favoriteProvider.favoriteState.favoriteData!.isNotEmpty &&
          favoriteProvider.favoriteState.favoriteData![widget.category] != null &&
          favoriteProvider.favoriteState.favoriteData![widget.category].isNotEmpty) {
        for (var i = 0; i < favoriteProvider.favoriteState.favoriteData![widget.category].length; i++) {
          if (favoriteProvider.favoriteState.favoriteData![widget.category][i]["userId"] == _authProvider!.authState.userModel!.id &&
              favoriteProvider.favoriteState.favoriteData![widget.category][i]["id"] == widget.id) {
            isFavorite = favoriteProvider.favoriteState.favoriteData![widget.category][i]["isFavorite"];
            break;
          }
        }
      }

      return GestureDetector(
        onTap: () async {
          if (AuthProvider.of(context).authState.loginState == LoginState.IsLogin) {
            _favoriteHandler(favoriteProvider, isFavorite);
          } else {
            LoginAskDialog.show(context, callback: () {});
          }
        },
        child: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
          size: widget.size,
          color: widget.color,
        ),
      );
    });
  }

  void _favoriteHandler(FavoriteProvider favoriteProvider, bool isFavorite) async {
    if (widget.callback != null) {
      widget.callback!();
    }

    if (favoriteProvider.favoriteState.progressState == 1) {
      _keicyProgressDialog = KeicyProgressDialog(context, message: "Favorite Data is loading...");
      _keicyProgressDialog!.show();
      return;
    }

    bool isFavorite = false;
    if (favoriteProvider.favoriteState.favoriteData!.isNotEmpty &&
        favoriteProvider.favoriteState.favoriteData![widget.category] != null &&
        favoriteProvider.favoriteState.favoriteData![widget.category].isNotEmpty) {
      for (var i = 0; i < favoriteProvider.favoriteState.favoriteData![widget.category].length; i++) {
        if (favoriteProvider.favoriteState.favoriteData![widget.category][i]["userId"] == _authProvider!.authState.userModel!.id &&
            favoriteProvider.favoriteState.favoriteData![widget.category][i]["id"] == widget.id) {
          isFavorite = favoriteProvider.favoriteState.favoriteData![widget.category][i]["isFavorite"];
          break;
        }
      }
    }

    favoriteProvider.setFavoriteState(favoriteProvider.favoriteState.update(progressState: 1), isNotifiable: false);

    favoriteProvider.setFavoriteData(
      userId: _authProvider!.authState.userModel!.id,
      id: widget.id,
      storeId: widget.storeId,
      category: widget.category,
      isFavorite: !isFavorite,
    );
  }
}
