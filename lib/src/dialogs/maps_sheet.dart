import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';

class MapsSheet {
  static show({
    @required BuildContext? context,
    @required Function(AvailableMap map)? onMapTap,
  }) async {
    final availableMaps = await MapLauncher.installedMaps;

    showModalBottomSheet(
      context: context!,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                "Choose An App to Navigate",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              Expanded(
                child: availableMaps.isEmpty
                    ? Center(
                        child: Text(
                          "No Navigation Apps",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Container(
                          child: Wrap(
                            children: <Widget>[
                              for (var map in availableMaps)
                                ListTile(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                    onMapTap!(map);
                                  },
                                  title: Text(map.mapName),
                                  leading: SvgPicture.asset(
                                    map.icon,
                                    height: 30.0,
                                    width: 30.0,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
