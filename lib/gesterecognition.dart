import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'main.dart';

class GestureRecognitionPage extends StatelessWidget {
  final CameraDescription camera;

  GestureRecognitionPage({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Roboto',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Gesture Recognition App'),
          backgroundColor: Color.fromARGB(255, 22, 82, 185),
        ),
        drawer: _buildDrawer(context),
        body: TakePictureScreen(camera: camera),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 22, 82, 185),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.blue),
                ),
                SizedBox(height: 10),
                Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          _buildDrawerItem(Icons.home, 'Accueil', context),
          _buildDrawerItem(Icons.settings, 'Paramètres', context),
          _buildDrawerItem(Icons.help, 'Aide', context),
          _buildDrawerItem(Icons.logout, 'Déconnexion', context, isLogout: true),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, BuildContext context, {bool isLogout = false}) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        if (isLogout) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage(camera: camera)),
          );
        } else {
          // Action pour l'élément
        }
      },
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  final CameraDescription camera;

  TakePictureScreen({required this.camera});

  @override
  _TakePictureScreenState createState() => _TakePictureScreenState();
}

class _TakePictureScreenState extends State<TakePictureScreen> {
  static const Color customBlue = Color.fromARGB(255, 22, 82, 185);
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String _prediction = 'Unknown';
  bool _isProcessing = false;
  bool _isCameraOn = true;
  FlutterTts flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _initializeTts();
  }

  void _initializeCamera() async {
    try {
      _controller = CameraController(
        widget.camera,
        ResolutionPreset.max,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller.initialize();
    } catch (e) {
      print('Erreur d\'initialisation de la caméra: $e');
    }
  }

  void _initializeTts() async {
    await flutterTts.setLanguage('fr-FR'); 
    await flutterTts.setSpeechRate(0.5);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _uploadImage(File image) async {
    setState(() {
      _isProcessing = true;
    });

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://10.0.2.2:5000/predict'),
    );
    request.files.add(await http.MultipartFile.fromPath('file', image.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseData = await response.stream.toBytes();
      final responseJson = jsonDecode(utf8.decode(responseData));
      setState(() {
        _prediction = responseJson['predicted_action'].toString();
      });
    } else {
      setState(() {
        _prediction = 'Error: ${response.statusCode}';
      });
    }

    setState(() {
      _isProcessing = false;
    });
  }

  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();

      final tempDir = await getTemporaryDirectory();
      final tempPath = '${tempDir.path}/temp_image.jpg';
      await image.saveTo(tempPath);

      final file = File(tempPath);
      await _uploadImage(file);
    } catch (e) {
      print('Error taking picture: $e');
      setState(() {
        _prediction = 'Error: ${e.toString()}';
      });
    }
  }

  void _toggleCamera() {
    setState(() {
      if (_isCameraOn) {
        _controller.dispose();
      } else {
        _initializeCamera();
      }
      _isCameraOn = !_isCameraOn;
    });
  }

  void _translateToVoice() async {
    if (_prediction.isNotEmpty) {
      await flutterTts.speak(_prediction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: customBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            _buildInstructions(),
            Expanded(
              child: FutureBuilder<void>(
                future: _initializeControllerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: customBlue,
                          width: 4,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: _isCameraOn ? CameraPreview(_controller) : Center(child: Text('Caméra fermée')),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
            SizedBox(height: 20),
            _buildButtonRow(),
            SizedBox(height: 20),
            _buildPredictionText(),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Instructions pour capturer un geste :',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: customBlue,
          ),
        ),
        Text(
          '1. Positionnez votre main dans le cadre.',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        Text(
          '2. Assurez-vous que le geste est bien visible.',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        Text(
          '3. Cliquez sur le bouton pour capturer l\'image.',
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildButtonRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildIconButton(
          icon: _isCameraOn ? Icons.power_settings_new : Icons.power_off,
          onPressed: _toggleCamera,
          tooltip: _isCameraOn ? 'Désactiver la caméra' : 'Activer la caméra',
        ),
        _buildIconButton(
          icon: Icons.camera_alt,
          onPressed: _takePicture,
          tooltip: 'Capturer',
        ),
        _buildIconButton(
          icon: Icons.volume_up,
          onPressed: _translateToVoice,
          tooltip: 'Générer vocal',
        ),
      ],
    );
  }

  Widget _buildIconButton({required IconData icon, required VoidCallback onPressed, required String tooltip}) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      color: customBlue,
    );
  }

  Widget _buildPredictionText() {
    return _isProcessing
        ? CircularProgressIndicator()
        : Text(
            'Prédiction : $_prediction',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: customBlue,
            ),
          );
  }
}