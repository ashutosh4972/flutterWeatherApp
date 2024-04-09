part of 'weather_bloc.dart';



sealed class WeatherState extends Equatable {
  const WeatherState();

  @override
  List<Object> get props => [];
}

class WeatherInitial extends WeatherState{}

class WeatherILoading extends WeatherState{}
class WeatherFailure extends WeatherState{}
class WeatherSuccess extends WeatherState{
  final Weather weather;

  const WeatherSuccess(this.weather);

  @override
  List<Object> get props => [weather];

}
