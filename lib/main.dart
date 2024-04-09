import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather/weather.dart';
import 'package:weatherapplication/bloc/weather_bloc.dart';
import 'package:weatherapplication/screens/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
          future: _determinePosition(context),
          builder: (context, snap) {
            if(snap.hasData){
              return BlocProvider<WeatherBloc>(
                create: (context) => WeatherBloc()..add(
                    FetchWeather(snap.data as Position)
                ),
                child: const HomeScreen(),
              );
            } else if(snap.hasError){
              // Handle errors here, for example, show an error message.
              return Scaffold(
                body: Center(
                  child: Text('Error: ${snap.error}'),
                ),
              );
            } else {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }

          }
      ),
    );
  }
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position?> _determinePosition(BuildContext context) async {
  bool serviceEnabled;
  LocationPermission permission;

  // Test if location services are enabled.
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    // Location services are not enabled, request to enable.
    bool serviceEnabledResult = await Geolocator.openLocationSettings();
    if (!serviceEnabledResult) {
      // User canceled the dialog or location settings couldn't be opened.
      throw 'User canceled the dialog or location settings couldn\'t be opened.';
    }
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      // Permissions are denied.
      throw 'Location permissions are denied';
    }
  }

  if (permission == LocationPermission.deniedForever) {
    // Permissions are denied forever.
    throw 'Location permissions are permanently denied';
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}
