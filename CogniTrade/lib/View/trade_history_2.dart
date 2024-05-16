import 'package:flutter/material.dart';



class Trade {
  final String description;

  Trade(this.description);
}

class TradeHistoryScreen extends StatefulWidget {
  @override
  _TradeHistoryScreenState createState() => _TradeHistoryScreenState();
}

class _TradeHistoryScreenState extends State<TradeHistoryScreen> {
  final List<Trade> tradeHistory = [
    Trade('Trade 1'),
    Trade('Trade 2'),
    Trade('Trade 3'),
  ];

  final double totalBalance = 10000;
  final double totalProfitLoss = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trade History'),
        backgroundColor: Colors.yellow,
      ),
      body: Container(
        color: Colors.yellow[50],
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: tradeHistory.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(tradeHistory[index].description),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Balance: $totalBalance',
                    style: TextStyle(fontSize: 18),
                  ),
                  Text(
                    'Total Profit/Loss: $totalProfitLoss',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

