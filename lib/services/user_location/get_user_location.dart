import 'dart:developer';

import 'package:axoproject/utils/shared_preferences/shared_preferneces.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:location/location.dart' as location;

class GetUserLocation {
  // static Future<Position> _determinePosition() async {
  static Future<location.LocationData> _determinePosition() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // Position position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.best);
    location.LocationData currentPosition =
        await location.Location().getLocation();
    return currentPosition;
  }

  static getCurrentLocation() async {
    bool isLocationEnabled = false;
    var status = await Permission.location.status;
    if (status.isGranted)
      isLocationEnabled = true;
    else {
      final status = await [Permission.location].request();

      if (status == PermissionStatus.permanentlyDenied)
        openAppSettings();
      else if (status == PermissionStatus.granted)
        isLocationEnabled = true;
      else {
        Map<Permission, PermissionStatus> status =
            await [Permission.location].request();
        if (status == PermissionStatus.granted) isLocationEnabled = true;
      }
    }

    if (isLocationEnabled) {
      location.LocationData position = await _determinePosition();
      UserSimplePreferences.setLatitude(position.latitude.toString());
      UserSimplePreferences.setLongitude(position.longitude.toString());
    }
  }

  // static Future<location.LocationData> getLoc() async {
  //   location.LocationData currentPosition =
  //       await location.Location().getLocation();
  //   log(currentPosition.toString());
  // }
}
