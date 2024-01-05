// map_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapBloc extends Cubit<LatLng> {
  MapBloc() : super(LatLng(0.0, 0.0));

  void updateLocation(LatLng location) => emit(location);
}
