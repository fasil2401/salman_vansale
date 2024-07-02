import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DirectionScreen extends StatelessWidget {
  DirectionScreen({super.key, required this.list});

  final List<CustomerModel> list;
  Set<Marker> createMarkersFromLocations(List<CustomerModel> locations) {
    Set<Marker> markers = {};

    for (CustomerModel location in locations) {
      if (location.longitude != null && location.latitude != null) {
        markers.add(
          Marker(
              markerId:
                  MarkerId(location.hashCode.toString()), // Unique marker ID
              position: LatLng(double.parse(location.latitude!),
                  double.parse(location.longitude!)),
              infoWindow: InfoWindow(
                  title: location.customerName ?? '',
                  snippet: location.address1 ?? '',
                  anchor:const Offset(0.5, 0))
              // You can customize the marker further if needed
              ),
        );
      }
    }
    return markers;
  }

  LatLng getInitialTarget(List<CustomerModel> customers) {
    LatLng location = const LatLng(0.0, 0.0);
    for (CustomerModel customer in customers) {
      if (customer.longitude != null && customer.latitude != null) {
        location = LatLng(double.parse(customer.latitude!),
            double.parse(customer.longitude!));
        break;
      }
    }
    return location;
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = createMarkersFromLocations(list);
    LatLng location = getInitialTarget(list);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Directions'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location, // Set the initial map position
          zoom: 12.0, // Set the initial zoom level
        ),
        markers: markers, // Pass your markers here
      ),
    );
  }
}
