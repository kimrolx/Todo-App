import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:todo_app/models/todo_item.dart';
import 'package:todo_app/services/todo_service.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TodoService _todoService = TodoService();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.green,
        centerTitle: true,
        title: const Text(
          'Tasks',
          style: TextStyle(
            fontFamily: 'Helvetica',
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<TodoItem>('todoBox').listenable(),
        builder: (context, Box<TodoItem> box, _) {
          return ListView.builder(
            itemCount: box.values.length,
            itemBuilder: (context, index) {
              var todo = box.getAt(index);
              return Card(
                elevation: 10.0,
                margin:
                    const EdgeInsets.symmetric(vertical: 7.0, horizontal: 14.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: ListTile(
                  title: Text(
                    todo!.title,
                    style: const TextStyle(
                      fontFamily: 'Helvetica',
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  leading: MSHCheckbox(
                    size: 20,
                    value: todo.isCompleted,
                    colorConfig: MSHColorConfig.fromCheckedUncheckedDisabled(
                      checkedColor: Colors.green,
                    ),
                    style: MSHCheckboxStyle.fillScaleColor,
                    onChanged: (val) {
                      _todoService.updateIsCompleted(index, todo);
                    },
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      _todoService.deleteTodo(index);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green,
        elevation: 20.0,
        label: const Text(
          'New Task',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add),
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('New Task'),
                content: TextField(
                  controller: _textEditingController,
                ),
                actions: [
                  ElevatedButton(
                    child: const Text('Add'),
                    onPressed: () async {
                      Navigator.pop(context);
                      var todo = TodoItem(_textEditingController.text, false);
                      await _todoService.addItem(todo);
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
