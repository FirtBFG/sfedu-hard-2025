/// Enum для периодов времени используемый в приложении
enum TimePeriod {
  hour, // 1 час (12 значений, каждые 5 минут)
  hours3, // 3 часа (18 значений, каждые 10 минут)
  hours6, // 6 часов (36 значений, каждые 10 минут)
  hours8, // 8 часов (48 значений, каждые 10 минут)
  hours12, // 12 часов (72 значения, каждые 10 минут)
  day, // 1 день (24 значения, каждый час)
  week, // неделя (7 значений, каждый день)
  month, // месяц (30 значений, каждый день)
}

extension TimePeriodExtension on TimePeriod {
  String get serverValue {
    switch (this) {
      case TimePeriod.hour:
        return '1h';
      case TimePeriod.hours3:
        return '3h';
      case TimePeriod.hours6:
        return '6h';
      case TimePeriod.hours8:
        return '8h';
      case TimePeriod.hours12:
        return '12h';
      case TimePeriod.day:
        return '24h';
      case TimePeriod.week:
        return '7d';
      case TimePeriod.month:
        return '30d';
    }
  }
}
