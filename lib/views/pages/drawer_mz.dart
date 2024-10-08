import 'dart:convert';

import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/controllers/static/server_info.dart';
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
    List<bool> list = [
      true,
      false,
      false,
      false,
      false,
      false,
      false,
      false,
      false
    ];
    var notifications;
    return FutureBuilder(future: Future(() async {
      notifications = await apiGET(api: "/api/app/notifications/all");

      return await apiGET(api: "/api/get-my-order");
    }), builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Drawer(
          child: Center(child: CircularProgressIndicator.adaptive()),
        );
      } else {
        return ChangeNotifierProvider<ShowMoreLessProvider>(
          create: (_) => ShowMoreLessProvider(list),
          child: DrawerMzP(
            snapdata: snapshot,
            notification: notifications,
            readed: required,
          ),
        );
      }
    });
  }
}

class DrawerMzP extends StatelessWidget {
  const DrawerMzP(
      {super.key,
      required this.snapdata,
      required this.notification,
      required this.readed});
  final snapdata, notification, readed;
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
                  tween: Tween(begin: 1000.0, end: items[0] ? 0.0 : 1000.0),
                  duration: const Duration(milliseconds: 200),
                  builder: (context, value, child) {
                    return Transform.translate(
                        offset: Offset(value, 0),
                        child: Container(
                            margin: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5)),
                            child: ListTile(
                              leading: veter != null && veter!.photo != null
                                  ? Container(
                                      width: 70,
                                      height: 70,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Image.network(veter!.photo!),
                                    )
                                  : FaIcon(veter != null
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
                  tween: Tween(begin: 1300.0, end: items[0] ? 0.0 : 1300.0),
                  duration: const Duration(milliseconds: 300),
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
                                  onPressed: () => itemsR.choosepure(7),
                                  icon: const FaIcon(
                                    FontAwesomeIcons.arrowLeft,
                                  ))),
                        ]),
                      ),
                    );
                  }),
              TweenAnimationBuilder(
                  tween: Tween(begin: 1300.0, end: items[0] ? 0.0 : 1300.0),
                  duration: const Duration(milliseconds: 400),
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
                        ));
                  }),
              TweenAnimationBuilder(
                  tween: Tween(begin: 1300.0, end: items[0] ? 0.0 : 1300.0),
                  duration: const Duration(milliseconds: 500),
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
              Column(children: [
                const SizedBox(height: 20),
                TweenAnimationBuilder(
                    tween: Tween(begin: 1.0, end: items[0] ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: buttonMz(
                            label: "تسجيل خروج",
                            color: Colors.white,
                            radius: 5.0,
                            function: () async {
                              await apiPost(
                                  api: "/api/breeder/auth/logout-breeder");
                              UserLoginInfo.remove(
                                  sharedPref: sharedPref, ctx: context);
                            }),
                      );
                    }),
                TweenAnimationBuilder(
                    tween: Tween(begin: 1.0, end: items[0] ? 1.0 : 0.0),
                    duration: const Duration(milliseconds: 600),
                    builder: (context, value, child) {
                      return Transform.scale(
                        scale: value,
                        child: buttonMz(
                            label: "حذف الحساب",
                            labelColor: Colors.red,
                            radius: 5.0,
                            function: () {}),
                      );
                    }),
              ]),
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
                                  child: veter != null && veter!.photo != null
                                      ? Image.network(veter!.photo!)
                                      : FaIcon(veter != null
                                          ? FontAwesomeIcons.userDoctor
                                          : FontAwesomeIcons.person),
                                ),
                              ))
                        ],
                      ));
                }),

//notifi
            Visibility(
                visible: items[7],
                child: FutureBuilder(
                    future: Future(() async =>
                        await apiGET(api: "/api/app/notifications/all")),
                    builder: (context, s) {
                      if (!s.hasData) {
                        return const Text("لا يوجد إشعارات جديدة");
                      } else {
                        Map data = s.data;
                        return TweenAnimationBuilder(
                            tween: Tween<double>(
                                begin: 1000.0, end: items[7] ? 0.0 : 1000.0),
                            duration: const Duration(milliseconds: 500),
                            builder: (context, value, child) {
                              return Transform.translate(
                                  offset: Offset(value, 0.0),
                                  child: Container(
                                    constraints:
                                        const BoxConstraints(minHeight: 300),
                                    margin: const EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Center(
                                            child: Text(
                                              "الإشعارات",
                                              style: ThemeM.theme()
                                                  .textTheme
                                                  .labelMedium,
                                            ),
                                          ),
                                          Divider(),
                                          ...data['data']['chat_notifications']
                                              .map((e) => Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15.0),
                                                    child: Row(
                                                      children: [
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            e['data']['message']
                                                                        [
                                                                        'type'] ==
                                                                    "image"
                                                                ? Image.network(
                                                                    "http://$serverIp${e['data']['message']['message']}",
                                                                    height: 50,
                                                                    width: 50,
                                                                  )
                                                                : Text(
                                                                    "${e['data']['message']['message']}"),
                                                            Text(
                                                                "from_  ${e['data']['sender_name']}"),
                                                            const Divider()
                                                          ],
                                                        ),
                                                        Spacer(),
                                                        IconButton(
                                                            onPressed: () async =>
                                                                await apiPost(
                                                                    api:
                                                                        "/api/app/mark_read/${e['data']['id']}"),
                                                            icon: const FaIcon(
                                                                FontAwesomeIcons
                                                                    .message))
                                                      ],
                                                    ),
                                                  )),
                                          Divider()
                                        ]),
                                  ));
                            });
                      }
                    })),
            //orders

            Visibility(
                visible: items[3],
                child: TweenAnimationBuilder(
                    tween: Tween<double>(
                        begin: 1000.0, end: items[3] ? 0.0 : 1000.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) {
                      return Transform.translate(
                          offset: Offset(value, 0.0),
                          child: snapdata.data == null ||
                                  snapdata.data['success'] != true ||
                                  snapdata.data['data'].isEmpty
                              ? const DecoratedBox(
                                  decoration: BoxDecoration(),
                                  child: SizedBox(
                                    width: 300,
                                    height: 300,
                                    child: Center(child: Text("لا يوجد طلبات")),
                                  ))
                              : Container(
                                  constraints:
                                      const BoxConstraints(minHeight: 300),
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: buttonMz(
                                                  padding: 2.0,
                                                  label: "الحالية",
                                                  color: !items[5]
                                                      ? Colors
                                                          .orangeAccent.shade200
                                                      : Colors.grey,
                                                  labelColor: Colors.white,
                                                  labelsize: 10.0,
                                                  radius: 5.0,
                                                  function: () =>
                                                      itemsR.togglepure(5)),
                                            ),
                                            Expanded(
                                              child: buttonMz(
                                                  padding: 2.0,
                                                  label: "السابقة",
                                                  labelColor: Colors.white,
                                                  color: items[5]
                                                      ? Colors
                                                          .orangeAccent.shade200
                                                      : Colors.grey,
                                                  labelsize: 10.0,
                                                  radius: 5.0,
                                                  function: () =>
                                                      itemsR.togglepure(5)),
                                            )
                                          ],
                                        ),
                                        ...snapdata.data['data']['orders']
                                            .where((s) => !items[5]
                                                ? s['status'] == "pending"
                                                : s['status'] != "pending")
                                            .map((e) => Column(
                                                  children: [
                                                    ListTile(
                                                        leading: Text(
                                                            e['order_number']),
                                                        title:
                                                            Text(e['location']),
                                                        subtitle: Column(
                                                          children: [
                                                            Text(
                                                                "${e['total_price']}"),
                                                            Text(
                                                                "${e['status']}")
                                                          ],
                                                        ),
                                                        trailing: IconButton(
                                                            onPressed: () {},
                                                            icon: const FaIcon(
                                                                FontAwesomeIcons
                                                                    .info))),
                                                    const Divider()
                                                  ],
                                                ))
                                      ]),
                                ));
                    })),

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
