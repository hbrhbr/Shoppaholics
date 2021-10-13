import 'package:active_ecommerce_flutter/helpers/shimmer_helper.dart';
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
import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/data_model/razorpay_payment_success_response.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

class KNETMyFatoorahScreen extends StatefulWidget {
  double amount;
  String payment_type;
  String payment_method_key;
  bool isKnet;

  KNETMyFatoorahScreen(
      {Key key,
      this.amount = 0.00,
      this.payment_type = "",
      this.isKnet = true,
      this.payment_method_key = ""})
      : super(key: key);

  @override
  _KNETMyFatoorahScreenState createState() => _KNETMyFatoorahScreenState();
}

class _KNETMyFatoorahScreenState extends State<KNETMyFatoorahScreen> {
  int _combined_order_id = 0;
  bool _order_init = false;
  String myFatoorahAPIKey = "";
  String myFatoorahURL = "";

  WebViewController _webViewController;

  bool isCredentailsFetched = false;
  @override
  void initState() {
    super.initState();
    getMyFatoorahKnetCredentails();
  }

  getMyFatoorahKnetCredentails() async {
    Map<String, dynamic> myFatoorahCredentails =
        await PaymentRepository().getMyFatoorahCredentails();
    myFatoorahAPIKey = myFatoorahCredentails["data"]["apiKey"];
    myFatoorahURL = myFatoorahCredentails["data"]["apiURL"];
    MFSDK.init(
      myFatoorahURL,
      myFatoorahAPIKey,
    );
    MFSDK.setUpAppBar(
      isShowAppBar: true,
      title: widget.isKnet ? "KNET Payment" : "MyFatoorah Payment",
    );
    initiatePayment();
  }

  Future createOrder() async {
    var orderCreateResponse = await PaymentRepository()
        .getOrderCreateResponse(widget.payment_method_key);

    if (orderCreateResponse.result == false) {
      ToastComponent.showDialog(orderCreateResponse.message, context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_LONG);
      Navigator.of(context).pop();
      return;
    }

    _combined_order_id = orderCreateResponse.combined_order_id;
    _order_init = true;
    setState(() {});

    print("-----------");
    print(_combined_order_id);
    print(user_id.value);
    print(widget.amount);
    print(widget.payment_method_key);
    print(widget.payment_type);
    print("-----------");
  }

  initiatePayment() async {
    // Initiate Payment
    MFInitiatePaymentRequest request =
        MFInitiatePaymentRequest(widget.amount, MFCurrencyISO.KUWAIT_KWD);
    MFSDK.initiatePayment(
      request,
      MFAPILanguage.EN,
      (MFResult<MFInitiatePaymentResponse> result) => {},
    );
    // // executePayment
    // // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    int paymentMethod = widget.isKnet ? 1 : 2;
    MFExecutePaymentRequest request1 =
        MFExecutePaymentRequest(paymentMethod, widget.amount);
    MFSDK.executePayment(
        context,
        request1,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) async => {
              if (result.isSuccess())
                {
                  if (widget.payment_type == "cart_payment")
                    {
                      await createOrder(),
                    },
                  if (widget.payment_type == "cart_payment")
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return OrderList(from_checkout: true);
                      })),
                    }
                  else if (widget.payment_type == "wallet_payment")
                    {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return Wallet(from_recharge: true);
                      })),
                    },
                  print(
                      "result.response.toJson()--->>>${result.response.toJson().toString()}"),
                }
              else
                {
                  Toast.show(result.error.message, context,
                      duration: Toast.LENGTH_LONG, gravity: Toast.CENTER),
                  print("result.error.message-->>${result.error.message}"),
                  Navigator.pop(context)
                }
            });
    setState(() {
      isCredentailsFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isCredentailsFetched)
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: buildAppBar(context),
        body: buildBody(),
      );
    else
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
            child: ShimmerHelper()
                .buildListShimmer(item_count: 5, item_height: 100.0)),
      );
  }

  void getData() {
    print('called.........');
    var payment_details = '';
    _webViewController
        .evaluateJavascript("document.body.innerText")
        .then((data) {
      var decodedJSON = jsonDecode(data);
      Map<String, dynamic> responseJSON = jsonDecode(decodedJSON);
      //print(responseJSON.toString());
      if (responseJSON["result"] == false) {
        Toast.show(responseJSON["message"], context,
            duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

        Navigator.pop(context);
      } else if (responseJSON["result"] == true) {
        print("a");
        payment_details = responseJSON['payment_details'];
        onPaymentSuccess(payment_details);
      }
    });
  }

  onPaymentSuccess(payment_details) async {
    print("b");

    var razorpayPaymentSuccessResponse = await PaymentRepository()
        .getRazorpayPaymentSuccessResponse(widget.payment_type, widget.amount,
            _combined_order_id, payment_details);

    if (razorpayPaymentSuccessResponse.result == false) {
      print("c");
      Toast.show(razorpayPaymentSuccessResponse.message, context,
          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      Navigator.pop(context);
      return;
    }

    Toast.show(razorpayPaymentSuccessResponse.message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
    if (widget.payment_type == "cart_payment") {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return OrderList(from_checkout: true);
      }));
    } else if (widget.payment_type == "wallet_payment") {
      print("d");
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return Wallet(from_recharge: true);
      }));
    }
  }

  buildBody() {
    return SizedBox();
    // String initial_url = "${AppConfig.BASE_URL}/razorpay/pay-with-razorpay?payment_type=${widget.payment_type}&order_id=${_order_id}&amount=${widget.amount}&user_id=${user_id.value}";
    //
    // print("init url");
    //
    // if (_order_init == false && _order_id == 0 && widget.payment_type == "cart_payment") {
    //   return Container(
    //     child: Center(
    //       child: Text("Creating order ..."),
    //     ),
    //   );
    // } else {
    //   return SizedBox.expand(
    //     child: Container(
    //       child: WebView(
    //         debuggingEnabled: false,
    //         javascriptMode: JavascriptMode.unrestricted,
    //         onWebViewCreated: (controller) {
    //           _webViewController = controller;
    //           _webViewController.loadUrl(initial_url);
    //         },
    //         onWebResourceError: (error) {},
    //         onPageFinished: (page) {
    //           print(page.toString());
    //           getData();
    //         },
    //       ),
    //     ),
    //   );
    // }
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
        "Pay with ${widget.isKnet ? 'KNET' : 'MyFatoorah'}",
        style: TextStyle(fontSize: 16, color: MyTheme.accent_color),
      ),
      elevation: 0.0,
      titleSpacing: 0,
    );
  }
}
