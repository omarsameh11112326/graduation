import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Live extends StatefulWidget {
  final double latitude;
  final double longitude;
   Live({Key? key, required this.latitude, required this.longitude}) : super(key: key);

  @override
  State<Live> createState() => _LiveState();
}

class _LiveState extends State<Live> {
  Completer<GoogleMapController> _googleMapController = Completer();
  CameraPosition? _cameraPosition;
  late Position _currentPosition;
  late StreamSubscription<Position> _positionStreamSubscription;

  //polyline
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  String googleAPiKey = "AIzaSyCzG2PxSPsIeiSrfbxN4zrYvmFVUhmRwZM";

  @override
  void initState() {
    _init();
    _getPolyline();
    super.initState();
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  _init() async {
    _currentPosition = await Geolocator.getCurrentPosition();
    _cameraPosition = CameraPosition(
      target: LatLng(_currentPosition.latitude, _currentPosition.longitude),
      zoom: 15,
    );
    _positionStreamSubscription =
        Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return _getMap();
  }

  Widget _getMap() {
    return Stack(
      children: [
        GoogleMap(
          initialCameraPosition: _cameraPosition!,
          mapType: MapType.terrain,
          polylines: Set<Polyline>.of(polylines.values),
          markers: _getCurrentLocationMarker(),
          onMapCreated: (GoogleMapController controller) {
            if (!_googleMapController.isCompleted) {
              _googleMapController.complete(controller);
            }
          },
        ),
      ],
    );
  }

  Set<Marker> _getCurrentLocationMarker() {
    return <Marker>[
      Marker(
        markerId: MarkerId('currentLocation'),
        position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
        icon: BitmapDescriptor.defaultMarker,
      ),
    ].toSet();
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.blue,
      points: polylineCoordinates,
    );
    polylines[id] = polyline;
    setState(() {});
  }

  _getPolyline() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleAPiKey,
      PointLatLng(30.0841, 31.2797), //مستشفى السنابل , حدائق القبة
      PointLatLng(widget.latitude, widget.longitude), //مستشفى الدمرداش
      travelMode: TravelMode.driving,
    );
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    _addPolyLine();
  }
}