import 'dart:convert';

import 'package:crypto/Model/transaction_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';


class TransactionController extends GetxController {
  RxList<TransactionModel> transactions = <TransactionModel>[].obs;
  

  @override
  void onInit() {
    super.onInit();
    // Fetch transactions when the controller is initialized
    // fetchTransactions();
  }

  
    void disposeTransactions() {
    transactions.clear();
  }
Future<void> exitTrading(bool boolValue) async {
    String url = 'http://your_flask_server_ip_or_domain/exit_trading';

    Map<String, dynamic> requestBody = {
      'bool_value': boolValue,
    };

    try {
      var response = await post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        print('Boolean value updated successfully');
        print('Response body: ${response.body}');
      } else {
        print('Failed to update boolean value');
        print('Response status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Exception occurred while making POST request: $e');
    }
  }





  Future<void> removeAsset( String ticker) async {

      var user = FirebaseAuth.instance.currentUser;
      String uid=user!.uid;
    // final url = Uri.parse('http://10.0.2.2:5000/remove_asset');

    final url = Uri.parse('http://192.168.100.165:5000/remove_asset');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({'uid': uid, 'ticker': ticker});

    try {
      final response = await post(url, headers: headers, body: body); // Pass body as a named argument
      if (response.statusCode == 200) {
        print('Request successful');
        print(response.body);
        // Handle successful response
      } else {
        print('Request failed with status code: ${response.statusCode}');
        // Handle failed response
      }
    } catch (e) {
      print('Error sending request: $e');
      // Handle request error
    }
  }





  Future<void> fetchTransactions(symbol) async {
    if (symbol=="btc"){
      symbol="BTC-USD";
    }
    print(symbol);
    
      var user = FirebaseAuth.instance.currentUser;
      String uid=user!.uid;
      print(uid);
       var tradeHistorySnapshot = await FirebaseFirestore.instance
    .collection('trade_history')
    .doc(uid)
    .collection("coins").where('ticker', isEqualTo: symbol) 
    .get();
    print(tradeHistorySnapshot.docs.length);
   tradeHistorySnapshot.docs.forEach((doc) {
    var model = TransactionModel.fromJson(doc.data());
    transactions.add(model);
    print(transactions[0].date);
});}


Future<List<dynamic>> fetchAllTransactions() async {
  var tradeHistory = <dynamic>[]; // Initialize an empty list
  var user = FirebaseAuth.instance.currentUser;
  String uid = user!.uid;
  print(uid);

  var tradeHistorySnapshot = await FirebaseFirestore.instance
      .collection('trade_history')
      .doc(uid)
      .collection("coins")
      .get();

  print(tradeHistorySnapshot.docs.length);

  tradeHistorySnapshot.docs.forEach((doc) {
    var model = TransactionModel.fromJson(doc.data());
    tradeHistory.add(model);
    print(tradeHistory[0].date);
  });

  return tradeHistory; // Return the populated list
}


  
  }







//   Future<void> fetchTransactions() async {
//   try {
//     // Replace 'your_document_uid_here' with the actual UID
//     String uid = '2';

//     // Fetch the document with the specified UID
//     DocumentSnapshot tradeHistorySnapshot = await FirebaseFirestore.instance
//         .collection('trade_history')
//         .doc(uid)
//         .get();
    
//     try {
//       QuerySnapshot coinsSnapshot = await tradeHistorySnapshot.reference
//           .collection('coins')
//           .get();
      
//       // Iterate over each document in the coins subcollection
//       for (DocumentSnapshot coinDoc in coinsSnapshot.docs) {
//         try {
//           String docId = coinDoc.id;
//           // Access the data of each coin document
//           Map<String, dynamic> coinData = coinDoc.data() as Map<String, dynamic>;
//           // Process the data as needed
//           print('Document ID: $docId, Coin Data: $coinData');
//         } catch (coinDataError) {
//           print('Error processing coin data: $coinDataError');
//         }
//       }

//       // Map each document in the coins collection to a TransactionModel
//       List<TransactionModel> transactionList = coinsSnapshot.docs
//           .map((coinDoc) =>
//               TransactionModel.fromJson(coinDoc.data() as Map<String, dynamic>))
//           .toList();

//       // Update the transactions list
//       transactions.assignAll(transactionList);
//       for (var transaction in transactionList) {
//         print('Action: ${transaction.action}, Date: ${transaction.date}, Coin: ${transaction.coin}, Amount: ${transaction.amount}');
//       }
//     } catch (coinsSnapshotError) {
//       print('Error fetching coins snapshot: $coinsSnapshotError');
//     }
//   } catch (tradeHistoryError) {
//     print('Error fetching trade history snapshot: $tradeHistoryError');
//   }
// }

// }
