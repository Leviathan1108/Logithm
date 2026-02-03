import 'package:flutter/material.dart';
import '../services/progress_manager.dart';

class GlobalData {
  static ValueNotifier<Set<int>> get completedModules => ProgressManager.completedMateri;
  static ValueNotifier<int> get totalScore => ProgressManager.totalScore;

  // Cek apakah materi ini sudah pernah dikerjakan?
  static bool isMateriCompleted(int id) {
    return completedModules.value.contains(id);
  }

  // Menandai selesai (tanpa tambah poin manual, karena poin dihitung dinamis di latihan)
  static Future<void> markAsComplete(int id) async {
    await ProgressManager.markAsComplete(id);
  }

  // Tambah Poin
  static void addScore(int points) {  
    ProgressManager.addScore(points);
  }

  // Hitung pengurangan poin (Logic: Kurang 2, minimal 0)
  static int calculatePenalty(int currentScore) {
    int newScore = currentScore - 2;
    return newScore < 0 ? 0 : newScore;
  }
}