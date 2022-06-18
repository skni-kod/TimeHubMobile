import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';

class DateTimeItem extends StatelessWidget {
  DateTimeItem(
      {Key? key, DateTime? dateTime, required this.onChanged, bool? isEnd})
      : date = dateTime == null
            ? DateTime.now()
            : DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? TimeOfDay(
                hour: DateTime.now().hour, minute: DateTime.now().minute)
            : TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        end = isEnd,
        super(key: key) {}

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;
  final bool? end;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: InkWell(
            onTap: (() => _showDatePicker(context, end)),
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(DateFormat('EEEE, d MMMM', 'pl').format(date))),
          ),
        ),
        InkWell(
          onTap: (() => _showTimePicker(context)),
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(DateFormat("HH:mm")
                  .format(DateTime(2000, 1, 1, time.hour, time.minute)))),
        ),
      ],
    );
  }

  Future _showDatePicker(BuildContext context, bool? end) async {
    DateTime? dateTimePicked = await showRoundedDatePicker(
        locale: const Locale("pl", "PL"),
        context: context,
        initialDate: date,
        firstDate: DateTime.now().subtract(Duration(days: 1000)),
        lastDate: DateTime(2030));

    if (dateTimePicked != null) {
      onChanged(DateTime(dateTimePicked.year, dateTimePicked.month,
          dateTimePicked.day, time.hour, time.minute));
    }
  }

  Future _showTimePicker(BuildContext context) async {
    TimeOfDay? timeOfDay = await showRoundedTimePicker(
        locale: Locale("pl", "PL"),
        context: context,
        theme: ThemeData(primaryColor: Theme.of(context).primaryColor),
        initialTime: TimeOfDay.now());

    if (timeOfDay != null) {
      onChanged(DateTime(
          date.year, date.month, date.day, timeOfDay.hour, timeOfDay.minute));
    }
  }
}
