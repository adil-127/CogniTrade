import 'dart:convert';

import 'package:crypto/Model/coinModel.dart';
import 'package:crypto/View/Components/item.dart';
import 'package:crypto/View/Components/item2.dart';
import 'package:crypto/View/login_signup/login.dart';
import 'package:crypto/View/tradehistory.dart';
import 'package:crypto/controllers/card_controller.dart';
import 'package:crypto/controllers/portfolio_coin_controller.dart';
import 'package:crypto/controllers/transaction_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;

class Portfolio extends StatefulWidget {
  const Portfolio({super.key});

  @override
  State<Portfolio> createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {

CardController Cardcontroller=Get.put(CardController());
PortfolioCoinController PortfolioController=Get.put(PortfolioCoinController());
TransactionController transactionController=Get.put(TransactionController());
  @override
  void initState() {
    getCoinMarket();
    PortfolioController.fetchUserData();
    PortfolioController.GetHoldings();
    super.initState();
  }
 @override
  // void dispose() {
  //   PortfolioController.holdings.close(); // Dispose of the holdings variable
  //   super.dispose();
  // }
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 253, 225, 112),
                Color(0xffFBC700),
              ]),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Padding(
              //   padding: EdgeInsets.symmetric(vertical: myHeight * 0.03),
              //   child:
              //    Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceAround,
              //     children: [
              //       Container(
              //         padding: EdgeInsets.symmetric(
              //             horizontal: myWidth * 0.02, vertical: myHeight * 0.005),
              //         decoration: BoxDecoration(
              //             color: Colors.white.withOpacity(0.5),
              //             borderRadius: BorderRadius.circular(5)),
              //         child: Text(
              //           'Main portfolio',
              //           style: TextStyle(fontSize: 18),
              //         ),
              //       ),
              //       Text(
              //         'Top 10 coins',
              //         style: TextStyle(fontSize: 18),
              //       ),
              //       Text(
              //         'Exprimental',
              //         style: TextStyle(fontSize: 18),
              //       ),
              //     ],
              //   ),
              // ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07,vertical: myHeight * 0.03),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {

                      return Text(
                      '\$ ${PortfolioController.liquidity.value.toInt()}',
                      style: TextStyle(fontSize: 35),
                    );
                    }),
                    
                    InkWell(
                      onTap: () async{
                        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(myWidth * 0.02),
                        height: myHeight * 0.07,
                        width: myWidth * 0.2,
                        decoration: BoxDecoration(
                            // shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.5)),
                        child: Center(child: Text("log out"))
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '0% all time',
                      style: TextStyle(fontSize: 16),
                    ),
                    InkWell(
                      onTap: () async{
                     await transactionController.exitTrading(true); // Replace true with your desired boolean value
                      },
                      child: Container(
                        padding: EdgeInsets.all(myWidth * 0.02),
                        height: myHeight * 0.07,
                        width: myWidth * 0.2,
                        decoration: BoxDecoration(
                            // shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white.withOpacity(0.5)),
                        child: Center(child: Text("Stop Bot"))
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: myHeight * 0.02,
              ),
              Container(
                height: myHeight * 0.7,
                width: myWidth,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 5,
                          color: Colors.grey.shade300,
                          spreadRadius: 3,
                          offset: Offset(0, 3))
                    ],
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    )),
                child: Column(
                  children: [
                    SizedBox(
                      height: myHeight * 0.03,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: myWidth * 0.08),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              PortfolioController.dispose_holdings();
                            },
                            child: Text(
                              'Assets',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          // Icon(Icons.add)
                        ],
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.02,
                    ),
                    Container(
                      height: myHeight * 0.36,
                      child: isRefreshing == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Color(0xffFBC700),
                              ),
                            )
                          : 
                          


                              FutureBuilder<Map<String, dynamic>>(
                              future: PortfolioController.GetHoldings(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError) {
                                  return Center(child: Text('Error: ${snapshot.error}'));
                                } else {
                                  // Extract keys from the map
                                  List<String> keys = snapshot.data!.keys.toList();
                                  return Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 20),
                                    child: ListView.builder(
                                      itemCount: keys.length,
                                      itemBuilder: (context, index) {
                                        final key = keys[index];
                                        print(key);
                                        final value = snapshot.data![key];
                                        return InkWell(
                                          onTap: () async{
                                                  await transactionController.fetchTransactions(key);
                                                 
                                              Get.to(TradeHistory());
                                          },
                                          child: ListTile(
                                            title: Text(key, style: TextStyle(color: Colors.black)),
                                            subtitle: Text('Amount: $value'),
                                            trailing: InkWell(
                                              onTap: () async{
                                                
                                                await transactionController.removeAsset(key);
                                                await     PortfolioController.fetchUserData();

                                                                    setState(() {});
                                                // PortfolioController.dispose_holdings();
                                              },
                                              child: Icon(Icons.delete,color: Colors.red.shade500,)),
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }
                              },
                            ),



                                
                               
                              // FutureBuilder(
                              //   future: getCoins(PortfolioController.items.map((coin) => coin.id.toString()).toList()),
                                
                              //   builder: (BuildContext context, AsyncSnapshot snapshot) {

                              //   var test=PortfolioController.items.map((coin) => coin.id.toString()).toList();
                              //   print(test.length);
                              //      if (snapshot.connectionState == ConnectionState.waiting) {
                              //       return CircularProgressIndicator();

                              //     } else if (snapshot.hasError) {
                              //       print(snapshot.error);
                              //       return 
                              //       Text('Error: ${snapshot.error}');
                              //     } else if (coins.isNotEmpty) {
                              //       // List<CoinModel> coins = snapshot.data!;

                              //       print(snapshot.data);
                              //       return ListView.builder(
                              //         itemCount: coins.length,
                              //         itemBuilder: (context, index) {
                              //           // CoinModel coin = coins[index];
                              //              return Item(
                              //           item: coins[index],
                              //         );
                              //         },
                              //       );
                              //     } else {
                              //       return Text('No coins in the Portfolio');
                              //     }
                              //   },
                              // ),
                    ),
                    SizedBox(
                      height: myHeight * 0.02,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: myWidth * 0.05),
                      child: Row(
                        children: [
                          Text(
                            'Recommend to Buy',
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: myWidth * 0.03),
                        child: isRefreshing == true
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xffFBC700),
                                ),
                              )
                            : coinMarket == null || coinMarket!.length == 0
                                ? Padding(
                                    padding: EdgeInsets.all(myHeight * 0.06),
                                    child: Center(
                                      child: Text(
                                        'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  )
                                : ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: coinMarket!.length,
                                    itemBuilder: (context, index) {
                                      return InkWell (
                                        onTap: () {
                                          PortfolioController.dispose_holdings();
                                        },
                                        child: Item2(
                                          item: coinMarket![index],
                                        ),
                                      );
                                    },
                                  ),
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  bool isRefreshing = true;
  bool isRefreshingPortfolio =true;
  List? coinMarket = [];
  var coinMarketList;
  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';

    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      print("all coins");
      
      var x = response.body;
      // var coinMap = json.decode(response.body);
      // print(x);
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }

// =======================================================================================
  

// Future<List<CoinModel>?> GetHold(List<String> coinIds) async {
//   const String baseUrl = 'https://api.coingecko.com/api/v3';  
//   List<CoinModel> coins = [];
  
//   if (coinIds.isNotEmpty) {
//     for (String coinId in coinIds) {
//       final String url = '$baseUrl/coins/$coinId?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true';

//       try {
//         final response = await http.get(Uri.parse(url), headers: {
//           "Content-Type": "application/json",
//           "Accept": "application/json",
//         });

//         if (response.statusCode == 200) {
//   print("selectcoin");
//   var coinMap = json.decode(response.body);
//   Iterable<String> keys = coinMap.keys;
//     List<String> keyList = keys.toList();
//   print("coinMap keys");
//   print(keyList);
//   var coin = CoinModel.PortffromJson(coinMap);
//   print(coin.id);
//   print(coin);
//   setState(() {
//     coins.add(coin);
//     print(coins);
//   });
// }

//         else {
//           print('Request failed with status: ${response.statusCode}');
//         }
//       } catch (error) {
//         print('Error: $error');
//       }
//     }
//   } else {
//     print('No coin IDs provided.');
//   }
  
//   // return coins;
// }



}



// Future<CoinModel?> getCoin(String coinId) async {
//   const String baseUrl = 'https://api.coingecko.com/api/v3';
//   final String url =
//       '$baseUrl/coins/$coinId?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false&sparkline=true';

//   try {
//     final response = await http.get(Uri.parse(url), headers: {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//     });

//     if (response.statusCode == 200) {
//       final jsonResponse = json.decode(response.body);
//       final coinModel = CoinModel.fromJson(jsonResponse);
//       return coinModel;
//     } else {
//       print('Request failed with status: ${response.statusCode}');
//       return null;
//     }
//   } catch (error) {
//     print('Error: $error');
//     return null;
//   }
// }



