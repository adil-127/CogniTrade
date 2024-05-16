import 'package:chart_sparkline/chart_sparkline.dart';
import 'package:crypto/View/home.dart';
import 'package:crypto/View/tradehistory.dart';
// import 'package:crypto/View/trade_history.dart';
import 'package:crypto/controllers/card_controller.dart';
import 'package:crypto/controllers/portfolio_coin_controller.dart';
import 'package:crypto/controllers/transaction_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Item extends StatelessWidget {
  var item;
  var Portfolio_detail;
  Item({this.item,this.Portfolio_detail});
  
  CardController cardController=Get.put(CardController());
  PortfolioCoinController PortfolioController =Get.put(PortfolioCoinController());
  TransactionController transController= Get.put(TransactionController());
  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: myWidth * 0.06, vertical: myHeight * 0.02),
      child: Container(
        child: InkWell(
          onTap: () async{
              await transController.fetchTransactions(item.symbol);
               Get.to(TradeHistory());
             
          },
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                    height: myHeight * 0.05, child: Image.network(item.image)),
              ),
              SizedBox(
                width: myWidth * 0.02,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.id,
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      Portfolio_detail.amount.toString() + item.symbol,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: myWidth * 0.01,
              ),
              // Expanded(
              //   flex: 2,
              //   child: Container(
              //     height: myHeight * 0.05,
              //     // width: myWidth * 0.2,
              //     child: Sparkline(
              //       data: item.sparklineIn7D.price,
              //       lineWidth: 2.0,
              //       lineColor: item.marketCapChangePercentage24H >= 0
              //           ? Colors.green
              //           : Colors.red,
              //       fillMode: FillMode.below,
              //       fillGradient: LinearGradient(
              //           begin: Alignment.topCenter,
              //           end: Alignment.bottomCenter,
              //           stops: const [0.0, 0.7],
              //           colors: item.marketCapChangePercentage24H >= 0
              //               ? [Colors.green, Colors.green.shade100]
              //               : [Colors.red, Colors.red.shade100]),
              //     ),
              //   ),
              // ),
              SizedBox(
                width: myWidth * 0.04,
              ),
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$ ' + item.currentPrice.toString(),
        
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        // Text(
                        //   item.priceChange24H.toString().contains('-')
                        //       ? "-\$" +
                        //           item.priceChange24H
                        //               .toStringAsFixed(2)
                        //               .toString()
                        //               .replaceAll('-', '')
                        //       : "\$" + item.priceChange24H.toStringAsFixed(2),
                        //   style: TextStyle(
                        //       fontSize: 13,
                        //       fontWeight: FontWeight.normal,
                        //       color: Colors.grey),
                        // ),
                        SizedBox(
                          width: myWidth * 0.03,
                        ),
                        // Text(
                        //   item.marketCapChangePercentage24H.toStringAsFixed(2) +
                        //       '%',
                        //   style: TextStyle(
                        //       fontSize: 10,
                        //       fontWeight: FontWeight.normal,
                        //       color: item.marketCapChangePercentage24H >= 0
                        //           ? Colors.green
                        //           : Colors.red),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
              InkWell(
                onTap: () async{
               
                },
                child: Icon(Icons.add))
            ],
          ),
        ),
      ),
    );
  }
   void _showInputDialog(BuildContext context) async {
    double? coinsWorth;
    double? cashAtRisk;
    double? stopLoss;
    double? takeProfit;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Trading Inputs'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Coins Worth'),
                keyboardType: TextInputType.number,
                onChanged: (value) {
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
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
