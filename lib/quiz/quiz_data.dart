class QuizConfig {
  final int id;
  final String question;
  final List<String> options;
  final int correctIndex;
  
  // Konfigurasi Kesulitan
  final int durationSeconds; // Waktu normal (detik)
  final int baseScore; // Poin maksimal jika tepat waktu

  QuizConfig({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.durationSeconds,
    required this.baseScore,
  });
}

class QuizData {
  static List<QuizConfig> getLevels() {
    return [
      // LEVEL 1-5 (MUDAH): Waktu 30s, Poin 15
      QuizConfig(
        id: 1,
        question: "Apa singkatan dari CPU?",
        options: ["Central Processing Unit", "Computer Personal Unit", "Central Personal Unit", "Control Panel Unit"],
        correctIndex: 0,
        durationSeconds: 30,
        baseScore: 15,
      ),
      QuizConfig(
        id: 2,
        question: "Manakah yang merupakan bahasa pemrograman?",
        options: ["HTML", "Python", "CSS", "HTTP"],
        correctIndex: 1,
        durationSeconds: 30,
        baseScore: 15,
      ),

      // LEVEL 6-10 (SEDANG): Waktu 45s, Poin 20
      QuizConfig(
        id: 3, // Anggap ini level 6 dst
        question: "Apa output dari print(10 % 3)?",
        options: ["3", "1", "3.33", "10"],
        correctIndex: 1,
        durationSeconds: 45,
        baseScore: 20,
      ),

      // LEVEL 11+ (SULIT): Waktu 60s, Poin 25
      QuizConfig(
        id: 4, // Anggap ini level sulit
        question: "Kompleksitas algoritma Binary Search adalah?",
        options: ["O(n)", "O(n^2)", "O(log n)", "O(1)"],
        correctIndex: 2,
        durationSeconds: 60,
        baseScore: 25,
      ),
    ];
  }
}