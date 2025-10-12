import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:quizzo/features/register/data/repositories/register-repo.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterRepo registerRepo;

  RegisterCubit(this.registerRepo) : super(RegisterInitial());

  Future<void> register({
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    var result = await registerRepo.register(email: email, password: password);
    result.fold(
      (l) => emit(RegisterFailure(l.errorMessage!)),
      (r) => emit(RegisterSuccess(r!)),
    );
  }
}
