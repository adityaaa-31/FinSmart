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

  // _ChartPageState(){
  //   tC = widget.totalCreditAmount;
  //   tD = widget.totalDebitAmount;
  // }

  Map<String, double> dataMap = {
    "Credit": 4000,
    "Debit": 3000,
  };
  //
  // var datamap = new Map();
  //
  // datamap['Credit'] = tC;




  @override
  Widget build(BuildContext context) {

    dataMap['Debit'] = widget.totalCreditAmount;
    dataMap['Credit'] = widget.totalDebitAmount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Chart'),
          backgroundColor: Colors.lightGreen,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(10),
              bottomRight: Radius.circular(10),
            ),
          )
      ),
      body: Center(
        child: PieChart(
          dataMap: dataMap,
          animationDuration: Duration(milliseconds: 800),
          chartLegendSpacing: 32.0,
          chartRadius:200,
          colorList: [
            Colors.green,
            Colors.red,
          ],
          initialAngleInDegree: 0,
          chartType: ChartType.ring,
          ringStrokeWidth: 32,
          centerText: "Total",
          legendOptions: LegendOptions(
            showLegendsInRow: false,
            legendPosition: LegendPosition.right,
            showLegends: true,
            legendTextStyle: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          chartValuesOptions: ChartValuesOptions(
            showChartValueBackground: true,
            showChartValues: true,
            showChartValuesInPercentage: false,
            showChartValuesOutside: false,
          ),
        ),
      ),
    );
  }
}
