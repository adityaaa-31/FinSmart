import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/sms.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'models/Transaction.dart';
import 'visualize.dart';

class Home_Page extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<Home_Page> {
  bool isTransactionsFiltered = false;
  List<String> categories = [
    'Food',
    'Shopping',
    'Transportation',
    'Entertainment',
    'Bills',
    'Others'
  ];
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
            categoryData: categoryData,
          ),
        ),
      );
    }
  }

  void _updateCategoryData(String selectedCategory, double amount) {
    categoryData[selectedCategory] = categoryData[selectedCategory]! + amount;
  }

  void _showCategorySelectionDialog(Transaction transaction) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Category'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: categories.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(categories[index]),
                  onTap: () {
                    setState(() {
                      selectedCategory = categories[index];
                    });
                    _updateCategoryData(
                        selectedCategory, double.parse(transaction.amount));
                    Fluttertoast.showToast(
                      msg: '${categories[index]} selected',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.white,
                      textColor: Colors.black,
                      fontSize: 16.0,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildTransactionList(),
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
                        onTap: () =>
                            _showCategorySelectionDialog(transactions[index]),
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
}
