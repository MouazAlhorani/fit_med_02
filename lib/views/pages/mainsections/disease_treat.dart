import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/models/service_model.dart';
import 'package:fit_medicine_02/views/pages/show_disease.dart';
import 'package:fit_medicine_02/views/pages/show_product.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/bottombar_mz.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:fit_medicine_02/views/widget/cardOne.dart';
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
                    child: BottombarMz(
                      routeMame: DiseaseTreat.routeName,
                      list: mainlist,
                    ),
                  )
                ]))));
  }

  Column body(List<DiseaseTreatMentModel> data, BuildContext context) {
    return Column(
      children: [
        ...data.map((e) {
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, ShowDisease.routeName,
                arguments: e),
            child: cardOne(
              context: context,
              photo: e.image,
              imageIcon: FontAwesomeIcons.flaskVial,
              mainlabel: e.name,
              firstRowIcon: FontAwesomeIcons.flask,
              firstRowText: e.treatment != null
                  ? "${e.treatment!.substring(0, 15)} ... "
                  : "",
              button: Align(
                alignment: Alignment.bottomLeft,
                child: buttonMz(
                    width: 100.0,
                    radius: 5.0,
                    label: "اسم العلاج",
                    labelColor: Colors.lightGreen,
                    color: Colors.white,
                    icon: FontAwesomeIcons.flask,
                    iconColor: Colors.lightGreen,
                    function: () {}),
              ),
            ),
          );
        })
      ],
    );
  }
}
