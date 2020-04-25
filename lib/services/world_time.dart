import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime{

  String location;//location name for the UI
  String time;//the time in that location
  String flag;//url to an asset flag icon
  String url;//location url for api endpoint
  bool isDaytime;//true or false if daytime or not

  WorldTime({this.location,this.flag,this.url});

 Future <void> getTime() async{

    try {
      // make the request
      Response response = await get(
          'http://worldtimeapi.org/api/timezone/$url');
      Map data = jsonDecode(response.body);
      //print(data);
      //get properties from data
      String datetime = data['utc_datetime'];
      String stroffset = data['utc_offset'];
      //print(datetime);
      //print(stroffset);
      //createDateTime object
      DateTime now = DateTime.parse(datetime);
      List<int> offset = stroffset.substring(1).split(":").map((temp) =>
          int.parse(temp)).toList();

      // check offset if it's ahead or behind and then add/ subtract based on that
      // now is indestructible - redeclare
      stroffset.substring(0, 1) == "+" ?
      now = now.add(Duration(hours: offset[0], minutes: offset[1])) : now =
          now.subtract(Duration(hours: offset[0], minutes: offset[1]));

      //set the time property
      isDaytime = now.hour > 6 && now.hour < 20 ? true : false;
      time = DateFormat.jm().format(now);
    }
    catch(e){
      print('caught error: $e');
      time='could not get time data';
    }

  }

}

