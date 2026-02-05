import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'dart:async'; 

class AudioManager {
  // --- SINGLETON PATTERN ---
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // Timer "Pendeteksi" (Watchdog) agar BGM tidak mati sendiri
  Timer? _bgmWatchdog;

  // Status user: Apakah user ingin musik menyala?
  bool _isBgmActive = true; 

  // Volume Config
  static const double _bgmNormalVolume = 0.75;  // Volume normal
  static const double _bgmDuckingVolume = 0.10; // Volume saat SFX bunyi

  AudioManager._internal();

  // ==========================================================
  // 1. INITIALIZATION (Panggil ini di main.dart)
  // ==========================================================
  Future<void> init() async {
    try {
      // Setup Audio Context (Agar tidak dimatikan OS sembarangan)
      final AudioContext audioContext = AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music,
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.none, 
        ),
      );
      await AudioPlayer.global.setAudioContext(audioContext);

      // Setup Players
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop); // BGM Loop
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop); // SFX Stop after play

      // [PENTING] Listener dipasang DISINI, bukan di dalam fungsi playSfx
      // Agar tidak terjadi memory leak (listener ganda)
      _sfxPlayer.onPlayerComplete.listen((event) {
        if (_isBgmActive) {
           // Kembalikan volume BGM ke normal setelah SFX selesai
           _bgmPlayer.setVolume(_bgmNormalVolume);
        }
      });

      // Jalankan Watchdog
      _startBgmWatchdog();

    } catch (e) {
      debugPrint("Error init audio: $e");
    }
  }

  // ==========================================================
  // 2. WATCHDOG (Penjaga BGM)
  // ==========================================================
  void _startBgmWatchdog() {
    _bgmWatchdog?.cancel();
    _bgmWatchdog = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Jika user mau BGM nyala, tapi player sedang mati/stop, dan SFX juga diam
      if (_isBgmActive) {
        bool sfxIsSilent = _sfxPlayer.state != PlayerState.playing;
        bool bgmIsDead = _bgmPlayer.state != PlayerState.playing;

        if (sfxIsSilent && bgmIsDead) {
          debugPrint("WATCHDOG: Menghidupkan kembali BGM...");
          await _bgmPlayer.setVolume(_bgmNormalVolume);
          // Gunakan resume jika paused, atau play ulang jika stopped
          if (_bgmPlayer.state == PlayerState.paused) {
            await _bgmPlayer.resume();
          } else {
            await _bgmPlayer.play(AssetSource('sound/soundtrack1.mp3'));
          }
        }
      }
    });
  }

  // ==========================================================
  // 3. KONTROL BGM UTAMA
  // ==========================================================
  Future<void> startBackgroundMusic() async {
    _isBgmActive = true; 
    if (_bgmPlayer.state == PlayerState.playing) return;

    try {
      await _bgmPlayer.setVolume(_bgmNormalVolume);
      await _bgmPlayer.play(AssetSource('sound/soundtrack1.mp3'));
    } catch (e) {
      debugPrint("Gagal start BGM: $e");
    }
  }

  Future<void> stopBackgroundMusic() async {
    _isBgmActive = false;
    await _bgmPlayer.stop();
  }

  // Helper untuk Lifecycle (saat minimize app)
  Future<void> pauseBGM() async {
    await _bgmPlayer.pause();
  }

  Future<void> resumeBGM() async {
    if (_isBgmActive) {
      await _bgmPlayer.resume();
    }
  }

  // ==========================================================
  // 4. LOGIKA SFX (EFEK SUARA)
  // ==========================================================
  Future<void> _playSfx(String fileName) async {
    try {
      // 1. Kecilkan BGM (Ducking)
      if (_isBgmActive && _bgmPlayer.state == PlayerState.playing) {
        await _bgmPlayer.setVolume(_bgmDuckingVolume);
      }

      // 2. Stop SFX sebelumnya jika ada (agar tidak tumpang tindih)
      if (_sfxPlayer.state == PlayerState.playing) {
        await _sfxPlayer.stop();
      }
      
      // 3. Mainkan SFX baru
      await _sfxPlayer.play(AssetSource('sound/$fileName'), volume: 1.0);

      // Note: Pengembalian volume BGM ditangani oleh listener di init()

    } catch (e) {
      debugPrint("Error SFX: $e");
    }
  }

  // ==========================================================
  // 5. SHORTCUT SFX
  // ==========================================================
  Future<void> playMateriComplete() async => await _playSfx('materi_done.mp3');
  Future<void> playLatihanCorrect() async => await _playSfx('latihan_done.mp3'); // Sesuaikan nama file: correct.mp3 atau latihan_done.mp3
  Future<void> playWrong() async => await _playSfx('wrong.mp3');
  Future<void> playGameOver() async => await _playSfx('game_over.mp3');

  void dispose() {
    _bgmWatchdog?.cancel();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }
}