import 'package:file_picker/file_picker.dart';
import 'package:fit_medicine_02/controllers/functions/api_requests.dart';
import 'package:fit_medicine_02/controllers/functions/audio_recorder.dart';
import 'package:fit_medicine_02/controllers/functions/pick_camera.dart';
import 'package:fit_medicine_02/controllers/functions/pick_file.dart';
import 'package:fit_medicine_02/controllers/providers/audio_provider.dart';
import 'package:fit_medicine_02/controllers/providers/directionality_provider.dart';
import 'package:fit_medicine_02/controllers/providers/listwithboolean_provider.dart';
import 'package:fit_medicine_02/controllers/static/server_info.dart';
import 'package:fit_medicine_02/controllers/static/userlogin_Info.dart';
import 'package:fit_medicine_02/models/chatitem_model.dart';
import 'package:fit_medicine_02/models/user_model.dart';
import 'package:fit_medicine_02/views/theme/theme.dart';
import 'package:fit_medicine_02/views/widget/imagenetwork.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:record/record.dart';

class Chatpage extends StatelessWidget {
  const Chatpage({super.key});
  static String routeName = "ChatPage";

  @override
  Widget build(BuildContext context) {
    VeterModel reciver =
        ModalRoute.of(context)!.settings.arguments as VeterModel;
    return FutureBuilder(
        future: Future(
          () async => await apiGET(api: "/api/app/get-message/${reciver.id}"),
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
            Map<String, bool> items = {
              'pickimgtype': false,
              'record': false,
              'wait': false
            };
            List<PlatformFile> pickedimage = [];
            return MultiProvider(providers: [
              ChangeNotifierProvider<MzProvider>(
                  create: (_) => MzProvider(items)),
              ChangeNotifierProvider<ARProvider>(create: (_) => ARProvider()),
              ChangeNotifierProvider<PickImageProvider>(
                  create: (_) => PickImageProvider(pickedimage))
            ], child: ChatpageP(snapdata: snapshot.data, reciver: reciver));
          }
        });
  }
}

class ChatpageP extends StatelessWidget {
  const ChatpageP({super.key, required this.snapdata, required this.reciver});
  final Map<String, dynamic> snapdata;
  final VeterModel reciver;
  @override
  Widget build(BuildContext context) {
    Map<String, bool> items = context.watch<MzProvider>().items;
    MzProvider itemsProvider = context.read<MzProvider>();
    List<PlatformFile> pickedimages = context.watch<PickImageProvider>().items;
    PickImageProvider pickedimagesProvider = context.read<PickImageProvider>();
    AudioRecorder recorder = AudioRecorder();
    TextEditingController controller = TextEditingController();
    List<ChatitemModel> chatitems = [];

    if (snapdata.containsKey("success") && snapdata['success'] == true) {
      for (var i in snapdata['data']) {
        if (i['type'] == "text") {
          chatitems.add(ChatitemModel.fromjsonText(data: i));
        } else if (i['type'] == "image") {
          chatitems.add(ChatitemModel.fromjsonImage(data: i));
        } else if (i['type'] == "Audio") {
          chatitems.add(ChatitemModel.fromjsonAudio(data: i));
        }
      }
    }
    ScrollController _scrollController = ScrollController();
    return SafeArea(
        child: Directionality(
            textDirection: context
                    .watch<DirectionalityProvider>()
                    .getDirection(sharedPref) ??
                TextDirection.rtl,
            child: Scaffold(
                body: Center(
              child: Stack(children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Expanded(
                      child: StreamBuilder(
                          stream: Stream.periodic(const Duration(seconds: 2))
                              .asyncMap(
                            (_) => apiGET(
                                api: "/api/app/get-message/${reciver.id}"),
                          ),
                          builder: (context, snapshotsStream) {
                            if (snapshotsStream.hasData &&
                                snapshotsStream.data.containsKey("data") &&
                                snapshotsStream.data['data'].isNotEmpty) {
                              List streamdata = snapshotsStream.data['data'];
                              for (var i in streamdata) {
                                bool messageExists =
                                    chatitems.any((item) => item.id == i['id']);
                                if (!messageExists) {
                                  if (i['type'] == "text") {
                                    chatitems.add(
                                        ChatitemModel.fromjsonText(data: i));
                                  } else if (i['type'] == "image") {
                                    chatitems.add(
                                        ChatitemModel.fromjsonImage(data: i));
                                  } else if (i['type'] == "Audio") {
                                    chatitems.add(
                                        ChatitemModel.fromjsonAudio(data: i));
                                  }
                                }
                              }
                            }
                            return ListView(
                              controller: _scrollController,
                              children: [
                                reciver.photo != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(25.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(1000),
                                          child: Image(
                                            image: NetworkImage(reciver.photo!),
                                            width: 100,
                                            height: 100,
                                          ),
                                        ),
                                      )
                                    : const Center(
                                        child: Padding(
                                        padding: EdgeInsets.all(25.0),
                                        child: FaIcon(
                                          FontAwesomeIcons.userDoctor,
                                          size: 100,
                                        ),
                                      )),
                                Center(
                                  child: Text(
                                    reciver.username,
                                    style: ThemeM.theme().textTheme.titleMedium,
                                  ),
                                ),
                                const Divider(
                                  indent: 40,
                                  endIndent: 40,
                                ),
                                !(snapdata.containsKey("success") &&
                                        snapdata['success'] == true)
                                    ? SizedBox(
                                        height: 300,
                                        child: Center(
                                          child: Text("ابدأ الدردشة",
                                              style: ThemeM.theme()
                                                  .textTheme
                                                  .bodyLarge),
                                        ),
                                      )
                                    : Column(children: [
                                        ...chatitems.map((c) {
                                          return Align(
                                            alignment: c.senderId != reciver.id
                                                ? Alignment.centerRight
                                                : Alignment.centerLeft,
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(10),
                                                margin:
                                                    const EdgeInsets.all(10),
                                                constraints: const BoxConstraints(
                                                    maxWidth: 500,
                                                    minWidth: 85),
                                                decoration: BoxDecoration(
                                                    borderRadius: c.senderId !=
                                                            reciver.id
                                                        ? const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    25),
                                                            topLeft:
                                                                Radius.circular(
                                                                    25),
                                                            bottomLeft:
                                                                Radius.circular(
                                                                    25))
                                                        : const BorderRadius.only(
                                                            topRight:
                                                                Radius.circular(
                                                                    25),
                                                            topLeft: Radius.circular(25),
                                                            bottomRight: Radius.circular(25)),
                                                    color: c.senderId != reciver.id ? Colors.orange[200] : Colors.green[200]),
                                                child: c.type == "image"
                                                    ? ConstrainedBox(constraints: const BoxConstraints(maxWidth: 250, maxHeight: 250), child: networkImage(c.message))
                                                    : Text(
                                                        c.message!,
                                                        style: ThemeM.theme(
                                                                color: Colors
                                                                    .black)
                                                            .textTheme
                                                            .bodyMedium,
                                                      )),
                                          );
                                        }),
                                      ]),
                              ],
                            );
                          })),
                  Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: EdgeInsets.all(8),
                        child: TextFormField(
                          controller: controller,
                          onFieldSubmitted: (x) async {
                            if (controller.text.isNotEmpty) {
                              await apiPost(
                                  api: "/api/app/send-message/${reciver.id}",
                                  fields: {
                                    "type": "text",
                                    "message": controller.text
                                  });
                              controller.clear();
                            }
                          },
                          decoration: InputDecoration(
                              hintText: "اكتب هنا",
                              suffixIcon: IconButton(
                                  onPressed: () async {
                                    if (controller.text.isNotEmpty) {
                                      await apiPost(
                                          api:
                                              "/api/app/send-message/${reciver.id}",
                                          fields: {
                                            "type": "text",
                                            "message": controller.text
                                          });
                                      _scrollController.animateTo(
                                        _scrollController
                                            .position.maxScrollExtent,
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.easeOut,
                                      );
                                      controller.clear();
                                    }
                                  },
                                  icon: const FaIcon(
                                      FontAwesomeIcons.paperPlane))),
                        ),
                      )),
                      IconButton(
                          onPressed: () =>
                              itemsProvider.toggleOne('pickimgtype'),
                          icon: const FaIcon(FontAwesomeIcons.image)),
                      TweenAnimationBuilder(
                        tween: Tween(
                            begin: 1.0, end: items['record']! ? 1.4 : 1.0),
                        duration: Duration(microseconds: 300),
                        curve: Curves.bounceOut,
                        builder: (context, value, child) {
                          return Transform.scale(
                              scale: value,
                              child: Transform.translate(
                                  offset:
                                      Offset(0, items['record']! ? -20.0 : 0.0),
                                  child: child));
                        },
                        child: GestureDetector(
                          onLongPress: () async {
                            itemsProvider.toggleOne('record');
                            var a = await startrecorder(recorder);
                            if (a != null) {
                              await apiPost(
                                  api: "/api/app/send-message/${reciver.id}",
                                  fields: {
                                    "type": "Audio",
                                  },
                                  files: [
                                    {
                                      1: {"Audio": a}
                                    }
                                  ]);
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: Duration(milliseconds: 300),
                                curve: Curves.easeOut,
                              );
                            } else {
                              print("Emptyyyyyyyyyyyyyyy");
                            }
                          },
                          onLongPressUp: () async {
                            await stoprecorder(recorder);
                            itemsProvider.toggleOne('record');

                            bool recording = await isRecording(recorder);
                            if (!recording) {
                              print('Recording has stopped.');
                            } else {
                              print('Recording is still ongoing.');
                            }
                          },
                          child: IconButton(
                              onPressed: () async {},
                              icon: FaIcon(
                                FontAwesomeIcons.microphoneLines,
                                color: items['record']!
                                    ? Colors.green
                                    : Colors.black,
                              )),
                        ),
                      ),
                    ],
                  )
                ]),
                TweenAnimationBuilder(
                  tween: Tween(
                      begin: -1000.0,
                      end: items['pickimgtype']! ? 70.0 : -1000.0),
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.bounceOut,
                  builder: (context, value, child) {
                    return Positioned(
                        bottom: value,
                        left: 50,
                        child: DecoratedBox(
                          decoration: BoxDecoration(color: Colors.orange[100]),
                          child: Column(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    XFile? camimage = await pickImageCamera();

                                    if (camimage != null) {
                                      itemsProvider.toggleOne('wait');

                                      await apiPost(
                                          api:
                                              "/api/app/send-message/${reciver.id}",
                                          fields: {
                                            "type": "image",
                                          },
                                          files: [
                                            {
                                              1: {"image": camimage.path}
                                            }
                                          ]);
                                      itemsProvider.toggleOne('wait');
                                    }
                                    itemsProvider.toggleOne('pickimgtype');
                                  },
                                  icon: const FaIcon(FontAwesomeIcons.camera)),
                              const SizedBox(height: 20),
                              IconButton(
                                  onPressed: () async {
                                    itemsProvider.toggleOne('pickimgtype');
                                    itemsProvider.toggleOne('wait');

                                    List<PlatformFile>? t =
                                        await pickfilFunc(multifiles: true);
                                    if (t != null) {
                                      for (var i in t) {
                                        await apiPost(
                                            api:
                                                "/api/app/send-message/${reciver.id}",
                                            fields: {
                                              "type": "image",
                                            },
                                            files: [
                                              {
                                                1: {"image": i.path}
                                              }
                                            ]);
                                      }
                                    }
                                    itemsProvider.toggleOne('wait');
                                  },
                                  icon: const FaIcon(FontAwesomeIcons.images))
                            ],
                          ),
                        ));
                  },
                )
              ]),
            ))));
  }
}
