import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_tiktok_ui/screen/MainScreen.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';


class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {


  @override
  void initState() {
    super.initState();
    getVideoList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Image(image: AssetImage('assets/splash_screen.png'))
    );
  }

  getVideoList() async {
    print("***********videolist");
    var parameters = new Map<String, String>();
    parameters["fb_id"]="0";
    parameters["page"]="0";
    final response=await postTest(parameters, "https://api.theuwo.in/api-test/index2.php?p=showAllVideos");
    Map<String, dynamic> mapdata = json.decode(response);
    var videoList = <String>[];
    if(mapdata["code"].toString()=="200"){
      List msg_list = mapdata["msg"];
      for(Map<String, dynamic> map in msg_list){
        videoList.add(map['video']);
      }
    }
    Logger().i("complete");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(videoList),
      ),
    );
  }

  static Future<String> postTest(Map<String, String> map,String uri) async {

    var requestBody = {
      "fb_id":"0",
      "page":"0"
    };
    Map<String, String> headers = {
      "Content-Type": "application/x-www-form-urlencoded"};

    var request = http.MultipartRequest('POST', Uri.parse(uri))
      ..headers.addAll(headers) //if u have headers, basic auth, token bearer... Else remove line
      ..fields.addAll(map);

    var response = await request.send();
    final respStr = await response.stream.bytesToString();
    // http.Response response = await http.post(Uri.parse(uri), headers: headers, body: requestBody.toString());
    Logger().i(respStr);
    return respStr;
  }

}
