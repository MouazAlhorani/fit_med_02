import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

Card cardOne(
    {photo,
    imageIcon,
    mainlabel,
    firstRowIcon,
    firstRowText,
    secondRowIcon,
    secondRowText,
    button,
    context}) {
  return Card(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(children: [
          ConstrainedBox(
              constraints: const BoxConstraints(
                minHeight: 90,
                minWidth: 90,
                maxHeight: 100,
                maxWidth: 100,
              ),
              child: Card(
                  child: Center(
                      child: photo == null
                          ? FaIcon(imageIcon)
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(15),
                              child: Image(
                                image: NetworkImage(photo!),
                                errorBuilder: (context, error, stackTrace) {
                                  return const FaIcon(FontAwesomeIcons.image);
                                },
                                fit: BoxFit.cover,
                              ))))),
          const SizedBox(height: 100, child: VerticalDivider()),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Text(
                            mainlabel,
                            style:
                                ThemeM.theme(size: 18.0).textTheme.titleLarge,
                          ),
                        ),
                        firstRowText == null
                            ? const SizedBox()
                            : Row(
                                children: [
                                  FaIcon(
                                    firstRowIcon,
                                    color: Colors.orange[200],
                                    shadows: const [
                                      BoxShadow(
                                          offset: Offset(1, 1), blurRadius: 2)
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    firstRowText,
                                    style: ThemeM.theme(
                                            color: Colors.black, size: 16.0)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                        const SizedBox(height: 5),
                        secondRowText == null
                            ? const SizedBox()
                            : Row(
                                children: [
                                  FaIcon(
                                    secondRowIcon,
                                    color: Colors.grey[200],
                                    shadows: const [
                                      BoxShadow(
                                          offset: Offset(1, 1), blurRadius: 2)
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Text(
                                    secondRowText,
                                    style: ThemeM.theme(
                                            color: Colors.black, size: 16.0)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ],
                              ),
                      ]),
                ),
                button
              ],
            ),
          ),
        ]),
      ],
    ),
  );
}
