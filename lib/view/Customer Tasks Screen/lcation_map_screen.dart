import 'package:axoproject/model/Customer%20Model/customer_model.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationMapScreen extends StatelessWidget {
  LocationMapScreen({super.key, required this.customer});

  final CustomerModel customer;
  Set<Marker> createMarkersFromLocations(CustomerModel customer) {
    Set<Marker> markers = {};
    LatLng location = LatLng(
        double.parse(customer.latitude!), double.parse(customer.longitude!));
    markers.add(
      Marker(
          markerId: MarkerId(customer.hashCode.toString()), // Unique marker ID
          position: location,
          infoWindow: InfoWindow(
              title: customer.customerName ?? '',
              snippet: customer.address1 ?? '',
              anchor: Offset(0.5, 0))
          // You can customize the marker further if needed
          ),
    );
    return markers;
  }

  LatLng getInitialTarget(CustomerModel customer) {
    LatLng location = LatLng(
        double.parse(customer.latitude!), double.parse(customer.longitude!));
    return location;
  }

  @override
  Widget build(BuildContext context) {
    Set<Marker> markers = createMarkersFromLocations(customer);
    LatLng location = getInitialTarget(customer);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: location, // Set the initial map position
          zoom: 15, // Set the initial zoom level
        ),
        markers: markers, // Pass your markers here
      ),
    );
  }
}
