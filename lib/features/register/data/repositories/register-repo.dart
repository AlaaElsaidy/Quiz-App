import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzo/config/firebase-services/authentication.dart';
import 'package:quizzo/config/firebase-services/failure.dart';

class RegisterRepo {
  Future<Either<Failure, UserCredential?>> register({
    required String email,
    required String password,
  }) async {
    try {
      UserCredential? userCredential = await FirebaseAuthentication.register(
        email: email,
        password: password,
      );

      return right(userCredential);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return left(Failure('The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        return left(Failure('The account already exists for that email.'));
      } else {
        return left(Failure('FirebaseAuthException: ${e.message ?? e.code}'));
      }
    } catch (e) {
      return left(Failure('Unexpected error: ${e.toString()}'));
    }
  }
}
