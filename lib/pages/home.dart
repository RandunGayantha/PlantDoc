// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:plantdoc/pages/camera.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // --- Weather & Location State Variables ---
  String _location = 'Detecting location...';
  String _temperature = '--°C';
  String _condition = 'Fetching weather...';
  String _humidity = '--%';
  String _rain = '--%';
  bool _isLoadingWeather = true;

  @override
  void initState() {
    super.initState();
    _fetchLocalWeather();
  }

  // Helper method to get the current date
  String _getFormattedDate() {
    final now = DateTime.now();
    const weekdays = [
      'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'
    ];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${weekdays[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  // Real method to fetch location and weather data
  Future<void> _fetchLocalWeather() async {
    try {
      // 1. Check permissions and get current GPS location
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (mounted) setState(() { _condition = 'Location disabled'; _isLoadingWeather = false; });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (mounted) setState(() { _condition = 'Permission denied'; _isLoadingWeather = false; });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (mounted) setState(() { _condition = 'Permissions permanently denied'; _isLoadingWeather = false; });
        return;
      }

      // Get the actual device coordinates
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // 2. Call the Weather API
      // TODO: Get a free API key from https://openweathermap.org/ and paste it below
      const String apiKey = '66562bd926fd6c51adde8922ff24d344'; 
      
      final url = Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?lat=${position.latitude}&lon=${position.longitude}&appid=$apiKey&units=metric');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (mounted) {
          setState(() {
            // Parse the JSON data into your UI variables
            _location = '${data['name']}, ${data['sys']['country']}'; 
            _temperature = '${data['main']['temp'].round()}°C';        
            _condition = data['weather'][0]['main'];                   
            _humidity = '${data['main']['humidity']}%';               
            
            // Note: Basic OpenWeatherMap uses cloud cover as a rain/cloud metric
            _rain = '${data['clouds']['all']}% Clouds'; 
            _isLoadingWeather = false;
          });
        }
      } else {
        if (mounted) setState(() { _condition = 'API Error'; _isLoadingWeather = false; });
      }
    } catch (e) {
      if (mounted) setState(() { _condition = 'Network Error'; _isLoadingWeather = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), 
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildWeatherCard(),
              const SizedBox(height: 32),
              _buildRecentScansHeader(),
              const SizedBox(height: 16),
              _buildRecentScansList(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _getFormattedDate(), 
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Good Morning, Farmer',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0F172A),
              ),
            ),
          ],
        ),
        const CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(
              'https://ui-avatars.com/api/?name=Farmer&background=random'), 
        ),
      ],
    );
  }

  Widget _buildWeatherCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF388E3C), Color(0xFF4CAF50)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4CAF50).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: _isLoadingWeather 
          ? const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(color: Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.cloud_outlined, color: Colors.white, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          _condition,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _temperature,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _location,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    _buildWeatherChip(Icons.water_drop_outlined, _humidity),
                    const SizedBox(height: 12),
                    _buildWeatherChip(Icons.air, _rain),
                  ],
                )
              ],
            ),
    );
  }

  Widget _buildWeatherChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 14),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentScansHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Recent Scans',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
        TextButton(
          onPressed: () {},
          child: const Text(
            'View All',
            style: TextStyle(
              color: Color(0xFF2E7D32),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentScansList() {
    return SizedBox(
      height: 220,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _buildScanCard(
            title: 'Tomato',
            status: 'Healthy',
            time: 'Today, 9:30 AM',
            isHealthy: true,
            imageUrl: 'https://images.unsplash.com/photo-1592841200221-a6898f307baa?auto=format&fit=crop&q=80&w=300', 
          ),
          const SizedBox(width: 16),
          _buildScanCard(
            title: 'Potato',
            status: 'Early Blight',
            time: 'Yesterday',
            isHealthy: false,
            imageUrl: 'https://images.unsplash.com/photo-1518972554573-e2e7fbaf8166?auto=format&fit=crop&q=80&w=300', 
          ),
          const SizedBox(width: 16),
          _buildScanCard(
            title: 'Chilli',
            status: 'Leaf Curl Virus',
            time: 'Mar 18',
            isHealthy: false,
            imageUrl: 'https://images.unsplash.com/photo-1588879460618-936cb3b9f301?auto=format&fit=crop&q=80&w=300', 
          ),
          const SizedBox(width: 16),
          _buildScanCard(
            title: 'Bell Pepper',
            status: 'Healthy',
            time: 'Mar 15',
            isHealthy: true,
            imageUrl: 'https://images.unsplash.com/photo-1563514227147-6d2ff665a6a0?auto=format&fit=crop&q=80&w=300', 
          ),
        ],
      ),
    );
  }

  Widget _buildScanCard({
    required String title,
    required String status,
    required String time,
    required bool isHealthy,
    required String imageUrl,
  }) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              imageUrl,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    color: isHealthy ? const Color(0xFF2E7D32) : Colors.red,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}