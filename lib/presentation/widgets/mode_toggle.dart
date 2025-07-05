import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/theme_cubit.dart';
import '../../business_logic/cubit/theme_state.dart';
import '../../constants/my_colors.dart';

class ModeToggle extends StatelessWidget {
  const ModeToggle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        bool isDark = themeState.themeMode == ThemeMode.dark;

        return Switch(
          trackOutlineColor: WidgetStateProperty.all(
              isDark ? MyColors.myBlack50 : MyColors.myGrey2),
          trackColor: WidgetStateProperty.all(
              isDark ? MyColors.myBlue : MyColors.myGrey2),
          value: isDark,
          inactiveThumbColor: MyColors.myGrey2,
          thumbColor: WidgetStateProperty.all(MyColors.myWhite),
          onChanged: (bool value) {
            context.read<ThemeCubit>().toggleTheme();
          },
          thumbIcon: WidgetStateProperty.resolveWith(
            (states) {
              return isDark
                  ? const Icon(Icons.nightlight_round,
                      size: 22, color: MyColors.myLemon)
                  : const Icon(Icons.wb_sunny, size: 22, color: Colors.amber);
            },
          ),
        );
      },
    );
  }
}
