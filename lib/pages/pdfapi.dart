import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_widgets/models/models.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_internet_signal/flutter_internet_signal.dart';


class PdfApi {
  static Future<File> generatePDF({
    required Employee employee,
    required Uint8List signatureImageBytes,
  }) async {
    final document = PdfDocument();
    final page = document.pages.add();
    final pageSize = page.getClientSize();

    PdfPageTemplateElement header = PdfPageTemplateElement(Rect.fromLTWH(0, 0, pageSize.width, 100));
    header.graphics.drawString(
      "MAYKING TECHNOLOGY PVT LTD",
      PdfStandardFont(
        PdfFontFamily.helvetica, 20,
        style: PdfFontStyle.bold
      ),
      bounds: Rect.fromLTWH(pageSize.width/5, 10, 0, 0)
    );

    document.template.top = header;

    drawGrid(employee, page);
    drawSignature(employee, page, signatureImageBytes);

    return saveFile(document, employee);
  }

  static void drawGrid(Employee employee, PdfPage page){
    final grid = PdfGrid();
    grid.columns.add(count: 7);

    final headerRow = grid.headers.add(1)[0];
    headerRow.style.backgroundBrush = PdfSolidBrush(PdfColor(68, 114, 196));
    headerRow.style.textBrush = PdfBrushes.white;
    headerRow.cells[0].value = 'ID';
    headerRow.cells[1].value = 'Employee Name';
    headerRow.cells[2].value = 'Date Of Birth';
    headerRow.cells[3].value = 'Telephone No.';
    headerRow.cells[4].value = 'Email ID';
    headerRow.cells[5].value = 'Experience Level';
    headerRow.cells[6].value = 'Gender';
    
    headerRow.style.font =
      PdfStandardFont(PdfFontFamily.helvetica, 10, style: PdfFontStyle.bold);

    final row = grid.rows.add();
    row.cells[0].value = employee.id.toString();
    row.cells[1].value = employee.name;
    row.cells[2].value = employee.dob;
    row.cells[3].value = employee.phone;
    row.cells[4].value = employee.email;
    row.cells[5].value = employee.expLevel;
    row.cells[6].value = employee.gender;

    grid.applyBuiltInStyle(PdfGridBuiltInStyle.listTable4Accent5);

    for (int i=0; i<headerRow.cells.count; i++){
      headerRow.cells[i].style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
    }

    for (int i=0; i<grid.rows.count; i++){
      final row = grid.rows[i];
      for (int j=0; j<row.cells.count; j++){
        final cell = row.cells[j];
        cell.style.cellPadding = PdfPaddings(bottom: 5, left: 5, right: 5, top: 5);
      }
    }

    grid.draw(
      page: page,
      bounds: const Rect.fromLTWH(0, 80, 0, 0),
    );
  }

  static void drawSignature(Employee employee, PdfPage page, Uint8List signatureImageBytes){
    final pageSize = page.getClientSize();
    final PdfBitmap image = PdfBitmap(signatureImageBytes);

    const signatureText = 'Applicant Signature';

    page.graphics.drawString(
      signatureText,
      PdfStandardFont(PdfFontFamily.helvetica, 12),
      format: PdfStringFormat(),
      bounds: Rect.fromLTWH(pageSize.width-120, pageSize.height-250, 0, 0)
    );

    page.graphics.drawImage(
      image,
      Rect.fromLTWH(pageSize.width-120, pageSize.height-200, 100, 40)
    );
  }

  static Future<File> saveFile(PdfDocument document, Employee employee) async {
    Directory? directory;
    if (Platform.isAndroid){
      directory = await getExternalStorageDirectory();
    }
    else if (Platform.isIOS){
      final tmpDirectoryPath = await getApplicationDocumentsDirectory();
      Directory newDirectory = (tmpDirectoryPath.parent).parent;
      if (!Directory('${newDirectory.path}/test_widget/employee_pdf').existsSync()){
        directory = await Directory('${newDirectory.path}/test_widget/employee_pdf').create(recursive: true);
      }
      directory = Directory('${newDirectory.path}/test_widget/employee_pdf');
    }

    final employeePDFPath = '${directory!.path}/${employee.name}_${employee.id}_pdf';
    if (!Directory(employeePDFPath).existsSync()){
      await Directory(employeePDFPath).create(recursive: false);
    }
    else{
      await Directory(employeePDFPath).delete(recursive: true);
      await Directory(employeePDFPath).create(recursive: false);
    }
    final fileName = '$employeePDFPath/${employee.name}_${DateTime.now().toLocal()}.pdf';
    final file = File(fileName);
    file.writeAsBytes(await document.save());
    // sendEmail(fileName, employee);
    document.dispose();
    return file;
  }

  static void sendEmail(Employee employee, BuildContext context) async {
    final path = Platform.isAndroid ? await getExternalStorageDirectory() : await getApplicationDocumentsDirectory();
    final employeePDFPath = '${path!.path}/employee_pdf/${employee.name}_${employee.id}_pdf';
    if (Directory(employeePDFPath).existsSync()) {
      if (employeePDFPath.isNotEmpty){
        final fileName = await Directory(employeePDFPath).list().first;
        final body = 'Hello ${employee.name},\n\nBody of email\n\nThanks and Regards,\nMAYKING TECHNOLOGY PVT. LTD.';
        const subject = 'Subject of Email';

        if (Platform.isAndroid){
          final Email email = Email(
            body: body,
            subject: subject,
            recipients: [employee.email!],
            attachmentPaths: [fileName.path],
            isHTML: false,
          );
          await FlutterEmailSender.send(email);
        }
        else if (Platform.isIOS){
          final Email email = Email(
            body: 'Hello ${employee.name},\n\nBody of email\n\nThanks and Regards,\nMAYKING TECHNOLOGY PVT. LTD.',
            subject: 'Subject of Email',
            recipients: [employee.email!],
            attachmentPaths: [fileName.path],
            isHTML: false,
          );
          await FlutterEmailSender.send(email).onError((error, stackTrace) => 
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Failed to find mail app to send email."),
              backgroundColor: Colors.red,
            ),
          ));
        }
      }
      else{
        if (context.mounted){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("PDF file doesn't exists.\nPlease generate one to send to email."),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
    else{
      if (context.mounted){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("PDF file doesn't exists.\nPlease generate one to send to email."),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}

final class UserNetworkInfo {

  static Future<String?> getUserWifiName()  async {
    final info = NetworkInfo();
    final status = await Permission.location.request();
    if (status.isGranted){
      await Permission.location.request();
      final wifiName = await info.getWifiName();
      return wifiName;
    }
    else{
      return "Permission is not granted";
    }
  }
  static Future<String?> getUserWifiIP()  async {
    final info = NetworkInfo();
    final wifiIP = await info.getWifiIP();
    return wifiIP;
  }
  static Future<String?> getUserWifiBroadcast()  async {
    final info = NetworkInfo();
    final wifiBroadcast = await info.getWifiBroadcast();
    return wifiBroadcast;
  }
  static Future<String?> getUserWifiSubmask()  async {
    final info = NetworkInfo();
    final wifiSubmask = await info.getWifiSubmask();
    return wifiSubmask;
  }
  static Future<String?> getUserWifiGatewayIP()  async {
    final info = NetworkInfo();
    final wifiGatewayIP = await info.getWifiGatewayIP();
    return wifiGatewayIP;
  }

  static Future<dynamic> getUserInternetSignal() async {
    var signalList = {};
    final FlutterInternetSignal internetSignal = FlutterInternetSignal();
    final int? mobileSignal = await internetSignal.getMobileSignalStrength();
    final int? wifiSignal = await internetSignal.getWifiSignalStrength();
    signalList['MobileSignal'] = mobileSignal;
    signalList['WifiSignal'] = wifiSignal;
    return signalList;
  }
}

class OSInfo {
  static osVersion() async {
    if (Platform.isAndroid){
      var androidDeviceInfo = {};
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var androidModel = androidInfo.model;
      var release = androidInfo.version.release;
      var manufacturer = androidInfo.manufacturer;
      var sdkInt = androidInfo.version.sdkInt;
      androidDeviceInfo['Model'] = androidModel;
      androidDeviceInfo['Version'] = release;
      androidDeviceInfo['Manufacturer'] = manufacturer;
      androidDeviceInfo['SDK'] = sdkInt;
      return androidDeviceInfo;
    }
  }
}