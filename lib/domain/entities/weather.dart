import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  const Weather({
    required this.name,
    required this.description,
    required this.iconCode,
    required this.temperature,
    required this.pressure,
    required this.hummidity,
  });

  final String name;
  final String description;
  final String iconCode;
  final double temperature;
  final int pressure;
  final int hummidity;

  @override
  List<Object?> get props => [
        name,
        description,
        iconCode,
        temperature,
        pressure,
        hummidity,
      ];
}
