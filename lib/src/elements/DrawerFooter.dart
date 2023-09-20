import 'package:flutter/material.dart';
import 'package:trapp/environment.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DrawerFooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        PackageInfo? info = snapshot.data;
        if (info == null) {
          return Container();
        }
        return ListTile(
          leading: Icon(Icons.info),
          title: Text(info.appName),
          subtitle: Row(
            children: [
              Text("${info.version} (${info.buildNumber})"),
              Expanded(child: Container()),
              if (Environment.envName != "production")
                Text(
                  Environment.envName!.toLowerCase(),
                ),
            ],
          ),
        );
      },
    );
  }
}
