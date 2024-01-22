import 'package:weather/weather.dart';

WeatherFactory wf = WeatherFactory("9a6ac9be1840cdae59aa191380fe203b");

Future<String> getCurrentWeather(city) async {
  Weather weather = await wf.currentWeatherByCityName(city);
  String icon = '';
  if (weather.weatherDescription != null) {
    if (weather.temperature?.celsius != null) {
      if (weather.temperature!.celsius! <= 30 && weather.temperature!.celsius! >= 10) {
        icon = getWeatherIcon(weather.weatherDescription!);
      } else {
        icon = getTempIcon(weather.temperature!.celsius!);
      }
    } else {
      icon = "assets/weather/6sun_icon.png";
    }
  } else {
    icon = "assets/weather/6sun_icon.png";
  }
  return icon;
}

String getTempIcon(double temp) {
  if (temp < 10) {
    return "assets/weather/3snow_icon.png";
  } else {
    print("HIIIGH $temp");
    return "assets/weather/2hot_icon.png";
  }
}

String getWeatherIcon(String weather) {
  if (weather.contains("snow") ) {
    return "assets/weather/3snow_icon.png";
  } else if (weather.contains("rain") || weather.contains("drizzle")) {
    return "assets/weather/1rain_icon.png";
  }else if (weather.contains("wind")) {
    return "assets/weather/4wind_icon.png";
  } else if (weather.contains("tornado")) {
    return "assets/weather/5tornado_icon.png";
  }else if (weather.contains("thunderstorm")) {
    return "assets/weather/7thunderstorm_icon.png";
  }  else if (weather.contains("clouds")) {
    return "assets/weather/8clouds_icon.png";
  }  else if (weather.contains("clear")) {
    return "assets/weather/6sun_icon.png";
  } else {
    return "assets/weather/6sun_icon.png";
  }

}
