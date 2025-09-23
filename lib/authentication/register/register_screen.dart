import 'package:eventlyapp/Home%20Screen/tabs/widgets/custom_elevated_button.dart';
import 'package:eventlyapp/Home%20Screen/tabs/widgets/custom_textformfiled.dart';
import 'package:eventlyapp/generated/l10n.dart';
import 'package:eventlyapp/utils/app_assets.dart';
import 'package:eventlyapp/utils/app_color.dart';
import 'package:eventlyapp/utils/app_routes.dart';
import 'package:eventlyapp/utils/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:icons_plus/icons_plus.dart';

class RegisterScreen extends StatefulWidget {
  RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<RegisterScreen> {
  final formkey = GlobalKey<FormState>();

  bool isPasswordObscured = true;
  bool isRePasswordObscured = true;
  TextEditingController nameController = TextEditingController(text: "Moamen");
  TextEditingController emailController = TextEditingController(text: "moamen@gmail.com");
  TextEditingController passwordController = TextEditingController(text: "123456");
  TextEditingController rePasswordController = TextEditingController(text: "123456");

  @override
  Widget build(BuildContext context) {
    var hieght = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: AppColor.primaryLightColor),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          S.of(context).register,
          style: AppStyle.reglur22Primary,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: hieght * 0.02),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(AppAssets.eventLogo),
              SizedBox(
                height: hieght * 0.03,
              ),
              Form(
                key: formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextformfiled(
                      controller: nameController,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Enter Your name";
                        }

                        return null;
                      },
                      hintText: S.of(context).name,
                      prefixIcon: Icon(EvaIcons.person),
                    ),
                    SizedBox(
                      height: hieght * 0.02,
                    ),
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
                      height: hieght * 0.02,
                    ),
                    CustomTextformfiled(
                      controller: passwordController,
                      isObscured: isPasswordObscured,
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
                            isPasswordObscured = !isPasswordObscured;
                            setState(() {});
                          },
                          child: isPasswordObscured
                              ? Icon(EvaIcons.eye_off)
                              : Icon(EvaIcons.eye)),
                    ),
                    SizedBox(
                      height: hieght * 0.02,
                    ),
                    CustomTextformfiled(
                      controller: rePasswordController,
                      isObscured: isRePasswordObscured,
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return "Please Enter Re-Password";
                        }
                        if (text != passwordController.text) {
                          return "Re-Password doesn't Match Password";
                        }
                        return null;
                      },
                      hintText: S.of(context).re_password,
                      prefixIcon: Icon(Clarity.lock_solid),
                      suffixIcon: InkWell(
                          onTap: () {
                            isRePasswordObscured = !isRePasswordObscured;
                            setState(() {});
                          },
                          child: isRePasswordObscured
                              ? Icon(EvaIcons.eye_off)
                              : Icon(EvaIcons.eye)),
                    ),
                    SizedBox(
                      height: hieght * 0.022,
                    ),
                    CustomElevatedButton(
                      onPressed: register,
                      text: S.of(context).create_account,
                    ),
                    SizedBox(
                      height: hieght * 0.02,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          S.of(context).already_have_account,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        TextButton(
                            style: ButtonStyle(
                              overlayColor:
                                  MaterialStateProperty.all(Colors.transparent),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "${S.of(context).login}",
                              style: AppStyle.Bold16PrimaryItalicUL,
                            )),
                      ],
                    ),
                    SizedBox(
                      height: hieght * 0.02,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    if (formkey.currentState?.validate() == true) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.homescreen,
        (route) => false,
      );
    }
  }
}
