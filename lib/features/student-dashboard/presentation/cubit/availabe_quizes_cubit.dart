import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:quizzo/features/quiz-creation/data/models/quiz-model.dart';
import 'package:quizzo/features/student-dashboard/data/repositories/available-repo.dart';

part 'availabe_quizes_state.dart';

class AvailabeQuizesCubit extends Cubit<AvailabeQuizesState> {
  AvailableQuizesRepo availableQuizesRepo;

  AvailabeQuizesCubit(this.availableQuizesRepo)
    : super(AvailabeQuizesInitial());

  Future<void> getTotalQuizes() async {
    emit(AvailabeQuizesLoading());
    var result = await availableQuizesRepo.getTotalQuizes();
    result.fold(
      (l) => emit(AvailabeQuizesFailure(l.errorMessage!)),
      (r) => emit(AvailabeQuizesSuccess(r)),
    );
  }
}
