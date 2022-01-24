import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_weather_app_sample/presentation/bloc/weather_bloc.dart';
import 'package:flutter_weather_app_sample/presentation/pages/weather_page.dart';
import 'injection.dart' as di;

void main() {
  di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.locator<WeatherBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.orange,
        ),
        home: WeatherPage(),
      ),
    );
  }
}
