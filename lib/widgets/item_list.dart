import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebasetodoapp/constants/colors.dart';
import 'package:firebasetodoapp/database/database.dart';

class ItemList extends StatelessWidget {
  const ItemList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Database.readItems(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        } else if (snapshot.hasData && snapshot.data!.docs.length == 0) {
          return Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 150, child: Image.asset('assets/relax.png')),
              Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Text(
                    'Nenhuma tarefa por aqui.',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  )),
            ],
          ));
        } else if (snapshot.hasData || snapshot.data != null) {
          return ListView.separated(
            separatorBuilder: (context, index) => SizedBox(height: 16.0),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var todoInfo =
                  snapshot.data!.docs[index].data()! as Map<String, dynamic>;
              String docID = snapshot.data!.docs[index].id;
              String title = todoInfo['title'];
              bool completed = todoInfo['completed'];

              Color getColor(Set<MaterialState> states) {
                const Set<MaterialState> interactiveStates = <MaterialState>{
                  MaterialState.pressed,
                  MaterialState.hovered,
                  MaterialState.focused,
                };
                if (states.any(interactiveStates.contains)) {
                  return CustomColors.firebaseGrey;
                }
                return CustomColors.firebaseAmber;
              }

              return Dismissible(
                key: Key(docID),
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(.4),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                dismissThresholds: {DismissDirection.startToEnd: 0.9},
                confirmDismiss: (_) async {
                  if (completed) {
                    return true;
                  }
                  return showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                              'Esta tarefa ainda não foi concluída. Deseja mesmo deletar?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text('Sim'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text('Não'),
                            ),
                          ],
                        );
                      });
                },
                onDismissed: (_) {
                  // Delete todo
                  Database.deleteItem(docId: docID);
                  // Then show a snackbar.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Tarefa removida.',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      backgroundColor: CustomColors.firebaseAmber,
                      key: Key(docID),
                    ),
                  );
                },
                child: Ink(
                  decoration: BoxDecoration(
                    color: CustomColors.firebaseGrey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    title: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        decoration: completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: completed
                            ? Colors.grey
                            : Theme.of(context)
                                .primaryTextTheme
                                .bodyText1
                                ?.color,
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Tarefa'),
                              content: Text(title),
                            );
                          });
                    },
                    leading: Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: completed,
                      onChanged: (checked) {
                        print(checked);
                        if (checked != null) {
                          Database.updateItem(
                            docId: docID,
                            title: title,
                            completed: checked,
                          );
                        }
                      },
                    ),
                  ),
                ),
              );
            },
          );
        }

        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(
              CustomColors.firebaseOrange,
            ),
          ),
        );
      },
    );
  }
}
