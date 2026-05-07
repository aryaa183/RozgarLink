// import 'package:geolocator/geolocator.dart';

// class LocationService {

//   /// 📍 Get Current User Location
//   static Future<Position?> getUserLocation() async {
//     try {

//       // Check if location service enabled
//       bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

//       if (!serviceEnabled) {
//         print("Location service disabled");
//         return null;
//       }

//       // Check permission
//       LocationPermission permission =
//           await Geolocator.checkPermission();

//       // Ask permission
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();

//         if (permission == LocationPermission.denied) {
//           print("Location permission denied");
//           return null;
//         }
//       }

//       // Permanently denied
//       if (permission == LocationPermission.deniedForever) {
//         print("Location permission denied forever");
//         return null;
//       }

//       // Get location
//       return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//     } catch (e) {
//       print("Location Error: $e");
//       return null;
//     }
//   }

//   /// 📏 Calculate Distance in KM
//   static double calculateDistance(
//     double userLat,
//     double userLng,
//     double jobLat,
//     double jobLng,
//   ) {

//     double distanceInMeters = Geolocator.distanceBetween(
//       userLat,
//       userLng,
//       jobLat,
//       jobLng,
//     );

//     // Convert meters → KM
//     return distanceInMeters / 1000;
//   }
// }


import 'package:rozgar_link/services/location_service.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Gets the live position of whoever is holding the phone
  static Future<Position?> getUserLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) return null;
      }
      
      // Fetches current GPS coordinates (works anywhere in the world)
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
      );
    } catch (e) {
      return null;
    }
  }

  /// The Haversine Formula logic to calculate distance between ANY two points
  static double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    double distanceInMeters = Geolocator.distanceBetween(
      startLat, 
      startLng, 
      endLat, 
      endLng
    );
    return distanceInMeters / 1000; // Convert to Kilometers
  }
}