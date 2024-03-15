import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:test_widgets/models/models.dart';

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
    final path = await getExternalStorageDirectory();
    final employeePDFPath = '${path!.path}/employee_pdf/${employee.name}_${employee.id}_pdf';
    if (!Directory(employeePDFPath).existsSync()){
      await Directory(employeePDFPath).create(recursive: true);
    }
    else{
      await Directory(employeePDFPath).delete(recursive: true);
      await Directory(employeePDFPath).create(recursive: true);
    }
    final fileName = '$employeePDFPath/${employee.name}_${DateTime.now().toIso8601String()}.pdf';
    final file = File(fileName);
    file.writeAsBytes(await document.save());
    document.dispose();
    return file;
  }
}