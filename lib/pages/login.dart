import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final box = Hive.box('TokenBox');
  get_token({required String username, required String password}) async {
    var url = Uri.parse('http://192.168.42.236:8000/login/');
    var response = await http.post(url, body: {
      'username': username,
      'password': password,
    });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var tokenData = data['token'];
      await box.delete('token');
      debugPrint("before puting: ${box.get('token')}");
      await box.put('token', tokenData);
      debugPrint("after puting: ${box.get('token')}");
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text('Login'),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  hintText: 'Username',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () => {
                  get_token(
                      username: _usernameController.text,
                      password: _passwordController.text),
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ));
  }
}
