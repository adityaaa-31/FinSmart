import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/sms.dart';
import 'package:pie_chart/pie_chart.dart';

import 'models/Transaction.dart';

class ChartPage extends StatefulWidget {
  final double totalCreditAmount;
  final double totalDebitAmount;
  final Map<String, double> categoryData;
  final List<Transaction> transactions; // Include transactions as a parameter

  ChartPage(
      {required this.totalCreditAmount,
      required this.totalDebitAmount,
      required this.categoryData,
      required this.transactions});

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late double totalCreditAmount;
  late double totalDebitAmount;
  late Map<String, double> categoryData;
  late Map<String, double> bankData;
  late Map<String, double> paymentAppData;
  late List<Transaction> transactions;

  @override
  void initState() {
    super.initState();
    totalCreditAmount = widget.totalCreditAmount;
    totalDebitAmount = widget.totalDebitAmount;
    categoryData = widget.categoryData;
    transactions = widget.transactions;
    bankData = _getBankData(transactions);
    paymentAppData = _getPaymentAppData(transactions);
  }

  Map<String, double> _getBankData(List<Transaction> transactions) {
    Map<String, double> bankData = {};

    for (Transaction transaction
        in transactions.where((t) => t.category != null)) {
      String bank = transaction.bank ?? 'Unknown Bank';
      bankData[bank] = (bankData[bank] ?? 0) + double.parse(transaction.amount);
    }

    return bankData;
  }

  Map<String, double> _getPaymentAppData(List<Transaction> transactions) {
    Map<String, double> paymentAppData = {};

    for (Transaction transaction
        in transactions.where((t) => t.category != null)) {
      String paymentApp = transaction.paymentApp ?? 'Unknown Payment App';
      paymentAppData[paymentApp] =
          (paymentAppData[paymentApp] ?? 0) + double.parse(transaction.amount);
    }

    return paymentAppData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Chart'),
        backgroundColor: Colors.lightGreen,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 45),
              PieChart(
                dataMap: {
                  'Credit': totalCreditAmount,
                  'Debit': totalDebitAmount,
                },
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32.0,
                chartRadius: 250,
                colorList: const [
                  Colors.green,
                  Colors.red,
                ],
                initialAngleInDegree: 0,
                chartType: ChartType.ring,
                ringStrokeWidth: 32,
                centerText: 'Total',
                legendOptions: const LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                ),
              ),
              const SizedBox(height: 40),
              PieChart(
                dataMap: categoryData,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: 300,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                legendOptions: const LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
              const SizedBox(height: 40),
              // New pie chart for bank data
              PieChart(
                dataMap: bankData,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: 300,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                legendOptions: const LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
              const SizedBox(height: 40),
              PieChart(
                dataMap: paymentAppData,
                animationDuration: const Duration(milliseconds: 800),
                chartLegendSpacing: 32,
                chartRadius: 300,
                chartType: ChartType.disc,
                ringStrokeWidth: 32,
                legendOptions: const LegendOptions(
                  showLegendsInRow: true,
                  legendPosition: LegendPosition.bottom,
                  showLegends: true,
                  legendTextStyle: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                chartValuesOptions: const ChartValuesOptions(
                  showChartValueBackground: true,
                  showChartValues: true,
                  showChartValuesInPercentage: false,
                  showChartValuesOutside: false,
                  decimalPlaces: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
