import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

class ChartPage extends StatefulWidget {
  final double totalCreditAmount;
  final double totalDebitAmount;
  final Map<String, double> categoryData;

  ChartPage({
    required this.totalCreditAmount,
    required this.totalDebitAmount,
    required this.categoryData,
  });

  @override
  _ChartPageState createState() => _ChartPageState();
}

class _ChartPageState extends State<ChartPage> {
  late double totalCreditAmount;
  late double totalDebitAmount;
  late Map<String, double> categoryData;
//   Map<String, double> categoryMap = {
//   'Food': 0,
//   'Shopping': 2500,
//   'Transportation': 800,
//   'Entertainment': 500,
//   'Bills': 3000,
//   'Others': 1000,
// };

  @override
  void initState() {
    super.initState();
    totalCreditAmount = widget.totalCreditAmount;
    totalDebitAmount = widget.totalDebitAmount;
    categoryData = widget.categoryData;
  }

  // void updateCategoryData(Map<String, double> newCategoryData) {
  //   setState(() {
  //     categoryData = newCategoryData;
  //   });
  // }

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
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 45),
            PieChart(
              dataMap: {
                'Credit': totalCreditAmount,
                'Debit': totalDebitAmount,
              },
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
          ],
        ),
      ),
    );
  }
}
