import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/Model/card_detail.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CardController extends GetxController {
  var cardDetails = CardDetails(
    cardNumber: '',
    expiryDate: '',
    cvv: '',
    amount: 0.0,
  ).obs;

  

  void updateAmount(double newAmount) {
    cardDetails.update((val) {
      val!.amount = newAmount;
    });
  }

  void updatecardNumber(String value) {
    cardDetails.update((val) {
      val!.cardNumber = value;
    });
  }
  void updateexpiryDate(String value) {
    cardDetails.update((val) {
      val!.expiryDate = value;
    });
  }
  void updatecvv(String value) {
    cardDetails.update((val) {
      val!.cvv = value;
    });
  }

 Future<void> fetchCardDetails() async {
   var user = FirebaseAuth.instance.currentUser;
      String uid=user!.uid;
    final collectionReference = FirebaseFirestore.instance.collection('users');
    final documentSnapshot = await collectionReference.doc(uid).get();

    if (documentSnapshot.exists) {
      final data = documentSnapshot.data() as Map<String, dynamic>;
      cardDetails.value = CardDetails(
        cardNumber: data['cardNumber'] ?? '',
        expiryDate: data['expiryDate'] ?? '',
        cvv: data['cvv'] ?? '',
        amount: (data['totalamount'] ?? 0.0).toDouble(),
      );
    } else {
      print('Document does not exist');
    }
  }








Future saveCardDetails() async {
  
      var user = FirebaseAuth.instance.currentUser;
      String uid=user!.uid;
    try {
      final cardNumber = cardDetails.value.cardNumber;
      final amount = cardDetails.value.amount;
      final expiryDate = cardDetails.value.expiryDate;
      final cvv = cardDetails.value.cvv;

      // Reference to the Firestore collection
      final collectionReference = FirebaseFirestore.instance.collection('users');

      // Reference to the document with the specified UID
      final documentReference = collectionReference.doc(uid);

      // Store card details inside the document
      // change to update
      await documentReference.update({
        'cardNumber': cardNumber,
        'totalamount': amount,
        'expiryDate': expiryDate,
        'cvv': cvv,
        'liquidity':amount,
        'Portfolio':0
      });

      print('Card details saved successfully.');
    } catch (e) {
      print('Error saving card details: $e');
    }
  }



 
}
