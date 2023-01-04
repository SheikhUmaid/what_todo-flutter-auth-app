// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace,, dead_code

import 'package:flutter/material.dart';
// import 'package:http/http.dart';
// import 'package:todo/models/todo.dart';
import 'package:what_todo/models/todo.dart';

class TodoTile extends StatelessWidget {
  Todo todo;
  Function deleteTodo;
  TodoTile({
    super.key,
    required this.todo,
    required this.deleteTodo,
  });

  // const TodoTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Container(
        width: double.infinity,
        child: Card(
          color: Colors.black,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: todo.completed ? Colors.green : Colors.red,
                  // backgroundColor: true ? Colors.green : Colors.red,
                  radius: 9,
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      todo.todo,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    IconButton(
                        tooltip: 'Delete this One',
                        onPressed: () => deleteTodo(),
                        icon: Icon(
                          Icons.delete_forever,
                          color: Colors.white,
                        )),
                  ],
                ),
                SizedBox(
                  height: 8.0,
                ),
                Text(
                  todo.completed ? 'Completed' : 'Not Completed',
                  style: TextStyle(
                      color: Colors.white24,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
