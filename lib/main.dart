import 'package:fit_medicine_02/controllers/providers/addtolist_provider.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/theme_provider.dart';
import 'package:fit_medicine_02/views/pages/cart.dart';
import 'package:fit_medicine_02/views/pages/chatpage.dart';
import 'package:fit_medicine_02/views/pages/homepage.dart';
import 'package:fit_medicine_02/views/pages/interface.dart';
import 'package:fit_medicine_02/views/pages/login_page.dart';
import 'package:fit_medicine_02/views/pages/mainsections/disease_treat.dart';
import 'package:fit_medicine_02/views/pages/mainsections/feed.dart';
import 'package:fit_medicine_02/views/pages/mainsections/medicine.dart';
import 'package:fit_medicine_02/views/pages/mainsections/veters.dart';
import 'package:fit_medicine_02/views/pages/register_breed_page.dart';
import 'package:fit_medicine_02/views/pages/register_veter_page.dart';
import 'package:fit_medicine_02/views/pages/show_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

main() {
  return runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (_) => ThemeProvider()),
        ChangeNotifierProvider<DirectionalityProvider>(
            create: (_) => DirectionalityProvider()),
        ChangeNotifierProvider<AddtoCartlistProvider>(
            create: (_) => AddtoCartlistProvider(list: []))
      ],
      child: FutureBuilder(
          future: Future(
              () async => sharedPref = await SharedPreferences.getInstance()),
          builder: (_, snapshot) {
            return FitMed();
          })));
}

class FitMed extends StatelessWidget {
  const FitMed({super.key});
  @override
  Widget build(BuildContext context) {
    String? theme = sharedPref != null
        ? context.watch<ThemeProvider>().getTheme(sharedPref!)
        : null;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode:
          theme == null || theme == "light" ? ThemeMode.light : ThemeMode.dark,
      theme: theme == null || theme == "light"
          ? ThemeData.light()
          : ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const InterFace(),
        RegisterAsVeter.routeName: (context) => const RegisterAsVeter(),
        RegisterAsBreeder.routeName: (context) => const RegisterAsBreeder(),
        LoginPage.routeName: (context) => const LoginPage(),
        HomePage.routeName: (context) => const HomePage(),
        Medicine.routeName: (context) => const Medicine(),
        Feed.routeName: (context) => const Feed(),
        Veters.routeName: (context) => const Veters(),
        DiseaseTreat.routeName: (context) => const DiseaseTreat(),
        Cart.routeName: (context) => const Cart(),
        Chatpage.routeName: (context) => const Chatpage(),
        const ShowMedicine().routeName: (context) => const ShowMedicine(),
        const ShowFeed().routeName: (context) => const ShowFeed(),
      },
    );
  }
}
