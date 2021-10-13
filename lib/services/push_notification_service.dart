import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:active_ecommerce_flutter/services/route_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/screens/order_details.dart';
import 'package:active_ecommerce_flutter/screens/login.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/repositories/profile_repository.dart';
import 'package:one_context/one_context.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';


class PushNotificationService {
  final FirebaseMessaging _fcm = FirebaseMessaging();
  Future initialise() async {
    if (Platform.isIOS) {
      _fcm.requestNotificationPermissions(IosNotificationSettings());
    }
    _fcm.getToken().then((fcmToken) {
      if (fcmToken != null) {
        print("--fcm token--");
        print(fcmToken);
        if (is_logged_in.value == true) {
          ProfileRepository().getDeviceTokenUpdateResponse(fcmToken);
        }
      }
    });

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        OneContext().showDialog(
          // barrierDismissible: false,
            builder: (context) =>  AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('close'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                FlatButton(
                  child: Text('GO'),
                  onPressed: () {

                if (message['data']['item_type'] == 'today_deal') {
                  Navigator.of(context).pop();
                  OneContext().push(MaterialPageRoute(builder: (_) {
                    return TodaysDealProducts(from_notification: true,);
                  }));
                  return;
                }
                else if (message['data']['item_type'] == 'flash_sale') {
                  Navigator.of(context).pop();
                  OneContext().push(MaterialPageRoute(builder: (_) {
                    return FlashDealList(from_notification: true,);
                  }));
                  return;
                }

                if (is_logged_in.value == false) {
                  ToastComponent.showDialog("You are not logged in", context,
                      gravity: Toast.TOP, duration: Toast.LENGTH_LONG);
                  return;
                }
                    print(message);
                Navigator.of(context).pop();
                    if (message['data']['item_type'] == 'order') {

                      OneContext().push(MaterialPageRoute(builder: (_) {
                        return OrderDetails(
                            id: int.parse(message['data']['item_type_id']) ,
                            from_notification: true);
                      }));
                    }
                  } ,
                ),
              ],
            ),
        );

      },

      onLaunch: (Map<String, dynamic> message) async {
        print('ffffffffffffffffffff');
        print("onLaunch: $message");
        _serialiseAndNavigate(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('ggggggggggggggggggggg');
        print("onResume: $message");

        _serialiseAndNavigate(message);
      },
    );
  }

  void _serialiseAndNavigate(Map<String, dynamic> message) {
    print(message.toString());
    print('hridoy');
    if (message['data']['item_type'] == 'today_deal') {
      print("Navigating");
      OneContext().pushNamed(ShoppaholicsRoutes.ToadyDealScreenRoute,arguments: {"form_notification":true});
      // OneContext().push(MaterialPageRoute(builder: (_) {
      //   return TodaysDealProducts(from_notification: true,);
      // }));
      return;
    }
    else if (message['data']['item_type'] == 'flash_sale') {
      print("Navigating");
      OneContext().pushNamed(ShoppaholicsRoutes.FalshSaleScreenRoute,arguments: {"form_notification":true});
      // OneContext().push(MaterialPageRoute(builder: (_) {
      //   return FlashDealList(from_notification: true,);
      // }));
      return;
    }
    if (is_logged_in.value == false) {
      OneContext().showDialog(
        // barrierDismissible: false,
          builder: (context) => AlertDialog(
            title: new Text("You are not logged in"),
            content: new Text("Please log in"),
            actions: <Widget>[
              FlatButton(
                child: Text('close'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              FlatButton(
                child: Text('Login'),
                onPressed: () {
                  Navigator.of(context).pop();
                    OneContext().push(MaterialPageRoute(builder: (_) {
                      return Login();
                    }));
                  }
              ),
            ],
          )
      );
      return;
    }
    if (message['data']['item_type'] == 'order') {
      print("Navigating");
      // OneContext().push(MaterialPageRoute(builder: (_) {
      //   return OrderDetails(
      //       id: int.parse(message['data']['item_type_id']) ,
      //       from_notification: true);
      // }));
      OneContext().pushNamed(ShoppaholicsRoutes.OrderDetailRoute,arguments: {"id":int.parse(message['data']['item_type_id'])});
    }
    // If there's no view it'll just open the app on the first view
  }
}
