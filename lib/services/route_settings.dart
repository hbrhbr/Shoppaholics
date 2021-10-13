import 'package:active_ecommerce_flutter/data_model/order_mini_response.dart';
import 'package:active_ecommerce_flutter/screens/flash_deal_list.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/screens/order_details.dart';
import 'package:active_ecommerce_flutter/screens/todays_deal_products.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShoppaholicsRoutes{
  static String initialRoute = "/";
  static String OrderDetailRoute = "/orderDetailRoute";
  static String MainScreenRoute = "/mainScreenRoute";
  static String FalshSaleScreenRoute = "/falshSaleScreenRoute";
  static String ToadyDealScreenRoute = "/toadyDealScreenRoute";
 
}


final routes = {
  ShoppaholicsRoutes.MainScreenRoute: (context,) => Main(),
  ShoppaholicsRoutes.OrderDetailRoute: (context,{Map<String,int>arguments}) => OrderDetails(arguments: arguments,),
  ShoppaholicsRoutes.FalshSaleScreenRoute: (context,{Map<String,bool>arguments}) => FlashDealList(argument: arguments,),
  ShoppaholicsRoutes.ToadyDealScreenRoute: (context,{Map<String,bool>arguments}) => TodaysDealProducts(argument: arguments,),
  
};

var onGenerateRoute=(RouteSettings settings){
  print("Routing--->>>}");
  //Unified treatment
  final String name = settings.name;
  final Function pageContentBuilder = routes[name];
  if (pageContentBuilder != null) {
    if (settings.arguments != null) {

      final Route route = MaterialPageRoute(
        builder: (context) =>
            pageContentBuilder(context, arguments: settings.arguments),
      );
      return route;
    } else {
      final Route route = MaterialPageRoute(
        builder: (context) => pageContentBuilder(context),
      );
      return route;
    }
  }
};