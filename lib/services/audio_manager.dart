import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';
import 'dart:async'; 

class AudioManager {
  // Singleton Pattern
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();

  // Timer "Pendeteksi" (Watchdog)
  Timer? _bgmWatchdog;

  // Variabel Niat: Apakah user ingin musik menyala?
  bool _isBgmActive = false;

  // Volume
  static const double _bgmNormalVolume = 0.50;
  static const double _bgmDuckingVolume = 0.10; 

  AudioManager._internal() {
    _initAudioSettings();
    _startBgmWatchdog(); // Jalankan pendeteksi otomatis sejak awal
  }

  // ==========================================================
  // 1. SETUP AUDIO CONTEXT (Supaya tidak dimatikan Android)
  // ==========================================================
  Future<void> _initAudioSettings() async {
    try {
      // Pastikan mode release benar
      await _sfxPlayer.setReleaseMode(ReleaseMode.stop);
      await _bgmPlayer.setReleaseMode(ReleaseMode.loop);

      final AudioContext audioContext = AudioContext(
        iOS: AudioContextIOS(
          category: AVAudioSessionCategory.ambient,
          options: {AVAudioSessionOptions.mixWithOthers},
        ),
        android: AudioContextAndroid(
          isSpeakerphoneOn: true,
          stayAwake: true,
          contentType: AndroidContentType.music, // Pakai music biar prioritas tinggi
          usageType: AndroidUsageType.media,
          audioFocus: AndroidAudioFocus.none, // PENTING: Jangan biarkan Android atur fokus
        ),
      );

      await AudioPlayer.global.setAudioContext(audioContext);
    } catch (e) {
      debugPrint("Error init settings: $e");
    }
  }

  // ==========================================================
  // 2. WATCHDOG (PENDETEKSI OTOMATIS) - FITUR BARU 🛠️
  // ==========================================================
  void _startBgmWatchdog() {
    // Cek setiap 2 detik
    _bgmWatchdog?.cancel();
    _bgmWatchdog = Timer.periodic(const Duration(seconds: 2), (timer) async {
      // Syarat BGM harus dipaksa nyala kembali:
      // 1. User memang mengaktifkan musik (_isBgmActive == true)
      // 2. SFX sedang TIDAK bunyi (state != playing)
      // 3. BGM ternyata sedang MATI (state != playing)
      
      if (_isBgmActive) {
        bool sfxIsSilent = _sfxPlayer.state != PlayerState.playing;
        bool bgmIsDead = _bgmPlayer.state != PlayerState.playing;

        if (sfxIsSilent && bgmIsDead) {
          debugPrint("WATCHDOG: BGM mati padahal harusnya nyala. Memaksa Resume...");
          // Kita pakai play() ulang, bukan resume(), agar lebih ampuh me-reload file
          await _bgmPlayer.setVolume(_bgmNormalVolume);
          await _bgmPlayer.play(AssetSource('sound/soundtrack1.mp3'));
        }
      }
    });
  }

  // ==========================================================
  // 3. LOGIKA BGM
  // ==========================================================
  Future<void> startBackgroundMusic() async {
    _isBgmActive = true; // Tandai user mau musik nyala

    if (_bgmPlayer.state == PlayerState.playing) return;

    try {
      await _bgmPlayer.setVolume(_bgmNormalVolume);
      await _bgmPlayer.play(AssetSource('sound/soundtrack1.mp3'));
    } catch (e) {
      debugPrint("Gagal start BGM: $e");
    }
  }

  Future<void> stopBackgroundMusic() async {
    _isBgmActive = false; // Tandai user mau musik mati
    await _bgmPlayer.stop();
  }

  // ==========================================================
  // 4. LOGIKA SFX (Dengan Safety Net)
  // ==========================================================
  Future<void> _playSfx(String fileName) async {
    try {
      // A. Kecilkan BGM (Ducking)
      if (_isBgmActive && _bgmPlayer.state == PlayerState.playing) {
        await _bgmPlayer.setVolume(_bgmDuckingVolume);
      }

      // B. Mainkan SFX
      if (_sfxPlayer.state == PlayerState.playing) {
        await _sfxPlayer.stop();
      }
      
      await _sfxPlayer.play(
        AssetSource('sound/$fileName'),
        volume: 1.0, 
        // Hapus mode lowLatency jika bikin crash, tapi kalau aman biarkan saja
        // mode: PlayerMode.lowLatency, 
      );

      // C. Listener Manual (Plan A)
      // Kita tetap pasang listener ini untuk respon cepat
      _sfxPlayer.onPlayerComplete.listen((event) {
        if (_isBgmActive) {
           _bgmPlayer.setVolume(_bgmNormalVolume);
           if (_bgmPlayer.state != PlayerState.playing) {
             _bgmPlayer.resume();
           }
        }
      });

      // CATATAN:
      // Jika Listener di atas (Plan A) gagal jalan karena bug library/OS,
      // "Watchdog" (Plan B) di atas akan mengambil alih dalam waktu max 2 detik
      // untuk menyalakan musik lagi.

    } catch (e) {
      debugPrint("Error SFX: $e");
    }
  }

  // ==========================================================
  // 5. HELPER LAIN
  // ==========================================================
  // Panggil ini jika aplikasi ditutup total (opsional, untuk bersih-bersih memory)
  void dispose() {
    _bgmWatchdog?.cancel();
    _bgmPlayer.dispose();
    _sfxPlayer.dispose();
  }

  Future<void> playMateriComplete() async => await _playSfx('materi_done.mp3');
  Future<void> playLatihanCorrect() async => await _playSfx('latihan_done.mp3');
  Future<void> playWrong() async => await _playSfx('wrong.mp3');
  Future<void> playGameOver() async => await _playSfx('game_over.mp3');
}