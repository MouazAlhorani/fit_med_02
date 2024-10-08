import 'dart:math';

import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/addtolist_provider.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/models/provider_itemwithboolean_model.dart';
import 'package:fit_medicine_02/models/service_model.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/button_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart' as intl;

class Cart extends StatelessWidget {
  const Cart({super.key});
  static String routeName = "Cart";
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Future(() async => await apiGET(api: "/api/app/get-locations")),
        builder: (_, snaps) {
          if (snaps.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            List<LocationModel> list = [
              LocationModel(
                  id: 0, label: "بدون توصيل", price: 0, selected: true)
            ];
            List<bool> wait = [false];
            return FutureBuilder(
                future: Future(
                    () async => await apiGET(api: "/api/app/get-locations")),
                builder: (_, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Scaffold(
                      body: Center(
                        child: CircularProgressIndicator.adaptive(),
                      ),
                    );
                  } else {
                    for (var i in snapshot.data['data']['locations']) {
                      list.add(LocationModel.fromjson(data: i));
                    }
                    return MultiProvider(providers: [
                      ChangeNotifierProvider<LocationProvider>(
                        create: (_) => LocationProvider(list),
                      ),
                      ChangeNotifierProvider<WaitProvider>(
                          create: (_) => WaitProvider(wait))
                    ], child: const CartP());
                  }
                });
          }
        });
  }
}

class CartP extends StatelessWidget {
  const CartP({super.key});
  @override
  Widget build(BuildContext context) {
    List<LocationModel> locations = context.watch<LocationProvider>().list;
    LocationProvider locationsRead = context.read<LocationProvider>();
    List<ServiceModel> cartitems = context.watch<AddtoCartlistProvider>().list;
    AddtoCartlistProvider cartitemsRead = context.read<AddtoCartlistProvider>();
    bool wait = context.watch<WaitProvider>().list[0];
    WaitProvider waitProvider = context.read<WaitProvider>();
    return SafeArea(
        child: Directionality(
      textDirection:
          context.watch<DirectionalityProvider>().getDirection(sharedPref) ??
              TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
            toolbarHeight: 60,
            flexibleSpace: appBarMZ("السلة", Cart.routeName)),
        body: context.watch<AddtoCartlistProvider>().list.isEmpty
            ? emptyCart()
            : Column(
                children: [
                  Expanded(
                      flex: 3, child: orderDetails(context, cartitemsRead)),
                  Expanded(
                      flex: 2,
                      child: orderResultConfirm(wait, waitProvider, locations,
                          locationsRead, context, cartitems, cartitemsRead))
                ],
              ),
      ),
    ));
  }

  ListView orderResultConfirm(
      bool wait,
      WaitProvider waitProvider,
      List<LocationModel> locations,
      LocationProvider locationsRead,
      BuildContext context,
      List<ServiceModel> cartitems,
      AddtoCartlistProvider cartitemsRead) {
    return ListView(
      children: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.lightGreen),
              borderRadius: BorderRadius.circular(5)),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: Colors.lightGreen,
                    border: Border.all(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                    title: Text(
                      "تحديد موقع التوصيل",
                      style: ThemeM.theme(color: Colors.white)
                          .textTheme
                          .bodyMedium,
                    ),
                    trailing: DropdownButton(
                        value: locations.firstWhere((e) => e.selected == true),
                        items: [
                          ...locations.map((e) =>
                              DropdownMenuItem(value: e, child: Text(e.label)))
                        ],
                        onChanged: (x) {
                          locationsRead.chooseItemformgroup(x);
                        })),
              ),
              ListTile(
                title: Text(
                  "قيمة التوصيل",
                  style: ThemeM.theme(color: Colors.black).textTheme.bodyMedium,
                ),
                trailing: Text(intl.NumberFormat("#,### ل س").format(
                    locations.firstWhere((e) => e.selected == true).price)),
              ),
              locations.firstWhere((e) => e.selected == true).time != null
                  ? ListTile(
                      title: Text(
                        "وقت التوصيل",
                        style: ThemeM.theme(color: Colors.black)
                            .textTheme
                            .bodyMedium,
                      ),
                      trailing: Text(
                        intl.DateFormat("yyyy-MM-dd").format(locations
                            .firstWhere((e) => e.selected == true)
                            .time!),
                      ))
                  : const SizedBox(),
              Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.lightGreen),
                    borderRadius: BorderRadius.circular(5)),
                child: ListTile(
                  title: const Text("إجمالي قيمة الطلب"),
                  trailing: Text(intl.NumberFormat("#,### ل س").format(context
                          .read<AddtoCartlistProvider>()
                          .getTotalPrice() +
                      locations.firstWhere((e) => e.selected == true).price)),
                ),
              ),
              wait
                  ? const LinearProgressIndicator()
                  : buttonMz(
                      padding: 4.0,
                      width: 200.0,
                      label: "تأكيد عملية الشراء",
                      labelColor: Colors.white,
                      radius: 8.0,
                      color: Colors.deepOrange.shade300,
                      function: () async {
                        waitProvider.togglepure(0);
                        Map? resp =
                            await apiPost(api: "/api/order", optionalfields: {
                          locations.firstWhere((r) => r.selected).id == 0
                              ? null
                              : "delivery_type": "delivery",
                          locations.firstWhere((r) => r.selected).id == 0
                                  ? null
                                  : "location_id":
                              "${locations.firstWhere((r) => r.selected).id}"
                        }, fields: {
                          "total_price":
                              "${cartitemsRead.getTotalPrice() + locations.firstWhere((e) => e.selected).price}",
                          "delivery_type": "non_delivery",
                        }, fieldsArray: [
                          {
                            "medicines": [
                              ...cartitems
                                  .where((e) =>
                                      e.serviceType == ServiceType.medicine)
                                  .map(
                                      (e) => {"id": e.id, "quantity": e.count}),
                            ],
                            "feeds": [
                              ...cartitems
                                  .where(
                                      (e) => e.serviceType == ServiceType.feed)
                                  .map(
                                      (e) => {"id": e.id, "quantity": e.count}),
                            ]
                          }
                        ]);
                        if (resp != null &&
                            resp.containsKey("success") &&
                            resp['success'] == true) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              showCloseIcon: true,
                              content: Text(
                                  "تم تسجيل طلبك بنجاح .. يمكنك مراجعة طلباتك من قائمة طلباتي"),
                              elevation: 10,
                            ),
                          );
                          cartitemsRead.reset();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              showCloseIcon: true,
                              content: Text("حدث خطأ ما"),
                              elevation: 10,
                            ),
                          );
                        }
                        waitProvider.togglepure(0);
                      },
                    ),
              wait
                  ? const SizedBox()
                  : buttonMz(
                      padding: 4.0,
                      width: 200.0,
                      label: "حذف الطلب",
                      labelColor: Colors.white,
                      radius: 8.0,
                      color: Colors.grey,
                      function: () {
                        cartitemsRead.reset();
                      })
            ],
          ),
        )
      ],
    );
  }

  Container orderDetails(
      BuildContext context, AddtoCartlistProvider cartitemsRead) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ...context
                    .watch<AddtoCartlistProvider>()
                    .list
                    .where((e) => e.serviceType == ServiceType.medicine)
                    .map((e) {
                  TextEditingController countController = TextEditingController(
                      text: context
                          .read<AddtoCartlistProvider>()
                          .getitemCount(e)
                          .toString());
                  return productsList(e, context, countController);
                }),
                ...context
                    .watch<AddtoCartlistProvider>()
                    .list
                    .where((e) => e.serviceType == ServiceType.feed)
                    .map((e) {
                  TextEditingController countController = TextEditingController(
                      text: context
                          .read<AddtoCartlistProvider>()
                          .getitemCount(e)
                          .toString());
                  return productsList(e, context, countController);
                }),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.lightGreen),
                borderRadius: BorderRadius.circular(5)),
            child: ListTile(
              title: const Text("سعر المنتجات"),
              trailing: Text(intl.NumberFormat("#,### ل س")
                  .format(cartitemsRead.getTotalPrice())),
            ),
          )
        ],
      ),
    );
  }

  Stack productsList(ServiceModel e, BuildContext context,
      TextEditingController countController) {
    return Stack(
      children: [
        Container(
          color: Colors.white,
          child: Column(
            children: [
              ListTile(
                leading: SizedBox(
                    height: 200,
                    width: 100,
                    child: Card(
                      child: Center(
                          child: e.image == null
                              ? const FaIcon(FontAwesomeIcons.image)
                              : Image.network(
                                  e.image!,
                                )),
                    )),
                title: Text(
                  e.name,
                  style: ThemeM.theme(size: 15.0).textTheme.bodyLarge,
                ),
                subtitle: Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        IconButton(
                            onPressed: e.count == 1
                                ? null
                                : () {
                                    context
                                        .read<AddtoCartlistProvider>()
                                        .removeProduct(item: e);
                                  },
                            icon: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                    color: e.count == 1
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
                            onChanged: (value) => context
                                .read<AddtoCartlistProvider>()
                                .setProductcount(
                                    e, value, context, countController),
                            style: ThemeM.theme().textTheme.bodySmall,
                          ),
                        ),
                        IconButton(
                            onPressed: () {
                              context
                                  .read<AddtoCartlistProvider>()
                                  .addProduct(item: e);
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
                      ],
                    ),
                    Text(e.price == null
                        ? "__"
                        : intl.NumberFormat("#,### ل س")
                            .format(e.price! * e.count))
                  ],
                ),
              ),
              const Divider(
                indent: 50,
                endIndent: 10,
              )
            ],
          ),
        ),
        Positioned(
            left: -35,
            top: 5,
            width: 130.0,
            child: Transform.rotate(
              angle: -45 * pi / 180,
              child: buttonMz(
                  radius: 2.0,
                  label: "حذف الطلب",
                  labelColor: Colors.black,
                  icon: FontAwesomeIcons.xmark,
                  iconColor: Colors.red,
                  labelsize: 8.0,
                  color: Colors.amber.shade100,
                  function: () {
                    context
                        .read<AddtoCartlistProvider>()
                        .removeProductCompletly(item: e);
                  }),
            ))
      ],
    );
  }

  Center emptyCart() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TweenAnimationBuilder(
              tween: Tween(
                begin: -500.0,
                end: 0.0,
              ),
              curve: Curves.easeIn,
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.translate(
                    offset: Offset(value, 0.0),
                    child: TweenAnimationBuilder(
                        tween: Tween(
                          begin: 0.5,
                          end: 1.2,
                        ),
                        curve: Curves.linear,
                        duration: const Duration(milliseconds: 500),
                        builder: (context, value, child) {
                          return Transform.scale(
                              scale: value,
                              child: Image.asset("asset/images/cart.png"));
                        }));
              }),
          Text(
            "لا يوجد أي طلبات في السلة",
            style: ThemeM.theme().textTheme.bodyMedium,
          )
        ],
      ),
    );
  }
}
