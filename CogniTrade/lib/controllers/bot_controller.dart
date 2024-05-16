import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ApiController extends GetxController {
  // final String baseUrl = "http://10.0.2.2:5000"; // Change this to your Flask app's URL

  final String baseUrl = "http://192.168.100.165:5000"; // Change this to your Flask app's URL
  var isBotTrading = false.obs;
  


  void toggleBotTrading() {
    // Toggle the value of isBotTrading
    isBotTrading.value = !isBotTrading.value;
  }



 Future<void>  startBot ({
    required String tickerSymbol,
    required double initialBalance,
     double? amount,
    required String uid,
  }) async
    {
    final String startBotUrl = "$baseUrl/start_bot";

    final Map<String, dynamic> paramsData = {
      "ticker_symbol": tickerSymbol,
      "initial_balance": initialBalance,
      "amount": amount,
      'uid': uid,
    };

    try {
      final  response = await http.post(
        Uri.parse(startBotUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(paramsData),
      );

      var statusCode;
      if (response.statusCode == 200) {
        // Handle successful response
        print(json.decode(response.body));
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}');
      }
    } 
    catch (e) {
      // Handle exceptions
      print('Error occurred: $e');
    }
  }

  Future<void> exitTrading() async {
    final String exitTradingUrl = "$baseUrl/exit_trading";

    final Map<String, dynamic> exitData = {
      "bool_value": true,
    };

    try {
      final response = await http.post(
        Uri.parse(exitTradingUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(exitData),
      );

      if (response.statusCode == 200) {
        // Handle successful response
        print(json.decode(response.body));
      } else {
        // Handle error response
        print('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      // Handle exceptions
      print('Error occurred: $e');
    }
  }
}
