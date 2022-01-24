import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_weather_app_sample/data/constants.dart';
import 'package:flutter_weather_app_sample/domain/entities/weather.dart';
import 'package:flutter_weather_app_sample/presentation/bloc/weather_bloc.dart';
import 'package:flutter_weather_app_sample/presentation/bloc/weather_event.dart';
import 'package:flutter_weather_app_sample/presentation/bloc/weather_state.dart';
import 'package:flutter_weather_app_sample/presentation/pages/weather_page.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';

class MockWeatherBloc extends MockBloc<WeatherEvent, WeatherState>
    implements WeatherBloc {}

class FakeWeatherState extends Fake implements WeatherState {}

class FakeWeatherEvent extends Fake implements WeatherEvent {}

void main() {
  late MockWeatherBloc mockWeatherBloc;

  setUpAll(() async {
    HttpOverrides.global = null;
    registerFallbackValue(FakeWeatherState());
    registerFallbackValue(FakeWeatherEvent());

    final di = GetIt.instance;
    di.registerFactory(() => mockWeatherBloc);
  });

  setUp(() {
    mockWeatherBloc = MockWeatherBloc();
  });

  const tWeather = Weather(
    cityName: 'Jakarta',
    main: 'Clouds',
    description: 'few clouds',
    iconCode: '02d',
    temperature: 302.28,
    pressure: 1009,
    humidity: 70,
  );

  Widget _makeTestableWidget(Widget body) {
    return BlocProvider<WeatherBloc>.value(
      value: mockWeatherBloc,
      child: MaterialApp(
        home: body,
      ),
    );
  }

  testWidgets(
    'text field should trigger state to change from empty to loading',
    (WidgetTester tester) async {
      // arrange
      when(() => mockWeatherBloc.state).thenReturn(WeatherEmpty());

      // act
      await tester.pumpWidget(_makeTestableWidget(WeatherPage()));
      await tester.enterText(find.byType(TextField), 'Jakarta');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pumpAndSettle();

      // assert
      verify(() => mockWeatherBloc.add(OnCityChanged('Jakarta'))).called(1);
      expect(find.byType(TextField), equals(findsOneWidget));
    },
  );

  testWidgets(
    'should show progress indicator when state is loading',
    (WidgetTester tester) async {
      // arrange
      when(() => mockWeatherBloc.state).thenReturn(WeatherLoading());

      // act
      await tester.pumpWidget(_makeTestableWidget(WeatherPage()));

      // assert
      expect(find.byType(CircularProgressIndicator), equals(findsOneWidget));
    },
  );

  testWidgets(
    'should show widget contain weather data when state is has data',
    (WidgetTester tester) async {
      // arrange
      when(() => mockWeatherBloc.state).thenReturn(WeatherHasData(tWeather));

      // act
      await tester.pumpWidget(_makeTestableWidget(WeatherPage()));
      await tester.runAsync(() async {
        final HttpClient client = HttpClient();
        await client.getUrl(Uri.parse(Urls.weatherIcon('02d')));
      });
      await tester.pumpAndSettle();

      // assert
      expect(find.byKey(Key('weather_data')), equals(findsOneWidget));
    },
  );
}
