import 'dart:io'; // Import only if you're targeting platforms other than web

// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:slam_pakistan_1/data_model.dart';
import 'package:slam_pakistan_1/firebase_options.dart';
import 'package:slam_pakistan_1/firebase_services.dart';
import 'package:slam_pakistan_1/receipt_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Seerat Un Nabi Debating Competition',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MainBanner(animation: _animation),
            const CompetitionAndForm(),
            const TeamSection(),
          ],
        ),
      ),
    );
  }
}

class MainBanner extends StatelessWidget {
  final Animation<double> animation;

  const MainBanner({super.key, required this.animation});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 400,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7a1fa2), Color(0xFFa52124), Color(0xFFc2272d)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            image: DecorationImage(
              image: AssetImage('images/header_bg.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black45,
                BlendMode.darken,
              ),
            ),
          ),
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(
              scale: animation,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: const Text(
                        'Seerat Un Nabi Debating Competition',
                        style: TextStyle(
                          fontSize: 42,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.5,
                          shadows: [
                            Shadow(
                              offset: Offset(2.0, 2.0),
                              blurRadius: 3.0,
                              color: Color.fromARGB(128, 0, 0, 0),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 1),
                        end: Offset.zero,
                      ).animate(animation),
                      child: const Text(
                        'Empowering Young Minds to Speak on the Life of Prophet Muhammad (PBUH)',
                        style: TextStyle(
                          fontSize: 22,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: const Text('SALAM PAKISTAN ORGANIZATION'),
            centerTitle: true,
          ),
        ),
      ],
    );
  }
}

class CompetitionAndForm extends StatelessWidget {
  const CompetitionAndForm({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth > 800) {
            return const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AboutSection(),
                      SizedBox(height: 20),
                      CompetitionDetails(),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Expanded(flex: 3, child: ApplyForm()),
              ],
            );
          } else {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AboutSection(),
                SizedBox(height: 20),
                CompetitionDetails(),
                SizedBox(height: 20),
                ApplyForm(),
              ],
            );
          }
        },
      ),
    );
  }
}

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Us',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'SALAM PAKISTAN ORGANIZATION is committed to nurturing young minds and promoting the teachings of Islam through meaningful debates and discussions.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class CompetitionDetails extends StatelessWidget {
  const CompetitionDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Competition Details',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'The "Seerat Un Nabi" Debating Competition is organized for Primary, Middle, High, and College level students. Each category will have different topics and debate durations.',
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Text(
            'Audition Process: Students will apply for auditions, and selected candidates will proceed to the final competition.',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class ApplyForm extends StatefulWidget {
  const ApplyForm({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ApplyFormState createState() => _ApplyFormState();
}

class _ApplyFormState extends State<ApplyForm>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fatherNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _schoolCollegeController =
      TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _contact1Controller = TextEditingController();
  final TextEditingController _contact2Controller = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  // Image picker and storage
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  String? _uploadedImageUrl;
  double _uploadProgress = 0;

  // Form fields
  String _name = '';
  String _fatherName = '';
  DateTime _dob = DateTime.now();
  String _schoolCollege = '';
  String _class = '';
  String _category = 'Primary';
  String _contact1 = '';
  String _contact2 = '';
  String _address = '';

  // Serial Number
  int _serialNumber = 0;
  bool _isLoading = true;

  late AnimationController _controller;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _buttonAnimation =
        Tween<double>(begin: 1.0, end: 1.05).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _controller.reverse();
      }
    });

    _fetchSerialNumber();
  }

  Future<void> _fetchSerialNumber() async {
    try {
      DocumentReference serialDoc =
          FirebaseFirestore.instance.collection('counters').doc('serial');

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot snapshot = await transaction.get(serialDoc);

        if (!snapshot.exists) {
          transaction.set(serialDoc, {'current': 0});
          _serialNumber = 1000;
        } else {
          int current = snapshot.get('current') as int;
          _serialNumber = current + 1;
          transaction.update(serialDoc, {'current': _serialNumber});
        }
      });

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching serial number: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = pickedFile;
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_selectedImage == null) return;

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('applications/${_name}_${_dob.toIso8601String()}.jpg');

    UploadTask uploadTask =
        storageRef.putData(await _selectedImage!.readAsBytes());

    uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
      setState(() {
        _uploadProgress = snapshot.bytesTransferred.toDouble() /
            snapshot.totalBytes.toDouble();
      });
    });

    TaskSnapshot taskSnapshot = await uploadTask;
    _uploadedImageUrl = await taskSnapshot.ref.getDownloadURL();
  }

//asdbas
  void _submitApplyForm() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      _formKey.currentState!.save();

      // Upload the image and get the download URL
      await _uploadImage();

      final newApplication = ApplicationForm(
        serialNumber: _serialNumber,
        name: _nameController.text.toString(),
        fatherName: _fatherNameController.text.toString(),
        dob: _dob,
        schoolCollege: _schoolCollegeController.text.toString(),
        studentClass: _classController.text.toString(),
        category: _category,
        contact1: _contact1Controller.text.toString(),
        contact2: _contact2Controller.text.toString(),
        address: _addressController.text.toString(),
        imageUrl: _uploadedImageUrl!,
      );

      FirebaseService().addApplication(newApplication);
      if (kDebugMode) {
        print('Application added to Firebase');
      }

      // Navigate to ReceiptScreen
      // ignore: use_build_context_synchronously
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => ReceiptScreen(application: newApplication),
        ),
      );

      // Clear the form fields after submission
      _nameController.clear();
      _fatherNameController.clear();
      _dobController.clear();
      _schoolCollegeController.clear();
      _classController.clear();
      _contact1Controller.clear();
      _contact2Controller.clear();
      _addressController.clear();
      setState(() {
        _selectedImage = null;
        _uploadProgress = 0;
      });
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an image')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Application Form',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        initialValue:
                            _serialNumber != null ? '$_serialNumber' : '',
                        decoration:
                            const InputDecoration(labelText: 'Serial Number'),
                        readOnly: true,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(labelText: 'Name'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _fatherNameController,
                        decoration:
                            const InputDecoration(labelText: "Father's Name"),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your father's name";
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _fatherName = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'Date of Birth'),
                        onTap: () async {
                          FocusScope.of(context).requestFocus(FocusNode());
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: _dob,
                            firstDate: DateTime(2000),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null && picked != _dob) {
                            setState(() {
                              _dob = picked;
                            });
                          }
                        },
                        readOnly: true,
                        controller: TextEditingController(
                          text: "${_dob.toLocal()}".split(' ')[0],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _schoolCollegeController,
                        decoration:
                            const InputDecoration(labelText: 'School/College'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your School/College';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _schoolCollege = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _classController,
                        decoration: const InputDecoration(labelText: 'Class'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your class';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _class = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        decoration:
                            const InputDecoration(labelText: 'Category'),
                        value: _category,
                        items: const [
                          DropdownMenuItem(
                            value: 'Primary',
                            child: Text('Primary'),
                          ),
                          DropdownMenuItem(
                            value: 'Middle',
                            child: Text('Middle'),
                          ),
                          DropdownMenuItem(
                            value: 'High',
                            child: Text('High'),
                          ),
                          DropdownMenuItem(
                            value: 'College',
                            child: Text('College'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _category = value!;
                          });
                        },
                        onSaved: (value) {
                          _category = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _contact1Controller,
                        decoration:
                            const InputDecoration(labelText: 'Contact #1'),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a contact number';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _contact1 = value!;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _contact2Controller,
                        decoration:
                            const InputDecoration(labelText: 'Contact #2'),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) {
                          _contact2 = value ?? '';
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(labelText: 'Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _address = value!;
                        },
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'Upload Profile Picture:',
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: _selectedImage == null
                              ? const CircleAvatar(
                                  radius: 200,
                                  child: Center(
                                    child: Text(
                                      'Tap to select an image',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                )
                              : Image.network(
                                  _selectedImage!.path,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_uploadProgress > 0)
                        LinearProgressIndicator(value: _uploadProgress),
                      const SizedBox(height: 20),
                      ScaleTransition(
                        scale: _buttonAnimation,
                        child: ElevatedButton(
                          onPressed: _submitApplyForm,
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class TeamSection extends StatelessWidget {
  const TeamSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF7a1fa2), Color(0xFFa52124), Color(0xFFc2272d)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        children: [
          Text(
            'Our Team',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TeamMemberCard(
                name: 'Ahmed Ashfaq Sehar',
                role: 'Coordinator',
                image: 'images/ashfaq_sb.jpg',
              ),
              TeamMemberCard(
                name: 'Iqbal Javed',
                role: 'Event Planner',
                image: 'images/iqbal_javed.jpg',
              ),
              TeamMemberCard(
                name: 'Ahmad Ashfaq Sehar',
                role: 'Marketing Head',
                image: 'images/ashfaq_sb.jpg',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TeamMemberCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;

  const TeamMemberCard({
    super.key,
    required this.name,
    required this.role,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {},
      onExit: (_) {},
      child: Container(
        height: 200,
        width: 300,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(10),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(50),
              child: Image.asset(
                image,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              role,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
