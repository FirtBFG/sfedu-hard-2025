import 'package:flutter/material.dart';
import 'package:hack_sfedu_2025/core/data/mok_data/plot_data.dart';

enum TimePeriod {
  hour, // 1 час (12 значений, каждые 5 минут)
  hours3, // 3 часа (18 значений, каждые 10 минут) - новый
  hours6, // 6 часов (36 значений, каждые 10 минут)
  hours8, // 8 часов (48 значений, каждые 10 минут)
  hours12, // 12 часов (72 значения, каждые 10 минут)
  day, // существующий
  week, // существующий
  month, // существующий
}

class PlotController extends ChangeNotifier {
  TimePeriod _selectedPeriod = TimePeriod.day;

  // double _minTemp = 0;
  // double _maxTemp = 20;

  TimePeriod get timePeriod => _selectedPeriod;

  //double get maxTemp => _maxTemp;
  List<double> get tempDataList {
    switch (_selectedPeriod) {
      case TimePeriod.hour:
        return PlotData.hourTemperatures;
      case TimePeriod.hours3:
        return PlotData.hours3Temperatures;
      case TimePeriod.hours6:
        return PlotData.hours6Temperatures;
      case TimePeriod.hours8:
        return PlotData.hours8Temperatures;
      case TimePeriod.hours12:
        return PlotData.hours12Temperatures;
      case TimePeriod.day:
        return PlotData.dayTemperatures;
      case TimePeriod.week:
        return PlotData.weekTemperatures;
      case TimePeriod.month:
        return PlotData.monthTemperatures;
    }
  }

  double get minTemp {
    final sortedData = List.from(tempDataList);
    sortedData.sort();
    return sortedData.first;
  }

  double get maxTemp {
    final sortedData = List.from(tempDataList);
    sortedData.sort();
    return sortedData.last;
  }

  String getBottomTitle(int value) {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case TimePeriod.hour:
        final time = now.subtract(Duration(minutes: (11 - value) * 5));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.hours3:
        final time = now.subtract(Duration(minutes: (17 - value) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.hours6:
        final time = now.subtract(Duration(minutes: (35 - value) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.hours8:
        final time = now.subtract(Duration(minutes: (47 - value) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.hours12:
        final time = now.subtract(Duration(minutes: (71 - value) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      case TimePeriod.day:
        return '${value.toString().padLeft(2, '0')}:00';
      case TimePeriod.week:
        final date = DateTime.now()
            .subtract(const Duration(days: 6))
            .add(Duration(days: value));
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
      case TimePeriod.month:
        final date = DateTime.now()
            .subtract(const Duration(days: 29))
            .add(Duration(days: value));
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}';
    }
  }

  double getInterval() {
    switch (_selectedPeriod) {
      case TimePeriod.hour:
        return 2; // каждые 10 минут (6 подписей)
      case TimePeriod.hours3:
        return 3; // каждые 30 минут (6 подписей)
      case TimePeriod.hours6:
        return 6; // каждый час (6 подписей)
      case TimePeriod.hours8:
        return 8; // каждые 80 минут (6 подписей)
      case TimePeriod.hours12:
        return 12; // каждые 2 часа (6 подписей)
      case TimePeriod.day:
        return 4; // каждые 4 часа (6 подписей)
      case TimePeriod.week:
        return 1; // каждый день (7 подписей)
      case TimePeriod.month:
        return 5; // каждые 5 дней (6 подписей)
    }
  }

  void changePeriod(TimePeriod period) {
    _selectedPeriod = period;
    notifyListeners();
  }

  String getTooltipText(int index) {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case TimePeriod.hour:
        final time = now.subtract(Duration(minutes: (11 - index) * 5));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}\n${tempDataList[index]}°C';
      case TimePeriod.hours3:
        final time = now.subtract(Duration(minutes: (17 - index) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}\n${tempDataList[index]}°C';
      case TimePeriod.hours6:
        final time = now.subtract(Duration(minutes: (35 - index) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}\n${tempDataList[index]}°C';
      case TimePeriod.hours8:
        final time = now.subtract(Duration(minutes: (47 - index) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}\n${tempDataList[index]}°C';
      case TimePeriod.hours12:
        final time = now.subtract(Duration(minutes: (71 - index) * 10));
        return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}\n${tempDataList[index]}°C';
      case TimePeriod.day:
        return '${index.toString().padLeft(2, '0')}:00\n${tempDataList[index]}°C';
      case TimePeriod.week:
        final date = DateTime.now()
            .subtract(const Duration(days: 6))
            .add(Duration(days: index));
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}\n${tempDataList[index]}°C';
      case TimePeriod.month:
        final date = DateTime.now()
            .subtract(const Duration(days: 29))
            .add(Duration(days: index));
        return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}\n${tempDataList[index]}°C';
    }
  }
}
