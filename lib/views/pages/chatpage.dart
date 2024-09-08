import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/models/user_model.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chatpage extends StatelessWidget {
  const Chatpage({super.key});
  static String routeName = "ChatPage";

  @override
  Widget build(BuildContext context) {
    VeterModel reciver =
        ModalRoute.of(context)!.settings.arguments as VeterModel;
    return FutureBuilder(
        future: Future(
          () async => await apiGET(api: "/api/app/get-messages/1"),
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
            return ChatpageP(snapdata: snapshot.data);
          }
        });
  }
}

class ChatpageP extends StatelessWidget {
  const ChatpageP({super.key, required this.snapdata});
  final Map<String, dynamic> snapdata;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Directionality(
            textDirection: context
                    .watch<DirectionalityProvider>()
                    .getDirection(sharedPref) ??
                TextDirection.rtl,
            child: Scaffold(
              body: Center(
                child: Text(snapdata.toString()),
              ),
            )));
  }
}
