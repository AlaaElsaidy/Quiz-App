import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quizzo/features/login/data/repositories/login-repo.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginRepo loginRepo;

  LoginCubit(this.loginRepo) : super(LoginInitial());

  Future<void> login({required String email, required String password}) async {
    emit(LoginLoading());
    var data = await loginRepo.login(email: email, password: password);
    data.fold(
      (l) => emit(LoginFailure(l.errorMessage!)),
      (r) => emit(LoginSuccess()),
    );
  }
}
