import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/models/provider_itemwithboolean_model.dart';
import 'package:fit_medicine_02/views/pages/login_page.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:fit_medicine_02/views/widget/textformfield_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class RegisterAsVeter extends StatelessWidget {
  const RegisterAsVeter({super.key});
  static String routeName = "registerAsVeter";

  @override
  Widget build(BuildContext context) {
    List<bool> wait = [false];
    List<TextFormFieldModel> list = [
      TextFormFieldModel(
        label: "الاسم الكامل",
        textInputType: TextInputType.name,
        suffixIcon: FontAwesomeIcons.userDoctor,
        controller: TextEditingController(),
        validate: (v) {
          if (v == null || v.trim().isEmpty) {
            return "لا يمكن أن يكون الحقل فارغا!!!";
          }
          return null;
        },
      ),
      TextFormFieldModel(
        label: "الايميل",
        textInputType: TextInputType.emailAddress,
        suffixIcon: FontAwesomeIcons.mailchimp,
        controller: TextEditingController(),
        validate: (v) {
          if (v == null || v.trim().isEmpty) {
            return "لا يمكن أن يكون الحقل فارغا!!!";
          }
          return null;
        },
      ),
      TextFormFieldModel(
          label: "كلمة المرور",
          textInputType: TextInputType.visiblePassword,
          suffixIcon: FontAwesomeIcons.eyeSlash,
          obscuretext: true,
          controller: TextEditingController(),
          maxlength: 8,
          validate: (v) {
            if (v == null || v.trim().isEmpty) {
              return "لا يمكن أن يكون الحقل فارغا!!!";
            }
            return null;
          }),
      TextFormFieldModel(
        label: "تأكيد كلمة المرور",
        textInputType: TextInputType.visiblePassword,
        suffixIcon: FontAwesomeIcons.eyeSlash,
        obscuretext: true,
        maxlength: 8,
        controller: TextEditingController(),
      ),
      TextFormFieldModel(
        label: "العنوان",
        textInputType: TextInputType.text,
        suffixIcon: FontAwesomeIcons.locationPinLock,
        controller: TextEditingController(),
        validate: (v) {
          if (v == null || v.trim().isEmpty) {
            return "لا يمكن أن يكون الحقل فارغا!!!";
          }
          return null;
        },
      ),
      TextFormFieldModel(
        label: "إرفاق الشهادة المصدقة",
        textInputType: TextInputType.text,
        suffixIcon: FontAwesomeIcons.fileShield,
        controller: TextEditingController(),
        readonly: true,
        validate: (v) {
          if (v == null || v.trim().isEmpty) {
            return "لا يمكن أن يكون الحقل فارغا!!!";
          }
          return null;
        },
      ),
      TextFormFieldModel(
        label: "إرفاق صورة للهوية الشخصية",
        textInputType: TextInputType.text,
        suffixIcon: FontAwesomeIcons.fileImage,
        controller: TextEditingController(),
        readonly: true,
      ),
      TextFormFieldModel(
        label: "إرفاق وثائق أخرى",
        textInputType: TextInputType.text,
        suffixIcon: FontAwesomeIcons.fileLines,
        controller: TextEditingController(),
        readonly: true,
      )
    ];
    list[3].validate = (x) {
      if (x != list[2].controller!.text) {
        return "كلمة المرور غير متطابقة!!";
      }
      return null;
    };
    return MultiProvider(providers: [
      ChangeNotifierProvider<RegisterAsVeteInputProvider>(
          create: (_) => RegisterAsVeteInputProvider(list)),
      ChangeNotifierProvider<WaitProvider>(create: (_) => WaitProvider(wait))
    ], child: RegisterAsVeterP(routeName: routeName));
  }
}

class RegisterAsVeterP extends StatelessWidget {
  const RegisterAsVeterP({super.key, required this.routeName});
  final String routeName;
  @override
  Widget build(BuildContext context) {
    bool wait = context.watch<WaitProvider>().list[0];
    WaitProvider waitRead = context.read<WaitProvider>();
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    List<TextFormFieldModel> inputfields =
        context.watch<RegisterAsVeteInputProvider>().list;
    inputfields[2].suffixFunction = () => context
        .read<RegisterAsVeteInputProvider>()
        .togglePassword(inputfields[2]);
    inputfields[3].suffixFunction = () => context
        .read<RegisterAsVeteInputProvider>()
        .togglePassword(inputfields[3]);
    inputfields[5].suffixFunction = () => context
        .read<RegisterAsVeteInputProvider>()
        .pickfile(item: inputfields[5], ctx: context);
    inputfields[6].suffixFunction = () => context
        .read<RegisterAsVeteInputProvider>()
        .pickfile(item: inputfields[6], ctx: context);
    inputfields[7].suffixFunction = () => context
        .read<RegisterAsVeteInputProvider>()
        .pickfile(item: inputfields[7], ctx: context);
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
                                  Hero(
                                    tag: routeName,
                                    child: Text(
                                      "إنشاء حساب كطبيب",
                                      style: ThemeM.theme(size: 20.0)
                                          .textTheme
                                          .titleLarge,
                                    ),
                                  ),
                                  const Divider(),
                                  ...inputfields.map((e) => textFormFieldMZ(
                                      label: e.label,
                                      keyboardtype: e.textInputType,
                                      suffixIcon: e.suffixIcon!,
                                      suffixFunction: e.suffixFunction,
                                      controller: e.controller,
                                      obscuretext: e.obscuretext,
                                      validate: e.validate,
                                      maxlength: e.maxlength,
                                      readonly: e.readonly,
                                      submit: (x) {
                                        return sendFunction(
                                            _formKey,
                                            inputfields,
                                            waitRead,
                                            wait,
                                            context);
                                      })),
                                  const Divider(),
                                  sendFunction(_formKey, inputfields, waitRead,
                                      wait, context),
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

  sendFunction(
      GlobalKey<FormState> _formKey,
      List<TextFormFieldModel> inputfields,
      WaitProvider waitRead,
      bool wait,
      ctx) {
    return wait
        ? const LinearProgressIndicator()
        : Align(
            alignment: Alignment.centerLeft,
            child: buttonMz(
                radius: 2.0,
                width: 50.0,
                label: "إرسال",
                labelColor: Colors.white70,
                icon: FontAwesomeIcons.floppyDisk,
                color: Colors.orangeAccent,
                iconColor: Colors.white38,
                function: wait
                    ? null
                    : () async {
                        if (_formKey.currentState?.validate() == true) {
                          waitRead.togglepure(0);
                          Map resp = await apiPost(
                              api: "/api/auth/register-veterinarian",
                              headers: {
                                'Accept': 'application/json'
                              },
                              fields: {
                                'name': inputfields[0].controller!.text,
                                'email': inputfields[1].controller!.text,
                                'phone number': inputfields[1].controller!.text,
                                'password': inputfields[2].controller!.text,
                                'confirm_password':
                                    inputfields[3].controller!.text,
                                'Address': inputfields[4].controller!.text,
                              },
                              files: [
                                {
                                  1: {
                                    'certificate_image':
                                        inputfields[5].controller!.text
                                  }
                                },
                                {
                                  1: {'photo': inputfields[6].controller!.text}
                                },
                                {
                                  3: {
                                    'experience_certificate_image[]':
                                        inputfields[7].controller!.text
                                  }
                                }
                              ]);
                          waitRead.togglepure(0);
                          if (resp.containsKey('success') &&
                              resp['success'] == true) {
                            ScaffoldMessenger.of(ctx)
                                .showSnackBar(const SnackBar(
                              content: Text("تم التسجيل بنجاح"),
                              elevation: 10,
                              backgroundColor: Colors.lightGreen,
                            ));
                            Navigator.pushReplacementNamed(
                                ctx, LoginPage.routeName);
                          } else {
                            try {
                              ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                                showCloseIcon: true,
                                content: Text(resp['message']),
                                elevation: 10,
                              ));
                            } catch (e) {}
                          }
                        }
                      }),
          );
  }
}
