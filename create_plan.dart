import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:printing/printing.dart';
import 'trip_pdf_generator.dart';
import 'user_data.dart';

class AppStrings {
  static const Map<String, Map<String, String>> texts = {
    'en': {
      'createTrip': 'Create a Trip Plan',
      'noPlacesLeft': 'No places left',
      'applyNow': 'Apply Now',
      'added': 'added',
      'removed': 'removed',
      'selectRange': 'Select date range',
      'start': 'Start',
      'end': 'End',
      'pickStart': 'Pick start date',
      'pickEnd': 'Pick end date',
      'invalidRanges': 'Please set valid start & end dates for all items',
      'generatingPdf': 'Generating PDF...',
      'outOfRange': 'Date must be within the selected trip range!',
      'pdfSaved': 'PDF saved successfully!',
      'pdfShared': 'PDF shared successfully!',
      'error': 'Error generating PDF',
    },
    'ar': {
      'createTrip': 'إنشاء خطة الرحلة',
      'noPlacesLeft': 'لا توجد أماكن متبقية',
      'applyNow': 'تطبيق الآن',
      'added': 'تمت إضافته',
      'removed': 'تم حذفه',
      'selectRange': 'اختر نطاق التاريخ',
      'start': 'بداية',
      'end': 'نهاية',
      'pickStart': 'اختر تاريخ البداية',
      'pickEnd': 'اختر تاريخ النهاية',
      'invalidRanges': 'يرجى تعيين تواريخ بداية ونهاية صحيحة لجميع العناصر',
      'generatingPdf': 'جارٍ إنشاء الـ PDF...',
      'outOfRange': 'التاريخ يجب أن يكون ضمن نطاق الرحلة المحدد!',
      'pdfSaved': 'تم حفظ ملف PDF بنجاح!',
      'pdfShared': 'تمت مشاركة ملف PDF بنجاح!',
      'error': 'حدث خطأ أثناء إنشاء ملف PDF',
    },
  };

  static String get(String key, bool isArabic) {
    return isArabic ? texts['ar']![key]! : texts['en']![key]!;
  }
}

class SelectDis extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final DateTime tripStart;
  final DateTime tripEnd;

  const SelectDis({
    super.key,
    required this.cartItems,
    required this.tripStart,
    required this.tripEnd,
  });

  @override
  State<SelectDis> createState() => _SelectDisState();
}

class _SelectDisState extends State<SelectDis> {
  late String currentLanguage;
  bool _isGenerating = false;
  final Map<int, DateTime?> _startDates = {};
  final Map<int, DateTime?> _endDates = {};
  final DateFormat _displayFormat = DateFormat('dd/MM/yyyy');

  bool get isArabic => currentLanguage == "Arabic";

  @override
  void initState() {
    super.initState();
    currentLanguage = userDataNotifier.value.language.isNotEmpty
        ? userDataNotifier.value.language
        : "English";

    userDataNotifier.addListener(() {
      setState(() {
        currentLanguage = userDataNotifier.value.language;
      });
    });
  }

  bool _hasAllValidRanges() {
    for (int i = 0; i < widget.cartItems.length; i++) {
      final s = _startDates[i];
      final e = _endDates[i];
      if (s == null || e == null || e.isBefore(s)) return false;
    }
    return true;
  }

  Future<void> _pickStartDate(BuildContext context, int index) async {
    final initial = _startDates[index] ?? widget.tripStart;

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: widget.tripStart,
      lastDate: widget.tripEnd,
      locale: isArabic ? const Locale('ar') : const Locale('en'),
    );

    if (picked == null) return;

    if (picked.isBefore(widget.tripStart) || picked.isAfter(widget.tripEnd)) {
      _showSnack(AppStrings.get('outOfRange', isArabic));
      return;
    }

    setState(() {
      _startDates[index] = picked;
      final end = _endDates[index];
      if (end != null && end.isBefore(picked)) _endDates[index] = null;
    });
  }

  Future<void> _pickEndDate(BuildContext context, int index) async {
    final start = _startDates[index] ?? widget.tripStart;
    final initial = _endDates[index] ?? start.add(const Duration(days: 1));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: start.isBefore(widget.tripStart) ? widget.tripStart : start,
      lastDate: widget.tripEnd,
      locale: isArabic ? const Locale('ar') : const Locale('en'),
    );

    if (picked == null) return;

    if (picked.isBefore(widget.tripStart) || picked.isAfter(widget.tripEnd)) {
      _showSnack(AppStrings.get('outOfRange', isArabic));
      return;
    }

    setState(() => _endDates[index] = picked);
  }

  Future<void> _onApplyNow() async {
    if (!_hasAllValidRanges()) {
      _showSnack(AppStrings.get('invalidRanges', isArabic));
      return;
    }

    setState(() => _isGenerating = true);

    final itemsForPdf = <Map<String, dynamic>>[];
    for (int i = 0; i < widget.cartItems.length; i++) {
      final item = widget.cartItems[i];
      itemsForPdf.add({
        'name': _displayNameFor(item),
        'startDate': _startDates[i],
        'endDate': _endDates[i],
        'image': item['image'] ?? item['path'],
      });
    }

    try {
      _showSnack(AppStrings.get('generatingPdf', isArabic));

      final pdfBytes = await generateTripPlanPdfBytes(itemsForPdf);

      final savedFile = await _savePdfToDownloads(pdfBytes, 'trip_plan.pdf');
      await Printing.sharePdf(bytes: Uint8List.fromList(pdfBytes), filename: 'trip_plan.pdf');

      if (savedFile != null && savedFile.existsSync()) {
        _showSnack(AppStrings.get('pdfSaved', isArabic));
      } else {
        _showSnack(AppStrings.get('pdfShared', isArabic));
      }
    } catch (e) {
      _showSnack('${AppStrings.get('error', isArabic)}: $e');
    } finally {
      if (mounted) setState(() => _isGenerating = false);
    }
  }

  // ✅ حفظ PDF بطريقة آمنة لجميع الأجهزة
  Future<File?> _savePdfToDownloads(List<int> pdfBytes, String fileName) async {
    try {
      Directory? dir;

      if (Platform.isAndroid) {
        final status = await Permission.storage.request();
        if (!status.isGranted) return null;

        // استخدام مجلد خارجي آمن (Scoped Storage)
        dir = await getExternalStorageDirectory();
        if (dir == null) return null;

        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(pdfBytes, flush: true);
        return file;
      } else {
        final docDir = await getApplicationDocumentsDirectory();
        final file = File('${docDir.path}/$fileName');
        await file.writeAsBytes(pdfBytes, flush: true);
        return file;
      }
    } catch (e) {
      print('Error saving PDF: $e');
      return null;
    }
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  String _displayNameFor(Map<String, dynamic> item) {
    return (item['name'] ??
        item['title'] ??
        item['title_en'] ??
        item['name_en'] ??
        'Unknown')
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF160948);

    return Directionality(
      textDirection: isArabic ? ui.TextDirection.rtl : ui.TextDirection.ltr,
      child: Scaffold(
        backgroundColor: containerColor,
        appBar: AppBar(
          backgroundColor: containerColor,
          title: Text(
            AppStrings.get('createTrip', isArabic),
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: widget.cartItems.isEmpty
              ? Center(
            child: Text(
              AppStrings.get('noPlacesLeft', isArabic),
              style: TextStyle(color: textColor, fontSize: 18),
            ),
          )
              : Column(
            children: [
              Expanded(
                child: ListView.separated(
                  itemCount: widget.cartItems.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final place = widget.cartItems[index];
                    final title = _displayNameFor(place);
                    final start = _startDates[index];
                    final end = _endDates[index];

                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: textColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              color: containerColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickStartDate(context, index),
                                  child: _buildDateBox('start', start),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => _pickEndDate(context, index),
                                  child: _buildDateBox('end', end),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _isGenerating ? null : _onApplyNow,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isGenerating ? Colors.grey : textColor,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: _isGenerating
                    ? const CircularProgressIndicator(
                    color: Colors.white, strokeWidth: 2)
                    : Text(
                  AppStrings.get('applyNow', isArabic),
                  style: TextStyle(
                    color: containerColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateBox(String key, DateTime? date) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF160948);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
      decoration: BoxDecoration(
        color: containerColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(AppStrings.get(key, isArabic),
              style: TextStyle(color: textColor, fontSize: 12)),
          const SizedBox(height: 6),
          Text(
            date != null
                ? _displayFormat.format(date)
                : AppStrings.get('pick${key[0].toUpperCase()}${key.substring(1)}', isArabic),
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
