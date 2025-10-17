import 'package:eventlyapp/Home%20Screen/tabs/profile%20tab/Theme/Theme_buttom_sheet.dart';
import 'package:eventlyapp/Home%20Screen/tabs/profile%20tab/language/language_buttom_sheet.dart';
import 'package:eventlyapp/Home%20Screen/tabs/widgets/custom_elevated_button.dart';
import 'package:eventlyapp/Providers/app_language_provider.dart';
import 'package:eventlyapp/Providers/app_theme_provider.dart';
import 'package:eventlyapp/Providers/user_provider.dart';
import 'package:eventlyapp/authentication/google_sign_in.dart';
import 'package:eventlyapp/generated/l10n.dart';
import 'package:eventlyapp/utils/app_assets.dart';
import 'package:eventlyapp/utils/app_color.dart';
import 'package:eventlyapp/utils/app_routes.dart';
import 'package:eventlyapp/utils/app_style.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var languageProvider = Provider.of<AppLanguageProvider>(context);
    var themeProvider = Provider.of<AppThemeProvider>(context);
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.primaryLightColor,
        toolbarHeight: height * .18,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(55))),
        title: Row(
          children: [
            Image.asset(AppAssets.routeImages),
            SizedBox(
              width: width * .04,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userProvider.currentUser?.name ?? "",
                    style: AppStyle.bold24White,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    userProvider.currentUser?.email ?? "",
                    style: AppStyle.bold16White,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    width: width * 0.08,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width * 0.04, vertical: height * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              S.of(context).language,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            InkWell(
              onTap: () {
                ShowLanguageButtonSheet();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * .03, vertical: height * .01),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColor.primaryLightColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      languageProvider.appLanguage == "en"
                          ? S.of(context).english
                          : S.of(context).arabic,
                      style: AppStyle.bold20Primary,
                    ),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 35,
                      color: AppColor.primaryLightColor,
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: height * 0.02,
            ),
            Text(
              S.of(context).theme,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            SizedBox(
              height: height * 0.02,
            ),
            InkWell(
              onTap: () {
                showThemeButtomSheet();
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: width * .03, vertical: height * .01),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColor.primaryLightColor)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      themeProvider.appTheme == ThemeMode.dark
                          ? S.of(context).dark
                          : S.of(context).light,
                      style: AppStyle.bold20Primary,
                    ),
                    Icon(
                      Icons.arrow_drop_down_outlined,
                      size: 35,
                      color: AppColor.primaryLightColor,
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            CustomElevatedButton(
              onPressed: logout,
              text: S.of(context).logout,
              textStyle: AppStyle.bold20White,
              backgroundColor: AppColor.logoutColor,
              hasIcon: true,
              iconWidget: Padding(
                padding: EdgeInsetsDirectional.only(start: width * 0.04),
                child: Icon(
                  Icons.logout,
                  color: AppColor.whiteColor,
                  size: 25,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> logout() async {
    try {
      await FirebaseAuth.instance.signOut();

      // Sign out from Google
      GoogleSignInService googleSignInService = GoogleSignInService();
      await googleSignInService.signOut();
      // Clear user provider
      if (mounted) {
        Provider.of<UserProvider>(context, listen: false).currentUser = null;
      }

      // Navigate to login screen
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.loginScreen,
          (route) => false,
        );
      }
    } catch (e) {
      print("Logout error: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void ShowLanguageButtonSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => LanguageButtomSheet());
  }

  void showThemeButtomSheet() {
    showModalBottomSheet(
        context: context, builder: (context) => ThemeButtomSheet());
  }
}
