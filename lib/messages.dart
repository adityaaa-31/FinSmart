
// import 'dart:js_util';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
// import 'package:flutter_titled_container/flutter_titled_container.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:intl/intl.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'dart:developer';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_application_1/visualize.dart';

class Home_Page extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home_Page> {
  List<Transaction> transactions = [];
  List<SmsMessage> messages = [];


  double totalDebitAmount=0;
  double totalCreditAmount=0;

  SnackBar sb = new SnackBar(content: Text('Messages Imported'));

  List<String> categories = [
    'Food',
    'Shopping',
    'Transportation',
    'Entertainment',
    'Bills',
    'Others',
  ];
  String selectedCategory='';


  void getSms() {
    //super.initState();
    // Load the SMS messages
    SmsQuery().getAllSms.then((value) {
      setState(() {
        messages = value;
      });
      filterTransactions();
    });
  }

  void filterTransactions() async {
    // Filter the transactions from the messages
    final regExpDate = RegExp(r'\d{1,2}[-/]\d{1,2}[-/]\d{2}|\d{1,2}[-/]\d{1,2}[-/]\d{4}');
    final regExpDate2 = RegExp(r'\d{1,2}[-/]\d{1,2}[-/]\d{4}');
    //RegExp regExp = RegExp(r"\b\d+\.\d+\b");
    RegExp regExpCred = RegExp(r"(?:INR\.*|Rs)\s*(\d+(?:\.\d*)?)");
    RegExp regExp1 = RegExp(r"(?:Rs\.?|INR)\s*(\d+(?:[.,]\d+)*)|(\d+(?:[.,]\d+)*)\s*(?:Rs\.?|INR)");

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // List<String> importedId = prefs.getStringList('importedIds') ?? [];


    for (SmsMessage message in messages) {

       totalDebitAmount = 0;
       totalCreditAmount = 0;

      if (message.body!.contains('credited') || message.body!.contains('debited')) {

        List<String> parts = message.body!.split(' ');

        List importedIds = transactions.map((t) => t.id).toList();

       // RegExpMatch? match = regExp.firstMatch(message.body.toString());
        RegExpMatch? match1 = regExpCred.firstMatch(message.body.toString());

        final matchDate = regExpDate.allMatches(message.body.toString());
        final matchDate2 = regExpDate2.allMatches(message.body.toString());

        String title = "";

        if(parts.toString().contains('credited')){
          title = "Amount Credited";
        }else{
          title = "Amount Debited";
        }

        if(match1 != null) {
          //String? amountDebitText = match.group(0);
          String? amountCreditText = match1.group(0);

          double amountCredit = double.parse(amountCreditText!.replaceAll('INR.', '').replaceAll('INR','').replaceAll('Rs', ''));

          for (Transaction transaction in transactions) {
            if (transaction.title == "Amount Credited") {
              totalCreditAmount += double.parse(transaction.amount);
            } else if (transaction.title == "Amount Debited") {
              totalDebitAmount += double.parse(transaction.amount);
            }
          }

          // if(parts.toString().contains('credited')){
          //   // title = "Amount Credited";
          //   totalCreditAmount += amountCredit;
          // }else{
          //   totalDebitAmount += amountCredit;
          // }




          //inspect(totalCreditAmount);

          //String category = parts[2];



          //DateFormat format = DateFormat('dd-MM-yy');
          String transactionId = message.address! + amountCreditText;

          if (!importedIds.contains(transactionId)) {

            String dateText = matchDate != null ? matchDate.first.group(0)! : '';

            // if(parts.toString().contains('credited')){
            //   dateText = matchDate != null ? matchDate.first.group(0)! : '';
            // }else{
            //   dateText = matchDate2 != null ? matchDate2.first.group(0)! : '';
            //
            // }

            //DateTime date = DateTime.parse(dateText);
           // String formatted = format.format(date);
           //  transactions.add(
           //      Transaction(
           //        id: transactionId,
           //        title: title,
           //        category: selectedCategory,
           //        amount: amountCredit.toString(),
           //        date: dateText,
           //        total: '88',
           //        totalDebit: totalDebitAmount.toStringAsFixed(1),
           //        totalCredit: totalCreditAmount.toStringAsFixed(1),
           //      ));

                addTransactions('77',title,transactionId,selectedCategory,amountCredit.toString(),totalDebitAmount.toString(),totalCreditAmount.toString(),dateText.toString());

            //final DatabaseReference databaseReference = FirebaseDatabase.instance.ref();


            // transactions.forEach((transaction) {
            //   databaseReference.child("transactions").push().set({
            //     "description": transaction.title,
            //     "amount": transaction.amount,
            //     "date": transaction.date,
            //     // add any other fields you want to store
            //   });
            // });

            //await prefs.setStringList('importedIds', importedId);
          } else {
            //ScaffoldMessenger.of(context).showSnackBar(sb);
          }//transaction
        }//match
        print('$totalCreditAmount');
        print('$totalDebitAmount');
      }//credit/debit
    }//message iteration

  }

  void importMessages() async {

    var permissions = await Permission.sms.status;

    if(!permissions.isGranted) {
      await Permission.sms.request();
    }
    else{
      getSms();
      filterTransactions();
    }

  }

  void calculate(){

  }

  void _showCategorySelectionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Category'),
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

  void addTransactions(String total,String title, String transactionId, String category, String amount, String totalCreditAmount, String totalDebitAmount, String date){
    transactions.add(
        Transaction(
            total: total,
            title: title,
            amount: amount,
            id: transactionId,
            date: date,
            totalCredit: totalCreditAmount,
            totalDebit: totalDebitAmount));
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 20,),
              SizedBox(
                // decoration: const BoxDecoration(
                //
                // ),
                height: 100,
                width: 380,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Total Amount Credited is: $totalDebitAmount',
                      style: GoogleFonts.abel(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.justify,
                    ),
                    Text('  Total Amount Debited is: $totalCreditAmount',
                    style:  GoogleFonts.abel(fontSize: 25, fontWeight: FontWeight.bold),)
                  ],
                ),
              ),



            ],
          ),
          Container(
            decoration: const BoxDecoration(
              //border: Border.all(color: Colors.black)
            ),
            height: 670,
            width: 500,
            child: ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    elevation: 12,
                    //color: Colors.lightGreen,
                    child: ListTile(
                      title: Text(transactions[index].title,
                      style: GoogleFonts.abel(fontWeight: FontWeight.bold, fontSize: 18),
                      ),

                      subtitle: Row(
                        children: [
                          Text(transactions[index].date,
                          style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                          ),

                          SizedBox(width: 20,),

                          Text('Category',
                            style: GoogleFonts.abel(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      trailing: Text(transactions[index].amount.toString(),
                      style: GoogleFonts.abel(fontWeight: FontWeight.bold),),

                    ),
                  ),

                  onTap: _showCategorySelectionDialog,
                );
              },
            ),
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed:
                importMessages,
                child: Text('Import Messages'),
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  primary: Colors.green,
                ),
              ),
              SizedBox(width: 20,),
              ElevatedButton(
                onPressed:() {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ChartPage(totalCreditAmount: totalCreditAmount, totalDebitAmount: totalDebitAmount)));
                },
                child: Text('Show Graph'),
                style: ElevatedButton.styleFrom(
                  elevation: 10,
                  primary: Colors.green,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }



}

class Transaction {
  String title;
  String? category;
  String amount;
  String id;
  String date;
  String total;
  String totalCredit;
  String totalDebit;

  Transaction({required this.total, required this.title,  this.category, required this.amount, required this.id, required this.date, required this.totalCredit, required this.totalDebit});
}

