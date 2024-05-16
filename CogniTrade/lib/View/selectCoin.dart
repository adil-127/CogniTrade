import 'dart:convert';
import 'dart:ffi';

import 'package:crypto/controllers/bot_controller.dart';
import 'package:crypto/controllers/news_controller.dart';
import 'package:crypto/controllers/portfolio_coin_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';
import '../Model/chartModel.dart';

class SelectCoin extends StatefulWidget {
  var selectItem;

  SelectCoin({this.selectItem});


  @override
  State<SelectCoin> createState() => _SelectCoinState();
}

class _SelectCoinState extends State<SelectCoin> {
  late TrackballBehavior trackballBehavior;

  PortfolioCoinController PortfolioController=Get.put(PortfolioCoinController());
  SentimentAnalysisController newsController=Get.put(SentimentAnalysisController());
  ApiController apiController =Get.put(ApiController());
  @override
  void initState() {
    getChart();
    trackballBehavior = TrackballBehavior(
        enable: true, activationMode: ActivationMode.singleTap);
    
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
     PortfolioController.balance.value=widget.selectItem.currentPrice;
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: myWidth * 0.05, vertical: myHeight * 0.02),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            height: myHeight * 0.08,
                            child: Image.network(widget.selectItem.image)),
                        SizedBox(
                          width: myWidth * 0.03,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.selectItem.id,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text(
                              widget.selectItem.symbol,
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Obx(() {
                        return Text(
                          '\$' + PortfolioController.balance.value.toString(),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.normal,
                              color: Colors.black),
                        );
                        }),
                        
                        SizedBox(
                          height: myHeight * 0.01,
                        ),
                        Text(
                          widget.selectItem.marketCapChangePercentage24H
                                  .toString() +
                              '%',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: widget.selectItem
                                          .marketCapChangePercentage24H >=
                                      0
                                  ? Colors.green
                                  : Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                  child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: myWidth * 0.05, vertical: myHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Low',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text(
                              '\$' + widget.selectItem.low24H.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'High',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text(
                              '\$' + widget.selectItem.high24H.toString(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              'Vol',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                            SizedBox(
                              height: myHeight * 0.01,
                            ),
                            Text(
                              '\$' +
                                  widget.selectItem.totalVolume.toString() +
                                  'M',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.015,
                  ),
                  Container(
                    height: myHeight * 0.4,
                    width: myWidth,
                    // color: Colors.amber,
                    child: isRefresh == true
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color(0xffFBC700),
                            ),
                          )
                        : itemChart == null
                            ? Padding(
                                padding: EdgeInsets.all(myHeight * 0.06),
                                child: Center(
                                  child: Text(
                                    'Attention this Api is free, so you cannot send multiple requests per second, please wait and try again later.',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              )
                            : SfCartesianChart(
                                trackballBehavior: trackballBehavior,
                                zoomPanBehavior: ZoomPanBehavior(
                                    enablePinching: true, zoomMode: ZoomMode.x),
                                series: <CandleSeries>[
                                  CandleSeries<ChartModel, int>(
                                      enableSolidCandles: true,
                                      enableTooltip: true,
                                      bullColor: Colors.green,
                                      bearColor: Colors.red,
                                      dataSource: itemChart!,
                                      xValueMapper: (ChartModel sales, _) =>
                                          sales.time,
                                      lowValueMapper: (ChartModel sales, _) =>
                                          sales.low,
                                      highValueMapper: (ChartModel sales, _) =>
                                          sales.high,
                                      openValueMapper: (ChartModel sales, _) =>
                                          sales.open,
                                      closeValueMapper: (ChartModel sales, _) =>
                                          sales.close,
                                      animationDuration: 55)
                                ],
                              ),
                  ),
                  SizedBox(
                    height: myHeight * 0.01,
                  ),
                  Center(
                    child: Container(
                      height: myHeight * 0.03,
                      child: ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: text.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                EdgeInsets.symmetric(horizontal: myWidth * 0.02),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  textBool = [
                                    false,
                                    false,
                                    false,
                                    false,
                                    false,
                                    false
                                  ];
                                  textBool[index] = true;
                                });
                                setDays(text[index]);
                                getChart();
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: myWidth * 0.03,
                                    vertical: myHeight * 0.005),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: textBool[index] == true
                                      ? Color(0xffFBC700).withOpacity(0.3)
                                      : Colors.transparent,
                                ),
                                child: Text(
                                  text[index],
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: myHeight * 0.04,
                  ),
      
                  FutureBuilder(
                                future: newsController.fetchData(widget.selectItem.id),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return CircularProgressIndicator(); // Display loading indicator while waiting for data
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (newsController.NewsData.isNotEmpty) {
                                    // If data is available, display it
                                    return 
                  Expanded(
                      child: 
                      
                      
                      
                      
                      ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: myWidth * 0.06),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'News',
                              style: TextStyle(fontSize: 25),
                            ),
                            Text(
                              newsController.NewsData[0].date,
                              style: TextStyle(color: Colors.grey, fontSize: 17),
                            ),
                          ],
                        ),

                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: myWidth * 0.06,
                            vertical: myHeight * 0.01),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: 
                                   Text(
                                          newsController.NewsData[0].articleSummary,
                                          textAlign: TextAlign.justify,
                                          style: TextStyle(color: Colors.grey, fontSize: 17),
                                        ),                                  
                                ),
                             
      
                                Container(
                                  width: myWidth * 0.25,
                                  child: CircleAvatar(
                                    radius: myHeight * 0.04,
                                    backgroundImage:
                                        NetworkImage(newsController.NewsData[0].img),
                                  ),
                                )
                              
                              ],
                            ),
                            Text(newsController.NewsData[0].sentiment,
                            style: TextStyle(
                              color:
                               newsController.NewsData[0].sentiment == 'negative'
            ? Colors.red
            :  Colors.green,
            fontSize: 25
                                 
                            
                            ),

                            )
                          ],
                        ),
                      )
                    ],
                  )
                  
                  );
                                    
                                  } else {
                                    return Text('No data available'); // Handle case where no data is available
                                  }
                                },
                              ),
      
      
      
      
      
                ],
              )
              ),
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
      
              
              Container(
                height: myHeight * 0.1,
                width: myWidth,
                // color: Colors.amber,
                child: Column(
                  children: [
                    Divider(),
                    SizedBox(
                      height: myHeight * 0.01,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding:
                                EdgeInsets.symmetric(vertical: myHeight * 0.015),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xffFBC700)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: myHeight * 0.02,
                                ),
                                InkWell(
                                  onTap: () {
                                    print(widget.selectItem.symbol);
                                     _showInputDialog(context);
                                   
                                  },
                                  child: Text(
                                    'Add to portfolio',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                        // Expanded(
                        //   flex: 2,
                        //   child: Container(
                        //     padding:
                        //         EdgeInsets.symmetric(vertical: myHeight * 0.012),
                        //     decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(50),
                        //         color: Colors.grey.withOpacity(0.2)),
                        //     child: Image.asset(
                        //       'assets/icons/3.1.png',
                        //       height: myHeight * 0.03,
                        //       color: Colors.black,
                        //     ),
                        //   ),
                        // ),
                        SizedBox(
                          width: myWidth * 0.05,
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }

  List<String> text = ['D', 'W', 'M', '3M', '6M', 'Y'];
  List<bool> textBool = [false, false, true, false, false, false];

  int days = 30;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 90;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }

  List<ChartModel>? itemChart;

  bool isRefresh = true;

  Future<void> getChart() async {
    String url = 'https://api.coingecko.com/api/v3/coins/' +
        widget.selectItem.id +
        '/ohlc?vs_currency=usd&days=' +
        days.toString();

    setState(() {
      isRefresh = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });

    setState(() {
      isRefresh = false;
    });
    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);
      List<ChartModel> modelList =
          x.map((e) => ChartModel.fromJson(e)).toList();
      setState(() {
        itemChart = modelList;
      });
    } else {
      print(response.statusCode);
    }
  }

  void _showInputDialog(BuildContext context) async {
    double? coinsWorth;
    double? cashAtRisk;
    double? stopLoss;
    double? takeProfit;
    double coin_price=widget.selectItem.currentPrice;
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Trading Inputs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Enter coins '),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  // coinsWorth = coinsWorth;

                  coinsWorth = double.tryParse(value) ?? coinsWorth;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Cash at Risk'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  cashAtRisk = double.tryParse(value) ?? cashAtRisk;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Stop Loss'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  stopLoss = double.tryParse(value) ?? stopLoss;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Take Profit'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  takeProfit = double.tryParse(value) ?? takeProfit;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Use the entered values here
                print('Coins Worth: $coinsWorth');
                print('Cash at Risk: $cashAtRisk');
                print('Stop Loss: $stopLoss');
                print('Take Profit: $takeProfit');

                Navigator.of(context).pop();
              },
              child: InkWell(
                onTap: () async{
          //  bool canBuy = PortfolioController.canBuyCoin(coin_price, coinsWorth);  
          //  print(canBuy);
          //  if (canBuy==true) {
                
                await PortfolioController.getCoins(widget.selectItem.id);
                 print(widget.selectItem.id);
                var user = FirebaseAuth.instance.currentUser;
                String uid=user!.uid;
                PortfolioController.addItem(widget.selectItem.id,coinsWorth,cashAtRisk,stopLoss,takeProfit);
                print("-------------------------");
                print(coinsWorth);
                await PortfolioController.fetchUserData();
                apiController.startBot(tickerSymbol: widget.selectItem.symbol, initialBalance:PortfolioController.liquidity.value , amount: coinsWorth, uid: uid);
                Navigator.of(context).pop(); 

            // } 
            // else {
            //     ScaffoldMessenger.of(context).showSnackBar(
            //     SnackBar(
            //       content: Text('No enough Balance'),
            //       duration: Duration(seconds: 2),
            //     ),
                
            //   );
            //                   Navigator.of(context).pop(); 

              
            // }
              //   await PortfolioController.getCoins(widget.selectItem.id);
                
              //  PortfolioController.addItem(widget.selectItem.id,coinsWorth,cashAtRisk,stopLoss,takeProfit);
              
              //   Navigator.of(context).pop();     
                },
                child: Text('Submit')),
            ),
          ],
        );
      },
    );
  }
}
