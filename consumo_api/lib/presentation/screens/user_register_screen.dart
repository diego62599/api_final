import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserRegisterScreen extends StatefulWidget {
  const UserRegisterScreen({super.key});

  @override
  State<UserRegisterScreen> createState() => _UserRegisterScreenState();
}

class _UserRegisterScreenState extends State<UserRegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String rol = "Cliente";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isVisible = true;

  final String url = 'https://api-clientes-moviles.onrender.com/api/users';

  void apiLogin() async {
    final name = nameController.text;
    final email = emailController.text;
    final password = passwordController.text;

    final body = jsonEncode(
        {'nombre': name, 'correo': email, 'contrasena': password, 'rol': rol});

    final response = await http.post(Uri.parse(url),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: body);

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Registro exitoso')));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error de registro')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(60.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    labelText: 'Nombre',
                    hintText: 'Ingrese su nombre',
                    prefixIcon: Icon(Icons.person)),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'Ingrese su correo',
                    prefixIcon: Icon(Icons.email_outlined)),
              ),
              TextField(
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
                          : Icon(Icons.visibility_off)),
                ),
                obscureText: _isVisible,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    apiLogin();
                  },
                  child: const Text('Registrarse')),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancelar',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
