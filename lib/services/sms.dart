import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/models/Transaction.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:uuid/uuid.dart';

List<Transaction> transactions = [];
List<SmsMessage> messages = [];
double totalDebitAmount = 0;
double totalCreditAmount = 0;
String selectedCategory = '';
Map<String, double> categoryData = {
  'Food': 0,
  'Shopping': 0,
  'Transportation': 0,
  'Entertainment': 0,
  'Bills': 0,
  'Others': 0,
};

void addTransactions(
    String total,
    String title,
    String transactionId,
    String category,
    String amount,
    String totalCreditAmount,
    String totalDebitAmount,
    String date,
    String bankName) {
  transactions.add(Transaction(
      total: total,
      title: title,
      amount: amount,
      id: transactionId,
      date: date,
      totalCredit: totalCreditAmount,
      totalDebit: totalDebitAmount,
      bank: bankName));
}

List<String> extractBankName(SmsMessage message) {
  List<String> matchingBanks = [];
  for (String bankName in bankNames) {
    if (message.body!.contains(bankName)) {
      matchingBanks.add(bankName);
    }
  }
  return matchingBanks.isNotEmpty ? matchingBanks : ['Select Bank'];
}

void filterTransactions() {
  var uuid = const Uuid();

  final regExpDate = RegExp(
      r'(?<day>\d{1,2})[-/](?<month>\d{1,2})[-/](?<year>\d{2}(?:\d{2})?)');
  final RegExp regExpCred = RegExp(r"(?:INR\.*|Rs)\s*(\d+(?:\.\d*)?)");

  for (SmsMessage message in messages) {
    if (message.body!.contains('credited') ||
        message.body!.contains('debited')) {
      List<String> parts = message.body!.split(' ');

      List importedIds = transactions.map((t) => t.id).toList();

      RegExpMatch? match1 = regExpCred.firstMatch(message.body.toString());

      final matchDate = regExpDate.allMatches(message.body.toString()).toList();
      String title = "";

      title = parts.toString().contains('credited')
          ? "Amount Credited"
          : "Amount Debited";

      if (match1 != null) {
        String? amountCreditText = match1.group(0);

        double amountCredit = double.parse(amountCreditText!
            .replaceAll('INR.', '')
            .replaceAll('INR', '')
            .replaceAll('Rs', ''));

        String transactionId = uuid.v4().toString();
        String bankName = extractBankName(message)
            .first; // Extract the first bank name from the list

        if (!importedIds.contains(transactionId)) {
          String dateText =
              matchDate.isNotEmpty ? matchDate.first.group(0)! : '';

          addTransactions(
              transactionId,
              title,
              transactionId,
              selectedCategory.toString(),
              amountCredit.toString(),
              totalDebitAmount.toString(),
              totalCreditAmount.toString(),
              dateText.toString(),
              bankName);

          print(
              'Transaction id: $transactionId has $amountCredit  with $dateText');
        }
      }
    } //credit/debit
  } //message iteration

  // Calculate total amounts after processing all messages
  totalCreditAmount = transactions
      .where((transaction) => transaction.title == "Amount Credited")
      .map((transaction) => double.parse(transaction.amount))
      .fold(0, (prev, amount) => prev + amount);

  totalDebitAmount = transactions
      .where((transaction) => transaction.title == "Amount Debited")
      .map((transaction) => double.parse(transaction.amount))
      .fold(0, (prev, amount) => prev + amount);

  print('Total Credit Amount: $totalCreditAmount');
  print('Total Debit Amount: $totalDebitAmount');
}
