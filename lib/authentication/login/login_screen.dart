import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:eventlyapp/Home%20Screen/tabs/widgets/custom_elevated_button.dart';
import 'package:eventlyapp/Home%20Screen/tabs/widgets/custom_textformfiled.dart';
import 'package:eventlyapp/Providers/app_language_provider.dart';
import 'package:eventlyapp/Providers/event_list.dart';
import 'package:eventlyapp/Providers/user_provider.dart';
import 'package:eventlyapp/authentication/google_sign_in.dart';
import 'package:eventlyapp/generated/l10n.dart';
import 'package:eventlyapp/model/myUser.dart';
import 'package:eventlyapp/utils/app_assets.dart';
import 'package:eventlyapp/utils/app_color.dart';
import 'package:eventlyapp/utils/app_routes.dart';
import 'package:eventlyapp/utils/app_style.dart';
import 'package:eventlyapp/utils/AlrertDialog.dart';
import 'package:eventlyapp/utils/firebase_utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formkey = GlobalKey<FormState>();
  final googleSignInService = GoogleSignInService();

  bool isObscured = true;
  TextEditingController emailController =
      TextEditingController(text: "moamen@gmail.com");
  TextEditingController passwordController =
      TextEditingController(text: "123456");

  @override
  void initState() {
    super.initState();
    _initializeGoogleSignIn();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _initializeGoogleSignIn() {
    unawaited(
      googleSignInService.initialize(
        onSignIn: (googleUser) async {
          await _handleGoogleSignIn(googleUser);
        },
        onError: (error) {
          _handleGoogleSignInError(error);
        },
      ),
    );
  }

  Future<void> _handleGoogleSignIn(GoogleSignInAccount googleUser) async {
    try {
      final credential =
          await googleSignInService.getFirebaseCredential(googleUser);
      final userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      await _handleAuthSuccess(userCredential.user);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      AlretDiallogUtils.hideLoading(context: context);
      AlretDiallogUtils.showMessage(
        context: context,
        title: "Failed",
        message: e.message ?? "Firebase authentication failed",
        positiveButtonText: "OK",
      );
    } catch (e) {
      if (!mounted) return;
      AlretDiallogUtils.hideLoading(context: context);
      AlretDiallogUtils.showMessage(
        context: context,
        title: "Failed",
        message: e.toString(),
        positiveButtonText: "OK",
      );
    }
  }

  void _handleGoogleSignInError(Object error) {
    if (!mounted) return;

    final errorMessage = error is GoogleSignInException
        ? 'Google Sign-In error: ${error.code}'
        : 'An error occurred: $error';

    AlretDiallogUtils.hideLoading(context: context);
    AlretDiallogUtils.showMessage(
      context: context,
      title: "Failed",
      message: errorMessage,
      positiveButtonText: "OK",
    );
  }

  Future<void> _handleAuthSuccess(User? firebaseUser) async {
    if (firebaseUser == null) return;

    try {
      var user = await FirebaseUtils.readUsersFromFirestore(firebaseUser.uid);

      if (user == null) {
        Myuser newUser = Myuser(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? "",
          name: firebaseUser.displayName ?? "",
        );
        await FirebaseUtils.addUserToFirestore(newUser);
        user = newUser;
      }

      if (!mounted) return;

      var userProvider = Provider.of<UserProvider>(context, listen: false);
      userProvider.updateUser(user);

      var eventListProvider =
          Provider.of<EventListProvider>(context, listen: false);
      eventListProvider.getEventCollections(user?.id ?? "");

      AlretDiallogUtils.hideLoading(context: context);
      AlretDiallogUtils.showMessage(
        context: context,
        title: "Success",
        message: "Account Logged in Successfully",
        positiveButtonText: "OK",
        onPositivePressed: () {
          Navigator.of(context).pushReplacementNamed(AppRoutes.homescreen);
        },
      );
    } catch (e) {
      if (!mounted) return;
      AlretDiallogUtils.hideLoading(context: context);
      AlretDiallogUtils.showMessage(
        context: context,
        title: "Failed",
        message: "Error: ${e.toString()}",
        positiveButtonText: "OK",
      );
    }
  }

  int? _getCurrentLanguageValue(String language) {
    switch (language) {
      case "en":
        return 0;
      case "ar":
        return 1;
      default:
        return null;
    }
  }

  String _getLanguageFromValue(int? value) {
    switch (value) {
      case 0:
        return "en";
      case 1:
        return "ar";
      default:
        return "en";
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var languageProvider = Provider.of<AppLanguageProvider>(context);

    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: EdgeInsets.symmetric(horizontal: width * 0.04),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(AppAssets.eventLogo),
              SizedBox(
                height: height * 0.03,
              ),
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextformfiled(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Enter Email";
                        }
                        final bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return "Please Enter Valid Email";
                        }
                        return null;
                      },
                      hintText: S.of(context).email,
                      prefixIcon: Icon(EvaIcons.email),
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomTextformfiled(
                      controller: passwordController,
                      isObscured: isObscured,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Enter Password";
                        }
                        return null;
                      },
                      hintText: S.of(context).password,
                      prefixIcon: Icon(Clarity.lock_solid),
                      suffixIcon: InkWell(
                          onTap: () {
                            isObscured = !isObscured;
                            setState(() {});
                          },
                          child: isObscured
                              ? Icon(EvaIcons.eye_off)
                              : Icon(EvaIcons.eye)),
                    ),
                    SizedBox(
                      height: height * 0.002,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {},
                            child: Text(
                              "${S.of(context).forget_password}?",
                              style: AppStyle.Bold16PrimaryItalicUL,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomElevatedButton(
                      onPressed: login,
                      text: S.of(context).login,
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).dont_Have_account,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  WidgetStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(AppRoutes.registerScreen);
                            },
                            child: Text(
                              S.of(context).create_account,
                              style: AppStyle.Bold16PrimaryItalicUL,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            indent: width * 0.04,
                            endIndent: width * 0.04,
                            color: AppColor.primaryLightColor,
                            thickness: 1,
                          ),
                        ),
                        Text(
                          S.of(context).or,
                          style: AppStyle.medium16Primary,
                        ),
                        Expanded(
                          child: Divider(
                            indent: width * 0.04,
                            endIndent: width * 0.04,
                            color: AppColor.primaryLightColor,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: height * 0.02,
                    ),
                    CustomElevatedButton(
                      backgroundColor: Colors.transparent,
                      onPressed: _handleGoogleSignInClick,
                      text: S.of(context).login_with_google,
                      borderColor: AppColor.primaryLightColor,
                      textStyle: AppStyle.medium20Primary,
                      hasIcon: true,
                      mainAxisAlignment: MainAxisAlignment.center,
                      iconWidget: Image.asset(AppAssets.googlelogo),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: height * 0.02,
              ),
              AnimatedToggleSwitch<int?>.rolling(
                iconOpacity: 100,
                allowUnlistedValues: true,
                styleAnimationType: AnimationType.onHover,
                current: _getCurrentLanguageValue(languageProvider.appLanguage),
                values: const [0, 1],
                onChanged: (i) {
                  final newLanguage = _getLanguageFromValue(i);
                  languageProvider.changeLanguage(newLanguage);
                },
                iconBuilder: languageIconBuilder,
                style: ToggleStyle(
                    backgroundColor: Colors.transparent,
                    borderColor: AppColor.primaryLightColor,
                    borderRadius: BorderRadius.circular(25),
                    indicatorColor: AppColor.primaryLightColor),
                borderWidth: 3.0,
              ),
            ],
          ),
        ),
      )),
    );
  }

  void _handleGoogleSignInClick() async {
    AlretDiallogUtils.showLoading(context: context, message: "Signing in...");
    try {
      await googleSignInService.signIn();
    } catch (e) {
      if (!mounted) return;
      AlretDiallogUtils.hideLoading(context: context);
      AlretDiallogUtils.showMessage(
        context: context,
        title: "Failed",
        message: e.toString(),
        positiveButtonText: "OK",
      );
    }
  }

  void login() async {
    if (formkey.currentState?.validate() == true) {
      AlretDiallogUtils.showLoading(context: context, message: "Login in...");
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await _handleAuthSuccess(credential.user);
      } on FirebaseAuthException catch (e) {
        if (!mounted) return;
        AlretDiallogUtils.hideLoading(context: context);
        if (e.code == 'invalid-credential') {
          AlretDiallogUtils.showMessage(
            context: context,
            title: "Failed",
            message: "No user found for that email.",
            positiveButtonText: "OK",
          );
        } else if (e.code == 'wrong-password') {
          AlretDiallogUtils.showMessage(
            context: context,
            title: "Failed",
            message: "Wrong password provided for that user.",
            positiveButtonText: "OK",
          );
        }
      } catch (e) {
        if (!mounted) return;
        AlretDiallogUtils.hideLoading(context: context);
        AlretDiallogUtils.showMessage(
          context: context,
          title: "Failed",
          message: e.toString(),
          positiveButtonText: "OK",
        );
      }
    }
  }

  Widget languageIconBuilder(int? value, bool foreground) {
    return Container(
      child: Center(
        child: flagByValue(value),
      ),
    );
  }

  Widget flagByValue(int? value) => switch (value) {
        0 => Flag(
            Flags.united_states_of_america,
            size: 28,
          ),
        1 => Flag(
            Flags.egypt,
            size: 28,
          ),
        _ => Icon(
            Icons.language,
            size: 28,
            color: AppColor.primaryLightColor,
          ),
      };
}
