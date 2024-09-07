import 'package:fit_medicine_02/controllers/providers/addtolist_provider.dart';
import 'package:fit_medicine_02/controllers/providers/counter_provider.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/controllers/providers/radio_provider.dart';
import 'package:fit_medicine_02/models/service_model.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:fit_medicine_02/views/widget/cartnotifi_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart' as intl;
import 'package:provider/provider.dart';

import '../widget/showmoreless_mz.dart';

class ShowProduct extends StatelessWidget {
  const ShowProduct(
      {super.key,
      required this.label,
      required this.routeName,
      required this.serviceType});
  final String routeName;
  final String label;
  final ServiceType serviceType;
  @override
  Widget build(BuildContext context) {
    List<bool> show = [false, false];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CounterProvider>(
            create: (_) => CounterProvider()),
        ChangeNotifierProvider<ShowMoreLessProvider>(
            create: (_) => ShowMoreLessProvider(show)),
        ChangeNotifierProvider<ChooseWeightUnitProvider>(
            create: (_) => ChooseWeightUnitProvider()),
      ],
      child: ShowProductP(
        routeName: routeName,
        label: label,
        serviceType: serviceType,
      ),
    );
  }
}

class ShowProductP extends StatelessWidget {
  const ShowProductP(
      {super.key,
      required this.routeName,
      required this.label,
      required this.serviceType});
  final String routeName;
  final String label;
  final ServiceType serviceType;
  @override
  Widget build(BuildContext context) {
    String selectedWeight = context.watch<ChooseWeightUnitProvider>().selected;
    ChooseWeightUnitProvider selectedWeightRead =
        context.read<ChooseWeightUnitProvider>();
    int count = context.watch<CounterProvider>().count;
    CounterProvider countRead = context.read<CounterProvider>();
    TextEditingController countController =
        TextEditingController(text: "$count");
    List<bool> show = context.watch<ShowMoreLessProvider>().list;
    ShowMoreLessProvider showRead = context.read<ShowMoreLessProvider>();
    ServiceModel item =
        ModalRoute.of(context)!.settings.arguments as ServiceModel;
    return SafeArea(
        child: Directionality(
      textDirection:
          context.watch<DirectionalityProvider>().getDirection(sharedPref) ??
              TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
              actions: [cartNotify(context)],
              toolbarHeight: 60,
              flexibleSpace: appBarMZ(label, routeName)),
          body: SingleChildScrollView(
              child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                constraints: const BoxConstraints(
                    minWidth: double.infinity, minHeight: 150, maxHeight: 200),
                child: Card(
                  child: Center(
                    child: item.image == null
                        ? const FaIcon(FontAwesomeIcons.image)
                        : Image.network(item.image!, fit: BoxFit.cover),
                  ),
                ),
              ),
              const Divider(),
              ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.name,
                      style: ThemeM.theme().textTheme.bodyLarge,
                    ),
                    Text(
                      serviceType == ServiceType.feed
                          ? intl.NumberFormat("#,### ل س لـ 1 كغ")
                              .format(item.price)
                          : intl.NumberFormat("#,### ل س").format(item.price),
                      style: ThemeM.theme().textTheme.bodySmall,
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        item.category == null
                            ? const SizedBox()
                            : Container(
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(3),
                                color: Colors.orangeAccent.shade100,
                                child: Text(
                                  item.category!,
                                  style: ThemeM.theme(color: Colors.black54)
                                      .textTheme
                                      .bodySmall,
                                ),
                              ),
                        item.type == null
                            ? const SizedBox()
                            : Container(
                                margin: const EdgeInsets.all(2),
                                padding: const EdgeInsets.all(3),
                                color: Colors.orangeAccent.shade100,
                                child: Text(
                                  item.type!,
                                  style: ThemeM.theme(color: Colors.black54)
                                      .textTheme
                                      .bodySmall,
                                ),
                              )
                      ],
                    ),
                    const SizedBox(height: 10),
                    ListTile(
                      title: Text(
                        "الوصف",
                        style: ThemeM.theme().textTheme.bodyLarge,
                      ),
                      subtitle: paragraph(show, showRead, item.usage, 0),
                    ),
                    ListTile(
                      title: Text(
                        "التركيب",
                        style: ThemeM.theme().textTheme.bodyLarge,
                      ),
                      subtitle: paragraph(show, showRead, item.composition, 1),
                    ),
                  ],
                ),
              ),
              const Divider(),
              buttonMz(
                  width: 150.0,
                  radius: 4.0,
                  labelColor: Colors.white,
                  color: Colors.orangeAccent,
                  label: "أضف إلى السلة",
                  labelsize: 15.0,
                  icon: FontAwesomeIcons.cartPlus,
                  iconColor: Colors.white60,
                  function: () {
                    if (serviceType == ServiceType.feed &&
                        selectedWeight == "طن") {
                      count *= 1000;
                    }
                    context
                        .read<AddtoCartlistProvider>()
                        .addProduct(item: item, count: count);
                  }),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: count == 1
                          ? null
                          : () {
                              countRead.minusone();
                            },
                      icon: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: count == 1
                                  ? Colors.grey
                                  : Colors.orangeAccent.shade400,
                              borderRadius: BorderRadius.circular(4)),
                          child: const FaIcon(
                            FontAwesomeIcons.minus,
                            color: Colors.white,
                            size: 15,
                          ))),
                  SizedBox(
                    width: 50,
                    child: TextField(
                      controller: countController,
                      onChanged: (value) {
                        countRead.setcount(
                            value, countController, item, context);
                      },
                      style: ThemeM.theme().textTheme.bodySmall,
                    ),
                  ),
                  IconButton(
                      onPressed: () {
                        countRead.addone();
                      },
                      icon: Container(
                          padding: const EdgeInsets.all(2),
                          decoration: BoxDecoration(
                              color: Colors.orangeAccent.shade400,
                              borderRadius: BorderRadius.circular(4)),
                          child: const FaIcon(
                            FontAwesomeIcons.plus,
                            color: Colors.white,
                            size: 15,
                          ))),
                  Visibility(
                    visible: serviceType == ServiceType.feed,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Radio(
                                value: "طن",
                                groupValue: selectedWeight,
                                onChanged: (x) {
                                  selectedWeightRead.selected = x;
                                }),
                            const Text("طن")
                          ],
                        ),
                        Row(
                          children: [
                            Radio(
                                value: "كيلو غرام",
                                groupValue: selectedWeight,
                                onChanged: (x) {
                                  selectedWeightRead.selected = x;
                                }),
                            const Text("كيلو غرام")
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ))),
    ));
  }
}

class ShowMedicine extends ShowProduct {
  const ShowMedicine({super.key})
      : super(
            label: "الأدوية",
            routeName: "ShowMedicine",
            serviceType: ServiceType.medicine);
}

class ShowFeed extends ShowProduct {
  const ShowFeed({super.key})
      : super(
            label: "الأعلاف",
            routeName: "ShowFeed",
            serviceType: ServiceType.feed);
}
