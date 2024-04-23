import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/visualize.dart';
import 'package:uuid/uuid.dart';
import 'models/Transaction.dart';

class Home_Page extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home_Page> {
  List<Transaction> transactions = [];
  List<SmsMessage> messages = [];
  double totalDebitAmount = 0;
  double totalCreditAmount = 0;
  bool isTransactionsFiltered = false;
  List<String> categories = [
    'Food',
    'Shopping',
    'Transportation',
    'Entertainment',
    'Bills',
    'Others'
  ];
  String selectedCategory = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    importMessages();
  }

  void importMessages() async {
    var permissions = await Permission.sms.status;

    if (!permissions.isGranted) {
      await Permission.sms.request();
    } else {
      if (!isTransactionsFiltered) {
        getSms();
      }
    }
  }

  void getSms() {
    SmsQuery().getAllSms.then((value) {
      setState(() {
        messages = value;
        filterTransactions();
        isTransactionsFiltered = true;
      });
    });
  }

  void filterTransactions() {
    var uuid = const Uuid();

    final regExpDate =
        RegExp(r'\d{1,2}[-/]\d{1,2}[-/]\d{2}|\d{1,2}[-/]\d{1,2}[-/]\d{4}');
    RegExp regExpCred = RegExp(r"(?:INR\.*|Rs)\s*(\d+(?:\.\d*)?)");

    for (SmsMessage message in messages) {
      if (message.body!.contains('credited') ||
          message.body!.contains('debited')) {
        List<String> parts = message.body!.split(' ');

        List importedIds = transactions.map((t) => t.id).toList();

        RegExpMatch? match1 = regExpCred.firstMatch(message.body.toString());

        final matchDate = regExpDate.allMatches(message.body.toString());
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

          if (!importedIds.contains(transactionId)) {
            String dateText =
                matchDate != null ? matchDate.first.group(0)! : '';

            addTransactions(
                transactionId,
                title,
                transactionId,
                selectedCategory,
                amountCredit.toString(),
                totalDebitAmount.toString(),
                totalCreditAmount.toString(),
                dateText.toString());

            print('Transaction id: $transactionId has $amountCredit');
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

  void addTransactions(
      String total,
      String title,
      String transactionId,
      String category,
      String amount,
      String totalCreditAmount,
      String totalDebitAmount,
      String date) {
    transactions.add(Transaction(
        total: total,
        title: title,
        amount: amount,
        id: transactionId,
        date: date,
        totalCredit: totalCreditAmount,
        totalDebit: totalDebitAmount));
  }

  void _showCategorySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: Container(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(categories[index]),
                  onTap: () {
                    selectedCategory = categories[index];
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('${categories[index]} selected'),
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      // Index 1 corresponds to the Chart tab
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChartPage(
            totalCreditAmount: totalCreditAmount,
            totalDebitAmount: totalDebitAmount,
          ),
        ),
      );
    }
  }

  // Method to build the widget tree for displaying transactions
  Widget _buildTransactionList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 100,
                width: 380,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount Credited is: ${totalCreditAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.abel(
                          fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                    Text(
                      '  Total Amount Debited is: ${totalDebitAmount.toStringAsFixed(2)}',
                      style: GoogleFonts.abel(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
          Container(
            decoration: const BoxDecoration(),
            height: 670,
            width: 500,
            child: isTransactionsFiltered
                ? ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: _showCategorySelectionDialog,
                        child: Card(
                          elevation: 12,
                          child: ListTile(
                            title: Text(
                              transactions[index].title,
                              style: GoogleFonts.abel(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            subtitle: Row(
                              children: [
                                Text(
                                  transactions[index].date,
                                  style: GoogleFonts.abel(
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                Text(
                                  'Category',
                                  style: GoogleFonts.abel(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            trailing: Text(
                              transactions[index].amount.toString(),
                              style:
                                  GoogleFonts.abel(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          _buildTransactionList(), // Calling the method to build transaction list
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Chart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
