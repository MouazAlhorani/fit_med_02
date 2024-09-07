import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/models/user_model.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/bottombar_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Veters extends StatelessWidget {
  const Veters({super.key});
  static String routeName = "Veters";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future(
          () async => await apiGET(api: "/api/app/get-veterinarians"),
        ),
        builder: (_, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));
          } else if (!snapshot.hasData) {
            return Scaffold(
                body: Center(
                    child: Text(
              "لا يمكن الوصول للمخدم",
              style: ThemeM.theme().textTheme.bodyLarge,
            )));
          } else {
            return VetersP(routeName: routeName, snapdata: snapshot.data);
          }
        });
  }
}

class VetersP extends StatelessWidget {
  const VetersP({super.key, required this.routeName, required this.snapdata});
  final String routeName;
  final Map<String, dynamic> snapdata;
  @override
  Widget build(BuildContext context) {
    List<VeterModel> data = [];
    print(snapdata['data']['Veterinarians']);
    for (var i in snapdata['data']['Veterinarians']) {
      data.add(VeterModel.fromjson(data: i));
    }
    return SafeArea(
        child: Directionality(
            textDirection: context
                    .watch<DirectionalityProvider>()
                    .getDirection(sharedPref) ??
                TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                    toolbarHeight: 60,
                    flexibleSpace: appBarMZ("الأطباء البيطريين", routeName)),
                drawer: Drawer(),
                body: Column(children: [
                  Expanded(
                      child: data.isEmpty
                          ? Center(
                              child: Text(
                                "لا يوجد أي أطباء في القائمة",
                                style: ThemeM.theme().textTheme.bodyLarge,
                              ),
                            )
                          : SingleChildScrollView(
                              child: body(data, context),
                            )),
                  SizedBox(
                    height: 50,
                    child: BottombarMz(routeMame: Veters.routeName),
                  )
                ]))));
  }

  Column body(List<VeterModel> data, BuildContext context) {
    return Column(
      children: [
        ...data.map((e) {
          return Stack(
            children: [
              Column(
                children: [
                  ListTile(
                    leading: SizedBox(
                        height: 200,
                        width: 100,
                        child: Card(
                            child: Center(
                                child: e.photo == null
                                    ? FaIcon(FontAwesomeIcons.userDoctor)
                                    : Image.network(
                                        e.photo!,
                                      )))),
                    title: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text(
                        e.username,
                        style: ThemeM.theme(size: 22.0).textTheme.titleLarge,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.userDoctor),
                              const SizedBox(width: 20),
                              Text(
                                e.specialization ?? '',
                                style: ThemeM.theme(
                                        color: Colors.black, size: 16.0)
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.mapLocation),
                              const SizedBox(width: 20),
                              Text(
                                e.address ?? '',
                                style: ThemeM.theme(
                                        color: Colors.black, size: 16.0)
                                    .textTheme
                                    .bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Divider()
                ],
              ),
              Positioned(
                bottom: 10,
                left: 2,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                      backgroundColor: Colors.orangeAccent.shade100),
                  onPressed: () {},
                  label: Text(
                    "تواصل مع الطبيب",
                    style: ThemeM.theme(color: Color.fromARGB(255, 5, 71, 104))
                        .textTheme
                        .bodySmall,
                  ),
                  icon: const FaIcon(
                    FontAwesomeIcons.commentDots,
                    color: Color.fromARGB(255, 5, 71, 104),
                  ),
                ),
              )
            ],
          );
        })
      ],
    );
  }
}
