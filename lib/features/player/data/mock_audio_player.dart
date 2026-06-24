import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final mockAudioPlayerProvider = StateNotifierProvider<MockAudioPlayer, PlaybackState>((ref) {
  final player = MockAudioPlayer(durationMs: 6400);
  return player;
});

class MockAudioPlayer extends StateNotifier<PlaybackState> {
  MockAudioPlayer({required int durationMs})
      : super(PlaybackState(durationMs: durationMs));

  Timer? _timer;

  void play() {
    state = state.copyWith(isPlaying: true);
    _timer ??= Timer.periodic(const Duration(milliseconds: 100), (_) {
      final next = state.positionMs + 100;
      if (next >= state.durationMs) {
        pause();
        seek(0);
      } else {
        state = state.copyWith(positionMs: next);
      }
    });
  }

  void pause() {
    _timer?.cancel();
    _timer = null;
    state = state.copyWith(isPlaying: false);
  }

  void toggle() => state.isPlaying ? pause() : play();

  void seek(int positionMs) {
    state = state.copyWith(positionMs: positionMs.clamp(0, state.durationMs));
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class PlaybackState {
  const PlaybackState({
    this.positionMs = 0,
    this.durationMs = 0,
    this.isPlaying = false,
  });

  final int positionMs;
  final int durationMs;
  final bool isPlaying;

  PlaybackState copyWith({
    int? positionMs,
    int? durationMs,
    bool? isPlaying,
  }) {
    return PlaybackState(
      positionMs: positionMs ?? this.positionMs,
      durationMs: durationMs ?? this.durationMs,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}
