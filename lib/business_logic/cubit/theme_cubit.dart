import 'package:FakeStore/business_logic/cubit/theme_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeCubit extends Cubit<ThemeState> {
  ThemeCubit() : super(const LightThemeState());

  void toggleTheme() {
    if (state is LightThemeState) {
      emit(const DarkThemeState());
    } else {
      emit(const LightThemeState());
    }
  }
}
