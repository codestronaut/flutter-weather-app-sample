import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app_sample/data/constants.dart';
import 'package:flutter_weather_app_sample/data/datasources/remote_data_source.dart';
import 'package:flutter_weather_app_sample/data/exception.dart';
import 'package:flutter_weather_app_sample/data/models/weather_model.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../helpers/json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MockHttpClient mockHttpClient;
  late RemoteDataSourceImpl dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = RemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get current weather', () {
    final tCityName = 'Jakarta';
    final tWeatherModel = WeatherModel.fromJson(json
        .decode(readJson('helpers/dummy_data/dummy_weather_response.json')));

    test(
      'should return weather model when the response code is 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(Urls.currentWeatherByName(tCityName))),
        ).thenAnswer(
          (_) async => http.Response(
              readJson('helpers/dummy_data/dummy_weather_response.json'), 200),
        );

        // act
        final result = await dataSource.getCurrentWeather(tCityName);

        // assert
        expect(result, equals(tWeatherModel));
      },
    );

    test(
      'should throw a server exception when the response code is 404 or other',
      () async {
        // arrange
        when(
          mockHttpClient.get(Uri.parse(Urls.currentWeatherByName(tCityName))),
        ).thenAnswer(
          (_) async => http.Response('Not found', 404),
        );

        // act
        final call = dataSource.getCurrentWeather(tCityName);

        // assert
        expect(() => call, throwsA(isA<ServerException>()));
      },
    );
  });
}
