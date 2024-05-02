class Transaction {
  String title;
  String? category;
  String amount;
  String id;
  String date;
  String total;
  String totalCredit;
  String totalDebit;
  String? bank; // New field for bank
  String? paymentApp; // New field for payment app

  Transaction({
    required this.total,
    required this.title,
    this.category,
    required this.amount,
    required this.id,
    required this.date,
    required this.totalCredit,
    required this.totalDebit,
    this.bank,
    this.paymentApp,
  });
}
