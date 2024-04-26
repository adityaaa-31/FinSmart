import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../models/Transaction.dart';

Future<void> exportTransactionsToCSV(List<Transaction> transactions) async {
 try {
    // Determine the directory path based on the platform
    Directory? directory;
    if (kIsWeb) {
      // Web platform is not supported for this operation
      print("Web platform does not support saving files to Downloads directory.");
      return;
    } else if (Platform.isIOS) {
      // For iOS, use the application documents directory as a fallback
      directory = await getApplicationDocumentsDirectory();
    } else {
      // For Android, attempt to use the external storage directory
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        // Fallback to the external storage directory if the default download folder does not exist
        directory = await getExternalStorageDirectory();
      }
    }

    // Construct the file path
    final String filePath = '${directory!.path}/transactions.csv';
    
    // Create the file if it doesn't exist
    final File file = File(filePath);
    if (!await file.exists()) {
      await file.create();
    }
    
    // Open the file in write mode
    final IOSink sink = file.openWrite(mode: FileMode.write);
    
    // Write the CSV header
    sink.write('Title,Amount,Date,Category\n');
    
    // Write each transaction to the file as a CSV row
    for (var transaction in transactions) {
      // Ensure each field is properly escaped to handle commas and newlines in the data
      final String title = transaction.title.replaceAll(',', '\\,');
      final String amount = transaction.amount.toString(); // Assuming amount is a number
      final String date = transaction.date;
      final String category = transaction.category?.replaceAll(',', '\\,') ?? 'Unknown';
      
      sink.write('$title,$amount,$date,$category\n');
    }
    
    // Close the file
    await sink.flush();
    await sink.close();
    
    // Optionally, you can use a more user-friendly way to show the export success message
    print('Transactions exported to $filePath');
 } catch (e) {
    print('Error exporting transactions: $e');
 }
}
