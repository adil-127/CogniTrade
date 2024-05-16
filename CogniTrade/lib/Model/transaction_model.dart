class TransactionModel {
   String? action;
   String? date;
   String? ticker="";
   double? amount;
   double? Price;

  TransactionModel({
    required this.action,
    required this.date,
    // this.coin,
    required this.amount,
    required this.Price,
    required this.ticker
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      action: json['Action'] ,
      date: json['date'] ?? '',
      // coin: json['coin'] ?? '',
      amount: json['coin_amount'] ,
      Price:json['Price']?? 0.00,
      ticker: json['ticker']?? ''
    );
  }
}
