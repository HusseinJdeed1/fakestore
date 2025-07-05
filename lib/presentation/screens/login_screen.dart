import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../business_logic/cubit/cart_cubit.dart';
import '../../business_logic/cubit/user_cubit.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_strings.dart';
import '../../data/models/user.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/styled_title_text.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late User currentUser;
  late final String? currentUserId;
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // final SharedPreferences prefs = await SharedPreferences.getInstance();
    //   currentUserId = await prefs.getString('currentUserId');
  }

  late String userName;
  late String userPassword;
  bool isPasswordObscured = true;
  final GlobalKey<FormState> signInFormKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Column(
          mainAxisSize: MainAxisSize.max,
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
                      key: signInFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StyledTitleText(text: "Sign in", fontSize: 28),
                          buildEmailFormField(),
                          buildPasswordFormField(),
                          buildSignInButton(),
                          buildCreateNewAccountText(),
                          buildLoginSubmittedBloc(),
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

  Widget buildCreateNewAccountText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: RichText(
        text: TextSpan(
          text: "Don't Have an Account? ",
          style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyMedium!.color),
          children: <TextSpan>[
            TextSpan(
              text: "Create one.",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyMedium!.color),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  if (kDebugMode) {
                    print("Create one tapped");
                  }
                  Navigator.pushNamed(context, signUpScreen);
                },
            )
          ],
        ),
      ),
    );
  }

  Widget buildEmailFormField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        controller: userNameController,
        textAlign: TextAlign.start,
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(color: Theme.of(context).textTheme.bodyMedium!.color),
        cursorColor: Theme.of(context).textTheme.bodyMedium!.color,
        decoration: InputDecoration(
          hintText: "User Name",
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
          if (value.length < 3) {
            return 'Enter a valid user name';
          }
          return null;
        },
        onSaved: (emailAddress) {
          userName = emailAddress!;
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
          hintText: "Password",
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
          return null;
        },
        onSaved: (password) {
          userPassword = password!;
        },
      ),
    );
  }

  Widget buildSignInButton() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (signInFormKey.currentState!.validate()) {
                  signInFormKey.currentState!.save();
                  BlocProvider.of<UserCubit>(context)
                      .userLogIn(userName, userPassword);

                  //
                  // print("77777777777777");
                  // print(currentUserId);
                  // print("77777777777777");

                  // BlocProvider.of<CartCubit>(context)
                  //     .getUserCartInfoById(int.parse(currentUserId!));

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
                "Sign In",
                style: TextStyle(
                    color: MyColors.myGrey2, fontSize: 18, letterSpacing: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLoginSubmittedBloc() {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is UserLoggingIn) {
          showProgressIndicator(context);
        }
        if (state is UserLoggedIn) {
          //Navigator.pop(context);
        }
        if (state is UserDataLoaded) {
          currentUser = state.user;
          int userId = currentUser.id;
          BlocProvider.of<CartCubit>(context).getUserCartInfoById(userId);
          if (kDebugMode) {
            print("+++++++++++++++++");
            print(currentUser.firstname);
          }

          Navigator.pushNamedAndRemoveUntil(
            context,
            homeScreen,
            (route) => route.settings.name == homeScreen,
            arguments: currentUser,
          );
        }

        if (state is UserLoggingInError) {
          Navigator.pop(context);
          String errMsg = state.error;
          if (kDebugMode) {
            print(errMsg);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Login Failed",
              style: TextStyle(color: MyColors.myGrey2),
            ),
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
