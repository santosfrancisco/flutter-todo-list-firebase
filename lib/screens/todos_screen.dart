import 'package:firebasetodoapp/utils/validator.dart';
import 'package:firebasetodoapp/widgets/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:firebasetodoapp/constants/colors.dart';
import 'package:firebasetodoapp/database/database.dart';
import 'package:firebasetodoapp/widgets/item_list.dart';

class TodosScreen extends StatefulWidget {
  @override
  _TodosScreenState createState() => _TodosScreenState();
}

class _TodosScreenState extends State<TodosScreen> {
  final _focusNode = FocusNode();
  final _todoFormKey = GlobalKey<FormState>();
  final TextEditingController _todoTitleController = TextEditingController();

  void _createTodo() {
    if (_todoFormKey.currentState!.validate()) {
      Database.addItem(title: _todoTitleController.text);
      _todoTitleController.clear();
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColors.firebaseNavy,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomColors.firebaseNavy,
        title: Text('Lista de tarefas'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: Text('Nova tarefa'),
                content: Form(
                  key: _todoFormKey,
                  child: CustomFormField(
                    focusNode: _focusNode,
                    controller: _todoTitleController,
                    keyboardType: TextInputType.text,
                    inputAction: TextInputAction.done,
                    validator: (value) => Validator.validateField(value: value),
                    label: 'O que quer fazer?',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: _createTodo,
                    child: Text('OK'),
                  )
                ],
              );
            },
          );
        },
        backgroundColor: CustomColors.firebaseOrange,
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: ItemList(),
        ),
      ),
    );
  }
}
