import 'dart:async';

import 'package:famer_map/screens/add_famer.dart';
import 'package:famer_map/widgets/card_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeScreen extends StatefulWidget {
  Position currentPosition;
  HomeScreen({super.key, required this.currentPosition});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(6.2252351, 1.1826758),
    zoom: 15.4746,
  );
  late Set<Marker> _markers;
  // Default marker that won't change
  final Marker _defaultMarker = const Marker(
    markerId: MarkerId("Moi"),
    position:
        LatLng(37.7749, -122.4194), // Default location (e.g., city center)
    infoWindow: InfoWindow(title: "Moi"),
    icon: BitmapDescriptor.defaultMarker,
  );
  List<Map<String, dynamic>> data = [
    {"nom": "Taj Mahal", "latitude": 27.1751, "longitude": 78.0421},
    {"nom": "Jaipur", "latitude": 26.9124, "longitude": 75.7873},
    {"nom": "Delhi", "latitude": 28.6139, "longitude": 77.2090},
    {"nom": "Varanasi", "latitude": 25.3176, "longitude": 82.9739},
    {"nom": "Goa", "latitude": 15.2993, "longitude": 74.1240},
    {"nom": "Kochi", "latitude": 9.9312, "longitude": 76.2673},
    {"nom": "Mumbai", "latitude": 19.0760, "longitude": 72.8777},
    {"nom": "Rishikesh", "latitude": 30.0868, "longitude": 78.2676},
    {"nom": "Leh-Ladakh", "latitude": 34.1642, "longitude": 77.5848},
    {"nom": "Kolkata", "latitude": 22.5726, "longitude": 88.3639},
    {"nom": "Agra Fort", "latitude": 27.1796, "longitude": 78.0212},
    {"nom": "Udaipur", "latitude": 24.5854, "longitude": 73.7125},
    {"nom": "Chennai", "latitude": 13.0827, "longitude": 80.2707},
    {"nom": "Amritsar", "latitude": 31.5497, "longitude": 74.3436},
    {"nom": "Mysuru", "latitude": 12.2958, "longitude": 76.6394},
    {"nom": "Hampi", "latitude": 15.3350, "longitude": 76.4600},
    {"nom": "Ajmer", "latitude": 26.4691, "longitude": 74.6390},
    {"nom": "Kanyakumari", "latitude": 8.0883, "longitude": 77.5385},
    {"nom": "Shimla", "latitude": 31.1048, "longitude": 77.1734},
    {"nom": "Pondicherry", "latitude": 11.9139, "longitude": 79.8145},
    {"nom": "Srinagar", "latitude": 34.0836, "longitude": 74.7973},
    {"nom": "Darjeeling", "latitude": 27.0360, "longitude": 88.2627},
    {"nom": "Kanpur", "latitude": 26.4499, "longitude": 80.3319},
    {"nom": "Rajkot", "latitude": 22.3039, "longitude": 70.8022},
    {"nom": "Bhopal", "latitude": 23.2599, "longitude": 77.4126},
    {"nom": "Guwahati", "latitude": 26.1445, "longitude": 91.7362},
    {"nom": "Nainital", "latitude": 29.3801, "longitude": 79.4630},
    {"nom": "Jodhpur", "latitude": 26.2389, "longitude": 73.0243},
    {"nom": "Trivandrum", "latitude": 8.5241, "longitude": 76.9366},
    {"nom": "Khajuraho", "latitude": 24.8510, "longitude": 79.9199},
    {"nom": "Rameswaram", "latitude": 9.2876, "longitude": 79.3129},
    {"nom": "Haridwar", "latitude": 29.9457, "longitude": 78.1642},
    {"nom": "Ahmedabad", "latitude": 23.0225, "longitude": 72.5714},
    {"nom": "Pushkar", "latitude": 26.4872, "longitude": 74.5500},
    {"nom": "Gangtok", "latitude": 27.3314, "longitude": 88.6138},
    {"nom": "Aurangabad", "latitude": 19.8762, "longitude": 75.3433},
    {"nom": "Bhubaneswar", "latitude": 20.2961, "longitude": 85.8245},
    {"nom": "Lucknow", "latitude": 26.8467, "longitude": 80.9462},
    {"nom": "Gulmarg", "latitude": 34.0496, "longitude": 74.3824},
    {"nom": "Agartala", "latitude": 23.8315, "longitude": 91.2868},
    {"nom": "Nashik", "latitude": 20.5937, "longitude": 78.9629},
    {"nom": "Dehradun", "latitude": 30.3165, "longitude": 78.0322},
    {"nom": "Kozhikode", "latitude": 11.2588, "longitude": 75.7804},
    {"nom": "Shillong", "latitude": 25.5788, "longitude": 91.8933},
    {"nom": "Jaisalmer", "latitude": 26.9157, "longitude": 70.9083},
    {
      "nom": "La Grande Muraille, Badaling",
      "latitude": 40.3225,
      "longitude": 116.2572
    },
    {
      "nom": "Cité interdite, Beijing",
      "latitude": 39.9042,
      "longitude": 116.4074
    },
    {"nom": "Montagne Jaune", "latitude": 29.7147, "longitude": 118.3365},
    {"nom": "Xi'an", "latitude": 34.3416, "longitude": 108.9398},
    {"nom": "Shanghai", "latitude": 31.2304, "longitude": 121.4737},
    {"nom": "Guilin", "latitude": 25.2736, "longitude": 110.2900},
    {"nom": "Lhassa, Tibet", "latitude": 29.6500, "longitude": 91.1175},
    {"nom": "Hangzhou", "latitude": 30.2741, "longitude": 120.1551},
    {"nom": "Chengdu", "latitude": 30.5728, "longitude": 104.0668},
    {"nom": "Lijiang", "latitude": 26.8550, "longitude": 100.2278},
    {"nom": "Harbin", "latitude": 45.8038, "longitude": 126.5343},
    {"nom": "Hong Kong", "latitude": 22.3193, "longitude": 114.1694},
    {"nom": "Macau", "latitude": 22.1987, "longitude": 113.5439},
    {"nom": "Shenzhen", "latitude": 22.5431, "longitude": 114.0579},
    {"nom": "Chongqing", "latitude": 29.4316, "longitude": 106.9123},
    {"nom": "Zhuhai", "latitude": 22.2562, "longitude": 113.5678},
    {"nom": "Yangshuo", "latitude": 24.7809, "longitude": 110.4895},
    {"nom": "Kunming", "latitude": 25.0389, "longitude": 102.7183},
    {"nom": "Nanjing", "latitude": 32.0603, "longitude": 118.7969},
    {"nom": "Dali", "latitude": 25.6065, "longitude": 100.2676},
    {"nom": "Huangshan", "latitude": 30.1340, "longitude": 118.1619},
    {"nom": "Urumqi", "latitude": 43.8256, "longitude": 87.6168},
    {"nom": "Hohhot", "latitude": 40.8424, "longitude": 111.7498},
    {"nom": "Wuhan", "latitude": 30.5928, "longitude": 114.3055},
    {"nom": "Guangzhou", "latitude": 23.1291, "longitude": 113.2644},
    {"nom": "Xiamen", "latitude": 24.4798, "longitude": 118.0894},
    {"nom": "Nanning", "latitude": 22.8170, "longitude": 108.3665},
    {"nom": "Qingdao", "latitude": 36.0671, "longitude": 120.3826},
    {"nom": "Shenyang", "latitude": 41.8057, "longitude": 123.4315},
    {"nom": "Taiyuan", "latitude": 37.8706, "longitude": 112.5489},
    {"nom": "Changsha", "latitude": 28.2282, "longitude": 112.9388},
    {"nom": "Guiyang", "latitude": 26.5730, "longitude": 106.7076},
    {"nom": "Xining", "latitude": 36.6232, "longitude": 101.7801},
    {"nom": "Zhengzhou", "latitude": 34.7466, "longitude": 113.6253},
    {
      "nom": "Cristo Redentor, Rio de Janeiro",
      "latitude": -22.9519,
      "longitude": -43.2105
    },
    {
      "nom": "Plage de Copacabana, Rio de Janeiro",
      "latitude": -22.9714,
      "longitude": -43.1825
    },
    {
      "nom": "Iguaçu Falls, Foz do Iguaçu",
      "latitude": -25.6953,
      "longitude": -54.4367
    },
    {
      "nom": "Plage de Ipanema, Rio de Janeiro",
      "latitude": -22.9868,
      "longitude": -43.2015
    },
    {"nom": "Salvador, Bahia", "latitude": -12.9714, "longitude": -38.5014},
    {"nom": "Brasília", "latitude": -15.8267, "longitude": -47.9218},
    {"nom": "Manaus, Amazonas", "latitude": -3.1190, "longitude": -60.0217},
    {"nom": "Fortaleza, Ceará", "latitude": -3.7172, "longitude": -38.5433},
    {"nom": "Pantanal", "latitude": -17.7887, "longitude": -57.7728},
    {"nom": "Recife, Pernambuco", "latitude": -8.0476, "longitude": -34.8770},
    {"nom": "São Paulo", "latitude": -23.5505, "longitude": -46.6333},
    {"nom": "Fernando de Noronha", "latitude": -3.8444, "longitude": -32.4233},
    {"nom": "Belém, Pará", "latitude": -1.4558, "longitude": -48.4902},
    {
      "nom": "Porto Alegre, Rio Grande do Sul",
      "latitude": -30.0346,
      "longitude": -51.2177
    },
    {
      "nom": "Florianópolis, Santa Catarina",
      "latitude": -27.5954,
      "longitude": -48.5480
    },
    {
      "nom": "Natal, Rio Grande do Norte",
      "latitude": -5.7945,
      "longitude": -35.2120
    },
    {"nom": "Curitiba, Paraná", "latitude": -25.4284, "longitude": -49.2733},
    {"nom": "São Luís, Maranhão", "latitude": -2.5307, "longitude": -44.3067},
    {
      "nom": "Chichén Itzá, Yucatán",
      "latitude": 20.6830,
      "longitude": -88.5701
    },
    {"nom": "Teotihuacán, Mexico", "latitude": 19.6926, "longitude": -98.8437},
    {"nom": "Cancún, Quintana Roo", "latitude": 21.1619, "longitude": -86.8515},
    {"nom": "Palenque, Chiapas", "latitude": 17.4875, "longitude": -92.0451},
    {
      "nom": "Guadalajara, Jalisco",
      "latitude": 20.6597,
      "longitude": -103.3496
    },
    {"nom": "Mérida, Yucatán", "latitude": 20.9670, "longitude": -89.6237},
    {
      "nom": "Puerto Vallarta, Jalisco",
      "latitude": 20.6534,
      "longitude": -105.2253
    },
    {"nom": "Oaxaca, Oaxaca", "latitude": 17.0732, "longitude": -96.7266},
    {"nom": "Tulum, Quintana Roo", "latitude": 20.2114, "longitude": -87.4654},
    {"nom": "Mexico City", "latitude": 19.4326, "longitude": -99.1332},
    {
      "nom": "Monterrey, Nuevo León",
      "latitude": 25.4383,
      "longitude": -100.9737
    },
    {
      "nom": "Cabo San Lucas, Baja California Sur",
      "latitude": 22.8905,
      "longitude": -109.9167
    },
    {"nom": "Puebla, Puebla", "latitude": 19.0414, "longitude": -98.2063},
    {
      "nom": "Playa del Carmen, Quintana Roo",
      "latitude": 20.6296,
      "longitude": -87.0739
    },
    {
      "nom": "Guanajuato, Guanajuato",
      "latitude": 21.1619,
      "longitude": -101.1721
    },
    {"nom": "Veracruz, Veracruz", "latitude": 19.1724, "longitude": -96.1333},
    {
      "nom": "Chiapa de Corzo, Chiapas",
      "latitude": 16.7325,
      "longitude": -92.9526
    },
    {"nom": "Durango, Durango", "latitude": 24.0277, "longitude": -104.6532},
    {"nom": "Morelia, Michoacán", "latitude": 19.7008, "longitude": -101.1844},
    {"nom": "Campeche, Campeche", "latitude": 19.8301, "longitude": -90.5349},
    {
      "nom": "San Miguel de Allende, Guanajuato",
      "latitude": 20.9144,
      "longitude": -100.7459
    },
    {
      "nom": "Tijuana, Baja California",
      "latitude": 32.5149,
      "longitude": -117.0382
    },
    {
      "nom": "Tuxtla Gutiérrez, Chiapas",
      "latitude": 16.7531,
      "longitude": -93.1145
    },
    {"nom": "Acapulco, Guerrero", "latitude": 16.8531, "longitude": -99.8237},
    {"nom": "Cuernavaca, Morelos", "latitude": 18.9225, "longitude": -99.2343},
    {
      "nom": "Querétaro, Querétaro",
      "latitude": 20.5881,
      "longitude": -100.3899
    },
    {
      "nom": "Chihuahua, Chihuahua",
      "latitude": 28.6320,
      "longitude": -106.0691
    },
    {"nom": "Huatulco, Oaxaca", "latitude": 15.7750, "longitude": -96.1253},
    {"nom": "Ixtapa, Guerrero", "latitude": 20.7099, "longitude": -105.2095},
    {"nom": "Tepotzotlán, Mexico", "latitude": 19.7231, "longitude": -99.2182},
    {"nom": "Pointe-à-Pitre", "latitude": 16.2415, "longitude": -61.5335},
    {"nom": "Basse-Terre", "latitude": 15.9970, "longitude": -61.7260},
    {"nom": "Les Saintes", "latitude": 15.8642, "longitude": -61.5809},
    {"nom": "Marie-Galante", "latitude": 15.9320, "longitude": -61.2970},
    {"nom": "La Désirade", "latitude": 16.3342, "longitude": -61.0768},
    {"nom": "Port-Louis", "latitude": 16.4571, "longitude": -61.5392},
    {"nom": "Saint-François", "latitude": 16.2577, "longitude": -61.2704},
    {"nom": "Sainte-Anne", "latitude": 16.2268, "longitude": -61.3664},
    {"nom": "Trois-Rivières", "latitude": 15.9670, "longitude": -61.6770},
    {"nom": "Petit-Bourg", "latitude": 16.2333, "longitude": -61.6000},
    {"nom": "Lagos", "latitude": 6.5244, "longitude": 3.3792},
    {"nom": "Abuja", "latitude": 9.0579, "longitude": 7.4951},
    {"nom": "Kano", "latitude": 12.0029, "longitude": 8.5923},
    {"nom": "Ibadan", "latitude": 7.3776, "longitude": 3.9470},
    {"nom": "Benin City", "latitude": 6.3350, "longitude": 5.6036},
    {"nom": "Port Harcourt", "latitude": 4.8156, "longitude": 7.0498},
    {"nom": "Kaduna", "latitude": 10.5231, "longitude": 7.4408},
    {"nom": "Enugu", "latitude": 6.4483, "longitude": 7.5464},
    {"nom": "Abeokuta", "latitude": 7.1557, "longitude": 3.3453},
    {"nom": "Owerri", "latitude": 5.4836, "longitude": 7.0332},
    {"nom": "Praia, Santiago", "latitude": 14.9242, "longitude": -23.5115},
    {"nom": "Mindelo, São Vicente", "latitude": 16.8901, "longitude": -24.9804},
    {"nom": "Assomada, Santiago", "latitude": 15.1000, "longitude": -23.6833},
    {"nom": "Santa Maria, Sal", "latitude": 16.5953, "longitude": -22.9216},
    {"nom": "Espargos, Sal", "latitude": 16.7413, "longitude": -22.9332},
    {
      "nom": "Porto Novo, Santo Antão",
      "latitude": 17.0236,
      "longitude": -25.0618
    },
    {"nom": "São Filipe, Fogo", "latitude": 14.8938, "longitude": -24.4955},
    {"nom": "Tarrafal, Santiago", "latitude": 15.2886, "longitude": -23.7572},
    {
      "nom": "Ribeira Grande, Santo Antão",
      "latitude": 17.1944,
      "longitude": -25.0722
    },
    {"nom": "Vila do Maio, Maio", "latitude": 15.1301, "longitude": -23.2139}
  ];
  late GoogleMapController _mapController;
  late String lat = "";
  late String long = "";
  late Marker _origin;
  Set<Marker> _buildMarkers() {
    Set<Marker> markers = {};

    // Add a marker for the user's current position
    markers.add(
      Marker(
        markerId: const MarkerId("currentPosition"),
        position: LatLng(
          widget.currentPosition.latitude,
          widget.currentPosition.longitude,
        ),
        infoWindow: const InfoWindow(title: "Your Location"),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );

    // Add markers from the provided data
    for (var place in data) {
      markers.add(
        Marker(
          markerId: MarkerId(place["nom"].toString()),
          position: LatLng(place["latitude"], place["longitude"]),
          infoWindow: InfoWindow(title: place["nom"]),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        ),
      );
    }

    return markers;
  }

  void _initialize() async {
    try {
      setState(() {
        lat = widget.currentPosition.latitude.toString();
        long = widget.currentPosition.longitude.toString();
        _origin = Marker(
          markerId: const MarkerId("origin"),
          infoWindow: const InfoWindow(title: 'origin'),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          position: LatLng(widget.currentPosition.latitude,
              widget.currentPosition.longitude),
        );
      });
    } catch (e) {
      print("Error initializing: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _markers = _buildMarkers();
    _initialize();
  }

  void _goToCurrentLocation(double lat, double long) {
    _mapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(lat, long),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          // _goToCurrentLocation();
          // addMarker(widget.currentPosition);
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddFamer()));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: widget.currentPosition == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(alignment: Alignment.bottomCenter, children: [
              GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition: _kGooglePlex,
                markers: _markers,
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
              ),
              Positioned(
                bottom: 60.0,
                child: SizedBox(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      Map<String, dynamic> item = data[index];
                      return InkWell(
                        onTap: () {
                          _goToCurrentLocation(
                              item["latitude"], item["longitude"]);
                        },
                        child: CardWidget(
                          name: item["nom"],
                        ),
                      );
                    },
                  ),
                ),
              ),
            ]),
    );
  }

  void addMarker(Position pos) {
    setState(() {
      _origin = Marker(
        markerId: const MarkerId("destination"),
        infoWindow: const InfoWindow(title: 'destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(pos.latitude, pos.longitude),
      );
    });
  }
}
