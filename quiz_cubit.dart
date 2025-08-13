import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guidey/quiz/question_model.dart';
import 'package:guidey/quiz/quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  QuizCubit() : super(QuizInitial());

  String? selectedOption;
  int currentIndex = 0;
  List<String> selectedAnswers = [];

  // متغير اللغة (افتراضي انجليزي)
  String currentLanguage = "en";

  // متغير الدارك مود (افتراضي light)
  bool isDark = false;

  void selectAnswers(String answer) {
    selectedOption = answer;
    emit(QuizProgress(currentIndex, questions[currentIndex]));
  }

  void nextQuestion() {
    if (selectedOption != null) {
      selectedAnswers.add(selectedOption!);
      selectedOption = null;
      if (currentIndex < questions.length - 1) {
        currentIndex++;
        emit(QuizProgress(currentIndex, questions[currentIndex]));
      } else {
        emit(QuizCompleted(selectedAnswers));
      }
    }
  }

  void goBack() {
    if (currentIndex > 0) {
      currentIndex--;
      selectedAnswers.removeLast();
      emit(QuizProgress(currentIndex, questions[currentIndex]));
    }
  }

  void startQuiz() {
    currentIndex = 0;
    selectedAnswers.clear();
    emit(QuizProgress(currentIndex, questions[currentIndex]));
  }

// دالة تغيير اللغة
  void changeLanguage(String languageCode) {
    currentLanguage = languageCode;
    emit(LanguageChanged(currentLanguage));

    // لو عايز كمان تعيد عرض السؤال الحالي باللغة الجديدة
    emit(QuizProgress(currentIndex, questions[currentIndex]));
  }
  // دالة تغيير الثيم
  void toggleTheme() {
    isDark = !isDark;
    emit(ThemeChanged(isDark));
  }
}