import 'package:weather/weather.dart';

WeatherFactory wf = WeatherFactory("9a6ac9be1840cdae59aa191380fe203b", language: Language.SPANISH);

getCurrentWeather(latitude, longitude) async {
  Weather weather = await wf.currentWeatherByLocation(latitude, longitude);

  if (weather.weatherDescription != null) {
    print(weather.weatherDescription);
  }

}

