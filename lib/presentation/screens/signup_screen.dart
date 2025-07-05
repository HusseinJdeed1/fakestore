import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/user_cubit.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_strings.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/styled_title_text.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  late String userName;
  late int userID;
  late String userEmail;
  bool isPasswordObscured = true;

  late String userPassword;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userIDController = TextEditingController();
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  TextEditingController userConfirmPasswordController = TextEditingController();
  final GlobalKey<FormState> signUpFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          children: [
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ModeToggle(),
              ],
            ),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                      key: signUpFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StyledTitleText(text: "Sign up", fontSize: 28),
                          //buildIdFormField(),
                          buildUsernameFormField(),
                          buildEmailFormField(),
                          buildPasswordFormField(),
                          buildConfirmPasswordFormField(),
                          buildSignUpButton(),
                          buildLogInToAccountText(),
                          buildSignupSubmittedBloc(),
                        ],
                      )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildLogInToAccountText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: RichText(
        text: TextSpan(
          text: "Have an Account? ",
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium!.color),
          children: <TextSpan>[
            TextSpan(
              text: "Log In.",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (kDebugMode) {
                    print("Create one tapped");
                  }
                  Navigator.pushNamed(context, loginScreen);
                },
            )
          ],
        ),
      ),
    );
  }

  // Widget buildIdFormField() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
  //     child: TextFormField(
  //       controller: userIDController,
  //       textAlign: TextAlign.start,
  //       textAlignVertical: TextAlignVertical.center,
  //       style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
  //       cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
  //       decoration: InputDecoration(
  //         hintText: "Enter user ID",
  //         filled: true,
  //         fillColor: Theme.of(context).colorScheme.surface,
  //         contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //         border: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide.none,
  //         ),
  //         errorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(color: Colors.red),
  //         ),
  //         focusedErrorBorder: OutlineInputBorder(
  //           borderRadius: BorderRadius.circular(10),
  //           borderSide: BorderSide(color: Colors.red),
  //         ),
  //         hintStyle: TextStyle(
  //           color: Theme.of(context).textTheme.bodyMedium!.color,
  //           fontSize: 16,
  //         ),
  //         errorStyle: TextStyle(color: Colors.red, fontSize: 12),
  //       ),
  //       validator: (value) {
  //         if (value == null || value.isEmpty) {
  //           return 'Please enter your ID';
  //         }
  //         if (!RegExp(r'^\d+$').hasMatch(value)) {
  //           return 'User ID must contain numbers only';
  //         }
  //         if (value.length < 3) {
  //           return 'Enter a valid user ID';
  //         }
  //         return null;
  //       },
  //       onSaved: (userId) {
  //         userID = int.parse(userId!);
  //       },
  //     ),
  //   );
  // }

  Widget buildUsernameFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        controller: userNameController,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
        cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: InputDecoration(
          hintText: "Enter user name",
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: 16,
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your ID';
          }
          if (value.length < 3) {
            return 'Enter a valid user ID';
          }
          return null;
        },
        onSaved: (username) {
          userName = username!;
        },
      ),
    );
  }

  Widget buildEmailFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        controller: userEmailController,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
        cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: InputDecoration(
          hintText: "Enter you email",
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: 16,
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 12),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your email';
          }

          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
            return 'Enter a valid email address';
          }

          return null;
        },
        onSaved: (email) {
          userEmail = email!;
        },
      ),
    );
  }

  Widget buildPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        controller: userPasswordController,
        obscureText: isPasswordObscured,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
        cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: InputDecoration(
          hintText: "Enter your password",
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: 16,
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 12),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordObscured ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              setState(() {
                isPasswordObscured = !isPasswordObscured;
              });
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your password';
          }
          if (value.length < 6) {
            return 'Password must be at least 6 characters';
          }
          if (!RegExp(r'[A-Z]').hasMatch(value)) {
            return 'Password must contain at least one uppercase letter';
          }
          if (!RegExp(r'[a-z]').hasMatch(value)) {
            return 'Password must contain at least one lowercase letter';
          }
          if (!RegExp(r'[0-9]').hasMatch(value)) {
            return 'Password must contain at least one number';
          }
          if (!RegExp(r'[!@#\$&*~%^()\-_=+{}[\]|;:"<>,./?]').hasMatch(value)) {
            return 'Password must contain at least one special character';
          }
          return null;
        },
        onSaved: (password) {
          userPassword = password!;
        },
      ),
    );
  }

  Widget buildConfirmPasswordFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        controller: userConfirmPasswordController,
        obscureText: isPasswordObscured,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
        cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: InputDecoration(
          hintText: "Confirm your password",
          filled: true,
          fillColor: Theme.of(context).colorScheme.surface,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red),
          ),
          hintStyle: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color,
            fontSize: 16,
          ),
          errorStyle: TextStyle(color: Colors.red, fontSize: 12),
          suffixIcon: IconButton(
            icon: Icon(
              isPasswordObscured ? Icons.visibility_off : Icons.visibility,
              color: Theme.of(context).iconTheme.color,
            ),
            onPressed: () {
              setState(() {
                isPasswordObscured = !isPasswordObscured;
              });
            },
          ),
        ),
        validator: (confirmationPassword) {
          if (confirmationPassword == null || confirmationPassword.isEmpty) {
            return 'Please enter confirmation  password';
          }
          if (confirmationPassword != userPasswordController.text) {
            return "Password doesn't match";
          }
          return null;
        },
        onSaved: (password) {
          userPassword = password!;
        },
      ),
    );
  }

  Widget buildSignUpButton() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // BlocProvider.of<UserCubit>(context).userSignUp(
                //     125, "hmjdeed@gmail.com", "hmjdeed", "hmjdeed123");

                if (signUpFormKey.currentState!.validate()) {
                  signUpFormKey.currentState!.save();
                  BlocProvider.of<UserCubit>(context)
                      .userSignUp(null, userEmail, userName, userPassword);

                  if (kDebugMode) {
                    print("Form is valid. Proceed with login...");
                  }
                } else {
                  if (kDebugMode) {
                    print("Form is not valid");
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.myBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(65),
                ),
              ),
              child: const Text(
                "Sign Up",
                style: TextStyle(
                    color: MyColors.myGrey2, fontSize: 18, letterSpacing: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSignupSubmittedBloc() {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is UserRegistration) {
          showProgressIndicator(context);
        }
        if (state is UserRegistered) {
          Navigator.pop(context);
          Navigator.popAndPushNamed(context, homeScreen, arguments: state.user);

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Account created successfully",
                style: TextStyle(color: MyColors.myGrey2)),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ));
        }
        if (state is UserRegistrationError) {
          Navigator.pop(context);
          String errMsg = state.error;
          if (kDebugMode) {
            print(errMsg);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Failed to Register",
                style: TextStyle(color: MyColors.myGrey2)),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ));
        }
      },
      child: Container(),
    );
  }

  void showProgressIndicator(context) {
    AlertDialog alertDialog = AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(MyColors.myBlue),
        ),
      ),
    );
    showDialog(
        barrierColor: Theme.of(context).colorScheme.surface,
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }
}
