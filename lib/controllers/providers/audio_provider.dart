
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';

class ARModel {
  AudioRecorder recorder = AudioRecorder();
  AudioPlayer player = AudioPlayer();
  String? filePath;
  ARModel({
    required this.recorder,
    required this.player,
    required this.filePath,
  });
}

class ARProvider extends ChangeNotifier {
  ARModel _armodel = ARModel(
    recorder: AudioRecorder(),
    player: AudioPlayer(),
    filePath: '',
  );
}
