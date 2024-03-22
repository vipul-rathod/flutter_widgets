import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanBarcode extends StatefulWidget {
  const ScanBarcode({super.key});

  @override
  State<ScanBarcode> createState() => _ScanBarcodeState();
}

class _ScanBarcodeState extends State<ScanBarcode> {
  String result = 'Hey there';
  String scanResult = '';
  Future<void> scanBarcode() async {
    try {
      final qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult.rawContent;
      });
    } on PlatformException catch(ex){
      setState(() {
        result = '$ex';
      });
    } catch (ex){
      setState(() {
        result = '$ex';
      });
    }

    // var result = await BarcodeScanner.scan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code data'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: scanBarcode,
          ),
        ],
      ),
      body: Text('Scan results are: $result'),
    );
  }
}
