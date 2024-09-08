import 'package:fit_medicine_02/controllers/functions/login.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/models/provider_itemwithboolean_model.dart';
import 'package:fit_medicine_02/views/pages/homepage.dart';
import 'package:fit_medicine_02/views/pages/register_breed_page.dart';
import 'package:fit_medicine_02/views/pages/register_veter_page.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:fit_medicine_02/views/widget/textformfield_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});
  static String routeName = "LogInPage";

  @override
  Widget build(BuildContext context) {
    List<TextFormFieldModel> list = [
      TextFormFieldModel(
          label: "رقم الهاتف / الايميل",
          textInputType: TextInputType.text,
          suffixIcon: FontAwesomeIcons.user,
          controller: TextEditingController(),
          validate: (v) {
            if (v == null || v.trim().isEmpty) {
              return "لا يمكن أن يكون الحقل فارغا!!!";
            }
            return null;
          }),
      TextFormFieldModel(
          label: "كلمة المرور",
          textInputType: TextInputType.visiblePassword,
          suffixIcon: FontAwesomeIcons.eyeSlash,
          maxlength: 8,
          controller: TextEditingController(),
          obscuretext: true,
          validate: (v) {
            if (v == null || v.trim().isEmpty) {
              return "لا يمكن أن يكون الحقل فارغا!!!";
            } else if (v.length < 6) {
              return "لا يمكن أن تكون كلمة المرور أقل من ستة محارف";
            }
            return null;
          }),
    ];
    List<bool> wait = [false];
    return MultiProvider(providers: [
      ChangeNotifierProvider<LogInInputProvider>(
          create: (context) => LogInInputProvider(list)),
      ChangeNotifierProvider<WaitProvider>(
          create: (context) => WaitProvider(wait))
    ], child: LoginPageP(routeName: routeName));
  }
}

class LoginPageP extends StatelessWidget {
  const LoginPageP({super.key, required this.routeName});
  final String routeName;
  @override
  Widget build(BuildContext context) {
    bool wait = context.watch<WaitProvider>().list[0];
    WaitProvider waitRead = context.read<WaitProvider>();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    List<TextFormFieldModel> inputfields =
        context.watch<LogInInputProvider>().list;
    inputfields[1].suffixFunction =
        () => context.read<LogInInputProvider>().togglePassword(inputfields[1]);
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
                  right: 20, child: Image.asset("asset/images/dogfeet.png")),
              Positioned(
                  bottom: 20, child: Image.asset("asset/images/bone.png")),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20, bottom: 20),
                          child: Center(
                            child: Image.asset("asset/images/logo.png"),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20))),
                          child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Text(
                                    "تسجيل الدخول",
                                    style: ThemeM.theme().textTheme.titleSmall,
                                  ),
                                  const Divider(),
                                  ...inputfields.map((e) => textFormFieldMZ(
                                      submit: (x) async {
                                        if (_formKey.currentState?.validate() ==
                                            true) {
                                          await login(
                                              ctx: context,
                                              email: inputfields[0]
                                                      .controller!
                                                      .text
                                                      .contains("@")
                                                  ? inputfields[0]
                                                      .controller!
                                                      .text
                                                  : null,
                                              phone: !inputfields[0]
                                                      .controller!
                                                      .text
                                                      .contains("@")
                                                  ? inputfields[0]
                                                      .controller!
                                                      .text
                                                  : null,
                                              password: inputfields[1]
                                                  .controller!
                                                  .text);
                                        }
                                      },
                                      label: e.label,
                                      keyboardtype: e.textInputType,
                                      suffixIcon: e.suffixIcon!,
                                      suffixFunction: e.suffixFunction,
                                      controller: e.controller,
                                      obscuretext: e.obscuretext,
                                      validate: e.validate,
                                      maxlength: e.maxlength)),
                                  const Divider(),
                                  wait
                                      ? LinearProgressIndicator()
                                      : buttonMz(
                                          labelsize: 25.0,
                                          label: "دخول",
                                          icon: FontAwesomeIcons
                                              .arrowRightToBracket,
                                          iconColor:
                                              Colors.orangeAccent.shade100,
                                          function: () async {
                                            if (_formKey.currentState
                                                    ?.validate() ==
                                                true) {
                                              waitRead.togglepure(0);

                                              await login(
                                                  ctx: context,
                                                  email: inputfields[0]
                                                          .controller!
                                                          .text
                                                          .contains("@")
                                                      ? inputfields[0]
                                                          .controller!
                                                          .text
                                                      : null,
                                                  phone: !inputfields[0]
                                                          .controller!
                                                          .text
                                                          .contains("@")
                                                      ? inputfields[0]
                                                          .controller!
                                                          .text
                                                      : null,
                                                  password: inputfields[1]
                                                      .controller!
                                                      .text);
                                              waitRead.togglepure(0);
                                            }
                                          }),
                                  const SizedBox(height: 50),
                                  const Divider(),
                                  Text(
                                    "إنشاء حساب جديد",
                                    style: ThemeM.theme().textTheme.bodyMedium,
                                  ),
                                  const Divider(),
                                  Hero(
                                    tag: RegisterAsVeter.routeName,
                                    child: buttonMz(
                                        padding: 3.0,
                                        label: "إنشاء حساب كطبيب",
                                        labelsize: 20.0,
                                        icon: FontAwesomeIcons.userDoctor,
                                        color: Colors.orangeAccent,
                                        labelColor: Colors.white,
                                        iconColor: Colors.white,
                                        elevation: 1.0,
                                        width: 180.0,
                                        function: () {
                                          Navigator.pushNamed(context,
                                              RegisterAsVeter.routeName);
                                        }),
                                  ),
                                  buttonMz(
                                      padding: 3.0,
                                      label: "إنشاء حساب كمربي",
                                      labelsize: 20.0,
                                      icon: FontAwesomeIcons.tractor,
                                      color: Colors.orangeAccent,
                                      labelColor: Colors.white,
                                      iconColor: Colors.white,
                                      elevation: 1.0,
                                      width: 180.0,
                                      function: () {
                                        Navigator.pushNamed(context,
                                            RegisterAsBreeder.routeName);
                                      }),
                                ],
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
