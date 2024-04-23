import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ChartPage extends StatefulWidget {
  double totalCreditAmount;
  double totalDebitAmount;
  ChartPage({required this.totalCreditAmount, required this.totalDebitAmount});

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  double tC = 0;
  double tD = 0;

  @override
  void initState() {
    super.initState();
    tC = widget.totalCreditAmount ?? 0.0;
    tD = widget.totalDebitAmount ?? 0.0;
  }

  Map<String, double> dataMap = {
    "Credit": 4000,
    "Debit": 3000,
  };

  Map<String, double> categoryMap = {
  'Food': 20,
  'Shopping': 30,
  'Transportation': 15,
  'Entertainment': 10,
  'Bills': 20,
  'Others': 5,
};

  @override
  Widget build(BuildContext context) {
    dataMap['Debit'] = widget.totalDebitAmount;
    dataMap['Credit'] = widget.totalCreditAmount;

    return Scaffold(
      appBar: AppBar(
          title: const Text('Your Chart'),
          backgroundColor: Colors.lightGreen,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          )),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 45,
            ),
            PieChart(
              dataMap: dataMap,
              animationDuration: const Duration(milliseconds: 800),
              chartLegendSpacing: 32.0,
              chartRadius: 250,
              colorList: [
                Colors.green,
                Colors.red,
              ],
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              centerText: "Total",
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
            const SizedBox(
              height: 40,
            ),
            PieChart(
              dataMap: categoryMap,
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
            )
          ],
        ),
      ),
    );
  }
}
