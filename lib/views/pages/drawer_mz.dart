import 'dart:convert';

import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/controllers/static/userlogin_Info.dart';
import 'package:fit_medicine_02/models/user_model.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DrawerMz extends StatelessWidget {
  const DrawerMz({super.key});

  @override
  Widget build(BuildContext context) {
    List<bool> list = [true, false, false, false, false];
    return ChangeNotifierProvider<ShowMoreLessProvider>(
      create: (_) => ShowMoreLessProvider(list),
      child: const DrawerMzP(),
    );
  }
}

class DrawerMzP extends StatelessWidget {
  const DrawerMzP({super.key});

  @override
  Widget build(BuildContext context) {
    if (UserLoginInfo.get(sharedPref: sharedPref)[2] == "veterinarian") {
      veter = VeterModel.fromjson(
          data: jsonDecode(UserLoginInfo.get(sharedPref: sharedPref)[3]));
    } else {
      breeder = BreederModel.fromjson(
          data: jsonDecode(UserLoginInfo.get(sharedPref: sharedPref)[3]));
    }
    List<bool> items = context.watch<ShowMoreLessProvider>().list;
    ShowMoreLessProvider itemsR = context.read<ShowMoreLessProvider>();
    print(UserLoginInfo.get(sharedPref: sharedPref)[4]);
    return Drawer(
      width: MediaQuery.of(context).size.width - 75,
      child: ListView(
        children: [
          Align(
            alignment: Alignment.bottomLeft,
            child: IconButton(
                onPressed: () {
                  items[0] ? Navigator.pop(context) : itemsR.choosepure(0);
                },
                icon: const FaIcon(FontAwesomeIcons.xmark)),
          ),
          Stack(children: [
            //main
            Column(children: [
              TweenAnimationBuilder(
                  tween: Tween(begin: -1000.0, end: items[0] ? 0.0 : -1000.0),
                  duration: const Duration(milliseconds: 500),
                  builder: (context, value, child) {
                    return Transform.translate(
                        offset: Offset(value, 0),
                        child: Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5)),
                            child: ListTile(
                              leading:
                                  //  veter != null && veter!.photo != null
                                  //     ? Container(
                                  //         width: 70,
                                  //         height: 70,
                                  //         decoration: BoxDecoration(
                                  //           borderRadius: BorderRadius.circular(10),
                                  //         ),
                                  //         child: Image.network(veter!.photo!),
                                  //       )
                                  //     :
                                  FaIcon(veter != null
                                      ? FontAwesomeIcons.userDoctor
                                      : FontAwesomeIcons.user),
                              title: Text(veter != null
                                  ? veter!.username
                                  : breeder != null
                                      ? breeder!.username
                                      : ''),
                              subtitle: Text(veter != null
                                  ? veter!.email != null
                                      ? veter!.email!
                                      : breeder!.mobile!
                                  : ''),
                              trailing: IconButton(
                                  onPressed: () => itemsR.choosepure(1),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.penToSquare,
                                    color: Colors.green,
                                  )),
                            )));
                  }),
              TweenAnimationBuilder(
                  tween: Tween(begin: -1300.0, end: items[0] ? 0.0 : -1300.0),
                  duration: const Duration(milliseconds: 600),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(value, 0),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(children: [
                          ListTile(
                              leading: const ClipRRect(
                                child: FaIcon(FontAwesomeIcons.bell),
                              ),
                              title: const Text("الإشعارات"),
                              trailing: IconButton(
                                  onPressed: () {},
                                  icon: const FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                  ))),
                        ]),
                      ),
                    );
                  }),
              TweenAnimationBuilder(
                  tween: Tween(begin: -1300.0, end: items[0] ? 0.0 : -1300.0),
                  duration: const Duration(milliseconds: 700),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(value, 0),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(children: [
                          ListTile(
                              leading: const ClipRRect(
                                child: FaIcon(FontAwesomeIcons.listCheck),
                              ),
                              title: const Text("طلباتي"),
                              trailing: IconButton(
                                  onPressed: () => itemsR.choosepure(3),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                  ))),
                        ]),
                      ),
                    );
                  }),
              TweenAnimationBuilder(
                  tween: Tween(begin: -1300.0, end: items[0] ? 0.0 : -1300.0),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, value, child) {
                    return Transform.translate(
                      offset: Offset(value, 0),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(children: [
                          ListTile(
                              leading: const ClipRRect(
                                child: FaIcon(FontAwesomeIcons.addressBook),
                              ),
                              title: const Text("تواصل معنا"),
                              trailing: IconButton(
                                  onPressed: () => itemsR.choosepure(4),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                  ))),
                        ]),
                      ),
                    );
                  }),
              Visibility(
                visible: items[0],
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    buttonMz(
                        label: "تسجيل خروج",
                        color: Colors.white,
                        radius: 5.0,
                        function: () {
                          UserLoginInfo.remove(
                              sharedPref: sharedPref, ctx: context);
                        }),
                    buttonMz(
                        label: "حذف الحساب",
                        labelColor: Colors.red,
                        radius: 5.0,
                        function: () {}),
                  ],
                ),
              ),
            ]),
            //profile

            TweenAnimationBuilder(
                tween: Tween<double>(
                    begin: -1000.0, end: items[1] ? 0.0 : -1000.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                      offset: Offset(0.0, value),
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              height: 200,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(25),
                                  child:
                                      // veter != null && veter!.photo != null
                                      //     ? Image.network(veter!.photo!)
                                      //     :
                                      FaIcon(veter != null
                                          ? FontAwesomeIcons.userDoctor
                                          : FontAwesomeIcons.person),
                                ),
                              ))
                        ],
                      ));
                }),

            //orders

            TweenAnimationBuilder(
                tween: Tween<double>(
                    begin: -1000.0, end: items[3] ? 0.0 : -1000.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                      offset: Offset(0.0, value),
                      child: Column(
                        children: [
                          Container(
                              width: double.infinity,
                              height: 200,
                              margin: const EdgeInsets.all(8.0),
                              decoration: BoxDecoration(
                                  border: Border.all(),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: buttonMz(
                                            label: "الطلبات الحالية",
                                            color: Colors.orangeAccent.shade200,
                                            labelColor: Colors.white,
                                            labelsize: 15.0,
                                            radius: 2.0,
                                            function: () {}),
                                      ),
                                      Expanded(
                                        child: buttonMz(
                                            label: "الطلبات السابقة",
                                            labelColor: Colors.white,
                                            color: Colors.grey,
                                            labelsize: 15.0,
                                            radius: 2.0,
                                            function: () {}),
                                      )
                                    ],
                                  )
                                ],
                              ))
                        ],
                      ));
                }),

            //cotact

            TweenAnimationBuilder(
                tween: Tween<double>(
                    begin: -1000.0, end: items[4] ? 0.0 : -1000.0),
                duration: const Duration(milliseconds: 500),
                builder: (context, value, child) {
                  return Transform.translate(
                      offset: Offset(0.0, value),
                      child: Column(
                        children: [
                          Text(
                            "تواصل معنا",
                            style: ThemeM.theme().textTheme.labelLarge,
                          ),
                          Container(
                            width: double.infinity,
                            height: 400,
                            margin: const EdgeInsets.all(8.0),
                            child: Center(
                                child: Image.asset(
                              "asset/images/logo.png",
                              color: Colors.orangeAccent.shade200,
                            )),
                          ),
                          ListTile(
                            title: Text(
                              "لا تتردد في طلب خدماتنا",
                              textAlign: TextAlign.center,
                              style:
                                  ThemeM.theme(color: Colors.black, size: 20.0)
                                      .textTheme
                                      .labelMedium,
                            ),
                            subtitle: buttonMz(
                                padding: 25.0,
                                label: "تواصل",
                                labelColor: Colors.white,
                                labelsize: 25.0,
                                icon: FontAwesomeIcons.phone,
                                iconColor: Colors.white,
                                color: Colors.orangeAccent.shade200,
                                function: () {}),
                          )
                        ],
                      ));
                }),
          ]),
        ],
      ),
    );
  }
}
