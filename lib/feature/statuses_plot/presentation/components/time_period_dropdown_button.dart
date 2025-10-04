import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/enums/time_period.dart';
import 'package:hack_sfedu_2025/feature/statuses_plot/controller/plot_controller.dart';

class TimePeriodDropdownButton extends StatelessWidget {
  const TimePeriodDropdownButton({
    super.key,
    required this.plotProvider,
  });

  final PlotController plotProvider;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<TimePeriod>(
      value: plotProvider.timePeriod,
      items: [
        DropdownMenuItem(
          value: TimePeriod.hour,
          child: Text('За 1 час'),
        ),
        DropdownMenuItem(
          value: TimePeriod.hours3,
          child: Text('За 3 часа'),
        ),
        DropdownMenuItem(
          value: TimePeriod.hours6,
          child: Text('За 6 часов'),
        ),
        DropdownMenuItem(
          value: TimePeriod.hours8,
          child: Text('За 8 часов'),
        ),
        DropdownMenuItem(
          value: TimePeriod.hours12,
          child: Text('За 12 часов'),
        ),
        DropdownMenuItem(
          value: TimePeriod.day,
          child: Text('За 24 часа'),
        ),
        DropdownMenuItem(
          value: TimePeriod.week,
          child: Text('За неделю'),
        ),
        DropdownMenuItem(
          value: TimePeriod.month,
          child: Text('За месяц'),
        ),
      ],
      onChanged: (value) {
        plotProvider.changePeriod(value ?? TimePeriod.day);
      },
    );
  }
}
