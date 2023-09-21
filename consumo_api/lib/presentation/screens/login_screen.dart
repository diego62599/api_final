import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:consumo_api/presentation/screens/admin_screen.dart';
import 'package:consumo_api/presentation/screens/books_screen.dart';
import 'package:consumo_api/presentation/screens/user_register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible = true;

  final String url = 'https://api-clientes-moviles.onrender.com/api/users/login';

  Future<void> apiLogin() async {
    final email = emailController.text;
    final password = passwordController.text;

    final body = jsonEncode({'correo': email, 'contrasena': password});

    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body,
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final rol = responseData['rol'];

      if (rol != null) {
        if (rol.toString().toLowerCase() == 'administrador') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AdminScreen()),
          );
          return;
        } else {
          // El usuario no es un administrador
          // Haz lo que sea necesario en este caso
        }
      } else {
        // La respuesta no contiene la clave 'rol'
        _showErrorSnackBar("La respuesta no contiene el rol del usuario");
      }
    } else if (response.statusCode == 401) {
      // Error: Credenciales incorrectas
      _showErrorSnackBar("Credenciales incorrectas");
    } else {
      // Otro error desconocido
      print("Código de estado: ${response.statusCode}");
      print("Cuerpo de la respuesta: ${response.body}");
      _showErrorSnackBar("Error desconocido");
    }
  }

  void _showErrorSnackBar(String errorMessage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(errorMessage),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Correo electrónico',
                  hintText: 'Ingrese su correo',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su correo';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  hintText: 'Ingrese su contraseña',
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isVisible = !_isVisible;
                      });
                    },
                    icon: _isVisible
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
                ),
                obscureText: !_isVisible,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, ingrese su contraseña';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    apiLogin();
                  }
                },
                child: const Text('Iniciar Sesión'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const UserRegisterScreen(),
                    ),
                  );
                },
                child: const Text('Registrarse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
