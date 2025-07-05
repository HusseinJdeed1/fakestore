import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../business_logic/cubit/user_cubit.dart';
import '../../constants/my_colors.dart';
import '../../constants/my_strings.dart';
import '../../data/models/user.dart';
import '../widgets/mode_toggle.dart';
import '../widgets/styled_title_text.dart';

class AccountScreen extends StatefulWidget {
  final User user;
  AccountScreen({super.key, required this.user});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late final currentUser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentUser = widget.user;
    userId = currentUser.id.toString();
    firstName = currentUser.firstname;
    lastName = currentUser.lastname;
    userName = currentUser.username;
    userEmail = currentUser.email;
    userPhone = currentUser.phone;
    userPassword = currentUser.password;
    userCity = currentUser.city;
    userStreet = currentUser.street;
  }

  @override
  String userId = "";

  String firstName = "";
  String lastName = "";
  String userName = "";
  String userEmail = "";
  String userPhone = "";
  String userPassword = "";
  String userAddress = "";
  String userCity = "";
  String userStreet = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StyledTitleText(text: "Account", fontSize: 28),
                  ModeToggle(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildInformationText("First name", firstName),
                  buildInformationText("Last name", lastName),
                ],
              ),
              buildInformationText("User name", userName),
              buildInformationText("Email", userEmail),
              buildInformationText("Mobile", userPhone),
              buildInformationText("Password", userPassword),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildInformationText("City", userCity),
                  buildInformationText("Street", userStreet)
                ],
              ),
              buildSignOutButton(),
              buildDeleteAccountButton(),
              builDeleteAccountBloc(),
            ],
          ),
        ),
      ),
    ));
  }

  Widget builDeleteAccountBloc() {
    return BlocListener<UserCubit, UserState>(
      listenWhen: (previous, current) {
        return previous != current;
      },
      listener: (context, state) {
        if (state is UserDeletingAccount) {
          showProgressIndicator(context);
        }

        if (state is UserDeletedAccount) {
          if (kDebugMode) {
            print("----------------");
            print("Deleted Successfully");
          }

          Navigator.pushReplacementNamed(context, loginScreen);
        }

        if (state is UserDeletingAccountError) {
          Navigator.pop(context);
          String errMsg = state.error;
          if (kDebugMode) {
            print(errMsg);
          }
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(errMsg),
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

  Widget buildSignOutButton() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 30, 15, 10),
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                removeToken();
                Navigator.pushReplacementNamed(context, loginScreen);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.myBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(65),
                ),
              ),
              child: const Text(
                "Sign Out",
                style: TextStyle(
                    color: MyColors.myGrey2, fontSize: 18, letterSpacing: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDeleteAccountButton() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: EdgeInsets.fromLTRB(15, 10, 15, 10),
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                deleteConfirmationDialog(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(65),
                ),
              ),
              child: const Text(
                "Delete Account",
                style: TextStyle(
                    color: MyColors.myGrey2, fontSize: 18, letterSpacing: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
  }

  Widget buildInformationText(String information, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Text(
        "$information: $value",
        style: TextStyle(
          fontSize: 18,
          color: Theme.of(context).textTheme.bodyMedium!.color,
        ),
      ),
    );
  }

  deleteConfirmationDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      title: StyledTitleText(
        text: "Delete Confirmation ",
        fontSize: 22,
      ),
      content: Text(
        "Are you sure you want to delete your account?",
        style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium!.color, fontSize: 16),
      ),
      actions: [
        buildCancelButton(context),
        buildConfirmButton(context),
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildCancelButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: MyColors.myBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(65),
        ),
      ),
      child: Text("Cancel",
          style: TextStyle(color: MyColors.myGrey2, fontSize: 16)),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  Widget buildConfirmButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(65),
        ),
      ),
      child: Text("Confirm",
          style: TextStyle(color: MyColors.myGrey2, fontSize: 16)),
      onPressed: () {
        BlocProvider.of<UserCubit>(context).userDelete(userId);
      },
    );
  }
}
