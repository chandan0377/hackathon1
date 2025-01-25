import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator_v2/liquid_progress_indicator.dart';
import 'package:lottie/lottie.dart';
import 'package:firebase_database/firebase_database.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseReference _wasteRef =
  FirebaseDatabase.instance.ref().child('wasteDetection');
  Map<String, dynamic>? wasteData;
  bool _isLoading = true;

  // Configuration for each waste type
  final Map<String, Map<String, dynamic>> _wasteConfig = {
    'metal': {
      'buttons': ["Recycle Metal", "Metal Management", "Scrap Solutions"],
      'lottieFile': 'assets/lottie/metal.json',
      'fallbackWidget': Icon(Icons.build, size: 100, color: Colors.blue),
    },
    'degradable': {
      'buttons': ["Compost Now", "Biodegradable Care", "Eco-friendly Disposal"],
      'lottieFile': 'assets/lottie/degradable.json',
      'fallbackWidget': Icon(Icons.eco, size: 100, color: Colors.green),
    },
    'nonDegradable': {
      'buttons': ["Disposal Guide", "Non-Degradable Tips", "Manage Waste"],
      'lottieFile': 'assets/lottie/non_degradable.json',
      'fallbackWidget': Icon(Icons.delete, size: 100, color: Colors.red),
    },
  };

  @override
  void initState() {
    super.initState();
    _setupRealTimeListener();
  }

  // Set up real-time listener for Firebase data
  void _setupRealTimeListener() {
    _wasteRef.onValue.listen((DatabaseEvent event) {
      final data = event.snapshot.value;
      if (data != null && data is Map<Object?, Object?>) {
        setState(() {
          wasteData = {
            'metal': {'count': _parseCount(data['metal'])},
            'degradable': {'count': _parseCount(data['degradable'])},
            'nonDegradable': {'count': _parseCount(data['nonDegradable'])},
          };
          _isLoading = false;
        });
      } else {
        setState(() {
          wasteData = null; // No data available
          _isLoading = false;
        });
      }
    }, onError: (error) {
      print('Error listening to database: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch real-time data. Please try again.')),
      );
      setState(() {
        _isLoading = false;
      });
    });
  }

  // Helper method to parse count from Firebase data
  int _parseCount(dynamic data) {
    if (data is Map<Object?, Object?>) {
      return data['count'] as int? ?? 0;
    }
    return 0;
  }

  double getProgress(int? count) {
    // Define the logic for progress calculation
    if (count == 1) {
      return 0.5; // 50% for count = 1
    } else if (count == 2) {
      return 1.0; // 100% for count = 2
    } else {
      return 0.0; // 0% for count = 0 or any other value
    }
  }

  void _showModalBottomSheet(BuildContext context, String type) {
    final config = _wasteConfig[type] ?? {
      'buttons': [],
      'lottieFile': '',
      'fallbackWidget': Icon(Icons.error, size: 100, color: Colors.grey),
    };

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie Animation or Fallback
              config['lottieFile'] != null && config['lottieFile'].isNotEmpty
                  ? Lottie.asset(
                config['lottieFile'],
                height: 150,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return config['fallbackWidget'];
                },
              )
                  : config['fallbackWidget'],
              SizedBox(height: 20),
              // Buttons
              ...(config['buttons'] as List<String>).map((button) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Add button actions here
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    backgroundColor: Colors.green[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    button,
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              )),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Waste Management",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        backgroundColor: Colors.green[600],
        elevation: 10,
        shadowColor: Colors.black26,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.lightGreen[100]!, Colors.lightGreen[50]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: _isLoading
              ? Lottie.asset(
            'assets/lottie/loading.json',
            height: 150,
            fit: BoxFit.cover,
          )
              : wasteData == null
              ? Text(
            'No data available',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          )
              : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildProgressIndicator('metal', wasteData?['metal']?['count'] ?? 0),
              SizedBox(height: 20),
              _buildProgressIndicator('degradable', wasteData?['degradable']?['count'] ?? 0),
              SizedBox(height: 20),
              _buildProgressIndicator('nonDegradable', wasteData?['nonDegradable']?['count'] ?? 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator(String type, int count) {
    double progress = getProgress(count);

    // Show SnackBar when progress reaches 100% (count = 2)
    if (progress >= 1.0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.9), // Transparent red background
                borderRadius: BorderRadius.circular(8), // Rounded corners
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.warning, color: Colors.white, size: 24), // Warning icon
                  SizedBox(width: 10), // Spacing between icon and text
                  Expanded(
                    child: Text(
                      '${type.capitalize()} container is filled now',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.transparent, // Transparent background for SnackBar
            behavior: SnackBarBehavior.floating, // Floating behavior
            margin: EdgeInsets.only(top: 20, left: 20, right: 20), // Position at the top
            elevation: 0, // No shadow for SnackBar
            duration: Duration(seconds: 3), // Display duration
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Rounded corners
            ),
          ),
        );
      });
    }

    return GestureDetector(
      onTap: () => _showModalBottomSheet(context, type),
      child: Column(
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: LiquidCircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              center: Text(
                '${(progress * 100).toStringAsFixed(0)}%',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              borderWidth: 5,
              borderColor: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            type.capitalize(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green[900]),
          ),
        ],
      ),
    );
  }
}

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}