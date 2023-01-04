import 'dart:convert';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:what_todo/models/todo.dart';
import 'package:http/http.dart' as http;
import '../widgets/todo_tile.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Todo> todos = [];
  var box = Hive.box('TokenBox');

  deleteTodo(id) async {
    final response = await http.delete(
        Uri.parse('http://192.168.42.236:8000/delete_api/$id'),
        headers: {
          'Content-Type': 'application/json',
          'authorization': "Token ${box.get('token')}",
        });
    if (response.statusCode == 200) {
      debugPrint('delete_todo end');
      todos.clear();

      fetchTodos();
    } else {
      throw Exception('Failed to delete todo');
    }
  }

  addTodo(String todo, bool completed) async {
    final response =
        await http.post(Uri.parse('http://192.168.42.236:8000/api/'),
            body: jsonEncode(<String, dynamic>{
              'todo': todo,
              'completed': false,
            }),
            headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'authorization': "Token ${box.get('token')}",
        });
    if (response.statusCode == 200) {
      // rebuild the screen
      setState(() {
        todos.clear();
        fetchTodos();
      });
      // adding = false;
    } else {
      throw Exception('Failed to add todo');
    }
  }

  fetchTodos() async {
    debugPrint('fetchTodos called');
    final response =
        await http.get(Uri.parse('http://192.168.42.236:8000/api/'), headers: {
      'Content-Type': 'application/json',
      'authorization': "Token ${box.get('token')}",
    });
    if (response.statusCode == 200) {
      final todosJson = jsonDecode(response.body) as List;
      setState(() {
        for (var todoJson in todosJson) {
          todos.add(Todo(
              id: todoJson['id'],
              todo: todoJson['todo'],
              completed: todoJson['completed']));
        }
      });
      debugPrint('fetchTodos end');
    } else {
      throw Exception('Failed to load todos');
    }
  }

  @override
  void initState() {
    super.initState();
    debugPrint('initState called');
    fetchTodos();
    debugPrint('initState end');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'What To Do?',
          style: TextStyle(color: Color.fromARGB(255, 72, 52, 52)),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              // fetchTodos();
              box.delete('token');
              Navigator.pushReplacementNamed(context, '/login');
            },
            icon: const Icon(Icons.logout),
            color: Colors.black,
          ),
        ],
      ),
      body: LiquidPullToRefresh(
        onRefresh: () async {
          todos.clear();
          fetchTodos();
        },
        animSpeedFactor: 10,
        height: 150,
        color: Colors.black,
        backgroundColor: Colors.white,
        child: ListView(
          children: todos
              .map((todo) => TodoTile(
                    todo: todo,
                    deleteTodo: () => deleteTodo(todo.id),
                  ))
              .toList(),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => addTodo("By Mobile Application", false)),
    );
  }
}
