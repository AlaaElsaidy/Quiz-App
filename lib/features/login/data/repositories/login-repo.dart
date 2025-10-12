import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quizzo/config/firebase-services/authentication.dart';
import 'package:quizzo/config/firebase-services/failure.dart';

class LoginRepo {
  Future<Either<Failure, void>> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuthentication.login(email: email, password: password);
      return Right(null);
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = "No user found for that email.";
        return Left(Failure(message));
      } else if (e.code == 'wrong-password') {
        message = "Wrong password provided.";
        return Left(Failure(message));
      } else {
        message = "Error: ${e.message}";
        return Left(Failure(message));
      }
    } catch (error) {
      return Left(Failure(error.toString()));
    }
  }
}
