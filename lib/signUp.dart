import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                  'Inscription',
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
                    height: 120,
                    width: 120,
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
                  controller: _emailController,
                  labelText: 'Email',
                  obscureText: false,
                ),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'Mot de passe',
                  obscureText: true,
                ),
                 SizedBox(height: 20),
                _buildTextField(
                  controller: _passwordController,
                  labelText: 'confirmer le mot de passe',
                  obscureText: true,
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    // Ajouter la logique d'inscription ici
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Inscription en cours...')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 59, 73, 236),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    side: BorderSide(color: const Color.fromARGB(255, 32, 103, 227)),
                  ),
                  child: Text(
                    'S\'inscrire',
                    style: TextStyle(color: Colors.black),
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
