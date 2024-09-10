import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/models/provider_itemwithboolean_model.dart';
import 'package:fit_medicine_02/models/user_model.dart';
import 'package:fit_medicine_02/views/pages/chatpage.dart';
import 'package:fit_medicine_02/views/pages/drawer_mz.dart';
import 'package:fit_medicine_02/views/widget/appbar_mz.dart';
import 'package:fit_medicine_02/views/widget/bottombar_mz.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class Conversations extends StatelessWidget {
  const Conversations({super.key});
  static String routeName = "Conversations";

  @override
  Widget build(BuildContext context) {
    Map<String, bool> label = {};
    for (var i in chatlist) {
      label.addAll({i.label: i.selected});
    }
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BottomBarProvider>(
            create: (_) => BottomBarProvider(chatlist)),
        ChangeNotifierProvider<MzProvider>(create: (_) => MzProvider(label)),
      ],
      child: ConversationsP(),
    );
  }
}

class ConversationsP extends StatelessWidget {
  const ConversationsP({super.key});
  @override
  Widget build(BuildContext context) {
    List<BottomBarItem> chatlist = context.watch<BottomBarProvider>().list;
    for (var i in chatlist) {
      i.function = () {
        context.read<MzProvider>().chooseOneFalseAll(i.label);
        context
            .read<BottomBarProvider>()
            .chooseItemformgroup(i, routeName: i.routeName, ctx: context);
      };
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
                  flexibleSpace: appBarMZ(
                      context
                          .watch<MzProvider>()
                          .items
                          .entries
                          .firstWhere((e) => e.value)
                          .key,
                      Conversations.routeName)),
              drawer: const DrawerMz(),
              body: Column(
                children: [
                  Expanded(
                      child: chatlist.indexWhere((e) => e.selected) == 0
                          ? chatsO()
                          : chatlist.indexWhere((e) => e.selected) == 1
                              ? SizedBox()
                              : communities()),
                  SizedBox(
                    height: 50,
                    child: BottombarMz(
                        routeMame: Conversations.routeName, list: chatlist),
                  )
                ],
              ),
            )));
  }

  FutureBuilder<dynamic> chatsO() {
    return FutureBuilder(
        future:
            Future(() async => await apiGET(api: "/api/app/get_conversations")),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            Map data = snapshot.data;
            return !data.containsKey('data')
                ? SizedBox()
                : ListView(
                    children: [
                      ...data['data']['conversation'].map((c) {
                        return FutureBuilder(future: Future(
                          () async {
                            var resp = await apiGET(
                                api:
                                    "/api/app/get-veterinarian/${c['veterinary_id']}");
                            var y = resp['data']['veterinarian'];
                            return VeterModel.fromjson(data: y);
                          },
                        ), builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox();
                          } else {
                            return GestureDetector(
                              onTap: () async {
                                Navigator.pushNamed(context, Chatpage.routeName,
                                    arguments: snapshot.data);
                              },
                              child: Card(
                                child: ListTile(
                                  leading: snapshot.data!.photo == null
                                      ? const FaIcon(
                                          FontAwesomeIcons.userDoctor)
                                      : Image.network(snapshot.data!.photo!),
                                  title: Text(snapshot.data!.username),
                                  subtitle: Text(c['created_at']),
                                ),
                              ),
                            );
                          }
                        });
                      })
                    ],
                  );
          } else {
            return SizedBox(
              height: 300,
              child: Center(
                child: Text("لا يمكن الوصول للمخدم"),
              ),
            );
          }
        });
  }

  FutureBuilder<dynamic> communities() {
    return FutureBuilder(
        future: Future(
            () async => await apiGET(api: "/api/breeder/get_communities")),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
              height: 300,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasData) {
            Map data = snapshot.data;
            return !data.containsKey('data')
                ? SizedBox()
                : ListView(
                    children: [
                      ...data['data']['data']['communities'].map((c) {
                        return FutureBuilder(future: Future(
                          () async {
                            var resp = await apiGET(
                                api: "/api/breeder/show_message/${c['id']}");
                            var y = resp['data']['messages'];
                            return y;
                          },
                        ), builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return SizedBox();
                          } else {
                            return GestureDetector(
                              // onTap: () async {
                              //   Navigator.pushNamed(context, Chatpage.routeName,
                              //       arguments: snapshot.data);
                              // },
                              child: Card(
                                child: ListTile(
                                  leading:
                                      const FaIcon(FontAwesomeIcons.userGroup),
                                  title: Text(c['name']),
                                  subtitle: Text("${c['id']}"),
                                ),
                              ),
                            );
                          }
                        });
                      })
                    ],
                  );
          } else {
            return SizedBox(
              height: 300,
              child: Center(
                child: Text("لا يمكن الوصول للمخدم"),
              ),
            );
          }
        });
  }
}
