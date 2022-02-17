import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/data_model/cbk_knet_url_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/material.dart';
import 'package:active_ecommerce_flutter/custom/toast_component.dart';
import 'package:toast/toast.dart';
import 'dart:io';
import 'dart:convert';
import 'package:active_ecommerce_flutter/repositories/payment_repository.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:active_ecommerce_flutter/screens/order_list.dart';
import 'package:active_ecommerce_flutter/screens/wallet.dart';

class CBK_KNET_Screen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;

  CBK_KNET_Screen(
      {Key key,
        this.amount = 0.00,
        this.payment_type = "",
        this.payment_method_key = ""})
      : super(key: key);

  @override
  _CBK_KNET_ScreenState createState() => _CBK_KNET_ScreenState();
}

class _CBK_KNET_ScreenState extends State<CBK_KNET_Screen> {
  int _combined_order_id = 0;
  bool _order_init = false;
  bool isOrderStatusFetching = false;
  String _initial_url = "";
  CBK_KNET_FormData_Response cbk_knet_formData_Response;
  bool _initial_url_fetched = false;

  WebViewController _webViewController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.payment_type == "cart_payment") {
      createOrder();
    }
  }

  createOrder() async {
    var orderCreateResponse = await PaymentRepository().getOrderCreateResponse(widget.payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }
    _combined_order_id = orderCreateResponse.combined_order_id;
    _order_init = true;
    _initial_url = "${AppConfig.BASE_URL}/cbk/pay-with-cbk?combined_order_id=$_combined_order_id&&user_id=${user_id.value}";
    _initial_url_fetched = true;
    print("--------------------------------\n$_initial_url\n------------------------------");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: buildBody(),
    );
  }



  void getData({String encrp}) async{
    setState(() {
      isOrderStatusFetching = true;
    });
    Map<String, dynamic> orderStatus = await PaymentRepository().getCBKOrderPaymentStatusResponse(combined_order_id: _combined_order_id.toString(),encrp: encrp);
    print("orderStatus---->>>${orderStatus}");
      if (orderStatus['success'] == false) {
        Toast.show("Payment Failed", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        // Navigator.pop(context);
      } else if (orderStatus['success']??false) {
        Toast.show("${orderStatus['msg']??''}", context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

        if (widget.payment_type == "cart_payment") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return OrderList(from_checkout: true);
          }));
        } else if (widget.payment_type == "wallet_payment") {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return Wallet(from_recharge: true);
          }));
        }
      }
  }

  buildBody() {
    if(_order_init){
      return SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: WebView(
            debuggingEnabled: false,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (controller) {
              _webViewController = controller;
              _webViewController.loadUrl(_initial_url);
            },
            onWebResourceError: (error) {},

            onPageFinished: (page) {
              print("$_combined_order_id WebView Page Result ${page}");
              if(page.contains('paymentcancel.htm')){
                  Toast.show("Payment Cancelled", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                  Navigator.pop(context);
              }
              else
                {
                  String encrpValue = '';
                  try{
                    Uri encrpUri = Uri.parse("$page");
                    print("encrpUri.queryParameters-->>${encrpUri.queryParameters}");
                    encrpValue = encrpUri.queryParameters['encrp'];
                  }catch(e){
                    print("Exception--->>>$e");
                  }
                  if(encrpValue.isNotEmpty) {
                    Toast.show("Checking Payment Status Please wait", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    getData(encrp: encrpValue);
                }
              }
            },
          ),
        ),
      );
    }
    else if(isOrderStatusFetching){
      return Container(
        child: Center(
          child: Text("Fetching Payment Status"),
        ),
      );
    }
    else
      return Container(
        child: Center(
          child: Text("Creating order ..."),
        ),
      );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      centerTitle: true,
      leading: Builder(
        builder: (context) => IconButton(
          icon: Icon(Icons.arrow_back, color: MyTheme.dark_grey),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      title: Text(
        "Pay with CBK KNET",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
