import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'create_plan.dart';
import 'user_data.dart'; // لدعم اللغة

class AppStrings {
  static const Map<String, Map<String, String>> texts = {
    'en': {
      'selectDates': 'Select Trip Dates',
      'from': 'From',
      'to': 'To',
      'cannotPast': 'Cannot select past date',
      'applyDates': 'Apply Dates',
    },
    'ar': {
      'selectDates': 'اختر تواريخ الرحلة',
      'from': 'من',
      'to': 'إلى',
      'cannotPast': 'لا يمكن اختيار تاريخ سابق',
      'applyDates': 'تطبيق التواريخ',
    },
  };

  static String get(String key, bool isArabic) {
    return isArabic ? texts['ar']![key]! : texts['en']![key]!;
  }
}

class Date extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  const Date({super.key, required this.items});

  @override
  State<Date> createState() => _DateState();
}

class _DateState extends State<Date> {
  DateTime? _startDate;
  DateTime? _endDate;
  DateTime _focusedDay = DateTime.now();
  late String currentLanguage;

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

  bool get isArabic => currentLanguage == "Arabic";

  bool _isBeforeToday(DateTime day) {
    final today = DateTime.now();
    return day.isBefore(DateTime(today.year, today.month, today.day));
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      _focusedDay = focusedDay;
      if (_startDate == null || (_startDate != null && _endDate != null)) {
        _startDate = selectedDay;
        _endDate = null;
      } else if (_startDate != null && _endDate == null) {
        if (selectedDay.isBefore(_startDate!)) {
          _startDate = selectedDay;
        } else {
          _endDate = selectedDay;
        }
      }
    });
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final containerColor = isDark ? const Color(0xFF160948) : Colors.white;
    final buttonTextColor = isDark ? Colors.white : const Color(0xFF160948);

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: containerColor,
        appBar: AppBar(
          title: Text(
            AppStrings.get('selectDates', isArabic),
            style: TextStyle(color: buttonTextColor),
          ),
          backgroundColor: containerColor,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonTextColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Text(
                        _startDate != null
                            ? _formatDate(_startDate)
                            : AppStrings.get('from', isArabic),
                        style: TextStyle(color: containerColor, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: buttonTextColor,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: Colors.grey),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 16),
                      child: Text(
                        _endDate != null
                            ? _formatDate(_endDate)
                            : AppStrings.get('to', isArabic),
                        style: TextStyle(color: containerColor, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: buttonTextColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TableCalendar(
                  firstDay: DateTime.now(),
                  lastDay: DateTime(DateTime.now().year + 1),
                  focusedDay: _focusedDay,
                  headerStyle: HeaderStyle(
                    formatButtonVisible: false,
                    titleCentered: true,
                    titleTextStyle: TextStyle(
                      color: containerColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    leftChevronIcon:
                    Icon(Icons.chevron_left, color: containerColor),
                    rightChevronIcon:
                    Icon(Icons.chevron_right, color: containerColor),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: containerColor,
                      fontWeight: FontWeight.bold,
                    ),
                    weekendStyle: TextStyle(
                      color: containerColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(color: containerColor),
                    weekendTextStyle: TextStyle(color: containerColor),
                    todayDecoration: BoxDecoration(
                      color: containerColor.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: const BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                  selectedDayPredicate: (day) =>
                  (_startDate != null && isSameDay(day, _startDate!)) ||
                      (_endDate != null && isSameDay(day, _endDate!)),
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!_isBeforeToday(selectedDay)) {
                      _onDaySelected(selectedDay, focusedDay);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(AppStrings.get('cannotPast', isArabic)),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: (_startDate != null && _endDate != null)
                    ? () {
                  // هنا نمرر نطاق التواريخ إلى صفحة create_plan
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectDis(
                        cartItems: widget.items,
                        tripStart: _startDate!,
                        tripEnd: _endDate!,
                      ),
                    ),
                  );
                }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: (_startDate != null && _endDate != null)
                      ? buttonTextColor
                      : Colors.grey,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  AppStrings.get('applyDates', isArabic),
                  style: TextStyle(
                    color: (_startDate != null && _endDate != null)
                        ? containerColor
                        : buttonTextColor,
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
}
