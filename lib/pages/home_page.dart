import "package:cloud_firestore/cloud_firestore.dart";
import "package:crud_tutorial/services/firestore.dart";
import "package:flutter/material.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//Firestore object calling
  final FirestoreService firestoreService = FirestoreService();
//Text Controller
  final TextEditingController textController = TextEditingController();

  //Open a dialog box to add a note
  void openNoteBox({String? docID}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              //Add a new note
              if (docID == null) {
                firestoreService.addNote(textController.text);
              } 
              else {
                firestoreService.updateNote(docID, textController.text);
              }

              //Clear the text controller
              textController.clear();

              //Close the box
              Navigator.pop(context);
            },
            child: Text("Add"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: firestoreService.getNotesStream(),
          //A StreamBuilder in Flutter is used to listen to a stream of data and rebuild its widget subtree whenever new data is emitted by the stream
          builder: (context, snapshot) {
            //If we have data, get all the docs

            if (snapshot.hasData) {
              List notesList = snapshot.data!.docs;

              //Display as list

              return ListView.builder(
                  itemCount: notesList.length,
                  itemBuilder: (context, index) {
                    //get each individual doc
                    DocumentSnapshot documnent = notesList[index];
                    String docID = documnent.id;

                    //Get note from each doc

                    Map<String, dynamic> data =
                        documnent.data() as Map<String, dynamic>;

                    String noteText = data['note'];

                    //Display as a list tile

                    return ListTile(
                      title: Text(noteText),
                      trailing: Row(
                        mainAxisSize: MainAxisSize
                            .min, //The Main Axis Size defines how much space a Row should occupy in the main axis
                        children: [
                          //Update button
                          IconButton(
                            //The Trailing Icon appears at the end (far right side) of the ListTile.
                            onPressed: () => openNoteBox(docID: docID),
                            icon: Icon(Icons.settings),
                          ),

                          //Delete button
                          IconButton(
                            onPressed: () => firestoreService.deleteNote(docID),
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    );
                  });
            }
            //If there is no data return noting
            else {
              return const Text('No Notes');
            }
          }),
    );
  }
}
