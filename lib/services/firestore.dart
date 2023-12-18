import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
//Get collection of notes
  final CollectionReference
      notes = //A CollectionReference object can be used for adding documents, getting document references, and querying for documents.
      FirebaseFirestore.instance.collection(
          "notes"); //Cloud Firestore is a NoSQL, document-oriented database. Unlike a SQL database, there are no tables or rows

//Create

  Future<void> addNote(String note) {
    return notes.add({
      'note': note,
      'timestamp': Timestamp.now(),
    });
  }

//Read

  Stream<QuerySnapshot> getNotesStream() {
    //A QuerySnapshot is returned from a collection query, and allows you to inspect the collection
    final notesStream = notes
        .orderBy('timestamp', descending: true)
        .snapshots(); //A Snapshot simplifies accessing and converting properties in a JSON-like object
    return notesStream;
  }

//Update

  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timestamp': Timestamp.now(),
    });
  }

//Delete

  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
