import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../provider/Providers.dart';

class Date extends StatefulWidget {
  Changes change;

  Date({required this.change});

  @override
  _DateState createState() => _DateState();
}

class _DateState extends State<Date> {
  DateRangePickerController _datePickerController = DateRangePickerController();

  DateTime data = DateTime.now();
  static String? startDate, endDate;
  int i =0;

  @override
  initState() {
    super.initState();

    _datePickerController.selectedDate = widget.change.day;
    final DateTime today = DateTime.now();
    startDate = DateFormat('dd').format(today).toString();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Changes>(builder: ((context, notiFil, child) {
      return SfDateRangePicker(
        allowViewNavigation: false,
        onSelectionChanged: selectionChanged,
        view: DateRangePickerView.month,
        initialDisplayDate: widget.change.day,
        selectionMode: DateRangePickerSelectionMode.single,
        controller: _datePickerController,
      );
    }));
  }

  void selectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value != null)
        widget.change.Time(args.value);

      //startDate = DateFormat('dd').format(args.value.startDate).toString();
    });
  }
}
