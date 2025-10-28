import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

/// دالة بسيطة للتحقق إذا النص عربي
bool isArabic(String text) {
  final arabicRegex = RegExp(r'[\u0600-\u06FF]');
  return arabicRegex.hasMatch(text);
}

/// توليد ملف PDF مع دعم العربية والانجليزية تلقائيًا
Future<Uint8List> generateTripPlanPdfBytes(
    List<Map<String, dynamic>> destinations) async {

  final pdf = pw.Document();

  // تحميل الخط العربي
  pw.Font? arabicFont;
  try {
    final fontData = await rootBundle.load("assets/fonts/Tajawal-Regular.ttf");
    arabicFont = pw.Font.ttf(fontData);
    print("Arabic font loaded successfully: ${fontData.lengthInBytes} bytes");
  } catch (e) {
    print("Error loading Arabic font: $e");
    arabicFont = null; // نستمر بالخط الافتراضي إذا فشل التحميل
  }

  // تحميل شعار اختياري
  pw.MemoryImage? logoImage;
  try {
    final Uint8List logoBytes =
    await rootBundle.load('assets/logo.png').then((b) => b.buffer.asUint8List());
    logoImage = pw.MemoryImage(logoBytes);
  } catch (e) {
    print("Logo not found: $e");
    logoImage = null;
  }

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (context) {
        return pw.Padding(
          padding: const pw.EdgeInsets.all(20),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // شعار أعلى الصفحة
              if (logoImage != null)
                pw.Center(
                  child: pw.Image(logoImage, width: 100, height: 100),
                ),
              pw.SizedBox(height: 10),

              // عنوان الصفحة
              pw.Center(
                child: pw.Directionality(
                  textDirection: isArabic('خطة الرحلة')
                      ? pw.TextDirection.rtl
                      : pw.TextDirection.ltr,
                  child: pw.Text(
                    'خطة الرحلة',
                    style: pw.TextStyle(
                      font: arabicFont,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blueGrey800,
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 20),

              // جدول الوجهات
              pw.Table(
                border: pw.TableBorder.all(width: 0.5, color: PdfColors.grey),
                columnWidths: {
                  0: const pw.FlexColumnWidth(3),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(2),
                },
                children: [
                  // صف الرؤوس
                  pw.TableRow(
                    decoration: pw.BoxDecoration(color: PdfColors.blueGrey800),
                    children: ['الوجهة', 'بداية', 'نهاية']
                        .map((header) => pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        header,
                        textAlign: pw.TextAlign.center,
                        style: pw.TextStyle(
                          font: arabicFont,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: PdfColors.white,
                        ),
                      ),
                    ))
                        .toList(),
                  ),
                  // صفوف البيانات
                  ...destinations.map((dest) {
                    final cells = [
                      dest['name'] ?? 'Unknown',
                      dest['startDate']?.toString().split(' ')[0] ?? '',
                      dest['endDate']?.toString().split(' ')[0] ?? '',
                    ];
                    return pw.TableRow(
                      children: cells.map((cell) {
                        final arabic = isArabic(cell);
                        return pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Directionality(
                            textDirection:
                            arabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
                            child: pw.Text(
                              cell,
                              style: pw.TextStyle(
                                font: arabic ? arabicFont : null,
                                fontSize: 12,
                                color: PdfColors.black,
                              ),
                              textAlign:
                              arabic ? pw.TextAlign.right : pw.TextAlign.left,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  }).toList(),
                ],
              ),

              pw.SizedBox(height: 20),

              // صور الوجهات
              ...destinations.map((dest) {
                final imagePath = dest['image'];
                final name = dest['name'] ?? '';
                if (imagePath != null && File(imagePath).existsSync()) {
                  final img = pw.MemoryImage(File(imagePath).readAsBytesSync());
                  final arabic = isArabic(name);
                  return pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 10),
                    child: pw.Align(
                      alignment:
                      arabic ? pw.Alignment.centerRight : pw.Alignment.centerLeft,
                      child: pw.Image(img, width: 400, height: 200),
                    ),
                  );
                } else if (imagePath != null) {
                  print("Image not found, skipped: $imagePath");
                }
                return pw.SizedBox(height: 0);
              }).toList(),
            ],
          ),
        );
      },
    ),
  );

  return pdf.save();
}
