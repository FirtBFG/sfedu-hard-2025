/// Модель для агрегированных данных
class AggregatedReading {
  final DateTime timestamp;
  final double value;
  final int sampleCount; // Количество исходных измерений в этой точке
  final String unit;
  final String sensorType;

  AggregatedReading({
    required this.timestamp,
    required this.value,
    required this.sampleCount,
    required this.unit,
    required this.sensorType,
  });

  @override
  String toString() {
    return 'AggregatedReading(timestamp: $timestamp, value: $value, samples: $sampleCount)';
  }
}
