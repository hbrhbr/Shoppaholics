import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:active_ecommerce_flutter/data_model/simple_image_upload_response.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:flutter/foundation.dart';

class FileRepository {

  Future<SimpleImageUploadResponse> getSimpleImageUploadResponse(
      @required String image, @required String filename) async {
    var post_body = jsonEncode({"image": "${image}", "filename": "$filename"});
    //print(post_body.toString());

    final response =
    await http.post("${AppConfig.BASE_URL}/file/image-upload",
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${access_token.value}"
        },
        body: post_body);

    //print(response.body.toString());
    return simpleImageUploadResponseFromJson(response.body);
  }
}