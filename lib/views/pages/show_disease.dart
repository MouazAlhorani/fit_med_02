import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/models/service_model.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:fit_medicine_02/views/widget/showmoreless_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ShowDisease extends StatelessWidget {
  const ShowDisease({super.key});
  static String routeName = "ShowName";
  @override
  Widget build(BuildContext context) {
    List<bool> show = [false, false, false, false];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ShowMoreLessProvider>(
            create: (_) => ShowMoreLessProvider(show)),
      ],
      child: const ShowDiseaseP(),
    );
  }
}

class ShowDiseaseP extends StatelessWidget {
  const ShowDiseaseP({super.key});

  @override
  Widget build(BuildContext context) {
    List<bool> show = context.watch<ShowMoreLessProvider>().list;
    ShowMoreLessProvider showRead = context.read<ShowMoreLessProvider>();
    DiseaseTreatMentModel item =
        ModalRoute.of(context)!.settings.arguments as DiseaseTreatMentModel;
    return SafeArea(
        child: Directionality(
            textDirection: context
                    .watch<DirectionalityProvider>()
                    .getDirection(sharedPref) ??
                TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                    toolbarHeight: 60,
                    flexibleSpace:
                        appBarMZ("أمراض وعلاجها", ShowDisease.routeName)),
                body: SingleChildScrollView(
                    child: Column(children: [
                  Container(
                    margin: const EdgeInsets.all(8.0),
                    constraints: const BoxConstraints(
                        minWidth: double.infinity,
                        minHeight: 150,
                        maxHeight: 200),
                    child: Card(
                      child: Center(
                        child: item.image == null
                            ? const FaIcon(FontAwesomeIcons.image)
                            : Image.network(item.image!,
                                errorBuilder: (context, error, stackTrace) {
                                return const FaIcon(FontAwesomeIcons.image);
                              }, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    title: Text(
                      item.name,
                      style: ThemeM.theme().textTheme.bodyLarge,
                    ),
                    subtitle: paragraph(show, showRead, item.details, 0),
                  ),
                  ListTile(
                    title: Text(
                      "أعراض المرض",
                      style: ThemeM.theme().textTheme.bodyLarge,
                    ),
                    subtitle: paragraph(show, showRead, item.symptoms, 1),
                  ),
                  ListTile(
                    title: Text(
                      "الوقاية",
                      style: ThemeM.theme().textTheme.bodyLarge,
                    ),
                    subtitle: paragraph(show, showRead, item.prevention, 2),
                  ),
                  ListTile(
                    title: Text(
                      "العلاج",
                      style: ThemeM.theme().textTheme.bodyLarge,
                    ),
                    subtitle: paragraph(show, showRead, item.treatment, 3),
                  ),

                  // subtitle: buttonMz(
                  //     label: buttonMz(
                  //   label: item.medicin != null ? item.medicin!.name : '',
                  //   icon: FontAwesomeIcons.flask,
                  // )
                  // )
                ])))));
  }
}
