import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/addtolist_provider.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/models/service_model.dart';
import 'package:fit_medicine_02/views/pages/drawer_mz.dart';
import 'package:fit_medicine_02/views/pages/show_product.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/bottombar_mz.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:fit_medicine_02/views/widget/cartnotifi_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class Feed extends StatelessWidget {
  const Feed({super.key});
  static String routeName = "Feed";

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future(
          () async => await apiGET(api: "/api/app/feeds/get-feeds"),
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
            return FeedP(routeName: routeName, snapdata: snapshot.data);
          }
        });
  }
}

class FeedP extends StatelessWidget {
  const FeedP({super.key, required this.routeName, required this.snapdata});
  final String routeName;
  final Map<String, dynamic> snapdata;
  @override
  Widget build(BuildContext context) {
    List<FeedModel> data = [];
    for (var i in snapdata['data']['feeds']) {
      data.add(FeedModel.fromjson(data: i));
    }
    return SafeArea(
        child: Directionality(
            textDirection: context
                    .watch<DirectionalityProvider>()
                    .getDirection(sharedPref) ??
                TextDirection.rtl,
            child: Scaffold(
                appBar: AppBar(
                    actions: [cartNotify(context)],
                    toolbarHeight: 60,
                    flexibleSpace: appBarMZ("الأعلاف", routeName)),
                drawer: const DrawerMz(),
                body: Column(children: [
                  Expanded(
                      child: data.isEmpty
                          ? Center(
                              child: Text(
                                "لا يوجد أي أعلاف في القائمة",
                                style: ThemeM.theme().textTheme.bodyLarge,
                              ),
                            )
                          : SingleChildScrollView(
                              child: body(data, context),
                            )),
                  SizedBox(
                    height: 50,
                    child: BottombarMz(routeMame: Feed.routeName),
                  )
                ]))));
  }

  Row body(List<FeedModel> data, BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: items(
                context, data.where((e) => data.indexOf(e).isOdd).toList()),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: items(
                context, data.where((e) => data.indexOf(e).isEven).toList()),
          ),
        )
      ],
    );
  }

  Column items(BuildContext context, List<FeedModel> data) {
    return Column(
      children: [
        ...data.map((i) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, const ShowFeed().routeName,
                  arguments: i);
            },
            child: Column(
              children: [
                Card(
                    child: i.image == null
                        ? const FaIcon(FontAwesomeIcons.image)
                        : ConstrainedBox(
                            constraints: const BoxConstraints(maxHeight: 160),
                            child: Image.network(
                              i.image!,
                              fit: BoxFit.cover,
                            ),
                          )),
                Padding(
                  padding: const EdgeInsets.only(right: 15.0),
                  child: Text(
                    i.name,
                    style: ThemeM.theme().textTheme.labelLarge,
                  ),
                ),
                Row(
                  children: [
                    i.category == null
                        ? const SizedBox()
                        : Container(
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.all(3),
                            color: Colors.orangeAccent.shade100,
                            child: Text(
                              i.category!,
                              style: ThemeM.theme(color: Colors.black)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ),
                    i.type == null
                        ? const SizedBox()
                        : Container(
                            margin: const EdgeInsets.all(2),
                            padding: const EdgeInsets.all(3),
                            color: Colors.orangeAccent.shade100,
                            child: Text(
                              i.type!,
                              style: ThemeM.theme(color: Colors.black)
                                  .textTheme
                                  .bodySmall,
                            ),
                          )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text(
                      "${i.price != null ? intl.NumberFormat("#,###").format(i.price) : "_"} ل.س",
                      style: ThemeM.theme(color: Colors.black, size: 15.0)
                          .textTheme
                          .bodyLarge,
                    )),
                buttonMz(
                    radius: 4.0,
                    labelColor: Colors.white,
                    color: Colors.orangeAccent,
                    label: "أضف إلى السلة",
                    labelsize: 11.0,
                    icon: FontAwesomeIcons.cartPlus,
                    iconColor: Colors.white60,
                    function: () {
                      print(i.serviceType);
                      context.read<AddtoCartlistProvider>().addProduct(item: i);
                    }),
                Divider()
              ],
            ),
          );
        }),
      ],
    );
  }
}
