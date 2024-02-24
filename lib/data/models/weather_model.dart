class Weather {
  final double temperature;
  final double apparentTemperature;
  final int cloudCover;

  Weather({
    required this.temperature,
    required this.apparentTemperature,
    required this.cloudCover,
  });

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
        temperature: json['temperature_2m'] ?? 0.0,
        apparentTemperature: json['apparent_temperature'] ?? 0.0,
        cloudCover: json['cloud_cover'] ?? 0.0,
      );
}
