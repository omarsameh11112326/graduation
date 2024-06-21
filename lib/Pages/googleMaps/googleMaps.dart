import 'dart:async';
import 'package:app_project/Wedgits/custom_botton.dart';
import 'package:app_project/Pages/serviceProviderPages/ServiceProgress.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Live extends StatefulWidget {
  final double latitude;
  final double longitude;
  final double latitude2;
  final double longitude2;

  Live({
    Key? key,
    required this.latitude,
    required this.longitude,
    required this.latitude2,
    required this.longitude2,
  }) : super(key: key);

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  late Position _currentPosition;
  late StreamSubscription<Position> _positionStreamSubscription;

  // Polyline
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyCzG2PxSPsIeiSrfbxN4zrYvmFVUhmRwZM"; 

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  Future<void> _init() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, don't continue
      return Future.error('Location services are disabled.');
    }

    // Check for location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, don't continue
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    // Get initial position
    _currentPosition = await Geolocator.getCurrentPosition();
    _cameraPosition = CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 15,
    );
    setState(() {});

    // Listen to position updates
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
        _updateCameraPosition(position);
      });
    });

    // Fetch and draw polyline
    _getPolyline();
  }

  void _updateCameraPosition(Position position) async {
    final GoogleMapController controller = await _googleMapController.future;
    controller.animateCamera(CameraUpdate.newLatLng(
        LatLng(position.latitude, position.longitude)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _cameraPosition == null
          ? Center(child: CircularProgressIndicator())
          : _buildMap(),
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.normal,
          polylines: Set<Polyline>.of(polylines.values),
          markers: _getMarkers(),
          onMapCreated: (GoogleMapController controller) {
            _googleMapController.complete(controller);
          },
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child:  CustomButton(
            
            
           onTap: ()  {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context){
                      return ServicePage();
                    }));
          },

          text: 'Arrived',
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
        
          ),
        ),
      ],
    );
  }

  Set<Marker> _getMarkers() {
    return <Marker>{
      Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ),
      Marker(
        markerId: MarkerId('serviceProviderLocation'),
        position: LatLng(widget.latitude2, widget.longitude2),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ),
    };
  }

  void _addPolyline() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
      width: 5, // Set the width of the polyline
    );
    polylines[id] = polyline;
    setState(() {});
  }

  Future<void> _getPolyline() async {
    try {
      PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleAPiKey,
        PointLatLng(widget.latitude, widget.longitude), // User location (source)
        PointLatLng(widget.latitude2, widget.longitude2), // Service provider location (destination)
        travelMode: TravelMode.driving,
      );

      if (result.status == 'OK' && result.points.isNotEmpty) {
        polylineCoordinates.clear();
        result.points.forEach((PointLatLng point) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        });
        _addPolyline();
      } else {
        print('Error in fetching polyline: ${result.errorMessage}');
      }
    } catch (e) {
      print('Exception while fetching polyline: $e');
    }
  }
}
