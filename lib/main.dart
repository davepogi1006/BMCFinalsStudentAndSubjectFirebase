import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserRegistrationScreen(),
    );
  }
}

class UserRegistrationScreen extends StatefulWidget {
  const UserRegistrationScreen({super.key});

  @override
  State<UserRegistrationScreen> createState() => _UserRegistrationScreenState();
}

class _UserRegistrationScreenState extends State<UserRegistrationScreen> {
  final nController = TextEditingController();
  final sController = TextEditingController();
  final cController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('User Registration')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            TextField(
              controller: nController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: sController,
              decoration: const InputDecoration(labelText: 'Section'),
            ),
            TextField(
              controller: cController,
              decoration: const InputDecoration(labelText: 'Course'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectEnrollmentScreen(
                      name: nController.text,
                      section: sController.text,
                      course: cController.text,
                    ),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectEnrollmentScreen extends StatefulWidget {
  final String name;
  final String section;
  final String course;

  const SubjectEnrollmentScreen({
    super.key,
    required this.name,
    required this.section,
    required this.course,
  });

  @override
  State<SubjectEnrollmentScreen> createState() =>
      _SubjectEnrollmentScreenState();
}

class _SubjectEnrollmentScreenState extends State<SubjectEnrollmentScreen> {
  final subject1Controller = TextEditingController();
  final time1Controller = TextEditingController();
  final subject2Controller = TextEditingController();
  final time2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subject Enrollment')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: [
            TextField(
              controller: subject1Controller,
              decoration: const InputDecoration(labelText: 'Subject 1'),
            ),
            TextField(
              controller: time1Controller,
              decoration: const InputDecoration(labelText: 'Time 1'),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: subject2Controller,
              decoration: const InputDecoration(labelText: 'Subject 2'),
            ),
            TextField(
              controller: time2Controller,
              decoration: const InputDecoration(labelText: 'Time 2'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubjectVerificationScreen(
                      name: widget.name,
                      section: widget.section,
                      course: widget.course,
                      sub1: subject1Controller.text,
                      time1: time1Controller.text,
                      sub2: subject2Controller.text,
                      time2: time2Controller.text,
                    ),
                  ),
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectVerificationScreen extends StatefulWidget {
  final String name;
  final String section;
  final String course;
  final String sub1;
  final String time1;
  final String sub2;
  final String time2;

  const SubjectVerificationScreen({
    super.key,
    required this.name,
    required this.section,
    required this.course,
    required this.sub1,
    required this.time1,
    required this.sub2,
    required this.time2,
  });

  @override
  State<SubjectVerificationScreen> createState() =>
      _SubjectVerificationScreenState();
}

class _SubjectVerificationScreenState extends State<SubjectVerificationScreen> {
  bool _isSaving = false;

  Future<void> _saveEnrollment() async {
    setState(() => _isSaving = true);

    try {
      await FirebaseFirestore.instance.collection('enrollments').add({
        'name': widget.name,
        'section': widget.section,
        'course': widget.course,
        'subjects': [
          {'name': widget.sub1, 'time': widget.time1},
          {'name': widget.sub2, 'time': widget.time2},
        ],
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Enrollment saved to Firebase!')),
      );
      Navigator.popUntil(context, (route) => route.isFirst);
    } on FirebaseException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not save enrollment: ${error.message ?? error.code}',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Subject Verification')),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: ${widget.name}'),
            Text('Section: ${widget.section}'),
            Text('Course: ${widget.course}'),
            const SizedBox(height: 14),
            Text('1. ${widget.sub1}'),
            Text('Time: ${widget.time1}'),
            const SizedBox(height: 6),
            Text('2. ${widget.sub2}'),
            Text('Time: ${widget.time2}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSaving ? null : _saveEnrollment,
              child: Text(_isSaving ? 'Saving...' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
