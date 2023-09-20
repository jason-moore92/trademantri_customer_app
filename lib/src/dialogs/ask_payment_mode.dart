import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:trapp/config/config.dart';

class AskPaymentMode {
  static show({
    @required BuildContext? context,
  }) async {
    return showModalBottomSheet(
      context: context!,
      isScrollControlled: false,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 20),
              Text(
                "Choose a payment method",
                style: TextStyle(fontSize: 18, color: Colors.black),
              ),
              SizedBox(height: 20),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: AppConfig.paymentMethods
                    .map(
                      (e) => ListTile(
                        onTap: () {
                          if (e["value"] == "icici_upi") {
                            Fluttertoast.showToast(
                              msg: "Coming soon",
                            );
                            return;
                          }
                          Navigator.of(context).pop(e["value"]);
                        },
                        leading: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Image.asset(
                            "img/payment_methods/${e['image']}.png",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                        title: Text(
                          e["name"],
                        ),
                      ),
                    )
                    .toList(),
              )
            ],
          ),
        );
      },
    );
  }
}
