import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/Transaction.dart';

Future<void> exportTransactionsToCSV(List<Transaction> transactions) async {
 try {
    Directory? directory;
    if (kIsWeb) {
      print("Web platform does not support saving files to Downloads directory.");
      return;
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    }

    final String filePath = '${directory!.path}/transactions.csv';
    
    final File file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }
    
    final IOSink sink = file.openWrite(mode: FileMode.write);
    
    sink.write('Title,Amount,Date,Category\n');
    
    for (var transaction in transactions) {
      final String title = transaction.title.replaceAll(',', '\\,');
      final String amount = transaction.amount.toString();
      final String date = transaction.date;
      final String category = transaction.category?.replaceAll(',', '\\,') ?? 'Unknown';
      
      sink.write('$title,$amount,$date,$category\n');
    }
    
    await sink.flush();
    await sink.close();
    
    print('Transactions exported to $filePath');
 } catch (e) {
    print('Error exporting transactions: $e');
 }
}
