// ignore_for_file: unused_field

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class BookRegisterScreen extends StatefulWidget {
  const BookRegisterScreen({super.key});

  @override
  State<BookRegisterScreen> createState() => _BookRegisterScreenState();
}

class _BookRegisterScreenState extends State<BookRegisterScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController autorController = TextEditingController();
  TextEditingController anoController = TextEditingController();
  TextEditingController Controller = TextEditingController();
  String estado = 'Activo';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // ignore: prefer_final_fields
  bool _isVisible = true;

  final String url = 'https://api-flutter.onrender.com/api/books';

  void regitrarLibro() async {
    final name = nameController.text;
    final autor = autorController.text;
    final ano = anoController.text;

    final body = jsonEncode({
      'nombre': name,
      'autor': autor,
      'año': int.parse(ano),
      'estado': estado
    });

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
                    hintText: 'Ingrese el nombre',
                    prefixIcon: Icon(Icons.book)),
              ),
              TextField(
                controller: autorController,
                decoration: const InputDecoration(
                    labelText: 'Autor',
                    hintText: 'Ingrese el autor',
                    prefixIcon: Icon(Icons.person_2)),
              ),
              TextField(
                keyboardType: TextInputType.number,
                controller: anoController,
                decoration: InputDecoration(
                  labelText: 'Año',
                  hintText: 'Ingrese el año',
                  prefixIcon: Icon(Icons.calendar_month),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    regitrarLibro();
                  },
                  child: const Text('Registrar')),
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
