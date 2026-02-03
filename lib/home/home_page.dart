import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:badges/badges.dart' as badges;
import 'package:shared_preferences/shared_preferences.dart'; // [WAJIB]
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart'; // [WAJIB]

// --- IMPORT WIDGETS ---
import '../../widgets/custom_bottom_bar.dart';
import '../../widgets/custom_avatar.dart';

// --- IMPORT SERVICES ---
import '../services/auth_manager.dart';
import '../services/progress_manager.dart';
import '../services/notification_manager.dart';

// --- IMPORT PAGES ---
import '../belajar/belajar_page.dart';
import '../belajar/materi_list_page.dart';
import '../quiz/quiz_page.dart';
import '../leaderboard/leaderboard_page.dart';
import '../profile/profile_page.dart';
import '../auth/login_page.dart';
import '../points/points_page.dart'; 
import 'notification_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentBottomNavIndex = 0;
  final AuthManager _auth = AuthManager();
  
  Stream<List<Map<String, dynamic>>>? _profileStream;
  late final StreamSubscription<AuthState> _authSubscription;
  Timer? _presenceTimer;

  // [GLOBAL KEYS]
  final GlobalKey _keyHeader = GlobalKey();
  final GlobalKey _keyProgress = GlobalKey();
  final GlobalKey _keyActionBelajar = GlobalKey();
  final GlobalKey _keyActionQuiz = GlobalKey();

  // [TUTORIAL VARIABLE]
  late TutorialCoachMark _tutorialCoachMark;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    
    NotificationManager().init();
    _refreshData(); 
    
    _authSubscription = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final AuthChangeEvent event = data.event;
      if (event == AuthChangeEvent.signedIn || event == AuthChangeEvent.signedOut) {
        _refreshData();
      }
    });

    _presenceTimer = Timer.periodic(const Duration(minutes: 2), (timer) {
      _heartbeat();
    });

    // [TUTORIAL CHECK]
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndShowTutorial();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _presenceTimer?.cancel();
    _authSubscription.cancel(); 
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _refreshData();
    }
  }

  // --- LOGIKA TUTORIAL (DIPERBAIKI) ---
  Future<void> _checkAndShowTutorial() async {
    final prefs = await SharedPreferences.getInstance();
    bool hasShown = prefs.getBool('has_shown_home_tutorial') ?? false;

    if (!hasShown) {
      _createTutorial();
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) _tutorialCoachMark.show(context: context);
      });
    }
  }

  void _createTutorial() {
    _tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      textSkip: "LEWATI",
      paddingFocus: 5, // Padding dikurangi agar lebih pas
      opacityShadow: 0.85,
      onFinish: () => _markTutorialAsShown(),
      onSkip: () {
        _markTutorialAsShown();
        return true;
      },
    );
  }

  Future<void> _markTutorialAsShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_shown_home_tutorial', true);
  }

  // [PERBAIKAN UTAMA ADA DI SINI]
  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];

    // 1. Profil (Header)
    targets.add(TargetFocus(
      identify: "Header",
      keyTarget: _keyHeader,
      alignSkip: Alignment.bottomLeft,
      // Gunakan RRect (Kotak Melengkung) bukan Lingkaran
      shape: ShapeLightFocus.RRect, 
      radius: 15,
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Halo! 👋", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                SizedBox(height: 10),
                Text("Ini adalah profilmu. Ketuk di sini untuk mengubah avatar atau melihat notifikasi pesan.", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            );
          },
        )
      ],
    ));

    // 2. Progress
    targets.add(TargetFocus(
      identify: "Progress",
      keyTarget: _keyProgress,
      // Gunakan RRect agar pas dengan bentuk kartu
      shape: ShapeLightFocus.RRect,
      radius: 24, // Sesuaikan dengan borderRadius widget asli (24)
      contents: [
        TargetContent(
          align: ContentAlign.bottom,
          builder: (context, controller) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pantau Progres 📈", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                SizedBox(height: 10),
                Text("Lihat total skor poin dan persentase materi yang sudah kamu selesaikan di sini.", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            );
          },
        )
      ],
    ));

    // 3. Belajar
    targets.add(TargetFocus(
      identify: "Belajar",
      keyTarget: _keyActionBelajar,
      // Gunakan RRect agar pas dengan bentuk kartu
      shape: ShapeLightFocus.RRect,
      radius: 16, // Sesuaikan dengan borderRadius widget asli (16)
      contents: [
        TargetContent(
          align: ContentAlign.top,
          builder: (context, controller) {
            return const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Mulai Belajar 🚀", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                SizedBox(height: 10),
                Text("Ketuk kartu ini untuk masuk ke materi pembelajaran dan melanjutkan levelmu.", style: TextStyle(color: Colors.white, fontSize: 16)),
              ],
            );
          },
        )
      ],
    ));

    return targets;
  }
  // -------------------------------------

  void _initStream() {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      setState(() {
        _profileStream = Supabase.instance.client
            .from('profiles')
            .stream(primaryKey: ['id'])
            .eq('id', userId);
      });
    } else {
      setState(() {
        _profileStream = null;
      });
    }
  }

  Future<void> _heartbeat() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId != null) {
      try {
        await Supabase.instance.client
            .from('profiles')
            .update({'last_active': DateTime.now().toIso8601String()})
            .eq('id', userId);
      } catch (_) {}
    }
  }

  Future<void> _refreshData() async {
    await AuthManager().init();
    await ProgressManager.init();
    _initStream();
    HapticFeedback.mediumImpact();
    if (mounted) setState(() {});
  }

  void _navigateTo(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    _refreshData(); 
  }

  void _handleBottomNavTap(int index) {
    setState(() => _currentBottomNavIndex = index);
    switch (index) {
      case 0: break; 
      case 1: 
        _navigateTo(const MateriListPage());
        setState(() => _currentBottomNavIndex = 0);
        break;
      case 2: 
        _navigateTo(const LeaderboardPage());
        setState(() => _currentBottomNavIndex = 0);
        break;
      case 3: 
        if (_auth.currentUserType == UserType.guest) {
          _showGuestLockDialog();
          setState(() => _currentBottomNavIndex = 0);
        } else {
          _navigateTo(const QuizPage());
          setState(() => _currentBottomNavIndex = 0);
        }
        break;
      case 4: 
        _navigateTo(const ProfilePage());
        setState(() => _currentBottomNavIndex = 0);
        break;
    }
  }

  void _showGuestLockDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Fitur Terkunci 🔒"),
        content: const Text("Mode Tamu tidak bisa mengakses Quiz.\nSilakan Login terlebih dahulu."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Nanti")),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _navigateTo(const LoginPage());
            },
            child: const Text("Login"),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: _buildHomeContent(), 
      bottomNavigationBar: CustomBottomBar(
        currentIndex: _currentBottomNavIndex,
        onTap: _handleBottomNavTap,
        showMapBadge: false,
        showQuizBadge: true,
      ),
    );
  }

  Widget _buildHomeContent() {
    final bool isGuest = _auth.currentUserType == UserType.guest;

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _refreshData,
        color: Theme.of(context).colorScheme.primary,
        
        child: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _profileStream ?? Stream.value([]), 
          builder: (context, snapshot) {
            
            int totalScore = ProgressManager.totalScore.value; 
            String avatarData = 'foto1.png'; 
            int avatarColorIndex = 3; 

            if (!isGuest && snapshot.hasData && snapshot.data!.isNotEmpty) {
              final data = snapshot.data!.first;
              totalScore = data['total_score'] ?? 0;
              avatarData = data['avatar_data'] ?? 'foto1.png';
              avatarColorIndex = data['avatar_color_index'] ?? 3;
              
              WidgetsBinding.instance.addPostFrameCallback((_) {
                 if (ProgressManager.totalScore.value != totalScore) {
                   ProgressManager.totalScore.value = totalScore;
                 }
              });
            } else if (isGuest) {
              totalScore = ProgressManager.totalScore.value;
            }

            return ValueListenableBuilder<Set<int>>(
              valueListenable: ProgressManager.completedMateri,
              builder: (context, completedIds, _) {
                int levelsCompleted = completedIds.length;
                int totalLevels = 20;

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // 1. HEADER (KEY DITAMBAHKAN)
                    SliverToBoxAdapter(
                      child: Container(
                        key: _keyHeader, // <--- KEY UNTUK TUTORIAL
                        child: GreetingHeaderWidget(
                          userName: _auth.username,
                          isGuest: isGuest,
                          avatarData: avatarData, 
                          avatarColorIndex: avatarColorIndex, 
                          onTap: () => _navigateTo(const ProfilePage()), 
                        ),
                      ),
                    ),

                    // 2. PROGRESS (KEY DITAMBAHKAN)
                    SliverToBoxAdapter(
                      child: Container(
                        key: _keyProgress, // <--- KEY UNTUK TUTORIAL
                        child: ProgressSummaryWidget(
                          levelsCompleted: levelsCompleted,
                          totalLevels: totalLevels,
                          totalScore: totalScore,
                          currentStreak: 0,
                          onTap: () => _navigateTo(const MateriListPage()), 
                        ),
                      ),
                    ),

                    // 3. TITLE
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 1.h),
                        child: Text(
                          'Aksi Cepat',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ),
                    ),

                    // 4. ACTION CARDS (KEY DITAMBAHKAN)
                    SliverToBoxAdapter(
                      child: Container(
                        key: _keyActionBelajar, // <--- KEY UNTUK TUTORIAL
                        child: ActionCardWidget(
                          title: 'Lanjut Belajar',
                          subtitle: 'Level ${levelsCompleted + 1}',
                          iconName: Icons.play_circle_filled,
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          iconColor: Theme.of(context).colorScheme.primary,
                          progress: levelsCompleted / totalLevels,
                          onTap: () => _navigateTo(const BelajarPage()),
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: Container(
                        key: _keyActionQuiz, // (Opsional)
                        child: ActionCardWidget(
                          title: 'Ikuti Quiz',
                          subtitle: isGuest ? 'Butuh Login' : 'Dapatkan Poin',
                          iconName: isGuest ? Icons.lock : Icons.quiz,
                          backgroundColor: Theme.of(context).colorScheme.secondary,
                          iconColor: Theme.of(context).colorScheme.secondary,
                          onTap: () {
                            if (isGuest) _showGuestLockDialog();
                            else _navigateTo(const QuizPage());
                          },
                        ),
                      ),
                    ),

                    SliverToBoxAdapter(
                      child: ActionCardWidget(
                        title: 'Lihat Peringkat',
                        subtitle: 'Top Players',
                        iconName: Icons.leaderboard,
                        backgroundColor: Colors.purple,
                        iconColor: Colors.purple,
                        onTap: () => _navigateTo(const LeaderboardPage()),
                      ),
                    ),

                    if (isGuest)
                      SliverToBoxAdapter(
                        child: GuestInvitationWidget(
                          onSignUpTap: () => _navigateTo(const LoginPage()),
                        ),
                      ),

                    // 5. QUICK STATS 
                    SliverToBoxAdapter(
                      child: QuickStatsWidget(
                        levelsCompleted: levelsCompleted,
                        totalPoints: totalScore, 
                        onLevelTap: () => _navigateTo(const MateriListPage()),
                        onPointsTap: () => _navigateTo(const PointsPage()), 
                      ),
                    ),

                    SliverToBoxAdapter(child: SizedBox(height: 2.h)),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

// ... Widget Pendukung (GreetingHeaderWidget, dll) Tetap Sama ...
// ... (Sisa kode Anda aman, cukup copy sampai _buildHomeContent berakhir) ...
// --- WIDGETS PENDUKUNG (TIDAK BERUBAH) ---

class GreetingHeaderWidget extends StatelessWidget {
  final String userName;
  final bool isGuest;
  final String avatarData;
  final int avatarColorIndex;
  final VoidCallback onTap;

  const GreetingHeaderWidget({
    super.key,
    required this.userName,
    required this.isGuest,
    this.avatarData = 'foto1.png',
    this.avatarColorIndex = 3,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(4.w, 2.h, 4.w, 2.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: onTap,
            child: CustomAvatar(
              avatarData: avatarData,
              colorIndex: avatarColorIndex,
              radius: 28,
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Selamat datang kembali,',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    userName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          
          if (!isGuest)
            ValueListenableBuilder<int>(
              valueListenable: NotificationManager().unreadCount,
              builder: (context, count, child) {
                return badges.Badge(
                  position: badges.BadgePosition.topEnd(top: -5, end: -2),
                  showBadge: count > 0,
                  badgeContent: const Text(
                    '', 
                    style: TextStyle(color: Colors.white, fontSize: 8),
                  ),
                  badgeStyle: const badges.BadgeStyle(
                    badgeColor: Colors.redAccent,
                    padding: EdgeInsets.all(5),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                         BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)
                      ]
                    ),
                    child: IconButton(
                      icon: Icon(
                        count > 0 ? Icons.mark_email_unread_outlined : Icons.mail_outline, 
                        color: count > 0 ? theme.colorScheme.primary : Colors.grey,
                        size: 26,
                      ),
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (c) => const NotificationPage()));
                      },
                    ),
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

class ProgressSummaryWidget extends StatelessWidget {
  final int levelsCompleted;
  final int totalLevels;
  final int totalScore;
  final int currentStreak;
  final VoidCallback onTap;

  const ProgressSummaryWidget({
    super.key,
    required this.levelsCompleted,
    required this.totalLevels,
    required this.totalScore,
    required this.currentStreak,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double progress = levelsCompleted / totalLevels;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withValues(alpha: 0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Skor',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$totalScore',
                      style: theme.textTheme.displaySmall?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(Icons.emoji_events, color: theme.colorScheme.onPrimary, size: 32),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Progres Materi',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                  ),
                ),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(theme.colorScheme.onPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCardWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconName;
  final Color backgroundColor;
  final Color iconColor;
  final VoidCallback onTap;
  final double? progress;

  const ActionCardWidget({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconName,
    required this.backgroundColor,
    required this.iconColor,
    required this.onTap,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: backgroundColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconName, color: iconColor),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                      if (progress != null) ...[
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 4,
                            backgroundColor: theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation(iconColor),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GuestInvitationWidget extends StatelessWidget {
  final VoidCallback onSignUpTap;
  const GuestInvitationWidget({super.key, required this.onSignUpTap});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.tertiaryContainer.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.tertiary.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.cloud_off, color: theme.colorScheme.tertiary),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  "Jangan sampai progres hilang!",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.onTertiaryContainer,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            "Buat akun untuk menyimpan skor dan akses semua fitur.",
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onTertiaryContainer),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton.tonal(
              onPressed: onSignUpTap,
              style: FilledButton.styleFrom(
                backgroundColor: theme.colorScheme.tertiary,
                foregroundColor: theme.colorScheme.onTertiary,
              ),
              child: const Text("Daftar Sekarang"),
            ),
          ),
        ],
      ),
    );
  }
}

class QuickStatsWidget extends StatelessWidget {
  final int levelsCompleted;
  final int totalPoints;
  final VoidCallback onLevelTap;
  final VoidCallback onPointsTap;

  const QuickStatsWidget({
    super.key,
    required this.levelsCompleted,
    required this.totalPoints,
    required this.onLevelTap,
    required this.onPointsTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: InkWell(
              onTap: onLevelTap,
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _buildStat(context, Icons.check_circle_outline, '$levelsCompleted', 'Levels'),
              ),
            ),
          ),
          Container(height: 40, width: 1, color: theme.colorScheme.outlineVariant),
          Expanded(
            child: InkWell(
              onTap: () {
                 ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Fitur Streak akan segera hadir!")));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _buildStat(context, Icons.local_fire_department_outlined, '0', 'Streak'),
              ),
            ),
          ),
          Container(height: 40, width: 1, color: theme.colorScheme.outlineVariant),
          Expanded(
            child: InkWell(
              onTap: onPointsTap,
              borderRadius: const BorderRadius.horizontal(right: Radius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: _buildStat(context, Icons.star_outline, '$totalPoints', 'Poin'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(BuildContext context, IconData icon, String value, String label) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(height: 4),
        Text(value, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
      ],
    );
  }
}