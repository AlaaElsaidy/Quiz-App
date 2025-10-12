import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quizzo/features/login/data/models/userModel.dart';

import '../../features/quiz-creation/data/models/quiz-model.dart';

class FirebaseFireStrore {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static CollectionReference createCollectionReference(String name) {
    CollectionReference users = firestore.collection(name);
    return users;
  }

  static Future<void> addUser(UserModel userModel, String password) async {
    var userCollection = createCollectionReference("users")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (value, _) => value.toJson(),
        );
    await userCollection
        .doc(userModel.id)
        .set(userModel)
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  static Future<UserModel> getUser({required String id}) async {
    var userCollection = createCollectionReference("users")
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (value, _) => value.toJson(),
        )
        .doc(id);
    var results = await userCollection.get();
    return results.data()!;
  }

  static Future<void> addQuiz(TotalQuiz totalQuiz) async {
    var userCollection = createCollectionReference(TotalQuiz.collectionName)
        .withConverter<TotalQuiz>(
          fromFirestore: (snapshot, _) => TotalQuiz.fromJson(snapshot.data()!),
          toFirestore: (value, _) => value.toJson(),
        );

    var doc = await userCollection.doc(totalQuiz.quizName).get();
    if (doc.exists) {
      print("exist");
      return;
    } else {
      await userCollection
          .doc(totalQuiz.quizName)
          .set(totalQuiz)
          .then((value) => print("Quiz Added"))
          .catchError((error) => print("Failed to add quiz: $error"));
    }
  }

  static Future<TotalQuiz> getQuiz({required String id}) async {
    var userCollection = createCollectionReference(TotalQuiz.collectionName)
        .withConverter<TotalQuiz>(
          fromFirestore: (snapshot, _) => TotalQuiz.fromJson(snapshot.data()!),
          toFirestore: (value, _) => value.toJson(),
        )
        .doc(id);
    var results = await userCollection.get();
    return results.data()!;
  }

  static Future<List<TotalQuiz>> getTotalQuizes() async {
    var userCollection = createCollectionReference(TotalQuiz.collectionName)
        .withConverter<TotalQuiz>(
          fromFirestore: (snapshot, _) => TotalQuiz.fromJson(snapshot.data()!),
          toFirestore: (value, _) => value.toJson(),
        );

    var results = await userCollection.get();

    return results.docs.map((doc) => doc.data()).toList();
  }
}
