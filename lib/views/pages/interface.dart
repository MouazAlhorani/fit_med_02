import 'package:fit_medicine_02/controllers/functions/login.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/views/pages/homepage.dart';
import 'package:fit_medicine_02/views/pages/login_page.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class InterFace extends StatelessWidget {
  const InterFace({super.key});
  static String routeName = "InterFace";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Directionality(
        textDirection:
            context.watch<DirectionalityProvider>().getDirection(sharedPref) ??
                TextDirection.rtl,
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0XFFFFCC48), Color(0xFFD47C10)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter)),
            child: Stack(
              children: [
                Positioned(
                    right: 0,
                    top: MediaQuery.of(context).size.height * 0.2,
                    child: Image.asset("asset/images/docinterface.png")),
                Positioned(
                    right: 20, child: Image.asset("asset/images/dogfeet.png")),
                Positioned(
                    bottom: 20, child: Image.asset("asset/images/bone.png")),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    const SizedBox(height: 70),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Text.rich(TextSpan(children: [
                          TextSpan(
                              text: "أهلا بك في تطبيق",
                              style: ThemeM.theme().textTheme.titleLarge),
                          TextSpan(
                              text: "\nFit Medic",
                              style: ThemeM.theme().textTheme.titleLarge)
                        ])),
                      ),
                    ),
                    Spacer(),
                    Align(
                      alignment: Alignment.center,
                      child: buttonMz(
                          labelsize: 25.0,
                          label: "ابــــدأ",
                          icon: FontAwesomeIcons.house,
                          iconColor: Colors.orangeAccent,
                          function: () async {
                            bool? loggedin = false;
                            if (sharedPref != null &&
                                sharedPref!.getStringList('userInfo') != null) {
                              await login(
                                  ctx: context,
                                  email: sharedPref!
                                          .getStringList('userInfo')![0]
                                          .contains("@")
                                      ? sharedPref!
                                          .getStringList('userInfo')![0]
                                      : null,
                                  phone: !sharedPref!
                                          .getStringList('userInfo')![0]
                                          .contains("@")
                                      ? sharedPref!
                                          .getStringList('userInfo')![0]
                                      : null,
                                  password: sharedPref!
                                      .getStringList('userInfo')![1]);
                            }

                            if (sharedPref == null ||
                                sharedPref!.getStringList('userInfo') == null) {
                              Navigator.pushNamed(context, LoginPage.routeName);
                            }
                          }),
                    ),
                    SizedBox(height: 30),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
