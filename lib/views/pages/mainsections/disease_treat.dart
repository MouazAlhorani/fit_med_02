import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/models/service_model.dart';
import 'package:fit_medicine_02/views/pages/show_product.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/bottombar_mz.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class DiseaseTreat extends StatelessWidget {
  const DiseaseTreat({super.key});
  static String routeName = "DiseaseTreat";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future(
          () async => await apiGET(api: "/api/app/get_diseases"),
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
            return DiseaseTreatP(routeName: routeName, snapdata: snapshot.data);
          }
        });
  }
}

class DiseaseTreatP extends StatelessWidget {
  const DiseaseTreatP(
      {super.key, required this.routeName, required this.snapdata});
  final String routeName;
  final Map<String, dynamic> snapdata;
  @override
  Widget build(BuildContext context) {
    List<DiseaseTreatMentModel> data = [];
    for (var i in snapdata['data']['Diseases']) {
      data.add(DiseaseTreatMentModel.fromjson(data: i));
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
                    flexibleSpace: appBarMZ("أمراض و علاجها", routeName)),
                drawer: Drawer(),
                body: Column(children: [
                  Expanded(
                      child: data.isEmpty
                          ? Center(
                              child: Text(
                                "لا يوجد أي أمراض في القائمة",
                                style: ThemeM.theme().textTheme.bodyLarge,
                              ),
                            )
                          : SingleChildScrollView(
                              child: body(data, context),
                            )),
                  SizedBox(
                    height: 50,
                    child: BottombarMz(routeMame: DiseaseTreat.routeName),
                  )
                ]))));
  }

  Column body(List<DiseaseTreatMentModel> data, BuildContext context) {
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
                              child: e.image == null
                                  ? const FaIcon(FontAwesomeIcons.userDoctor)
                                  : Image.network(
                                      e.image!,
                                    )),
                        )),
                    title: Text(
                      e.name,
                      style: ThemeM.theme().textTheme.bodyLarge,
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'العلاج',
                              style: ThemeM.theme(color: Colors.black)
                                  .textTheme
                                  .bodySmall,
                            ),
                            const SizedBox(width: 20),
                            e.medicin == null
                                ? SizedBox()
                                : buttonMz(
                                    color: Colors.orangeAccent.shade100,
                                    width: 130.0,
                                    label: "اسم الدواء",
                                    icon: FontAwesomeIcons.flask,
                                    function: () {
                                      Navigator.pushNamed(
                                          context, ShowMedicine().routeName,
                                          arguments: e.medicin);
                                    }),
                          ],
                        ),
                      ],
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
                  onPressed: () {},
                  label: Text(
                    "تواصل مع الطبيب",
                    style: ThemeM.theme(color: Colors.orangeAccent.shade200)
                        .textTheme
                        .bodySmall,
                  ),
                  icon: FaIcon(
                    FontAwesomeIcons.commentDots,
                    color: Colors.orangeAccent.shade200,
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
