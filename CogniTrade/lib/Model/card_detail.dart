class CardDetails {
  String cardNumber;
  String expiryDate;
  String cvv;
  double amount;

  CardDetails({
    required this.cardNumber,
    required this.expiryDate,
    required this.cvv,
    required this.amount,
  });

  factory CardDetails.fromMap(Map<String, dynamic> map) {
    return CardDetails(
      cardNumber: map['cardNumber'],
      expiryDate: map['expiryDate'],
      cvv: map['cvv'],
      amount: map['amount']?.toDouble() ?? 0.0,
    );
  }
}
