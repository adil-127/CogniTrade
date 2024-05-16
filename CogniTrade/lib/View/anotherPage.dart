import 'package:crypto/controllers/portfolio_coin_controller.dart';
import 'package:crypto/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionsView extends StatelessWidget {
TransactionController transactionController=Get.put(TransactionController());
PortfolioCoinController portfolio_controller=Get.put(PortfolioCoinController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar: AppBar(
            leading: Icon(Icons.arrow_back,color: Colors.black,),
            title: Padding(
              padding: EdgeInsets.only(right: 45, left: 45),
              child: Row(
                children: [
                  Text(
                    "Transactions",
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
          body: 
          FutureBuilder(
            future: portfolio_controller.GetHoldings(),
            
            builder: (BuildContext context, AsyncSnapshot snapshot) {
               if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                      List<String> keys = snapshot.data!.keys.toList();

                      return 
                            FutureBuilder(
                              future: transactionController.fetchAllTransactions(),
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else {
                                return Container(color: Colors.yellow.shade50, child: MyListView(snapshots: snapshot,));
                                }
                              },
                            );
                            // Container(color: Colors.yellow.shade50, child: Text("data"));
                                        }
                    },
                  ),
                );
        
  }
}


class MyListView extends StatelessWidget {
  var snapshots;
    MyListView({required this.snapshots});
//  TransactionController transController=Get.put(TransactionController());
  
  DateTime now = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshots.data.length,
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
                      Text("${snapshots.data[index].ticker}"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Text("Action: "),
                      Text("${snapshots.data[index].action}"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      
                      Text("Amount: "),
                      Text("${snapshots.data[index].amount}"),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      Text("Buy Price: "),
                      Text("${snapshots.data[index].Price}"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Date: "),
                      snapshots.data[index].date==null?
                      Text("${snapshots.data[index].date}"):
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
