import 'dart:ffi';

import 'package:crypto/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';

class TradeHistory extends StatelessWidget {
  // const TradeHistory({Key? key});
 
 TransactionController transController=Get.put(TransactionController());
 
  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return 
        Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () {
                transController.disposeTransactions();
                Get.back();
              },
              child: Icon(Icons.arrow_back)),
            title: Padding(
              padding: EdgeInsets.only(right: 45, left: 45),
              child: Row(
                children: [
                  Text(
                    "Trade History",
                    // style: GoogleFonts.poppins(
                    //     color: Colors.black, fontWeight: FontWeight.bold),
                    style: TextStyle(color: Colors.black),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  // Padding(
                  //   padding: const EdgeInsets.only(top: 28),
                  //   child: Container(
                  //     height: 150,
                  //     width: 70,
                  //     child: Image.asset(
                  //       'assets/images/logo1.png',
                  //       fit: BoxFit.cover,
                  //       filterQuality: FilterQuality.high,
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
            backgroundColor: Colors.amber[200],
            centerTitle: true,
          ),
          body: Container(color: Colors.yellow.shade50, child: MyListView()),
        );
      }
    );
  }
}


class MyListView extends StatelessWidget {
  
 TransactionController transController=Get.put(TransactionController());
  
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transController.transactions.length,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Card(
            color: Colors.yellow.shade200,
            child: ExpansionTile(
              title: Text("trade $index"),
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Ticker: "),
                      Text("${transController.transactions[index].ticker}"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Text("Action: "),
                      Text("${transController.transactions[index].action}"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Text("Amount: "),
                      Text("${transController.transactions[index].amount}"),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Buy Price: "),
                      Text("${transController.transactions[index].Price}"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date: "),
                      transController.transactions[index].date==null?
                      Text("${transController.transactions[index].date}"):
                      Text("${now.day}/${now.month}/${now.year}")
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
}
