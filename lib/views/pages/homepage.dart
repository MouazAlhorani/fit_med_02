import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/models/widgets_model/mainsection_model.dart';
import 'package:fit_medicine_02/views/pages/drawer_mz.dart';
import 'package:fit_medicine_02/views/pages/mainsections/disease_treat.dart';
import 'package:fit_medicine_02/views/pages/mainsections/feed.dart';
import 'package:fit_medicine_02/views/pages/mainsections/medicine.dart';
import 'package:fit_medicine_02/views/pages/mainsections/veters.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/bottombar_mz.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static String routeName = "HomePage";

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LogInInputProvider>(
            create: (_) => LogInInputProvider([])),
      ],
      child: HomePageP(routeName: routeName),
    );
  }
}

class HomePageP extends StatelessWidget {
  const HomePageP({super.key, required this.routeName});
  final String routeName;
  @override
  Widget build(BuildContext context) {
    List<MainSectionModel> items = [
      MainSectionModel(
          label: "الأدوية",
          routeName: Medicine.routeName,
          image: "asset/images/main/medicine.png"),
      MainSectionModel(
          label: "الأعلاف",
          routeName: Feed.routeName,
          image: "asset/images/main/feed.png"),
      MainSectionModel(
          label: "الأطباء",
          routeName: Veters.routeName,
          image: "asset/images/main/veters.png"),
      MainSectionModel(
          label: "الأمراض",
          routeName: DiseaseTreat.routeName,
          image: "asset/images/main/disease.png")
    ];

    return SafeArea(
        child: Directionality(
            textDirection: context
                    .watch<DirectionalityProvider>()
                    .getDirection(sharedPref) ??
                TextDirection.rtl,
            child: Scaffold(
              appBar: AppBar(
                  toolbarHeight: 60,
                  flexibleSpace: appBarMZ("الصفحة الرئيسية", routeName)),
              drawer: const DrawerMz(),
              body: Column(
                children: [
                  Expanded(
                      child: ListView(
                    children: [
                      ...items.map((e) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, e.routeName!);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(3),
                            height: 250.0,
                            width: double.infinity,
                            child: Center(
                              child: Stack(
                                fit: StackFit.expand,
                                alignment: Alignment.bottomCenter,
                                children: [
                                  Image.asset(
                                    e.image!,
                                    fit: BoxFit.cover,
                                    scale: 1.0,
                                  ),
                                  Positioned(
                                      bottom: 5,
                                      child: Container(
                                        padding: const EdgeInsets.all(10),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        decoration: const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 2,
                                                offset: Offset(-1, -1))
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          border: Border(
                                            top: BorderSide(
                                                width: 4,
                                                color: Colors.orangeAccent),
                                            left: BorderSide(
                                                width: 2,
                                                color: Colors.orangeAccent),
                                            right: BorderSide(
                                                width: 2,
                                                color: Colors.orangeAccent),
                                          ),
                                        ),
                                        child: Hero(
                                          tag: e.routeName!,
                                          child: Text(
                                            e.label,
                                            textAlign: TextAlign.center,
                                            style: ThemeM.theme()
                                                .textTheme
                                                .labelLarge,
                                          ),
                                        ),
                                      ))
                                ],
                              ),
                            ),
                          ),
                        );
                      })
                    ],
                  )),
                  SizedBox(
                      height: 50,
                      child: BottombarMz(
                        routeMame: HomePage.routeName,
                        list: mainlist,
                      ))
                ],
              ),
            )));
  }
}
