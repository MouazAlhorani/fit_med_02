import 'package:fit_medicine_02/controllers/providers/addtolist_provider.dart';
import 'package:fit_medicine_02/views/pages/cart.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

cartNotify(BuildContext ctx) {
  int cartNotify = ctx.watch<AddtoCartlistProvider>().list.length;
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: IconButton(
        onPressed: () {
          Navigator.pushNamed(ctx, Cart.routeName);
        },
        icon: Stack(
          children: [
            const FaIcon(
              FontAwesomeIcons.cartShopping,
              color: Color.fromARGB(153, 96, 125, 139),
            ),
            cartNotify > 0
                ? Positioned(
                    top: 0,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(25)),
                      child: Center(
                        child: Text(
                          "$cartNotify",
                          style: ThemeM.theme(color: Colors.white, size: 8.0)
                              .textTheme
                              .bodySmall,
                        ),
                      ),
                    ),
                  )
                : const SizedBox()
          ],
        )),
  );
}
