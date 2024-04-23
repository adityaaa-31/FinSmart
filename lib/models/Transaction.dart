class Transaction {
  String title;
  String? category;
  String amount;
  String id;
  String date;
  String total;
  String totalCredit;
  String totalDebit;

  Transaction(
      {required this.total,
      required this.title,
      this.category,
      required this.amount,
      required this.id,
      required this.date,
      required this.totalCredit,
      required this.totalDebit});
}