import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/models/provider_itemwithboolean_model.dart';
import 'package:fit_medicine_02/views/pages/homepage.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class BottombarMz extends StatelessWidget {
  const BottombarMz({super.key, required this.routeMame});
  final String routeMame;
  @override
  Widget build(BuildContext context) {
    List<BottomBarItem> list = [
      BottomBarItem(
        label: "الرئيسية",
        icon: FontAwesomeIcons.house,
        routeName: HomePage.routeName,
        selected: true,
      ),
      BottomBarItem(label: "بحث", icon: FontAwesomeIcons.magnifyingGlass),
      BottomBarItem(label: "المحادثات", icon: FontAwesomeIcons.commentDots),
      BottomBarItem(label: "إضافة منشور", icon: FontAwesomeIcons.clipboard)
    ];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomBarProvider>(
            create: (_) => BottomBarProvider(list))
      ],
      child: BottomBarP(
        routeName: routeMame,
      ),
    );
  }
}

class BottomBarP extends StatelessWidget {
  const BottomBarP({super.key, required this.routeName});
  final String routeName;
  @override
  Widget build(BuildContext context) {
    List<BottomBarItem> items = context.watch<BottomBarProvider>().list;
    BottomBarProvider itemsRead = context.read<BottomBarProvider>();

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(color: Colors.grey, blurRadius: 5),
        ]),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ...items.map((e) => TweenAnimationBuilder(
                  tween: Tween(begin: 1.0, end: e.selected ? 1.8 : 1.0),
                  duration: const Duration(milliseconds: 300),
                  builder: (context, value, child) => GestureDetector(
                    onTap: () {
                      itemsRead.chooseItemformgroup(e,
                          routeName: HomePage.routeName, ctx: context);
                      if (e.routeName != null && e.routeName != routeName) {
                        Navigator.pushNamed(context, e.routeName!);
                      }
                    },
                    child: Card(
                      elevation: 0,
                      color: Colors.white,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Transform.scale(
                            scale: value,
                            child: FaIcon(
                              e.icon,
                              size: 15,
                              color: e.selected ? Colors.green : Colors.grey,
                            ),
                          ),
                          Text(
                            e.label,
                            style: ThemeM.theme(
                                    color:
                                        e.selected ? Colors.green : Colors.grey)
                                .textTheme
                                .bodySmall,
                          )
                        ],
                      ),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
