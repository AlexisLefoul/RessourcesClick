import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  // Cette fonction charge toutes les caméras disponibles
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera App',
      home: CameraScreen(),
    );
  }
}

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    // Initialise le contrôleur de la caméra
    controller = CameraController(
      cameras[0], // Utilise la première caméra disponible
      ResolutionPreset.medium, // Réglage de la résolution de la caméra
    );

    // Initialise la caméra
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    // Libère les ressources de la caméra
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container(); // Affiche un conteneur vide s'il n'y a pas de caméra disponible
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Camera App'),
      ),
      body: CameraPreview(controller), // Affiche la preview de la caméra
    );
  }
}
