import 'package:flutter/material.dart';
import 'package:get/get.dart';
// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:slam_pakistan_1/Widget/custom_button.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LandingPageState createState() => _LandingPageState();
}

//newclass
class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  double _event1Opacity = 0.0;
  double _event2Opacity = 0.0;
  double _teamOpacity = 0.0;
  Map<String, dynamic>? _applicationDetails;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    double event1Offset = 100; // Adjust these offsets as needed
    double event2Offset = 200;
    double teamOffset = 300;

    setState(() {
      _event1Opacity = _scrollController.offset > event1Offset ? 1.0 : 0.8;
      _event2Opacity = _scrollController.offset > event2Offset ? 1.0 : 0.7;
      _teamOpacity = _scrollController.offset > teamOffset ? 1.0 : 0.6;
    });
  }

  Future<void> _searchApplication() async {
    final serialNumber = _searchController.text.trim();

    if (serialNumber.isNotEmpty) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('applications')
            .where('serialNumber', isEqualTo: serialNumber)
            .get();

        if (snapshot.docs.isNotEmpty) {
          setState(() {
            _applicationDetails = snapshot.docs.first.data();
          });
        } else {
          setState(() {
            _applicationDetails = null;
          });
          Get.snackbar(
            "No Results",
            "No application found with Serial Number $serialNumber",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
          );
        }
      } catch (e) {
        Get.snackbar(
          "Error",
          "Failed to fetch application: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header Section
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.6,
              padding: const EdgeInsets.all(20.0),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Logo and Organization Name
                      Row(
                        children: [
                          Image.asset(
                            'images/logo.png',
                            color: Colors.white, // Your logo path
                            height: 50,
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                    'Salam Pakistan Organization',
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Column(
                    children: [
                      Text(
                        'Presents',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Seerat Un Nabi Debating Competition 2024',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const AnimatedApplyButton(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search Application',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            labelText: 'Enter Serial Number',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _searchApplication,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                        ),
                        child: const Text('Search'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _applicationDetails != null
                      ? _buildApplicationDetails()
                      : const SizedBox.shrink(),
                  const SizedBox(height: 20),
                  const Text(
                    'Organization Highlights',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _event1Opacity,
                    child: _buildEvent(
                      context,
                      'Salam Pakistan Debating Writing and Painting Competition 2010',
                      'This competition was held at the school level, encouraging youth to express their talents in debating, writing, and painting. It was a significant success, with numerous participants showcasing their creativity and oratory skills. This event played a crucial role in fostering a sense of confidence and enthusiasm among young students, many of whom went on to achieve great success in their respective fields.',
                      'images/event_1.jpg',
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _event2Opacity,
                    child: _buildEvent(
                      context,
                      'Salam Pakistan Azadi Show 2016',
                      'Held on Pakistan\'s Independence Day, the Salam Pakistan Azadi Show 2016 was a grand celebration of the nation’s freedom. This event became the largest gathering in the history of Dokota and Tehsil Mailsi, bringing together people from all walks of life. The show featured performances, speeches, and cultural displays that captured the spirit of patriotism and unity.',
                      'images/event_2.jpg',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Meet Our Team',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AnimatedOpacity(
                    duration: const Duration(seconds: 1),
                    opacity: _teamOpacity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeamMember(
                          'images/ashfaq_sb.jpg',
                          'Ahmad Ashfaq Sehar',
                          'Event Coordinator',
                        ),
                        _buildTeamMember(
                          'images/iqbal_javed.jpg',
                          'Iqbal Javed',
                          'Event Director',
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildApplicationDetails() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'SALAM PAKISTAN ORGANIZATION DOKOTA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
                letterSpacing: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Name: ${_applicationDetails!['applicantName']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Father Name: ${_applicationDetails!['fatherName']}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: _applicationDetails!['imageUrl'] != null
                    ? Image.network(
                        _applicationDetails!['imageUrl'],
                        height: 100,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        height: 100,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Text('No Image Available'),
                        ),
                      ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'School/College: ${_applicationDetails!['schoolCollege']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Class: ${_applicationDetails!['studentClass']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Category: ${_applicationDetails!['category']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Contact Number 1: ${_applicationDetails!['contactNumber1']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Contact Number 2: ${_applicationDetails!['contactNumber2']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Address: ${_applicationDetails!['address']}',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEvent(BuildContext context, String title, String description,
      String imagePath) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            imagePath,
            width: 120,
            height: 120,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String imagePath, String name, String designation) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage(imagePath),
        ),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        Text(
          designation,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }
}
