import 'package:flutter/material.dart';
import 'package:todolist/screens/models/todo.dart';
import 'package:todolist/screens/models/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key});

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late String title;
  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  List<Todo> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: addTodo,
        child: const Icon(Icons.add),
      ),
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text("Todo List"),
        actions: const [
          Icon(Icons.settings),
          SizedBox(
            width: 5,
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.center,
              color: Colors.transparent,
              child: Form(
                  key: formKey,
                  child: TextFormField(
                    autovalidateMode: autovalidateMode,
                    onSaved: (newValue) {
                      title = newValue!;
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Boş geçilemez!";
                      } else {
                        return null;
                      }
                    },
                    decoration: const InputDecoration(
                        labelText: "Başlık", hintText: "Başlık giriniz"),
                  )),
            ),
          ),
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(10),
              alignment: Alignment.topCenter,
              child: GridView.count(
                crossAxisCount: 1,
                childAspectRatio: 15,
                mainAxisSpacing: 5,
                crossAxisSpacing: 5,
                children: todoList.map((item) {
                  return InkWell(
                    child: ListTile(
                      tileColor: item.isComplated
                          ? Colors.red[100]
                          : Colors.green[100],
                      title: TextFormField(
                        style: item.isComplated == false
                            ? const TextStyle()
                            : const TextStyle(
                                decoration: TextDecoration.lineThrough),
                        initialValue: item.title,
                        onChanged: (value) {
                          setState(() {
                            item.title = value;
                          });
                        },
                      ),
                      subtitle: const Text("Tıkla ve Tamamla"),
                      leading: Checkbox(
                        value: item.isComplated,
                        onChanged: (value) {
                          setState(() {
                            item.isComplated = value!;
                          });
                        },
                      ),
                      trailing: InkWell(
                        child: const Icon(Icons.close),
                        onTap: () {
                          setState(() {
                            deleteTodo(item.id);
                          }); //Delete
                        },
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        item.isComplated = !item.isComplated;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          )
        ],
      ),
    );
  }

  void addTodo() {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      setState(() {
        todoList.add(Todo(
            id: todoList.isNotEmpty ? todoList.last.id + 1 : 1,
            title: title,
            isComplated: false));
      });
      debugPrint(todoList.toString());
      alertSuccess();
      formKey.currentState!.reset();
    } else {
      setState(() {
        autovalidateMode = AutovalidateMode.always;
      });
    }
  }

  void deleteTodo(int id) {
    final item = todoList.firstWhere((element) => element.id == id);
    todoList.remove(item);
  }

  void alertSuccess() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Kapat"))
              ],
              content: SizedBox(
                height: 100,
                child: Column(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 72,
                    ),
                    Container(
                        margin: const EdgeInsets.only(top: 5),
                        child: const Text("Kayıt Eklendi!")),
                  ],
                ),
              ),
            ));
  }
}