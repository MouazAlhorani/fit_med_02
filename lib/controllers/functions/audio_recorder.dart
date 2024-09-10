import 'dart:async';

import 'package:record/record.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart' as dt;

class ARModel {
  AudioRecorder recorder;
  bool status;
  String? filepath;
  ARModel({
    required this.recorder,
    required this.status,
    required this.filepath,
  });
}

startrecorder(AudioRecorder recorder) async {
  Directory appDir = await getApplicationDocumentsDirectory();
  Directory recordDir = Directory('${appDir.path}/chats/records');
  if (!await recordDir.exists()) {
    await recordDir.create(recursive: true);
  }
  var filepath =
      "${recordDir.path}/me__${dt.DateFormat('yyyy_MM_dd_HH_mm_ss').format(DateTime.now())}_aa.aac";
  await recorder.start(const RecordConfig(), path: filepath);

  return filepath;
}

stoprecorder(AudioRecorder recorder) async {
  await recorder.stop();
  // recorder.dispose();
}

Future<bool> isRecording(AudioRecorder recorder) async {
  return await recorder.isRecording();
}

cancle() async {}
