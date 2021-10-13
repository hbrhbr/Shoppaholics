import 'package:flutter/material.dart';
import 'package:myfatoorah_flutter/myfatoorah_flutter.dart';

/*
TODO: The following data are using for testing only, so that when you go live
      don't forget to replace the following test credentials with the live
      credentials provided by MyFatoorah Company.
*/

// Base Url
final String baseUrl = "https://apitest.myfatoorah.com";

// You can get the API Key for regular payment or direct payment and recurring from here:
// https://myfatoorah.readme.io/docs/demo-information
final String mAPIKey = "bearer Tfwjij9tbcHVD95LUQfsOtbfcEEkw1hkDGvUbWPs9CscSxZOttanv3olA6U6f84tBCXX93GpEqkaP_wfxEyNawiqZRb3Bmflyt5Iq5wUoMfWgyHwrAe1jcpvJP6xRq3FOeH5y9yXuiDaAILALa0hrgJH5Jom4wukj6msz20F96Dg7qBFoxO6tB62SRCnvBHe3R-cKTlyLxFBd23iU9czobEAnbgNXRy0PmqWNohXWaqjtLZKiYY-Z2ncleraDSG5uHJsC5hJBmeIoVaV4fh5Ks5zVEnumLmUKKQQt8EssDxXOPk4r3r1x8Q7tvpswBaDyvafevRSltSCa9w7eg6zxBcb8sAGWgfH4PDvw7gfusqowCRnjf7OD45iOegk2iYSrSeDGDZMpgtIAzYVpQDXb_xTmg95eTKOrfS9Ovk69O7YU-wuH4cfdbuDPTQEIxlariyyq_T8caf1Qpd_XKuOaasKTcAPEVUPiAzMtkrts1QnIdTy1DYZqJpRKJ8xtAr5GG60IwQh2U_-u7EryEGYxU_CUkZkmTauw2WhZka4M0TiB3abGUJGnhDDOZQW2p0cltVROqZmUz5qGG_LVGleHU3-DgA46TtK8lph_F9PdKre5xqXe6c5IYVTk4e7yXd6irMNx4D4g1LxuD8HL4sYQkegF2xHbbN8sFy4VSLErkb9770-0af9LT29kzkva5fERMV90w";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFatoorah Plugin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'MyFatoorah Plugin Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _response = '';
  String _loading = "Loading...";

  @override
  void initState() {
    super.initState();

    if (mAPIKey.isEmpty) {
      setState(() {
        _response =
            "Missing API Key.. You can get it from here: https://myfatoorah.readme.io/docs/demo-information";
      });
      return;
    }

    // TODO, don't forget to init the MyFatoorah Plugin with the following line
    MFSDK.init(baseUrl, mAPIKey);

    // (Optional) un comment the following lines if you want to set up properties of AppBar.

//    MFSDK.setUpAppBar(
//      title: "MyFatoorah Payment",
//      titleColor: Colors.white,  // Color(0xFFFFFFFF)
//      backgroundColor: Colors.black, // Color(0xFF000000)
//      isShowAppBar: true); // For Android platform only

    // (Optional) un comment this line, if you want to hide the AppBar.
    // Note, if the platform is iOS, this line will not affected

//    MFSDK.setUpAppBar(isShowAppBar: false);
  }

  /*
    Send Payment
   */
  void sendPayment() {
    var request = MFSendPaymentRequest(
        invoiceValue: 0.100,
        customerName: "Customer name",
        notificationOption: MFNotificationOption.LINK);

    MFSDK.sendPayment(
        context,
        MFAPILanguage.EN,
        request,
        (MFResult<MFSendPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toJson());
                    _response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Initiate Payment
   */
  void initiatePayment() {
    var request = new MFInitiatePaymentRequest(5.5, MFCurrencyISO.KUWAIT_KWD);

    MFSDK.initiatePayment(
        request,
        MFAPILanguage.EN,
        (MFResult<MFInitiatePaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toJson());
                    _response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Execute Regular Payment
   */
  void executeRegularPayment() {
    // The value 1 is the paymentMethodId of KNET payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    int paymentMethod = 1;

    var request = new MFExecutePaymentRequest(paymentMethod, 0.100);

    MFSDK.executePayment(
        context,
        request,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(invoiceId);
                    print(result.response.toJson());
                    _response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Execute Direct Payment
   */
  void executeDirectPayment() {
    // The value 2 is the paymentMethodId of Visa/Master payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    int paymentMethod = 2;

    var request = new MFExecutePaymentRequest(paymentMethod, 0.100);

//    var mfCardInfo = new MFCardInfo(cardToken: "Put your token here");

    var mfCardInfo = new MFCardInfo(
        cardNumber: "5453010000095539",
        expiryMonth: "12",
        expiryYear: "25",
        securityCode: "100",
        cardHolderName: "Set Name",
        bypass3DS: false,
        saveToken: true);

    MFSDK.executeDirectPayment(
        context,
        request,
        mfCardInfo,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFDirectPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(invoiceId);
                    print(result.response.toJson());
                    _response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Execute Direct Payment with Recurring
   */
  void executeDirectPaymentWithRecurring() {
    // The value "2" is the paymentMethodId of Visa/Master payment method.
    // You should call the "initiatePayment" API to can get this id and the ids of all other payment methods
    int paymentMethod = 2;

    var request = new MFExecutePaymentRequest(paymentMethod, 100.0);

    var mfCardInfo = new MFCardInfo(
        cardNumber: "5453010000095539",
        expiryMonth: "12",
        expiryYear: "25",
        securityCode: "100",
        cardHolderName: "Set Name",
        bypass3DS: true,
        saveToken: true);

    mfCardInfo.iteration = 12;

    MFSDK.executeRecurringDirectPayment(
        context,
        request,
        mfCardInfo,
        MFRecurringType.monthly,
        MFAPILanguage.EN,
        (String invoiceId, MFResult<MFDirectPaymentResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(invoiceId);
                    print(result.response.toJson());
                    _response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(invoiceId);
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Payment Enquiry
   */
  void getPaymentStatus() {
    var request = MFPaymentStatusRequest(invoiceId: "457786");

    MFSDK.getPaymentStatus(
        MFAPILanguage.EN,
        request,
        (MFResult<MFPaymentStatusResponse> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toJson());
                    _response = result.response.toJson().toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Cancel Token
   */
  void cancelToken() {
    MFSDK.cancelToken(
        "Put your token here",
        MFAPILanguage.EN,
        (MFResult<bool> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toString());
                    _response = result.response.toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  /*
    Cancel Recurring Payment
   */
  void cancelRecurringPayment() {
    MFSDK.cancelRecurringPayment(
        "Put RecurringId here",
        MFAPILanguage.EN,
        (MFResult<bool> result) => {
              if (result.isSuccess())
                {
                  setState(() {
                    print(result.response.toString());
                    _response = result.response.toString();
                  })
                }
              else
                {
                  setState(() {
                    print(result.error.toJson());
                    _response = result.error.message;
                  })
                }
            });

    setState(() {
      _response = _loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(children: [
            IntrinsicWidth(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.all(5.0),
                  ),
                  RaisedButton(
                    child: Text('Send Payment'),
                    onPressed: sendPayment,
                  ),
                  RaisedButton(
                    child: Text('Initiate Payment'),
                    onPressed: initiatePayment,
                  ),
                  RaisedButton(
                    child: Text('Execute Regular Payment'),
                    onPressed: executeRegularPayment,
                  ),
                  RaisedButton(
                    child: Text('Execute Direct Payment'),
                    onPressed: executeDirectPayment,
                  ),
                  RaisedButton(
                    child: Text('Execute Direct Payment with Recurring'),
                    onPressed: executeDirectPaymentWithRecurring,
                  ),
                  RaisedButton(
                    child: Text('Cancel Recurring Payment'),
                    onPressed: cancelRecurringPayment,
                  ),
                  RaisedButton(
                    child: Text('Cancel Token'),
                    onPressed: cancelToken,
                  ),
                  RaisedButton(
                    child: Text('Get Payment Status'),
                    onPressed: getPaymentStatus,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                  ),
                ],
              ),
            ),
            Container(
              child: Expanded(
                flex: 1,
                child: SingleChildScrollView(
                  child: Text(_response),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
