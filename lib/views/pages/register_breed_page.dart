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

class RegisterAsBreeder extends StatelessWidget {
  const RegisterAsBreeder({super.key});
  static String routeName = "RegisterAsBreeder";

  @override
  Widget build(BuildContext context) {
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
          }),
      TextFormFieldModel(
          label: "رقم الهاتف",
          textInputType: TextInputType.phone,
          suffixIcon: FontAwesomeIcons.mailchimp,
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
          suffixIcon: FontAwesomeIcons.eye,
          controller: TextEditingController(),
          maxlength: 8,
          obscuretext: true,
          validate: (v) {
            if (v == null || v.trim().isEmpty) {
              return "لا يمكن أن يكون الحقل فارغا!!!";
            } else if (v.length < 6 || v.length > 8) {
              return "يجب ان تكون كلمة المرور بين 6 و 8 محارف";
            }
            return null;
          }),
      TextFormFieldModel(
        label: "تأكيد كلمة المرور",
        textInputType: TextInputType.visiblePassword,
        suffixIcon: FontAwesomeIcons.eye,
        maxlength: 8,
        obscuretext: true,
        controller: TextEditingController(),
      ),
      TextFormFieldModel(
          label: "العنوان",
          textInputType: TextInputType.text,
          suffixIcon: FontAwesomeIcons.locationPinLock,
          controller: TextEditingController(),
          validate: (v) {
            if (v == null || v.trim().isEmpty) {
              return "يجب ملئ الحقل!!!";
            }
            return null;
          }),
      TextFormFieldModel(
          label: "الحيوان الذي تربيه",
          textInputType: TextInputType.multiline,
          maxlines: 1,
          suffixIcon: FontAwesomeIcons.dog,
          controller: TextEditingController(),
          readonly: true,
          validate: (v) {
            if (v == null || v.trim().isEmpty) {
              return "يجب اختيار نوع واحد على الأقل!!!";
            }
            return null;
          }),
    ];
    list[3].validate = (x) {
      if (x != list[2].controller!.text) {
        return "كلمة المرور غير متطابقة!!";
      }
      return null;
    };
    List<AnimalCategories> animalsCategory = [
      AnimalCategories(id: 0, label: "اختر من القائمة"),
    ];
    List<bool> wait = [false];
    return FutureBuilder(
        future: Future(
            () async => await apiGET(api: "/api/app/get_animal_categorey")),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else {
            for (var i in snapshot.data['data']['Animal_Categories']) {
              animalsCategory.add(AnimalCategories.fromJson(data: i));
            }
            return MultiProvider(providers: [
              ChangeNotifierProvider<RegisterAsBreederInputProvider>(
                  create: (_) => RegisterAsBreederInputProvider(list)),
              ChangeNotifierProvider<ChooseAnimalTypesProvider>(
                  create: (_) => ChooseAnimalTypesProvider(animalsCategory)),
              ChangeNotifierProvider<WaitProvider>(
                  create: (_) => WaitProvider(wait))
            ], child: RegisterAsBreederP(routeName: routeName));
          }
        });
  }
}

class RegisterAsBreederP extends StatelessWidget {
  const RegisterAsBreederP({super.key, required this.routeName});
  final String routeName;
  @override
  Widget build(BuildContext context) {
    bool wait = context.watch<WaitProvider>().list[0];
    WaitProvider waitProvider = context.read<WaitProvider>();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    List<TextFormFieldModel> inputfields =
        context.watch<RegisterAsBreederInputProvider>().list;
    List<AnimalCategories> animalCategories =
        context.watch<ChooseAnimalTypesProvider>().list;
    inputfields[2].suffixFunction = () => context
        .read<RegisterAsBreederInputProvider>()
        .togglePassword(inputfields[2]);
    inputfields[3].suffixFunction = () => context
        .read<RegisterAsBreederInputProvider>()
        .togglePassword(inputfields[3]);
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
                              key: formKey,
                              child: Column(
                                children: [
                                  Hero(
                                    tag: routeName,
                                    child: Text(
                                      "إنشاء حساب كمربي",
                                      style: ThemeM.theme(size: 15.0)
                                          .textTheme
                                          .titleSmall,
                                    ),
                                  ),
                                  const Divider(),
                                  Stack(
                                    children: [
                                      Column(
                                        children: [
                                          ...inputfields.map((e) =>
                                              textFormFieldMZ(
                                                  label: e.label,
                                                  maxlength: e.maxlength,
                                                  keyboardtype: e.textInputType,
                                                  suffixIcon: e.suffixIcon!,
                                                  suffixFunction:
                                                      e.suffixFunction,
                                                  controller: e.controller,
                                                  obscuretext: e.obscuretext,
                                                  validate: e.validate,
                                                  readonly: e.readonly,
                                                  lines: e.maxlines,
                                                  submit: (x) {
                                                    return sendFunction(
                                                        formKey,
                                                        inputfields,
                                                        animalCategories,
                                                        waitProvider,
                                                        wait,
                                                        context);
                                                  })),
                                        ],
                                      ),
                                      animalCategory(animalCategories, context,
                                          inputfields),
                                    ],
                                  ),
                                  const Divider(),
                                  sendFunction(
                                      formKey,
                                      inputfields,
                                      animalCategories,
                                      waitProvider,
                                      wait,
                                      context),
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
      GlobalKey<FormState> formKey,
      List<TextFormFieldModel> inputfields,
      List<ChooseItemSModel> animalsGroups,
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
                function: () async {
                  if (formKey.currentState?.validate() == true) {
                    waitRead.togglepure(0);

                    var fields = {
                      'name': inputfields[0].controller!.text,
                      'password': inputfields[2].controller!.text,
                      'confirm_password': inputfields[3].controller!.text,
                      'phone_number': inputfields[1].controller!.text,
                      'region': inputfields[4].controller!.text,
                    };
                    for (var i in animalsGroups.where(
                        (e) => e.selected && animalsGroups.indexOf(e) != 0)) {
                      fields['animal_categorie_id[${animalsGroups.indexOf(i)}]'] =
                          (animalsGroups.indexOf(i)).toString();
                    }

                    var resp = await apiPost(
                      ctx: ctx,
                      api: '/api/breeder/auth/register-breeder',
                      fields: fields,
                    );
                    waitRead.togglepure(0);
                    waitRead.togglepure(0);
                    if (resp.containsKey('success') &&
                        resp['success'] == true) {
                      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
                        content: Text("تم التسجيل بنجاح"),
                        elevation: 10,
                        backgroundColor: Colors.lightGreen,
                      ));
                      Navigator.pushReplacementNamed(ctx, LoginPage.routeName);
                    } else {
                      try {
                        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
                          showCloseIcon: true,
                          content: Text(resp['message']),
                          elevation: 10,
                        ));
                        Navigator.pushReplacementNamed(
                            ctx, LoginPage.routeName);
                      } catch (e) {}
                    }
                  }
                }),
          );
  }
}

Positioned animalCategory(List<AnimalCategories> animalsGroups,
    BuildContext context, List<TextFormFieldModel> inputfields) {
  return Positioned(
    bottom: 10,
    left: 10,
    child: DropdownButton(
        icon: const FaIcon(FontAwesomeIcons.dog),
        value: animalsGroups[0],
        items: [
          DropdownMenuItem(
            value: animalsGroups[0],
            child: Text(animalsGroups[0].label),
          ),
          ...animalsGroups.sublist(1).map((e) => DropdownMenuItem(
                value: e,
                child: Text(e.label),
              ))
        ],
        onChanged: (x) {
          context.read<ChooseAnimalTypesProvider>().chooseItemS(x!);
          if (animalsGroups.indexOf(x) == 0) {
          } else if (x.selected == false) {
            inputfields.last.controller!.text = inputfields
                .last.controller!.text
                .replaceAll("*> ${x.label} \n", '');
            context
                .read<RegisterAsBreederInputProvider>()
                .removeline(inputfields.last);
          } else {
            inputfields.last.controller!.text += "*> ${x.label} \n";
            context
                .read<RegisterAsBreederInputProvider>()
                .addline(inputfields.last);
          }
        }),
  );
}
