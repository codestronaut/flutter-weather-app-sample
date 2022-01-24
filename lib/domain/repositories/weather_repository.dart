import 'package:dartz/dartz.dart';
import 'package:flutter_weather_app_sample/data/failure.dart';
import 'package:flutter_weather_app_sample/domain/entities/weather.dart';

abstract class WeatherRepository {
  Future<Either<Failure, Weather>> getCurrentWeather(String cityName);
}
