import 'package:flutter_weather_app_sample/data/datasources/remote_data_source.dart';
import 'package:flutter_weather_app_sample/domain/repositories/weather_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

@GenerateMocks([
  WeatherRepository,
  RemoteDataSource,
], customMocks: [
  MockSpec<http.Client>(as: #MockHttpClient)
])
void main() {}
