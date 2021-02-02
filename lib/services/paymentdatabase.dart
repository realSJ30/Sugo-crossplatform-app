import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentDatabase {
  final String uid;
  PaymentDatabase({this.uid});

  final CollectionReference _paymentCollection =
      FirebaseFirestore.instance.collection('payments');

  Future postPayments({
    String uid,
    String pspreference,
    String transaction,
    double amount,
  }) async {
    return await _paymentCollection.doc(pspreference).set({
      'pspreference': pspreference,
      'user id': uid,
      'transaction type': transaction, //top up
      'amount': amount,
      'date': Timestamp.now()
    });
  }
}
