import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';

import '../apikey.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(WeatherInitial()) {
    on<FetchWeather>((event, emit) async {
      // TODO: implement event handler
      emit(WeatherILoading());
      try{
        WeatherFactory wf = WeatherFactory(API_KEY, language:  Language.ENGLISH);
        Weather weather = await wf.currentWeatherByLocation(event.position.latitude, event.position.longitude);
        emit(WeatherSuccess(weather));
      } catch(e){
        emit(WeatherFailure());
      }
    });
  }
}
