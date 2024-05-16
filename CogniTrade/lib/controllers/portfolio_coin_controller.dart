import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:crypto/Model/coinModel.dart';
import 'package:crypto/Model/portfolio_coin.dart';
import 'package:get/get.dart';

class PortfolioCoinController extends GetxController {
  final items = <PortfolioCoin>[].obs; // The list of items
  RxDouble balance=0.0.obs;
  RxDouble liquidity=0.0.obs;

  RxString portfolio =''.obs;
  // var holdings={}.obs;

void invest(var amount) {
    // Simulate deducting the investment amount from the user's balance
     balance.value -= amount;
}
// bool canBuyCoin(double coinPrice, double? quantity) {
//     double totalPrice = coinPrice * quantity;
//     return balance.value >= totalPrice;
//   }


void dispose_holdings(){
  print("heelo");
  // holdings.clear();
}



Future<Map<String,dynamic>> GetHoldings() async {
  // Define the API endpoint URL
    var user = FirebaseAuth.instance.currentUser;
  var uid=user!.uid;
  // var url = Uri.parse('http://10.0.2.2:5000/get_holding_map');

  var url = Uri.parse('http://192.168.100.165:5000/get_holding_map');

  // Define the payload (UID)
  var payload = {'uid': uid};
  var null_map={'no data':'no data'};
  // Send a POST request to the API endpoint
  var response = await http.post(
    url,
    body: json.encode(payload),
    headers: {'Content-Type': 'application/json'},
  );

  // Print the response status code and content
  print('Response Status Code: ${response.statusCode}');
  print('Response Content:');
  
  print(json.decode(response.body));
  if (response.statusCode == 200) {
    // Decode the response body JSON
        Map<String, dynamic> decodedResponse = json.decode(response.body);
    //      decodedResponse.forEach((key, value) {
    //   // holdings[key] = value; // Assuming holdings is a Map<String, dynamic>
    //   // print(holdings[key]);
    // });
 
   print("holdings...");
  //  print(holdings);
    // Print the keys of the response JSON
     return decodedResponse;
    print("done...");
  } else {
    print('Failed to fetch data: ${response.reasonPhrase}');
    return null_map;
  }
}


Future<void> fetchUserData() async {
  var user = FirebaseAuth.instance.currentUser;
  var uid=user!.uid;
  try {
    // Reference to the document in the 'users' collection
    DocumentSnapshot<Map<String, dynamic>> doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (doc.exists) {
      // Extract liquidity and balance from the document data
       liquidity.value = doc['liquidity'].toDouble();
       balance.value = doc['totalamount'].toDouble();
       portfolio.value = doc['Portfolio'].toStringAsFixed(2);

      print('Liquidity: $liquidity, Balance: $balance');
    } else {
      print('No document found for UID: $uid');
    }
  } catch (e) {
    print('Error fetching user data: $e');
  }
}



  // Method to add an item to the list
  void addItem(String itemId, double? amnt, double? cash_risk, double? loss, double? profit) {
    // Create a PortfolioCoin object using the provided id
    PortfolioCoin item = PortfolioCoin(id: itemId,amount: amnt,cash_at_risk: cash_risk, stop_loss: loss, take_profit: profit);

    // Add the item to the list
    items.add(item);
  }

  // Method to remove an item from the list
  void removeItem(int id) {
    items.removeWhere((item) => item.id == id);
  }

  List coins = [].obs;

Future<List<CoinModel>?> getCoins(String coinId) async {
  const String baseUrl = 'https://api.coingecko.com/api/v3';  
  print("1");
  if (coinId.isNotEmpty) {
Future<List<CoinModel>?> getCoins(String coinId) async {
  const String baseUrl = 'https://api.coingecko.com/api/v3';  
  print("1");
  if (coinId.isNotEmpty) {
    // for (String coinId in coinIds) {
      final String url = '$baseUrl/coins/$coinId?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true';

      try {
        final response = await http.get(Uri.parse(url), headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        });

        if (response.statusCode == 200) {
  print("selectcoin");
  var coinMap = json.decode(response.body);
  print(coinMap);
  Iterable<String> keys = coinMap.keys;
    List<String> keyList = keys.toList();
  print("coinMap keys");
  print(keyList);
  var coin = CoinModel.PortffromJson(coinMap);
  print(coin.id);
  print(coin);
  coins.add(coin);
}

        else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    // }
  } else {
    print('No coin IDs provided.');
  }
  
  // return coins;
}
    // for (String coinId in coinIds) {
      final String url = '$baseUrl/coins/$coinId?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true';

      try {
        final response = await http.get(Uri.parse(url), headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        });

        if (response.statusCode == 200) {
  print("selectcoin");
  var coinMap = json.decode(response.body);
  print(coinMap);
  Iterable<String> keys = coinMap.keys;
    List<String> keyList = keys.toList();
  print("coinMap keys");
  print(keyList);
  var coin = CoinModel.PortffromJson(coinMap);
  print(coin.id);
  print(coin);
  coins.add(coin);
}

        else {
          print('Request failed with status: ${response.statusCode}');
        }
      } catch (error) {
        print('Error: $error');
      }
    // }
  } else {
    print('No coin IDs provided.');
  }
  
  // return coins;
}


}
