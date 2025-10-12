part of 'register_cubit.dart';

@immutable
sealed class RegisterState {}

final class RegisterInitial extends RegisterState {}

final class RegisterLoading extends RegisterState {}

final class RegisterSuccess extends RegisterState {
  UserCredential userCredential;

  RegisterSuccess(this.userCredential);
}

final class RegisterFailure extends RegisterState {
  String errorMessage;

  RegisterFailure(this.errorMessage);
}
