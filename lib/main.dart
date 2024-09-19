import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'signUp.dart'; // Import the signUp.dart file
import 'gesterecognition.dart'; // Import the gesture recognition page
import 'package:camera/camera.dart'; // Import camera package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final firstCamera = cameras.first;

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  final CameraDescription camera;

  MyApp({required this.camera});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(camera: camera),
      routes: {
        '/gesterecognition': (context) => GestureRecognitionPage(camera: camera),
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final CameraDescription camera;

  LoginPage({required this.camera});

  static const Color customBlue = Color.fromARGB(255, 22, 82, 185);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: customBlue,
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: customBlue,
            width: 15.0,
          ),
        ),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Gestures Translator',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: customBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                ClipOval(
                  child: Image.asset(
                    'assets/images/logo2.png',
                    height: 110,
                    width: 110,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField(
                  controller: _usernameController,
                  labelText: 'Nom d\'utilisateur',
                  obscureText: false,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Mot de passe',
                  obscureText: true,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to GestureRecognitionPage
                    Navigator.pushReplacementNamed(context, '/gesterecognition');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 59, 73, 236),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    side: BorderSide(color: const Color.fromARGB(255, 32, 103, 227)),
                  ),
                  child: Text(
                    'Se connecter',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Ou connectez-vous avec',
                  style: TextStyle(
                    fontSize: 16,
                    color: customBlue,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.google),
                      iconSize: 40,
                      color: customBlue,
                      onPressed: () {
                        // Ajouter la logique pour se connecter avec Gmail ici
                      },
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.facebook),
                      iconSize: 40,
                      color: customBlue,
                      onPressed: () {
                        // Ajouter la logique pour se connecter avec Facebook ici
                      },
                    ),
                    SizedBox(width: 20),
                    IconButton(
                      icon: FaIcon(FontAwesomeIcons.twitter),
                      iconSize: 40,
                      color: customBlue,
                      onPressed: () {
                        // Ajouter la logique pour se connecter avec Twitter ici
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    // Navigate to SignupPage
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupPage()),
                    );
                  },
                  child: Text(
                    'Créer un compte',
                    style: TextStyle(color: customBlue),
                  ),
                ),
                SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    // Ajouter la logique pour mot de passe oublié ou inscription ici
                  },
                  child: Text(
                    'Mot de passe oublié ?',
                    style: TextStyle(color: customBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required bool obscureText,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: labelText,
        labelStyle: TextStyle(color: customBlue),
        filled: true,
        fillColor: Colors.blue[50],
      ),
    );
  }
}
