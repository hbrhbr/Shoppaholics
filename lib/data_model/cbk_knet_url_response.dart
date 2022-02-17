import 'dart:convert';

CBK_KNET_UrlResponse cbkKnetUrlResponseFromJson(String str) => CBK_KNET_UrlResponse.fromJson(json.decode(str));

String cBK_KNET_UrlResponseToJson(CBK_KNET_UrlResponse data) => json.encode(data.toJson());

class CBK_KNET_UrlResponse {
  CBK_KNET_UrlResponse({
    this.result,
    this.url,
    this.message,
    this.cbk_knet_formData_Response,
  });

  bool result;
  String url;
  String message;
  CBK_KNET_FormData_Response cbk_knet_formData_Response;

  factory CBK_KNET_UrlResponse.fromJson(Map<String, dynamic> json){
    return CBK_KNET_UrlResponse(
      result: json["result"],
      url: json["data"]["url"],
      message: json["message"],
      cbk_knet_formData_Response: CBK_KNET_FormData_Response.fromJson(json["data"]["formData"]),
    );
  }

  Map<String, dynamic> toJson() => {
    "result": result,
    "url": url,
    "message": message,
  };
}
class CBK_KNET_FormData_Response {
  String tij_MerchantEncryptCode;
  String tij_MerchAuthKeyApi;
  String tij_MerchantPaymentLang;
  String tij_MerchantPaymentAmount;
  String tij_MerchantPaymentTrack;
  String tij_MerchantPaymentRef;
  String tij_MerchantUdf1;
  String tij_MerchantUdf2;
  String tij_MerchantUdf3;
  String tij_MerchantUdf4;
  String tij_MerchantUdf5;
  int tij_MerchPayType;
  String tij_MerchReturnUrl;
  CBK_KNET_FormData_Response({
    this.tij_MerchantEncryptCode,
    this.tij_MerchantPaymentAmount,
    this.tij_MerchantPaymentLang,
    this.tij_MerchantPaymentRef,
    this.tij_MerchantPaymentTrack,
    this.tij_MerchantUdf1,
    this.tij_MerchantUdf2,
    this.tij_MerchantUdf3,
    this.tij_MerchantUdf4,
    this.tij_MerchantUdf5,
    this.tij_MerchAuthKeyApi,
    this.tij_MerchPayType,
    this.tij_MerchReturnUrl,
  });

  factory CBK_KNET_FormData_Response.fromJson(Map<String, dynamic> json) => CBK_KNET_FormData_Response(
    tij_MerchantEncryptCode: json['tij_MerchantEncryptCode'],
    tij_MerchantPaymentAmount:  json['tij_MerchantPaymentAmount'],
    tij_MerchantPaymentLang:  json['tij_MerchantPaymentLang'],
    tij_MerchantPaymentRef:  json['tij_MerchantPaymentRef'],
    tij_MerchantPaymentTrack:  json['tij_MerchantPaymentTrack'],
    tij_MerchantUdf1:  json['tij_MerchantUdf1'],
    tij_MerchantUdf2:  json['tij_MerchantUdf2'],
    tij_MerchantUdf3:  json['tij_MerchantUdf3'],
    tij_MerchantUdf4:  json['tij_MerchantUdf4'],
    tij_MerchantUdf5:  json['tij_MerchantUdf5'],
    tij_MerchAuthKeyApi:  json['tij_MerchAuthKeyApi'],
    tij_MerchPayType:  json['tij_MerchPayType'],
    tij_MerchReturnUrl:  json['tij_MerchReturnUrl'],
  );

  Map<String, dynamic> toJson() => {
    "tij_MerchantEncryptCode": this.tij_MerchantEncryptCode,
    "tij_MerchantPaymentAmount": this.tij_MerchantPaymentAmount,
    "tij_MerchantPaymentLang": this.tij_MerchantPaymentLang,
    "tij_MerchantPaymentRef": this.tij_MerchantPaymentRef,
    "tij_MerchantPaymentTrack": this.tij_MerchantPaymentTrack,
    "tij_MerchantUdf1": this.tij_MerchantUdf1,
    "tij_MerchantUdf2": this.tij_MerchantUdf2,
    "tij_MerchantUdf3": this.tij_MerchantUdf3,
    "tij_MerchantUdf4": this.tij_MerchantUdf4,
    "tij_MerchantUdf5": this.tij_MerchantUdf5,
    "tij_MerchAuthKeyApi": this.tij_MerchAuthKeyApi,
    "tij_MerchPayType": this.tij_MerchPayType,
    "tij_MerchReturnUrl": this.tij_MerchReturnUrl,
  };
}