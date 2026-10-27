import 'dart:async';
import 'dart:io';
import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class HighgradeMobileApp extends StatelessWidget {
  const HighgradeMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(useMaterial3: true, brightness: Brightness.light);
    return MaterialApp(
      title: 'Highgrade Fitness',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        scaffoldBackgroundColor: HGColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: HGColors.red,
          primary: HGColors.red,
          secondary: HGColors.black,
          surface: Colors.white,
          error: HGColors.redDark,
        ),
        textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
          bodyColor: HGColors.ink,
          displayColor: HGColors.ink,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: HGColors.ink,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: HGColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: HGColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: HGColors.red, width: 1.4),
          ),
        ),
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: HGColors.red,
            foregroundColor: Colors.white,
            minimumSize: const Size(52, 52),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: HGColors.ink,
            side: const BorderSide(color: HGColors.border),
            minimumSize: const Size(52, 52),
            textStyle: const TextStyle(fontWeight: FontWeight.w800),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
      ),
      home: const AuthGate(),
    );
  }
}

class HGColors {
  static const red = Color(0xFFE9282B);
  static const redDark = Color(0xFFB8161B);
  static const black = Color(0xFF07090D);
  static const ink = Color(0xFF111827);
  static const muted = Color(0xFF64748B);
  static const background = Color(0xFFF7F8FA);
  static const border = Color(0xFFE6E9EF);
  static const green = Color(0xFF16A34A);
  static const blue = Color(0xFF2563EB);
  static const amber = Color(0xFFF59E0B);
}

class DemoUser {
  const DemoUser({
    required this.name,
    required this.email,
    required this.phone,
    required this.goal,
    required this.heightCm,
    required this.weightKg,
  });

  final String name;
  final String email;
  final String phone;
  final String goal;
  final double heightCm;
  final double weightKg;

  double get bmi => weightKg / math.pow(heightCm / 100, 2);
}

enum AppRole { user, admin }

class DemoMealLog {
  DemoMealLog({
    required this.client,
    required this.meal,
    required this.food,
    required this.calories,
    required this.protein,
    this.carbs = 42,
    this.fat = 14,
    this.fiber = 8,
    this.status = 'Pending',
    this.reason = '',
  });

  final String client;
  final String meal;
  final String food;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  String status;
  String reason;
}

class DemoClient {
  DemoClient({
    required this.name,
    required this.goal,
    required this.weight,
    required this.goalWeight,
    required this.streak,
    required this.coach,
    this.verified = true,
    this.active = true,
  });

  final String name;
  final String goal;
  final double weight;
  final double goalWeight;
  final int streak;
  final String coach;
  bool verified;
  bool active;
}

class SocialEntry {
  SocialEntry({
    required this.type,
    required this.text,
    this.owner = 'Bhadri',
    this.mediaKind = 'photo',
    this.mediaPath,
    this.isAdmin = false,
  });
  final String type;
  final String text;
  final String owner;
  final String mediaKind;
  final String? mediaPath;
  final bool isAdmin;
}

class HighgradeStore extends ChangeNotifier {
  final clients = <DemoClient>[
    DemoClient(
        name: 'Bhadri',
        goal: 'Fat loss and strength',
        weight: 76,
        goalWeight: 68,
        streak: 18,
        coach: 'Manoj'),
    DemoClient(
        name: 'Priya S',
        goal: 'Muscle toning',
        weight: 62,
        goalWeight: 58,
        streak: 11,
        coach: 'Manoj'),
    DemoClient(
        name: 'Arun K',
        goal: 'Muscle gain',
        weight: 71,
        goalWeight: 78,
        streak: 6,
        coach: 'Manoj'),
  ];

  final meals = <DemoMealLog>[
    DemoMealLog(
        client: 'Bhadri',
        meal: 'Breakfast',
        food: 'Oats, egg whites, banana',
        calories: 520,
        protein: 38),
    DemoMealLog(
        client: 'Priya S',
        meal: 'Lunch',
        food: 'Chicken rice bowl',
        calories: 690,
        protein: 46),
    DemoMealLog(
        client: 'Arun K',
        meal: 'Dinner',
        food: 'Paneer salad and millet roti',
        calories: 540,
        protein: 32,
        status: 'Approved'),
  ];

  final posts = <SocialEntry>[
    SocialEntry(
        type: 'Admin Post',
        text: 'Coach Manoj: Hydration target updated for today.',
        owner: 'Coach Manoj',
        mediaKind: 'photo',
        isAdmin: true),
    SocialEntry(
        type: 'Post',
        text: 'Leg day done. New PR on squats.',
        owner: 'Bhadri',
        mediaKind: 'video'),
    SocialEntry(
        type: 'Post',
        text: 'Meal prep ready for the week.',
        owner: 'Priya S',
        mediaKind: 'photo'),
  ];

  final stories = <SocialEntry>[
    SocialEntry(
        type: 'Story',
        text: 'Morning cardio complete',
        owner: 'Bhadri',
        mediaKind: 'photo'),
    SocialEntry(
        type: 'Story',
        text: 'Coach Manoj posted today checks',
        owner: 'Coach Manoj',
        mediaKind: 'video',
        isAdmin: true),
  ];

  int get pendingMeals =>
      meals.where((meal) => meal.status == 'Pending').length;
  int get activeClients => clients.where((client) => client.active).length;
  int get approvedMeals =>
      meals.where((meal) => meal.status == 'Approved').length;

  void addMeal(String meal) {
    meals.insert(
      0,
      DemoMealLog(
        client: 'Bhadri',
        meal: meal,
        food: '$meal upload from mobile app',
        calories: 480,
        protein: 34,
      ),
    );
    notifyListeners();
  }

  void addRecipeMeal(String meal, Recipe recipe) {
    meals.insert(
      0,
      DemoMealLog(
        client: 'Bhadri',
        meal: meal,
        food: recipe.name,
        calories: recipe.calories,
        protein: recipe.protein,
        carbs: recipe.carbs,
        fat: recipe.fat,
        fiber: recipe.fiber,
      ),
    );
    notifyListeners();
  }

  void approveMeal(DemoMealLog meal) {
    meal.status = 'Approved';
    meal.reason = '';
    notifyListeners();
  }

  void rejectMeal(DemoMealLog meal) {
    meal.status = 'Rejected';
    meal.reason = 'Image unclear or calories mismatch. Upload again.';
    notifyListeners();
  }

  void addPost(
    String type, {
    String text = 'New update from Highgrade Socio.',
    String owner = 'Bhadri',
    String mediaKind = 'photo',
    String? mediaPath,
    bool isAdmin = false,
  }) {
    posts.insert(
        0,
        SocialEntry(
            type: type,
            text: text,
            owner: owner,
            mediaKind: mediaKind,
            mediaPath: mediaPath,
            isAdmin: isAdmin));
    notifyListeners();
  }

  void addStory({
    String text = 'Fresh story update from Highgrade.',
    String owner = 'Bhadri',
    String mediaKind = 'photo',
    String? mediaPath,
    bool isAdmin = false,
  }) {
    stories.insert(
        0,
        SocialEntry(
            type: 'Story',
            text: text,
            owner: owner,
            mediaKind: mediaKind,
            mediaPath: mediaPath,
            isAdmin: isAdmin));
    notifyListeners();
  }

  void createVerifiedClient(String name) {
    clients.insert(
      0,
      DemoClient(
        name: name,
        goal: 'New verified member',
        weight: 72,
        goalWeight: 66,
        streak: 0,
        coach: 'Manoj',
        verified: true,
        active: true,
      ),
    );
    notifyListeners();
  }

  void setClientActive(DemoClient client, bool active) {
    client.active = active;
    notifyListeners();
  }

  void deleteClient(DemoClient client) {
    clients.remove(client);
    notifyListeners();
  }
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  DemoUser? _user;
  AppRole _role = AppRole.user;
  final _store = HighgradeStore();

  void _signIn([String name = 'Bhadri', AppRole role = AppRole.user]) {
    setState(() {
      _role = role;
      _user = DemoUser(
        name: name,
        email: role == AppRole.admin
            ? 'manoj@highgradefitness.in'
            : 'bhadri@highgradefitness.in',
        phone: '+91 98765 43210',
        goal:
            role == AppRole.admin ? 'Monitor clients' : 'Fat loss and strength',
        heightCm: 174,
        weightKg: 76,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = _user;
    if (user == null) return AuthPage(onSignedIn: _signIn);
    if (_role == AppRole.admin) {
      return AdminShell(
          user: user,
          store: _store,
          onLogout: () => setState(() => _user = null));
    }
    return HomeShell(
        user: user,
        store: _store,
        onLogout: () => setState(() => _user = null));
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({required this.onSignedIn, super.key});

  final void Function([String name, AppRole role]) onSignedIn;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _email = TextEditingController(text: 'Bhadri');
  final _password = TextEditingController(text: 'Bhadri103');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    final identifier = _email.text.trim();
    final password = _password.text.trim();
    final normalized = identifier.toLowerCase();
    final isAdminAttempt = normalized == 'manoj' ||
        normalized.contains('admin') ||
        normalized.contains('manoj');
    final isMemberAttempt = normalized == 'bhadri' ||
        normalized.contains('bhadri') ||
        normalized.contains('member');

    if (isAdminAttempt && password == 'admin123') {
      widget.onSignedIn('Manoj', AppRole.admin);
      return;
    }
    if (isMemberAttempt && password == 'Bhadri103') {
      widget.onSignedIn('Bhadri', AppRole.user);
      return;
    }

    _toast(context, 'Invalid login or account is not verified by admin');
  }

  void _forgotPassword() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Forgot Password',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('A reset link will be sent to your email.',
                style: TextStyle(color: HGColors.muted)),
            const SizedBox(height: 18),
            TextField(
                controller: _email,
                decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 14),
            FilledButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Send Reset Link')),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(minHeight: constraints.maxHeight - 48),
                child: Center(
                  child: Container(
                    width: double.infinity,
                    constraints: const BoxConstraints(maxWidth: 460),
                    padding: const EdgeInsets.fromLTRB(18, 24, 18, 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(34),
                      border: Border.all(color: HGColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: HGColors.black.withValues(alpha: .08),
                          blurRadius: 30,
                          offset: const Offset(0, 16),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: SizedBox(
                            width: 168,
                            height: 76,
                            child: Image.asset(
                              'assets/images/highgrade-logo.png',
                              fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => const Icon(
                                  Icons.fitness_center_rounded,
                                  color: HGColors.red,
                                  size: 44),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Train with Manoj',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: HGColors.ink,
                            fontSize: 30,
                            height: 1.05,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 22),
                        const Text(
                          'Admin creates and verifies every account. Use the same login form for member or admin access.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: HGColors.muted, height: 1.45),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                            controller: _email,
                            decoration: const InputDecoration(
                                labelText: 'Name or Email',
                                prefixIcon: Icon(Icons.person_rounded))),
                        const SizedBox(height: 12),
                        TextField(
                            controller: _password,
                            obscureText: true,
                            decoration: const InputDecoration(
                                labelText: 'Password',
                                prefixIcon: Icon(Icons.lock_rounded))),
                        const SizedBox(height: 14),
                        OutlinedButton.icon(
                          onPressed: _forgotPassword,
                          icon: const Icon(Icons.help_rounded),
                          label: const Text('Forgot Password'),
                        ),
                        const SizedBox(height: 16),
                        FilledButton.icon(
                          onPressed: _login,
                          icon: const Icon(Icons.verified_user_rounded),
                          label: const Text('Login to Highgrade'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class HomeShell extends StatefulWidget {
  const HomeShell(
      {required this.user,
      required this.store,
      required this.onLogout,
      super.key});

  final DemoUser user;
  final HighgradeStore store;
  final VoidCallback onLogout;

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      DashboardPage(user: widget.user, onOpenTab: (tab) => setState(() => _index = tab)),
      const WorkoutsPage(),
      NutritionPage(store: widget.store),
      ProgressPage(user: widget.user),
      SocialPage(store: widget.store),
      MorePage(user: widget.user, role: AppRole.user, onLogout: widget.onLogout),
    ];
    final titles = [
      'Dashboard',
      'Workouts',
      'Nutrition',
      'Progress',
      'Socio',
      'More'
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index],
            style: const TextStyle(fontWeight: FontWeight.w900)),
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: _LogoMark(),
        ),
        actions: [
          IconButton(
              onPressed: () => _openNotifications(context),
              icon: const Icon(Icons.notifications_none_rounded)),
          IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) =>
                      UserProfilePage(user: widget.user, store: widget.store))),
              icon: const Icon(Icons.account_circle_rounded)),
          const SizedBox(width: 8),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        height: 72,
        indicatorColor: HGColors.red.withValues(alpha: .12),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.dashboard_rounded), label: 'Home'),
          NavigationDestination(
              icon: Icon(Icons.fitness_center_rounded), label: 'Workouts'),
          NavigationDestination(
              icon: Icon(Icons.restaurant_menu_rounded), label: 'Meals'),
          NavigationDestination(
              icon: Icon(Icons.show_chart_rounded), label: 'Progress'),
          NavigationDestination(
              icon: Icon(Icons.groups_rounded), label: 'Socio'),
          NavigationDestination(
              icon: Icon(Icons.grid_view_rounded), label: 'More'),
        ],
      ),
    );
  }
}

class AdminShell extends StatefulWidget {
  const AdminShell(
      {required this.user,
      required this.store,
      required this.onLogout,
      super.key});

  final DemoUser user;
  final HighgradeStore store;
  final VoidCallback onLogout;

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      AdminDashboardPage(
        store: widget.store,
        onOpenClients: () => setState(() => _index = 1),
        onOpenPending: () => setState(() => _index = 2),
        onOpenReports: () => _openFeature(context, reportsModule),
      ),
      AdminClientsPage(store: widget.store),
      AdminVerificationPage(store: widget.store),
      SocialPage(store: widget.store),
      MorePage(user: widget.user, role: AppRole.admin, onLogout: widget.onLogout),
    ];
    final titles = ['Admin', 'Clients', 'Verify', 'Socio', 'More'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_index],
            style: const TextStyle(fontWeight: FontWeight.w900)),
        leadingWidth: 72,
        leading: const Padding(
          padding: EdgeInsets.only(left: 16),
          child: _LogoMark(),
        ),
        actions: [
          IconButton(
              onPressed: widget.onLogout,
              icon: const Icon(Icons.logout_rounded)),
          const SizedBox(width: 8),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        height: 72,
        indicatorColor: HGColors.red.withValues(alpha: .12),
        destinations: const [
          NavigationDestination(
              icon: Icon(Icons.admin_panel_settings_rounded), label: 'Admin'),
          NavigationDestination(
              icon: Icon(Icons.people_rounded), label: 'Clients'),
          NavigationDestination(
              icon: Icon(Icons.verified_rounded), label: 'Verify'),
          NavigationDestination(
              icon: Icon(Icons.groups_rounded), label: 'Socio'),
          NavigationDestination(
              icon: Icon(Icons.grid_view_rounded), label: 'More'),
        ],
      ),
    );
  }
}

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({
    required this.store,
    required this.onOpenClients,
    required this.onOpenPending,
    required this.onOpenReports,
    super.key,
  });

  final HighgradeStore store;
  final VoidCallback onOpenClients;
  final VoidCallback onOpenPending;
  final VoidCallback onOpenReports;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => AppList(
        children: [
          _HeroPanel(
            title: 'Admin Control',
            subtitle:
                'Monitor clients, verify meals, track streaks, and review daily progress.',
            actionLabel: 'Pending ${store.pendingMeals}',
            icon: Icons.admin_panel_settings_rounded,
            onTap: onOpenPending,
          ),
          Row(
            children: [
              Expanded(
                  child: MetricTile(
                      label: 'Clients',
                      value: '${store.activeClients}',
                      suffix: 'active',
                      icon: Icons.people_rounded,
                      color: HGColors.red,
                      onTap: onOpenClients)),
              const SizedBox(width: 12),
              Expanded(
                  child: MetricTile(
                      label: 'Pending',
                      value: '${store.pendingMeals}',
                      suffix: 'meals',
                      icon: Icons.hourglass_top_rounded,
                      color: HGColors.amber,
                      onTap: onOpenPending)),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: MetricTile(
                      label: 'Approved',
                      value: '${store.approvedMeals}',
                      suffix: 'meals',
                      icon: Icons.check_circle_rounded,
                      color: HGColors.green,
                      onTap: onOpenPending)),
              const SizedBox(width: 12),
              Expanded(
                  child: MetricTile(
                      label: 'Revenue',
                      value: '1.2L',
                      suffix: 'month',
                      icon: Icons.payments_rounded,
                      color: HGColors.blue,
                      onTap: onOpenReports)),
            ],
          ),
          SectionHeader(title: 'Today Monitor'),
          HGCard(
            child: Column(
              children: const [
                ProgressLine(
                    label: 'Meal Completion', value: .74, trailing: '74%'),
                SizedBox(height: 14),
                ProgressLine(
                    label: 'Workout Completion', value: .68, trailing: '68%'),
                SizedBox(height: 14),
                ProgressLine(label: 'Water Goal', value: .81, trailing: '81%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AdminClientsPage extends StatelessWidget {
  const AdminClientsPage({required this.store, super.key});

  final HighgradeStore store;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => AppList(
        children: [
          SectionHeader(
              title: 'Client Tracking',
              action: 'Create User',
              onTap: () {
                store.createVerifiedClient(
                    'Verified Member ${store.clients.length + 1}');
                _toast(context, 'Admin created and verified a new user');
              }),
          for (final client in store.clients)
            HGCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                    backgroundColor:
                        client.active ? HGColors.black : HGColors.muted,
                    child: Icon(
                        client.active
                            ? Icons.person_rounded
                            : Icons.person_off_rounded,
                        color: Colors.white)),
                title: Text(client.name,
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(
                    '${client.goal} | ${client.weight.toStringAsFixed(0)}kg -> ${client.goalWeight.toStringAsFixed(0)}kg | Streak ${client.streak} | ${client.active ? 'Active' : 'Inactive'}'),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'inactive') {
                      store.setClientActive(client, !client.active);
                    }
                    if (value == 'delete') {
                      store.deleteClient(client);
                    }
                  },
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: 'inactive',
                        child: Text(client.active
                            ? 'Make inactive'
                            : 'Make active')),
                    const PopupMenuItem(
                        value: 'delete', child: Text('Delete user')),
                  ],
                ),
                onTap: () => _openClientMonitor(context, store, client),
              ),
            ),
        ],
      ),
    );
  }
}

class AdminVerificationPage extends StatelessWidget {
  const AdminVerificationPage({required this.store, super.key});

  final HighgradeStore store;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: store,
      builder: (context, _) => AppList(
        children: [
          SectionHeader(title: 'Meal Verification Queue'),
          for (final meal in store.meals)
            HGCard(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                    backgroundColor: HGColors.red.withValues(alpha: .1),
                    child: const Icon(Icons.restaurant_rounded,
                        color: HGColors.red)),
                title: Text('${meal.client} - ${meal.meal}',
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(
                    '${meal.food}\n${meal.calories} kcal | ${meal.protein}g protein | ${meal.status}${meal.reason.isEmpty ? '' : '\n${meal.reason}'}'),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _openMealReview(context, store, meal),
              ),
            ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({required this.user, required this.onOpenTab, super.key});

  final DemoUser user;
  final ValueChanged<int> onOpenTab;

  @override
  Widget build(BuildContext context) {
    return AppList(
      children: [
        _HeroPanel(
          title: 'Welcome, ${user.name.split(' ').first}',
          subtitle: 'Today is strength + conditioning. Keep your streak alive.',
          actionLabel: 'Start Workout',
          icon: Icons.play_arrow_rounded,
          onTap: () => onOpenTab(1),
        ),
        Row(
          children: [
            Expanded(
                child: MetricTile(
                    label: 'Current',
                    value: '${user.weightKg.toStringAsFixed(0)}kg',
                    suffix: 'weight',
                    icon: Icons.local_fire_department_rounded,
                    color: HGColors.red,
                    onTap: () => onOpenTab(3))),
            const SizedBox(width: 12),
            Expanded(
                child: MetricTile(
                    label: 'Goal',
                    value: '68kg',
                    suffix: 'target',
                    icon: Icons.flag_rounded,
                    color: HGColors.green,
                    onTap: () => onOpenTab(3))),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: MetricTile(
                    label: 'Streak',
                    value: '18',
                    suffix: 'days',
                    icon: Icons.bolt_rounded,
                    color: HGColors.amber,
                    onTap: () => onOpenTab(3))),
            const SizedBox(width: 12),
            Expanded(
                child: MetricTile(
                    label: 'Calories',
                    value: '1,840',
                    suffix: 'today',
                    icon: Icons.restaurant_rounded,
                    color: HGColors.red,
                    onTap: () => onOpenTab(2))),
          ],
        ),
        Row(
          children: [
            Expanded(
                child: MetricTile(
                    label: 'Water',
                    value: '2.4L',
                    suffix: 'intake',
                    icon: Icons.water_drop_rounded,
                    color: HGColors.blue,
                    onTap: () => onOpenTab(2))),
            const SizedBox(width: 12),
            Expanded(
                child: MetricTile(
                    label: 'BMI',
                    value: user.bmi.toStringAsFixed(1),
                    suffix: 'healthy',
                    icon: Icons.monitor_weight_rounded,
                    color: HGColors.green,
                    onTap: () => onOpenTab(3))),
          ],
        ),
        SectionHeader(
            title: 'Daily Summary',
            action: 'View Report',
            onTap: () => onOpenTab(3)),
        HGCard(
          child: Column(
            children: const [
              ProgressLine(
                  label: 'Workout Progress', value: .72, trailing: '72%'),
              SizedBox(height: 14),
              ProgressLine(
                  label: 'Protein Goal', value: .65, trailing: '98 / 150g'),
              SizedBox(height: 14),
              ProgressLine(label: 'Steps', value: .84, trailing: '8,420'),
              SizedBox(height: 14),
              ProgressLine(
                  label: 'Meal Completion', value: .75, trailing: '3 / 4'),
              SizedBox(height: 14),
              ProgressLine(
                  label: 'Pending Verification',
                  value: .33,
                  trailing: '2 items'),
            ],
          ),
        ),
        SectionHeader(
            title: 'Upcoming Workout',
            action: 'AI Adjust',
            onTap: () => _openFeature(context, aiModule)),
        WorkoutPlanCard(
          title: 'Push Strength A',
          subtitle: 'Chest, shoulders, triceps',
          stats: '55 min | Intermediate | Gym equipment',
          exercises: const [
            'Bench Press',
            'Incline Dumbbell Press',
            'Shoulder Press',
            'Cable Fly',
            'Triceps Rope'
          ],
        ),
        SectionHeader(title: 'Quick Actions'),
        GridMenu(
          items: const [
            FeatureMini('QR Check-in', Icons.qr_code_scanner_rounded),
            FeatureMini('Book Class', Icons.event_available_rounded),
            FeatureMini('Rest Timer', Icons.timer_rounded),
            FeatureMini('Upload Progress', Icons.add_photo_alternate_rounded),
          ],
        ),
      ],
    );
  }
}

class WorkoutsPage extends StatefulWidget {
  const WorkoutsPage({super.key});

  @override
  State<WorkoutsPage> createState() => _WorkoutsPageState();
}

class _WorkoutsPageState extends State<WorkoutsPage> {
  String _filter = 'All';
  int _timer = 60;
  Timer? _ticker;

  final _filters = const [
    'All',
    'Beginner',
    'Intermediate',
    'Advanced',
    'Dumbbell',
    'Machine',
    'Bodyweight'
  ];

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _ticker?.cancel();
    setState(() => _timer = 60);
    _ticker = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timer <= 0) {
        timer.cancel();
        return;
      }
      setState(() => _timer--);
    });
  }

  @override
  Widget build(BuildContext context) {
    final exercises = demoExercises
        .where((item) => _filter == 'All' || item.tags.contains(_filter))
        .toList();
    return AppList(
      children: [
        const _SearchBox(hint: 'Search exercise library, plans, favorites'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              for (final filter in _filters)
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    selected: _filter == filter,
                    label: Text(filter),
                    onSelected: (_) => setState(() => _filter = filter),
                    selectedColor: HGColors.red.withValues(alpha: .12),
                    labelStyle: TextStyle(
                        color: _filter == filter ? HGColors.red : HGColors.ink,
                        fontWeight: FontWeight.w800),
                  ),
                ),
            ],
          ),
        ),
        SectionHeader(
            title: 'Workout Plans',
            action: 'Custom Workout',
            onTap: () => _openFeature(context, workoutsModule)),
        SizedBox(
          height: 186,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              SizedBox(width: 2),
              _PlanMini(
                  title: 'Fat Loss Builder',
                  detail: '4 weeks | 24 sessions',
                  icon: Icons.speed_rounded),
              _PlanMini(
                  title: 'Muscle Gain Pro',
                  detail: '8 weeks | Hypertrophy',
                  icon: Icons.fitness_center_rounded),
              _PlanMini(
                  title: 'Women Strength',
                  detail: 'Beginner friendly',
                  icon: Icons.self_improvement_rounded),
              _PlanMini(
                  title: 'Senior Mobility',
                  detail: 'Joint-safe routines',
                  icon: Icons.accessibility_new_rounded),
            ],
          ),
        ),
        SectionHeader(
            title: 'AI Workout Generator',
            action: 'Generate',
            onTap: () => _toast(context, 'AI generated a 45 minute plan')),
        HGCard(
          child: Column(
            children: [
              const Text('Goal: Fat loss | Time: 45 min | Equipment: Dumbbells',
                  style: TextStyle(fontWeight: FontWeight.w800)),
              const SizedBox(height: 12),
              FilledButton.icon(
                  onPressed: () =>
                      _toast(context, 'AI plan saved to custom workouts'),
                  icon: const Icon(Icons.auto_awesome_rounded),
                  label: const Text('Generate Smart Workout')),
            ],
          ),
        ),
        SectionHeader(title: 'Exercise Library', action: 'Favorites'),
        for (final item in exercises) ExerciseTile(exercise: item),
        SectionHeader(title: 'Rest Timer & PRs'),
        HGCard(
          child: Row(
            children: [
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Rest Timer',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                      Text('00:${_timer.toString().padLeft(2, '0')}',
                          style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.w900,
                              color: HGColors.red)),
                      FilledButton.icon(
                          onPressed: _startTimer,
                          icon: const Icon(Icons.timer_rounded),
                          label: const Text('Start')),
                    ]),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Personal Records',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                      SizedBox(height: 10),
                      Text('Bench: 92.5 kg'),
                      Text('Squat: 130 kg'),
                      Text('Deadlift: 155 kg'),
                    ]),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class NutritionPage extends StatefulWidget {
  const NutritionPage({required this.store, super.key});

  final HighgradeStore store;

  @override
  State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  final _days = const [
    ('JUN', '29', 'MON'),
    ('JUN', '30', 'TUE'),
    ('JUL', '1', 'WED'),
    ('JUL', '2', 'THU'),
    ('JUL', '3', 'FRI'),
    ('JUL', '4', 'SAT'),
    ('JUL', '5', 'SUN'),
  ];

  final _mealTimes = const [
    ('Meal 1', '09:00 AM', 'Breakfast'),
    ('Meal 2', '12:00 PM', 'Lunch'),
    ('Meal 3', '05:00 PM', 'Snack'),
    ('Meal 4', '08:00 PM', 'Dinner'),
  ];

  void _openRecipes(String mealName) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (_) =>
            RecipeLibraryPage(store: widget.store, mealName: mealName)));
  }

  void _uploadMealImage(String mealName) {
    widget.store.addMeal(mealName);
    _toast(context, '$mealName image sent for admin verification');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.store,
      builder: (context, _) {
        final logs = widget.store.meals
            .where((meal) => meal.client == 'Bhadri')
            .toList();
        final calories = logs.fold<int>(0, (sum, meal) => sum + meal.calories);
        final protein = logs.fold<int>(0, (sum, meal) => sum + meal.protein);
        final carbs = logs.fold<int>(0, (sum, meal) => sum + meal.carbs);
        final fat = logs.fold<int>(0, (sum, meal) => sum + meal.fat);
        final fiber = logs.fold<int>(0, (sum, meal) => sum + meal.fiber);

        return ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => _toast(context, 'Diet tracker refreshed'),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                const Expanded(
                  child: Text('Diet Tracker',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                ),
                IconButton(
                    onPressed: () => _openFeature(context, notificationsModule),
                    icon: const Icon(Icons.notifications_none_rounded)),
                IconButton(
                    onPressed: () => _openRecipes('Meal'),
                    icon: const Icon(Icons.more_vert_rounded)),
              ],
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('Sun, 05 Jul, 2026',
                  style: TextStyle(
                      color: HGColors.muted,
                      fontSize: 21,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 18),
            SizedBox(
              height: 84,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _days.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (context, index) {
                  final day = _days[index];
                  return _DatePill(
                      month: day.$1,
                      date: day.$2,
                      weekday: day.$3,
                      active: index == 6);
                },
              ),
            ),
            const SizedBox(height: 18),
            HGCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('$calories out of 2250',
                            style: const TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w900)),
                      ),
                      CircleAvatar(
                          backgroundColor: HGColors.red,
                          child: const Icon(Icons.bar_chart_rounded,
                              color: Colors.white)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Calories Consumed',
                      style: TextStyle(fontSize: 17, color: HGColors.ink)),
                  const SizedBox(height: 22),
                  _MacroLine(
                      icon: '💪',
                      label: 'Protein',
                      current: protein,
                      total: 150,
                      unit: 'g'),
                  _MacroLine(
                      icon: '🌾',
                      label: 'Carbs',
                      current: carbs,
                      total: 260,
                      unit: 'g'),
                  _MacroLine(
                      icon: '🥑',
                      label: 'Fats',
                      current: fat,
                      total: 70,
                      unit: 'g'),
                  _MacroLine(
                      icon: '🥗',
                      label: 'Fiber',
                      current: fiber,
                      total: 35,
                      unit: 'g'),
                ],
              ),
            ),
            const SizedBox(height: 10),
            for (final item in _mealTimes)
              _MealSlotCard(
                title: item.$1,
                time: item.$2,
                mealName: item.$3,
                logs: logs.where((meal) => meal.meal == item.$3).toList(),
                onAddFood: () => _openRecipes(item.$3),
                onAddImage: () => _uploadMealImage(item.$3),
              ),
            SectionHeader(
                title: 'Recipes',
                action: 'View All',
                onTap: () => _openRecipes('Meal')),
            for (final recipe in demoRecipes.take(4))
              _RecipeTile(
                recipe: recipe,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => RecipeDetailPage(
                        recipe: recipe,
                        mealName: 'Meal',
                        onAdd: () {
                          widget.store.addRecipeMeal('Meal', recipe);
                          _toast(context, '${recipe.name} added to tracker');
                        }))),
              ),
          ],
        );
      },
    );
  }
}

class RecipeLibraryPage extends StatefulWidget {
  const RecipeLibraryPage(
      {required this.store, required this.mealName, super.key});

  final HighgradeStore store;
  final String mealName;

  @override
  State<RecipeLibraryPage> createState() => _RecipeLibraryPageState();
}

class _RecipeLibraryPageState extends State<RecipeLibraryPage> {
  String _query = '';
  String _filter = 'All';

  @override
  Widget build(BuildContext context) {
    final recipes = demoRecipes.where((recipe) {
      final matchesQuery =
          recipe.name.toLowerCase().contains(_query.toLowerCase());
      final matchesFilter = _filter == 'All' ||
          (_filter == 'Favourites' && recipe.favorite) ||
          recipe.category == _filter;
      return matchesQuery && matchesFilter;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipes',
            style: TextStyle(fontWeight: FontWeight.w900)),
        actions: [
          IconButton(
              onPressed: () => _toast(context, 'Create recipe form opened'),
              icon: const Icon(Icons.add_rounded)),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
        children: [
          TextField(
            onChanged: (value) => setState(() => _query = value),
            decoration: const InputDecoration(
                hintText: 'Search Any Recipe',
                prefixIcon: Icon(Icons.search_rounded)),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final filter in const [
                  'All',
                  'Breakfast',
                  'Lunch',
                  'Dinner',
                  'Snack',
                  'Favourites'
                ])
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ChoiceChip(
                      selected: _filter == filter,
                      label: Text(filter),
                      selectedColor: HGColors.red.withValues(alpha: .12),
                      onSelected: (_) => setState(() => _filter = filter),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          for (final recipe in recipes)
            _RecipeTile(
              recipe: recipe,
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (_) => RecipeDetailPage(
                      recipe: recipe,
                      mealName: widget.mealName,
                      onAdd: () {
                        widget.store.addRecipeMeal(widget.mealName, recipe);
                        _toast(context,
                            '${recipe.name} added to ${widget.mealName}');
                      }))),
            ),
        ],
      ),
    );
  }
}

class RecipeDetailPage extends StatelessWidget {
  const RecipeDetailPage(
      {required this.recipe,
      required this.mealName,
      required this.onAdd,
      super.key});

  final Recipe recipe;
  final String mealName;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded)),
                const Spacer(),
                IconButton(
                    onPressed: () => _toast(context, 'Added to favourites'),
                    icon: const Icon(Icons.favorite_border_rounded,
                        color: HGColors.red)),
              ],
            ),
            _FoodHero(recipe: recipe),
            const SizedBox(height: 90),
            Row(
              children: [
                Expanded(
                  child: Text(recipe.name,
                      style: const TextStyle(
                          fontSize: 21, fontWeight: FontWeight.w900)),
                ),
                Text('🔥 ${recipe.calories.toStringAsFixed(2)} Kcal',
                    style: const TextStyle(
                        color: HGColors.red, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 22),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: HGColors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                      child: _NutrientStat(
                          label: 'PROTEIN', value: '${recipe.protein} g')),
                  Expanded(
                      child: _NutrientStat(
                          label: 'CARBS', value: '${recipe.carbs} g')),
                  Expanded(
                      child: _NutrientStat(
                          label: 'FATS', value: '${recipe.fat} g')),
                ],
              ),
            ),
            const SizedBox(height: 70),
            CircleAvatar(
                radius: 27,
                backgroundColor: HGColors.muted.withValues(alpha: .18),
                child:
                    const Icon(Icons.rice_bowl_rounded, color: HGColors.muted)),
            const SizedBox(height: 18),
            const Center(
              child: Text('Ingredients are currently not available.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: HGColors.muted,
                      fontSize: 18,
                      fontWeight: FontWeight.w700)),
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
                onPressed: () {
                  onAdd();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.add_rounded),
                label: Text('Add to $mealName')),
          ],
        ),
      ),
    );
  }
}

class _DatePill extends StatelessWidget {
  const _DatePill(
      {required this.month,
      required this.date,
      required this.weekday,
      required this.active});

  final String month;
  final String date;
  final String weekday;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 66,
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: active ? HGColors.red : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(month,
              style: TextStyle(
                  color: active ? Colors.white : HGColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w800)),
          Text(date,
              style: TextStyle(
                  color: active ? Colors.white : HGColors.ink,
                  fontSize: 25,
                  fontWeight: FontWeight.w900)),
          Text(weekday,
              style: TextStyle(
                  color: active ? Colors.white : HGColors.ink,
                  fontSize: 11,
                  fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _MacroLine extends StatelessWidget {
  const _MacroLine(
      {required this.icon,
      required this.label,
      required this.current,
      required this.total,
      required this.unit});

  final String icon;
  final String label;
  final int current;
  final int total;
  final String unit;

  @override
  Widget build(BuildContext context) {
    final value = total == 0 ? 0.0 : (current / total).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(icon),
              const SizedBox(width: 8),
              Expanded(
                  child: Text(label,
                      style: const TextStyle(fontWeight: FontWeight.w900))),
              Text('$current/$total$unit',
                  style: const TextStyle(
                      color: HGColors.red, fontWeight: FontWeight.w900)),
            ],
          ),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: value,
            minHeight: 5,
            backgroundColor: HGColors.border,
            color: HGColors.red,
            borderRadius: BorderRadius.circular(99),
          ),
        ],
      ),
    );
  }
}

class _MealSlotCard extends StatelessWidget {
  const _MealSlotCard(
      {required this.title,
      required this.time,
      required this.mealName,
      required this.logs,
      required this.onAddFood,
      required this.onAddImage});

  final String title;
  final String time;
  final String mealName;
  final List<DemoMealLog> logs;
  final VoidCallback onAddFood;
  final VoidCallback onAddImage;

  @override
  Widget build(BuildContext context) {
    final kcal = logs.fold<int>(0, (sum, item) => sum + item.calories);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(4, 16, 4, 18),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: HGColors.border)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              Text(time,
                  style: const TextStyle(
                      color: HGColors.muted,
                      fontSize: 17,
                      fontWeight: FontWeight.w700)),
              const Spacer(),
              Text('$kcal Kcal',
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w900)),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 14,
                backgroundColor: logs.any((item) => item.status == 'Approved')
                    ? HGColors.green
                    : HGColors.muted.withValues(alpha: .45),
                child: const Icon(Icons.done_all_rounded,
                    color: Colors.white, size: 16),
              ),
              const Icon(Icons.more_vert_rounded),
            ],
          ),
          if (logs.isNotEmpty) ...[
            const SizedBox(height: 10),
            for (final log in logs)
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                title: Text(log.food,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text('${log.status} | ${log.protein}g protein'),
                trailing: Text('${log.calories} kcal'),
              ),
          ],
          const SizedBox(height: 10),
          Row(
            children: [
              OutlinedButton.icon(
                onPressed: onAddFood,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Food'),
                style: OutlinedButton.styleFrom(
                    foregroundColor: HGColors.red,
                    side: const BorderSide(color: HGColors.red)),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: onAddImage,
                icon: const Icon(Icons.keyboard_arrow_down_rounded),
                label: const Text('Add Image & More'),
                style: TextButton.styleFrom(foregroundColor: HGColors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecipeTile extends StatelessWidget {
  const _RecipeTile({required this.recipe, required this.onTap});

  final Recipe recipe;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      onTap: onTap,
      leading: _RecipeThumb(recipe: recipe),
      title: Text(recipe.name,
          style: const TextStyle(fontWeight: FontWeight.w900)),
      subtitle: Text(
        '${recipe.timeMinutes == 0 ? '' : '${recipe.timeMinutes} minutes | '}${recipe.calories.toStringAsFixed(2)} Kcal',
        style: const TextStyle(color: HGColors.red),
      ),
      trailing: IconButton(
          onPressed: () => _toast(context, 'Favourite updated'),
          icon: Icon(recipe.favorite
              ? Icons.favorite_rounded
              : Icons.favorite_border_rounded),
          color: HGColors.red),
    );
  }
}

class _RecipeThumb extends StatelessWidget {
  const _RecipeThumb({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 54,
      height: 54,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(colors: recipe.colors),
      ),
      child: Icon(recipe.icon, color: Colors.white),
    );
  }
}

class _FoodHero extends StatelessWidget {
  const _FoodHero({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 390,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: recipe.colors),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Icon(recipe.icon,
                size: 150, color: Colors.white.withValues(alpha: .62)),
          ),
          Positioned(
            left: 18,
            bottom: 18,
            right: 18,
            child: Text(recipe.name,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }
}

class _NutrientStat extends StatelessWidget {
  const _NutrientStat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label,
            style: const TextStyle(
                color: HGColors.muted, fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w900)),
      ],
    );
  }
}

class ProgressPage extends StatelessWidget {
  const ProgressPage({required this.user, super.key});

  final DemoUser user;

  @override
  Widget build(BuildContext context) {
    return AppList(
      children: [
        SectionHeader(title: 'User Profile'),
        HGCard(
          child: Column(
            children: [
              ProfileRow(
                  label: 'Personal Details',
                  value: '${user.name} | ${user.email}'),
              ProfileRow(label: 'Fitness Goals', value: user.goal),
              ProfileRow(
                  label: 'Height & Weight',
                  value:
                      '${user.heightCm.toStringAsFixed(0)} cm | ${user.weightKg.toStringAsFixed(0)} kg'),
              ProfileRow(
                  label: 'BMI Calculator', value: user.bmi.toStringAsFixed(1)),
            ],
          ),
        ),
        SectionHeader(title: 'Progress Photos'),
        SizedBox(
          height: 118,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              for (final label in ['Day 1', 'Week 4', 'Week 8', 'Today'])
                Container(
                  width: 118,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                      color: HGColors.black,
                      borderRadius: BorderRadius.circular(22)),
                  child: Center(
                      child: Text(label,
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900))),
                ),
              InkWell(
                onTap: () => _toast(context, 'Progress photo upload opened'),
                child: Container(
                  width: 118,
                  decoration: BoxDecoration(
                      border: Border.all(color: HGColors.border),
                      borderRadius: BorderRadius.circular(22),
                      color: Colors.white),
                  child: const Icon(Icons.add_a_photo_rounded,
                      color: HGColors.red),
                ),
              ),
            ],
          ),
        ),
        SectionHeader(title: 'Charts & Reports'),
        const ChartCard(title: 'Weight Tracking', subtitle: 'Last 8 weeks'),
        const ChartCard(
            title: 'Strength Progress', subtitle: 'Compound lift trend'),
        SectionHeader(title: 'Body Measurements'),
        HGCard(
          child: Column(
            children: const [
              ProgressLine(label: 'Waist', value: .62, trailing: '82 cm'),
              SizedBox(height: 14),
              ProgressLine(label: 'Chest', value: .78, trailing: '102 cm'),
              SizedBox(height: 14),
              ProgressLine(label: 'Body Fat', value: .44, trailing: '18.2%'),
            ],
          ),
        ),
        SectionHeader(title: 'Workout Analytics'),
        GridMenu(
          items: const [
            FeatureMini('Volume Load', Icons.analytics_rounded),
            FeatureMini('Attendance', Icons.fact_check_rounded),
            FeatureMini('Recovery', Icons.hotel_rounded),
            FeatureMini('Reports', Icons.picture_as_pdf_rounded),
          ],
        ),
      ],
    );
  }
}

class SocialPage extends StatefulWidget {
  const SocialPage({required this.store, super.key});

  final HighgradeStore store;

  @override
  State<SocialPage> createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage> {
  final Set<SocialEntry> _liked = {};
  SocialEntry? _heartBurst;
  final _caption = TextEditingController();

  @override
  void dispose() {
    _caption.dispose();
    super.dispose();
  }

  Future<void> _captureAndPublish(String mediaKind, {bool story = false}) async {
    String? path;
    try {
      final picker = ImagePicker();
      final file = mediaKind == 'video'
          ? await picker.pickVideo(source: ImageSource.camera)
          : await picker.pickImage(source: ImageSource.camera, imageQuality: 82);
      path = file?.path;
    } catch (_) {
      path = null;
    }

    final text = _caption.text.trim().isEmpty
        ? (story ? 'New Highgrade story update' : 'New Highgrade community update')
        : _caption.text.trim();
    if (story) {
      widget.store.addStory(
          text: text, mediaKind: mediaKind, mediaPath: path);
    } else {
      widget.store.addPost(
          mediaKind == 'video' ? 'Video' : 'Photo',
          text: text,
          mediaKind: mediaKind,
          mediaPath: path);
    }
    _caption.clear();
    if (mounted) {
      Navigator.pop(context);
      _toast(context, story ? 'Story uploaded' : 'Community feed uploaded');
    }
  }

  void _openComposer() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Create Socio Post',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Open camera, add caption, and publish to story or feed.',
                style: TextStyle(color: HGColors.muted)),
            const SizedBox(height: 16),
            TextField(
              controller: _caption,
              maxLines: 3,
              decoration: const InputDecoration(
                  labelText: 'Caption',
                  prefixIcon: Icon(Icons.edit_note_rounded)),
            ),
            const SizedBox(height: 12),
            FilledButton.icon(
                onPressed: () => _captureAndPublish('photo'),
                icon: const Icon(Icons.photo_camera_rounded),
                label: const Text('Take Photo & Post')),
            const SizedBox(height: 10),
            OutlinedButton.icon(
                onPressed: () => _captureAndPublish('video'),
                icon: const Icon(Icons.videocam_rounded),
                label: const Text('Record Video & Post')),
            const SizedBox(height: 10),
            OutlinedButton.icon(
                onPressed: () => _captureAndPublish('photo', story: true),
                icon: const Icon(Icons.auto_stories_rounded),
                label: const Text('Upload to Story')),
          ],
        ),
      ),
    );
  }

  void _likePost(SocialEntry post, {bool burst = false}) {
    setState(() {
      _liked.add(post);
      _heartBurst = burst ? post : null;
    });
    if (burst) {
      Future<void>.delayed(const Duration(milliseconds: 650), () {
        if (mounted && _heartBurst == post) {
          setState(() => _heartBurst = null);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppList(
      children: [
        _HeroPanel(
          title: 'Highgrade Socio',
          subtitle: 'Stories, camera uploads, community posts, comments, shares, and member profile activity.',
          actionLabel: 'Create',
          icon: Icons.add_circle_rounded,
          onTap: _openComposer,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: FilledButton.icon(
              onPressed: _openComposer,
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Post')),
        ),
        SectionHeader(title: 'Stories'),
        AnimatedBuilder(
          animation: widget.store,
          builder: (context, _) => SizedBox(
            height: 96,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: _openComposer,
                  child: Container(
                    width: 82,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                        color: HGColors.red.withValues(alpha: .1),
                        borderRadius: BorderRadius.circular(22)),
                    child: const Icon(Icons.add_rounded, color: HGColors.red),
                  ),
                ),
                for (final story in widget.store.stories)
                  Container(
                    width: 92,
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: HGColors.red, width: 2),
                        borderRadius: BorderRadius.circular(28)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircleAvatar(
                            radius: 20,
                            backgroundColor: HGColors.black,
                            child: Text('HG',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900))),
                        const SizedBox(height: 6),
                        Text(story.text,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                fontSize: 11, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        SectionHeader(title: 'Community Feed'),
        AnimatedBuilder(
          animation: widget.store,
          builder: (context, _) => Column(
            children: [
              for (final post in widget.store.posts)
                HGCard(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundColor:
                                  post.isAdmin ? HGColors.red : HGColors.black,
                              child: Text(post.isAdmin ? 'M' : 'HG',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w900))),
                          const SizedBox(width: 10),
                          Expanded(
                            child: InkWell(
                              onTap: () => _openSocioProfile(
                                  context, widget.store, post.owner),
                              child: Text(post.owner,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900)),
                            ),
                          ),
                          const Icon(Icons.more_horiz_rounded),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(post.text),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onDoubleTap: () => _likePost(post, burst: true),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SocialMediaBox(entry: post),
                              AnimatedScale(
                                duration: const Duration(milliseconds: 180),
                                scale: _heartBurst == post ? 1 : 0,
                                child: const Icon(Icons.favorite_rounded,
                                    size: 94, color: HGColors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(children: [
                        IconButton(
                            onPressed: () => _likePost(post),
                            icon: Icon(_liked.contains(post)
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded),
                            color: _liked.contains(post)
                                ? HGColors.red
                                : HGColors.ink),
                        IconButton(
                            onPressed: () => _toast(context, 'Comment added'),
                            icon: const Icon(Icons.mode_comment_outlined)),
                        IconButton(
                            onPressed: () => _toast(context, 'Post shared'),
                            icon: const Icon(Icons.share_outlined)),
                        const Spacer(),
                        Text('${_liked.contains(post) ? 25 : 24} likes',
                            style:
                                const TextStyle(fontWeight: FontWeight.w800)),
                      ]),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class SocialMediaBox extends StatelessWidget {
  const SocialMediaBox({required this.entry, super.key});

  final SocialEntry entry;

  @override
  Widget build(BuildContext context) {
    final file = entry.mediaPath == null ? null : File(entry.mediaPath!);
    final hasFile = file != null && file.existsSync();
    return Container(
      height: 210,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: entry.mediaKind == 'video'
              ? [HGColors.black, HGColors.redDark]
              : [HGColors.red.withValues(alpha: .12), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (hasFile && entry.mediaKind != 'video')
            Image.file(file, fit: BoxFit.cover)
          else
            Center(
              child: Icon(
                entry.mediaKind == 'video'
                    ? Icons.play_circle_fill_rounded
                    : Icons.image_rounded,
                size: 72,
                color: entry.mediaKind == 'video' ? Colors.white : HGColors.red,
              ),
            ),
          if (entry.mediaKind == 'video')
            const Center(
              child: Icon(Icons.play_circle_fill_rounded,
                  size: 72, color: Colors.white),
            ),
          Positioned(
            left: 12,
            bottom: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: HGColors.black.withValues(alpha: .62),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Text(entry.mediaKind.toUpperCase(),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w900)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({required this.user, required this.store, super.key});

  final DemoUser user;
  final HighgradeStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Profile',
              style: TextStyle(fontWeight: FontWeight.w900))),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final meals = store.meals
              .where((meal) => meal.client == user.name)
              .toList();
          final posts =
              store.posts.where((post) => post.owner == user.name).toList();
          return AppList(
            children: [
              HGCard(
                child: Column(
                  children: [
                    const CircleAvatar(
                        radius: 38,
                        backgroundColor: HGColors.black,
                        child: Text('HG',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w900))),
                    const SizedBox(height: 12),
                    Text(user.name,
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w900)),
                    Text(user.goal,
                        style: const TextStyle(color: HGColors.muted)),
                  ],
                ),
              ),
              SectionHeader(title: 'Daily Activity'),
              HGCard(
                child: Column(
                  children: [
                    ProfileRow(label: 'Email', value: user.email),
                    ProfileRow(label: 'Phone', value: user.phone),
                    ProfileRow(
                        label: 'Height / Weight',
                        value:
                            '${user.heightCm.toStringAsFixed(0)} cm / ${user.weightKg.toStringAsFixed(0)} kg'),
                    ProfileRow(label: 'BMI', value: user.bmi.toStringAsFixed(1)),
                    const ProfileRow(label: 'Steps', value: '8,420'),
                    const ProfileRow(label: 'Water', value: '2.4L'),
                    const ProfileRow(label: 'Workout', value: 'Completed'),
                  ],
                ),
              ),
              SectionHeader(title: 'Meals & Verification'),
              for (final meal in meals)
                HGCard(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const CircleAvatar(
                        backgroundColor: HGColors.red,
                        child: Icon(Icons.restaurant_rounded,
                            color: Colors.white)),
                    title: Text('${meal.meal} - ${meal.food}',
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    subtitle: Text(
                        '${meal.calories} kcal | ${meal.protein}g protein | ${meal.status}'),
                  ),
                ),
              SectionHeader(title: 'Community Feed'),
              if (posts.isEmpty)
                const HGCard(
                    child: Text('Uploaded Socio posts will show here.'))
              else
                GridView.builder(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (_, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SocialMediaBox(entry: posts[index]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

void _openSocioProfile(
    BuildContext context, HighgradeStore store, String owner) {
  Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => SocioProfilePage(store: store, owner: owner)));
}

class SocioProfilePage extends StatelessWidget {
  const SocioProfilePage({required this.store, required this.owner, super.key});

  final HighgradeStore store;
  final String owner;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(owner, style: const TextStyle(fontWeight: FontWeight.w900))),
      body: AnimatedBuilder(
        animation: store,
        builder: (context, _) {
          final posts = store.posts.where((post) => post.owner == owner).toList();
          final stories =
              store.stories.where((story) => story.owner == owner).toList();
          final meals = store.meals.where((meal) => meal.client == owner).toList();
          return AppList(
            children: [
              HGCard(
                child: Row(
                  children: [
                    CircleAvatar(
                        radius: 34,
                        backgroundColor:
                            owner.contains('Coach') ? HGColors.red : HGColors.black,
                        child: Text(owner.contains('Coach') ? 'M' : 'HG',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900))),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(owner,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          Text('${posts.length} posts | ${stories.length} stories',
                              style: const TextStyle(color: HGColors.muted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SectionHeader(title: 'Stories'),
              SizedBox(
                height: 96,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: stories
                      .map((story) => Container(
                            width: 90,
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: HGColors.red, width: 2),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Center(
                                child: Icon(
                                    story.mediaKind == 'video'
                                        ? Icons.play_circle_fill_rounded
                                        : Icons.image_rounded,
                                    color: HGColors.red)),
                          ))
                      .toList(),
                ),
              ),
              SectionHeader(title: 'Daily Activity'),
              HGCard(
                child: Column(
                  children: [
                    const ProfileRow(label: 'Workout', value: 'Completed'),
                    const ProfileRow(label: 'Steps', value: '8,420'),
                    const ProfileRow(label: 'Water', value: '2.4L'),
                    ProfileRow(label: 'Meals uploaded', value: '${meals.length}'),
                  ],
                ),
              ),
              SectionHeader(title: 'Posts'),
              if (posts.isEmpty)
                const HGCard(child: Text('No posts yet.'))
              else
                GridView.builder(
                  itemCount: posts.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                  ),
                  itemBuilder: (_, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: SocialMediaBox(entry: posts[index]),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class MorePage extends StatelessWidget {
  const MorePage(
      {required this.user,
      required this.role,
      required this.onLogout,
      super.key});

  final DemoUser user;
  final AppRole role;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    final baseModules = [
      authenticationModule,
      workoutsModule,
      exercisesModule,
      clientProfileModule,
      dietBuilderModule,
      wearablesModule,
      attendanceModule,
      reportsModule,
      settingsModule,
    ];
    final adminModules = [
      adminModule,
      adminVerificationModule,
      gymModule,
      trainerModule,
      membershipsModule,
      paymentsModule,
      analyticsModule,
      notificationsModule,
      securityModule,
    ];
    final modules = role == AppRole.admin
        ? [...baseModules, ...adminModules]
        : baseModules;

    return AppList(
      children: [
        HGCard(
          child: Row(
            children: [
              const CircleAvatar(
                  radius: 30,
                  backgroundColor: HGColors.black,
                  child: Text('HG',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w900))),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(user.name,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w900)),
                      Text(user.goal,
                          style: const TextStyle(color: HGColors.muted)),
                    ]),
              ),
              IconButton(
                  onPressed: onLogout, icon: const Icon(Icons.logout_rounded)),
            ],
          ),
        ),
        SectionHeader(title: 'Core Modules'),
        GridView.builder(
          itemCount: modules.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 1.03,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final module = modules[index];
            return ModuleCard(
                module: module, onTap: () => _openFeature(context, module));
          },
        ),
      ],
    );
  }
}

class FeatureDetailPage extends StatelessWidget {
  const FeatureDetailPage({required this.module, super.key});

  final FeatureModule module;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(module.title,
              style: const TextStyle(fontWeight: FontWeight.w900))),
      body: AppList(
        children: [
          _HeroPanel(
            title: module.title,
            subtitle: module.description,
            actionLabel: 'Open Workspace',
            icon: module.icon,
            onTap: () => _openFeatureAction(context, module.title, 'Workspace'),
          ),
          SectionHeader(title: 'Included Features'),
          for (final item in module.features)
            HGCard(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: CircleAvatar(
                    backgroundColor: HGColors.red.withValues(alpha: .1),
                    child:
                        const Icon(Icons.check_rounded, color: HGColors.red)),
                title: Text(item,
                    style: const TextStyle(fontWeight: FontWeight.w800)),
                subtitle: Text(_featureSubtitle(module.title, item)),
                trailing: const Icon(Icons.chevron_right_rounded),
                onTap: () => _openFeatureAction(context, module.title, item),
              ),
            ),
          if (module.title.contains('Admin') ||
              module.title.contains('Owner')) ...[
            SectionHeader(title: 'Dashboard Preview'),
            Row(
              children: const [
                Expanded(
                    child: MetricTile(
                        label: 'Members',
                        value: '1,840',
                        suffix: 'active',
                        icon: Icons.people_rounded,
                        color: HGColors.red)),
                SizedBox(width: 12),
                Expanded(
                    child: MetricTile(
                        label: 'Revenue',
                        value: '12.4L',
                        suffix: 'monthly',
                        icon: Icons.payments_rounded,
                        color: HGColors.green)),
              ],
            ),
            const ChartCard(
                title: 'Reports & Analytics',
                subtitle: 'Revenue, attendance, leads, memberships'),
          ],
        ],
      ),
    );
  }
}

class AppList extends StatelessWidget {
  const AppList({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children),
        ),
      ],
    );
  }
}

class HGCard extends StatelessWidget {
  const HGCard({required this.child, this.margin, super.key});

  final Widget child;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HGColors.border),
        boxShadow: [
          BoxShadow(
              color: HGColors.ink.withValues(alpha: .045),
              blurRadius: 24,
              offset: const Offset(0, 12)),
        ],
      ),
      child: child,
    );
  }
}

class _MealPhotoPreview extends StatelessWidget {
  const _MealPhotoPreview({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 168,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: HGColors.black,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: HGColors.border),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    HGColors.red.withValues(alpha: .28),
                    HGColors.black,
                    HGColors.green.withValues(alpha: .14),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 14,
            bottom: 14,
            right: 14,
            child: Row(
              children: [
                const Icon(Icons.image_rounded, color: Colors.white),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(
      {required this.title, this.action, this.onTap, super.key});

  final String title;
  final String? action;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 12, 2, 12),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w900))),
          if (action != null)
            TextButton(
                onPressed: onTap,
                child: Text(action!,
                    style: const TextStyle(fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel(
      {required this.title,
      required this.subtitle,
      required this.actionLabel,
      required this.icon,
      required this.onTap});

  final String title;
  final String subtitle;
  final String actionLabel;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: HGColors.black,
          image: DecorationImage(
            image: const AssetImage('assets/images/highgrade-hero-bg.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
                HGColors.black.withValues(alpha: .72), BlendMode.darken),
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                right: -36,
                top: -48,
                child: Icon(icon,
                    size: 170, color: Colors.white.withValues(alpha: .055))),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _Badge(text: '#1 Fitness Platform', dark: true),
                const SizedBox(height: 16),
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        height: 1.05,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 10),
                Text(subtitle,
                    style: const TextStyle(
                        color: Color(0xFFD7DCE6), height: 1.55)),
                const SizedBox(height: 18),
                FilledButton.icon(
                    onPressed: onTap,
                    icon: Icon(icon),
                    label: Text(actionLabel)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile(
      {required this.label,
      required this.value,
      required this.suffix,
      required this.icon,
      required this.color,
      this.onTap,
      super.key});

  final String label;
  final String value;
  final String suffix;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: HGCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                backgroundColor: color.withValues(alpha: .12),
                child: Icon(icon, color: color)),
            const SizedBox(height: 14),
            Text(value,
                style:
                    const TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
            Text(suffix,
                style: const TextStyle(color: HGColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine(
      {required this.label,
      required this.value,
      required this.trailing,
      super.key});

  final String label;
  final double value;
  final String trailing;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w800))),
          Text(trailing,
              style: const TextStyle(
                  color: HGColors.muted, fontWeight: FontWeight.w800)),
        ]),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            minHeight: 9,
            value: value,
            backgroundColor: HGColors.border,
            color: HGColors.red,
          ),
        ),
      ],
    );
  }
}

class WorkoutPlanCard extends StatelessWidget {
  const WorkoutPlanCard(
      {required this.title,
      required this.subtitle,
      required this.stats,
      required this.exercises,
      super.key});

  final String title;
  final String subtitle;
  final String stats;
  final List<String> exercises;

  @override
  Widget build(BuildContext context) {
    return HGCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                  backgroundColor: HGColors.red,
                  child:
                      Icon(Icons.fitness_center_rounded, color: Colors.white)),
              const SizedBox(width: 12),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(title,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w900)),
                    Text(subtitle,
                        style: const TextStyle(color: HGColors.muted)),
                  ])),
            ],
          ),
          const SizedBox(height: 12),
          Text(stats, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          Wrap(
              spacing: 8,
              runSpacing: 8,
              children: exercises
                  .map((e) => Chip(
                      label: Text(e), visualDensity: VisualDensity.compact))
                  .toList()),
        ],
      ),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  const ExerciseTile({required this.exercise, super.key});

  final Exercise exercise;

  @override
  Widget build(BuildContext context) {
    return HGCard(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
                color: HGColors.black, borderRadius: BorderRadius.circular(20)),
            child: Icon(exercise.icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(exercise.name,
                  style: const TextStyle(fontWeight: FontWeight.w900)),
              const SizedBox(height: 4),
              Text('${exercise.muscle} | ${exercise.equipment}',
                  style: const TextStyle(color: HGColors.muted)),
              const SizedBox(height: 8),
              Wrap(
                  spacing: 6,
                  children: exercise.tags
                      .take(3)
                      .map((tag) => _SmallTag(tag))
                      .toList()),
            ]),
          ),
          IconButton(
              onPressed: () =>
                  _toast(context, '${exercise.name} added to favorites'),
              icon: const Icon(Icons.favorite_border_rounded)),
        ],
      ),
    );
  }
}

class ChartCard extends StatelessWidget {
  const ChartCard({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return HGCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
          Text(subtitle, style: const TextStyle(color: HGColors.muted)),
          const SizedBox(height: 18),
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) =>
                        FlLine(color: HGColors.border, strokeWidth: 1)),
                borderData: FlBorderData(show: false),
                titlesData: const FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    isCurved: true,
                    color: HGColors.red,
                    barWidth: 4,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                        show: true, color: HGColors.red.withValues(alpha: .12)),
                    spots: const [
                      FlSpot(0, 74),
                      FlSpot(1, 73),
                      FlSpot(2, 72.5),
                      FlSpot(3, 71),
                      FlSpot(4, 70.8),
                      FlSpot(5, 70),
                      FlSpot(6, 69.4),
                      FlSpot(7, 68.8)
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GridMenu extends StatelessWidget {
  const GridMenu({required this.items, super.key});

  final List<FeatureMini> items;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.45,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12),
      itemBuilder: (context, index) {
        final item = items[index];
        return HGCard(
          margin: EdgeInsets.zero,
          child: InkWell(
            onTap: () => _toast(context, '${item.label} opened'),
            borderRadius: BorderRadius.circular(18),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon, color: HGColors.red),
                  const SizedBox(height: 10),
                  Text(item.label,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                ]),
          ),
        );
      },
    );
  }
}

class ModuleCard extends StatelessWidget {
  const ModuleCard({required this.module, required this.onTap, super.key});

  final FeatureModule module;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: HGColors.border),
          boxShadow: [
            BoxShadow(
                color: HGColors.ink.withValues(alpha: .04),
                blurRadius: 22,
                offset: const Offset(0, 10))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
                backgroundColor: HGColors.red.withValues(alpha: .1),
                child: Icon(module.icon, color: HGColors.red)),
            const Spacer(),
            Text(module.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 4),
            Text('${module.features.length} features',
                style: const TextStyle(color: HGColors.muted, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

class ProfileRow extends StatelessWidget {
  const ProfileRow({required this.label, required this.value, super.key});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      color: HGColors.muted, fontWeight: FontWeight.w800))),
          Expanded(
              child: Text(value,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w900))),
        ],
      ),
    );
  }
}

class _PlanMini extends StatelessWidget {
  const _PlanMini(
      {required this.title, required this.detail, required this.icon});

  final String title;
  final String detail;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 210,
      margin: const EdgeInsets.only(right: 12, bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: HGColors.black,
        borderRadius: BorderRadius.circular(26),
        image: DecorationImage(
          image: const AssetImage('assets/images/highgrade-hero-bg.jpg'),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
              HGColors.black.withValues(alpha: .74), BlendMode.darken),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: .1),
              child: Icon(icon, color: Colors.white)),
          const Spacer(),
          Text(title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(detail, style: const TextStyle(color: Color(0xFFD5D9E2))),
        ],
      ),
    );
  }
}

class _LogoMark extends StatelessWidget {
  const _LogoMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: HGColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Image.asset(
          'assets/images/highgrade-logo.png',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Center(
              child: Icon(Icons.fitness_center_rounded, color: HGColors.red)),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.text, this.dark = false});

  final String text;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withValues(alpha: .08)
            : HGColors.red.withValues(alpha: .08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
            color: dark
                ? Colors.white.withValues(alpha: .12)
                : HGColors.red.withValues(alpha: .18)),
      ),
      child: Text(text,
          style: TextStyle(
              color: dark ? Colors.white : HGColors.red,
              fontWeight: FontWeight.w900,
              fontSize: 12)),
    );
  }
}

class _SmallTag extends StatelessWidget {
  const _SmallTag(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: HGColors.red.withValues(alpha: .08),
          borderRadius: BorderRadius.circular(999)),
      child: Text(label,
          style: const TextStyle(
              color: HGColors.red, fontSize: 11, fontWeight: FontWeight.w800)),
    );
  }
}

class _SearchBox extends StatelessWidget {
  const _SearchBox({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return HGCard(
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: const Icon(Icons.search_rounded),
          suffixIcon: const Icon(Icons.tune_rounded),
        ),
      ),
    );
  }
}

class FeatureMini {
  const FeatureMini(this.label, this.icon);
  final String label;
  final IconData icon;
}

class Exercise {
  const Exercise(
      {required this.name,
      required this.muscle,
      required this.equipment,
      required this.tags,
      required this.icon});
  final String name;
  final String muscle;
  final String equipment;
  final List<String> tags;
  final IconData icon;
}

class Meal {
  const Meal(this.title, this.detail, this.calories, this.icon);
  final String title;
  final String detail;
  final String calories;
  final IconData icon;
}

class Recipe {
  const Recipe({
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.fiber,
    required this.category,
    required this.icon,
    required this.colors,
    this.timeMinutes = 0,
    this.favorite = false,
  });

  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final int fiber;
  final String category;
  final IconData icon;
  final List<Color> colors;
  final int timeMinutes;
  final bool favorite;
}

class FeatureModule {
  const FeatureModule(
      {required this.title,
      required this.description,
      required this.icon,
      required this.features});
  final String title;
  final String description;
  final IconData icon;
  final List<String> features;
}

const demoExercises = [
  Exercise(
      name: 'Barbell Bench Press',
      muscle: 'Chest',
      equipment: 'Barbell',
      tags: ['Intermediate', 'Machine', 'Push'],
      icon: Icons.fitness_center_rounded),
  Exercise(
      name: 'Dumbbell Squat',
      muscle: 'Legs',
      equipment: 'Dumbbell',
      tags: ['Beginner', 'Dumbbell', 'Strength'],
      icon: Icons.accessibility_new_rounded),
  Exercise(
      name: 'Lat Pulldown',
      muscle: 'Back',
      equipment: 'Cable',
      tags: ['Intermediate', 'Machine', 'Pull'],
      icon: Icons.sports_gymnastics_rounded),
  Exercise(
      name: 'Push Up',
      muscle: 'Chest',
      equipment: 'Bodyweight',
      tags: ['Beginner', 'Bodyweight', 'Favorites'],
      icon: Icons.self_improvement_rounded),
  Exercise(
      name: 'Deadlift',
      muscle: 'Posterior Chain',
      equipment: 'Barbell',
      tags: ['Advanced', 'Strength'],
      icon: Icons.line_weight_rounded),
];

const demoMeals = [
  Meal('Breakfast', 'Egg whites, oats, banana, black coffee', '520 kcal',
      Icons.breakfast_dining_rounded),
  Meal('Lunch', 'Chicken rice bowl with vegetables', '690 kcal',
      Icons.lunch_dining_rounded),
  Meal('Snack', 'Greek yogurt and almonds', '260 kcal', Icons.cookie_rounded),
  Meal('Dinner', 'Paneer salad with millet roti', '540 kcal',
      Icons.dinner_dining_rounded),
];

const demoRecipes = [
  Recipe(
      name: 'Honey and Lemon Water',
      calories: 8,
      protein: 0,
      carbs: 2,
      fat: 0,
      fiber: 0,
      category: 'Breakfast',
      icon: Icons.local_drink_rounded,
      timeMinutes: 3,
      colors: [Color(0xFFFFD166), Color(0xFFFF8A00)]),
  Recipe(
      name: 'Green Protein Smoothie',
      calories: 304,
      protein: 28,
      carbs: 36,
      fat: 6,
      fiber: 7,
      category: 'Breakfast',
      icon: Icons.blender_rounded,
      colors: [Color(0xFF16A34A), Color(0xFF86EFAC)],
      favorite: true),
  Recipe(
      name: 'Chocolate Banana Protein Smoothie Bowl',
      calories: 384,
      protein: 32,
      carbs: 48,
      fat: 9,
      fiber: 8,
      category: 'Breakfast',
      icon: Icons.icecream_rounded,
      colors: [Color(0xFF7C2D12), Color(0xFFF59E0B)]),
  Recipe(
      name: 'Protein-Packed Overnight Oats',
      calories: 319,
      protein: 26,
      carbs: 42,
      fat: 7,
      fiber: 9,
      category: 'Breakfast',
      icon: Icons.breakfast_dining_rounded,
      colors: [Color(0xFF94A3B8), Color(0xFFF8FAFC)]),
  Recipe(
      name: 'Protein Pancakes',
      calories: 279,
      protein: 24,
      carbs: 34,
      fat: 6,
      fiber: 5,
      category: 'Breakfast',
      icon: Icons.bakery_dining_rounded,
      colors: [Color(0xFFFBBF24), Color(0xFFB45309)]),
  Recipe(
      name: 'Protein Energy Balls',
      calories: 177,
      protein: 12,
      carbs: 18,
      fat: 7,
      fiber: 4,
      category: 'Snack',
      icon: Icons.cookie_rounded,
      colors: [Color(0xFF92400E), Color(0xFFFCD34D)]),
  Recipe(
      name: 'Protein Roti',
      calories: 129,
      protein: 10,
      carbs: 18,
      fat: 3,
      fiber: 5,
      category: 'Lunch',
      icon: Icons.flatware_rounded,
      colors: [Color(0xFFD97706), Color(0xFFFDE68A)]),
  Recipe(
      name: 'High Protein Ice Cream',
      calories: 336,
      protein: 30,
      carbs: 34,
      fat: 8,
      fiber: 3,
      category: 'Snack',
      icon: Icons.icecream_rounded,
      colors: [Color(0xFF64748B), Color(0xFFE2E8F0)]),
  Recipe(
      name: 'Burrito Bowl',
      calories: 369,
      protein: 29,
      carbs: 46,
      fat: 10,
      fiber: 10,
      category: 'Lunch',
      icon: Icons.rice_bowl_rounded,
      colors: [Color(0xFFDC2626), Color(0xFF16A34A)]),
  Recipe(
      name: 'Chickpea Salad',
      calories: 275,
      protein: 14,
      carbs: 38,
      fat: 8,
      fiber: 11,
      category: 'Lunch',
      icon: Icons.eco_rounded,
      colors: [Color(0xFF65A30D), Color(0xFFFACC15)]),
  Recipe(
      name: 'Chicken Salad',
      calories: 333,
      protein: 33,
      carbs: 12,
      fat: 17,
      fiber: 6,
      category: 'Dinner',
      icon: Icons.restaurant_rounded,
      colors: [Color(0xFF22C55E), Color(0xFFE11D48)]),
  Recipe(
      name: 'Quinoa and Black Bean Bowl',
      calories: 402,
      protein: 24,
      carbs: 58,
      fat: 9,
      fiber: 13,
      category: 'Dinner',
      icon: Icons.rice_bowl_rounded,
      colors: [Color(0xFF0F172A), Color(0xFF38BDF8)]),
  Recipe(
      name: 'Vegetable Stir-Fry',
      calories: 119,
      protein: 7,
      carbs: 18,
      fat: 4,
      fiber: 7,
      category: 'Dinner',
      icon: Icons.dinner_dining_rounded,
      colors: [Color(0xFF16A34A), Color(0xFFF97316)],
      timeMinutes: 10),
];

const authenticationModule = FeatureModule(
  title: 'Authentication',
  description: 'Role-aware access for members, trainers, and admins.',
  icon: Icons.lock_rounded,
  features: [
    'User Login',
    'Admin Login',
    'Trainer Login',
    'Role-based Permissions',
    'OTP Login',
    'Google/Apple Login Support',
    'Forgot Password',
  ],
);

const dashboardModule = FeatureModule(
  title: 'Dashboard',
  description: 'Daily command center for users and admins.',
  icon: Icons.dashboard_rounded,
  features: [
    'User Dashboard',
    'Current Weight',
    'Goal Weight',
    'Calories Today',
    'Water Intake',
    'Steps',
    'Workout Status',
    'Meal Completion',
    'Today\'s Streak',
    'Weekly Progress',
    'Pending Verification',
    'Admin Dashboard',
    'Total Clients',
    'Active Clients',
    'New Registrations',
    'Pending Meal Verifications',
    'Pending Progress Photos',
    'Missed Meals',
    'Revenue',
    'Notifications',
  ],
);

const workoutsModule = FeatureModule(
  title: 'Workouts',
  description:
      'Workout planning, history, timers, records, and smart generation.',
  icon: Icons.fitness_center_rounded,
  features: [
    'Exercise Library',
    'Workout Plans',
    'Custom Workouts',
    'AI Workout Generator',
    'Workout History',
    'Rest Timer',
    'Personal Records'
  ],
);

const workoutBuilderModule = FeatureModule(
  title: 'Workout Builder',
  description: 'Admin-created workouts assigned to clients with media proof.',
  icon: Icons.edit_note_rounded,
  features: [
    'Admin creates Chest Day / Back Day / Leg Day',
    'Exercises',
    'Sets',
    'Reps',
    'Rest',
    'Video',
    'GIF',
    'Timer',
    'Notes',
    'Assign to Client',
    'Workout Completed Proof',
    'Pending Workout Verification',
  ],
);

const exercisesModule = FeatureModule(
  title: 'Exercises',
  description: 'Searchable exercise database with media and filters.',
  icon: Icons.sports_martial_arts_rounded,
  features: [
    'Images & Videos',
    'Muscle Groups',
    'Equipment Filter',
    'Difficulty Levels',
    'Search',
    'Favorites'
  ],
);

const nutritionModule = FeatureModule(
  title: 'Nutrition',
  description: 'Meal tracking, uploads, macros, scanner, and hydration.',
  icon: Icons.restaurant_menu_rounded,
  features: [
    'Meal Plans',
    'Calorie Tracker',
    'Macro Tracker',
    'Barcode Scanner',
    'Water Tracker',
    'Breakfast Upload',
    'Lunch Upload',
    'Dinner Upload',
    'Snack Upload',
    'Food Name',
    'Quantity',
    'Calories',
    'Protein',
    'Carbs',
    'Fat',
    'Meal Image',
    'Before / After Meal View',
    'AI Meal Planner'
  ],
);

const mealVerificationModule = FeatureModule(
  title: 'Meal Verification',
  description: 'Admin approval workflow for every client meal upload.',
  icon: Icons.fact_check_rounded,
  features: [
    'User Uploads Meal',
    'Status: Pending',
    'Admin Reviews Image',
    'Admin Reviews Calories',
    'Approve Meal',
    'Reject Meal',
    'Reject Reason',
    'User Uploads Again',
    'Approved Meal Locked',
    'Streak Updated',
    'Pending Meal Verifications',
    'Bulk Meal Approval',
  ],
);

const dietBuilderModule = FeatureModule(
  title: 'Diet Plan Builder',
  description: 'Admin diet templates for daily, weekly, and monthly plans.',
  icon: Icons.menu_book_rounded,
  features: [
    'Create Day 1 Plan',
    'Breakfast Builder',
    'Lunch Builder',
    'Dinner Builder',
    'Snack Builder',
    'Calories',
    'Protein',
    'Carbs',
    'Fat',
    'Meal Timing',
    'Repeat Meals',
    'Weekly Templates',
    'Monthly Templates',
    'PDF Export',
    'Assign Diet to Client',
  ],
);

const progressModule = FeatureModule(
  title: 'Progress',
  description:
      'Weight, measurements, strength, analytics, charts, and reports.',
  icon: Icons.show_chart_rounded,
  features: [
    'Weight Tracking',
    'Body Measurements',
    'Strength Progress',
    'Workout Analytics',
    'Charts & Reports',
    'Progress Photos'
  ],
);

const clientProfileModule = FeatureModule(
  title: 'Client Profile',
  description: 'Complete client health, goal, and coach assignment profile.',
  icon: Icons.badge_rounded,
  features: [
    'Personal Details',
    'Height',
    'Weight',
    'Age',
    'Gender',
    'Goal',
    'Medical Conditions',
    'Allergies',
    'Activity Level',
    'BMR',
    'BMI',
    'TDEE',
    'Coach Assigned',
  ],
);

const dailyCheckInModule = FeatureModule(
  title: 'Daily Check-in',
  description: 'Morning and evening uploads with admin approval.',
  icon: Icons.today_rounded,
  features: [
    'Morning Weight',
    'Morning Waist',
    'Sleep Hours',
    'Water Intake',
    'Mood',
    'Evening Workout Completed',
    'Evening Cardio Completed',
    'Steps',
    'Notes',
    'Admin Approval',
    'Pending Weight',
    'Pending Measurements',
  ],
);

const progressPhotosModule = FeatureModule(
  title: 'Progress Photos',
  description: 'Photo proof and visual transformation approval workflow.',
  icon: Icons.photo_camera_rounded,
  features: [
    'Upload Front Photo',
    'Upload Back Photo',
    'Upload Left Photo',
    'Upload Right Photo',
    'Weekly Comparison',
    'Monthly Comparison',
    'Admin Approval',
    'Pending Progress Photos',
  ],
);

const measurementsModule = FeatureModule(
  title: 'Measurements',
  description: 'Body measurements, composition, and graph tracking.',
  icon: Icons.straighten_rounded,
  features: [
    'Weight',
    'Chest',
    'Waist',
    'Hip',
    'Arm',
    'Thigh',
    'Neck',
    'Body Fat',
    'BMI',
    'Muscle %',
    'Measurement Graph',
    'Admin Measurement Approval',
  ],
);

const streakSystemModule = FeatureModule(
  title: 'Streak System',
  description: 'Improved streak logic with approval-based perfect days.',
  icon: Icons.local_fire_department_rounded,
  features: [
    'Breakfast Approved',
    'Lunch Approved',
    'Dinner Approved',
    'Workout Completed',
    'Water Goal Achieved',
    'All Required Tasks Complete',
    'Current Streak',
    'Longest Streak',
    'Total Perfect Days',
    'Missed Requirement Resets Streak',
    '7-day Badge',
    '30-day Badge',
    '100-day Badge',
    'Manual Admin Streak Override',
  ],
);

const timelineModule = FeatureModule(
  title: 'Progress Timeline',
  description: 'Day-wise client history with meals, workouts, and notes.',
  icon: Icons.timeline_rounded,
  features: [
    'Day-wise History',
    'Meals',
    'Workout',
    'Weight',
    'Photos',
    'Admin Notes',
    'Graphs',
    'Progress Calendar Link',
  ],
);

const aiModule = FeatureModule(
  title: 'AI Features',
  description: 'AI coach layer for workout, meals, form, and chat assistance.',
  icon: Icons.auto_awesome_rounded,
  features: [
    'AI Fitness Coach',
    'AI Meal Planner',
    'AI Workout Generator',
    'AI Form Correction',
    'AI Chat Assistant',
    'AI Food Recognition from Photos',
    'Automatic Calorie Estimation',
    'Workout Recommendations',
    'Diet Suggestions',
    'Weekly Progress Summary',
  ],
);

const gymModule = FeatureModule(
  title: 'Gym Features',
  description: 'In-gym operations for members.',
  icon: Icons.qr_code_scanner_rounded,
  features: [
    'QR Check-in',
    'Membership Management',
    'Attendance History',
    'Class Booking',
    'Gym Announcements'
  ],
);

const trainerModule = FeatureModule(
  title: 'Trainer Features',
  description: 'Trainer workflows for coaching clients.',
  icon: Icons.supervisor_account_rounded,
  features: [
    'Assign Workouts',
    'Create Meal Plans',
    'Client Progress',
    'Chat with Clients',
    'Video Consultation'
  ],
);

const chatModule = FeatureModule(
  title: 'Coach Chat',
  description: 'User to admin/trainer coaching communication.',
  icon: Icons.chat_bubble_rounded,
  features: [
    'User ↔ Admin Chat',
    'Text Messages',
    'Voice Notes',
    'Image Messages',
    'PDF Attachments',
    'Workout Video Attachments',
    'Read Status',
    'Typing Indicator',
    'Chat with Coach',
    'Chat with Clients',
  ],
);

const membershipsModule = FeatureModule(
  title: 'Memberships',
  description: 'Plans, renewals, expiry and member benefits.',
  icon: Icons.card_membership_rounded,
  features: [
    'Membership Plans',
    'Membership Purchase',
    'Expiry Tracking',
    'Coupons',
    'Premium Upgrades'
  ],
);

const subscriptionModule = FeatureModule(
  title: 'Subscription',
  description: 'Plans, renewal, coupons, invoices, and expiry reminders.',
  icon: Icons.subscriptions_rounded,
  features: [
    'Plans',
    'Renewal',
    'Coupons',
    'Payment',
    'Invoices',
    'Expiry Reminder',
    'Membership Purchase',
    'Invoice History',
  ],
);

const paymentsModule = FeatureModule(
  title: 'Payments',
  description: 'Payment flows for membership and invoices.',
  icon: Icons.payments_rounded,
  features: [
    'Membership Purchase',
    'Online Payments',
    'Coupons',
    'Invoice History',
    'Payment Receipts'
  ],
);

const socialModule = FeatureModule(
  title: 'Social',
  description:
      'Highgrade community with posts, videos, challenges, and friends.',
  icon: Icons.groups_rounded,
  features: [
    'Friends',
    'Leaderboards',
    'Challenges',
    'Achievements',
    'Workout Sharing',
    'Upload Pics',
    'Upload Videos'
  ],
);

const notificationsModule = FeatureModule(
  title: 'Notifications',
  description: 'Reminder and update center for members.',
  icon: Icons.notifications_rounded,
  features: [
    'Breakfast Reminder',
    'Lunch Reminder',
    'Dinner Reminder',
    'Workout Reminders',
    'Meal Reminders',
    'Water Reminders',
    'Admin Verification',
    'Diet Changes',
    'Workout Changes',
    'Achievements',
    'Membership Expiry',
    'Challenge Updates'
  ],
);

const rewardsModule = FeatureModule(
  title: 'Rewards',
  description: 'Gamified progress rewards for consistency.',
  icon: Icons.emoji_events_rounded,
  features: [
    'Coins',
    'XP',
    'Levels',
    'Achievements',
    'Referral Rewards',
    'Reward Milestones',
  ],
);

const leaderboardModule = FeatureModule(
  title: 'Leaderboard',
  description: 'Competitive social proof and member ranking.',
  icon: Icons.leaderboard_rounded,
  features: [
    'Top Streak',
    'Weight Loss',
    'Muscle Gain',
    'Workout Completion',
    'Calories Burned',
    'Challenge Ranking',
  ],
);

const analyticsModule = FeatureModule(
  title: 'Analytics',
  description: 'Visual graphs for client and admin progress review.',
  icon: Icons.analytics_rounded,
  features: [
    'Weight Graph',
    'Calories Graph',
    'Protein Graph',
    'Workout Graph',
    'Water Graph',
    'Body Fat Graph',
    'Steps Graph',
    'BMI Graph',
  ],
);

const calendarModule = FeatureModule(
  title: 'Calendar',
  description: 'Training, meals, progress, holidays, and cheat days.',
  icon: Icons.calendar_month_rounded,
  features: [
    'Workout Calendar',
    'Meal Calendar',
    'Progress Calendar',
    'Holiday',
    'Cheat Day',
    'Gym Attendance Calendar',
  ],
);

const fileUploadsModule = FeatureModule(
  title: 'File Uploads',
  description: 'Static upload flows for evidence and documents.',
  icon: Icons.cloud_upload_rounded,
  features: [
    'Meal Images',
    'Workout Videos',
    'Progress Photos',
    'Medical Reports',
    'PDF Uploads',
    'Image Upload Status',
  ],
);

const wearablesModule = FeatureModule(
  title: 'Wearable Integration',
  description: 'Wearable integrations and health signals.',
  icon: Icons.watch_rounded,
  features: [
    'Apple Watch',
    'Wear OS',
    'Fitbit',
    'Heart Rate Tracking',
    'Step Counter'
  ],
);

const premiumModule = FeatureModule(
  title: 'Premium Features',
  description: 'Paid member upgrades and advanced capability.',
  icon: Icons.workspace_premium_rounded,
  features: [
    'Unlimited AI Coach',
    'Advanced Analytics',
    'Personalized Plans',
    'Cloud Backup',
    'Ad-Free Experience'
  ],
);

const adminModule = FeatureModule(
  title: 'Admin Panel',
  description: 'Admin dashboard for complete gym operations.',
  icon: Icons.admin_panel_settings_rounded,
  features: [
    'User Management',
    'Gym Management',
    'Trainer Management',
    'Membership Management',
    'Payments',
    'Reports & Analytics',
    'Notifications',
    'Content Management',
    'Create Diet Plan',
    'Create Workout Plan',
    'Assign Trainer',
    'Verify Meals',
    'Verify Photos',
    'Verify Measurements',
    'Chat with Clients',
    'Export Reports',
    'Send Notifications',
    'Suspend User',
    'Reset Streak',
    'Bulk Actions',
  ],
);

const adminVerificationModule = FeatureModule(
  title: 'Admin Verification',
  description: 'Approval queue for meals, workouts, photos, and check-ins.',
  icon: Icons.verified_rounded,
  features: [
    'Pending Meals',
    'Pending Workout',
    'Pending Photos',
    'Pending Measurements',
    'Pending Weight',
    'Reject Reason',
    'Approve All',
    'Bulk Approval',
    'Meal Locked After Approval',
    'Streak Update After Approval',
  ],
);

const ownerModule = FeatureModule(
  title: 'Gym Owner Panel',
  description: 'Owner-level business tools and revenue controls.',
  icon: Icons.business_center_rounded,
  features: [
    'Manage Members',
    'Manage Trainers',
    'Attendance',
    'Membership Plans',
    'Revenue Dashboard',
    'Equipment Management',
    'Class Scheduling'
  ],
);

const attendanceModule = FeatureModule(
  title: 'Attendance',
  description: 'Gym and workout attendance tracking.',
  icon: Icons.how_to_reg_rounded,
  features: [
    'Workout Attendance',
    'Gym Attendance',
    'Missed Workout',
    'Late Workout',
    'Attendance Calendar',
    'Admin Attendance Review',
  ],
);

const reportsModule = FeatureModule(
  title: 'Reports',
  description:
      'Charts and reporting for members, trainers, admins, and owners.',
  icon: Icons.bar_chart_rounded,
  features: [
    'Weekly Reports',
    'Monthly Reports',
    'Yearly Reports',
    'Calories',
    'Protein',
    'Workout %',
    'Weight',
    'BMI',
    'Water',
    'Steps',
    'Streak',
    'Revenue Dashboard',
    'Attendance Reports',
  ],
);

const databaseTablesModule = FeatureModule(
  title: 'Database Tables',
  description: 'Suggested future schema map for production integration.',
  icon: Icons.storage_rounded,
  features: [
    'users',
    'admins',
    'trainers',
    'user_profiles',
    'diet_plans',
    'diet_plan_items',
    'workout_plans',
    'workout_exercises',
    'meal_logs',
    'meal_images',
    'meal_verifications',
    'workout_logs',
    'workout_verifications',
    'progress_photos',
    'body_measurements',
    'daily_checkins',
    'streaks',
    'achievements',
    'notifications',
    'chats',
    'messages',
    'subscriptions',
    'payments',
    'reports',
    'rewards',
    'badges',
    'attendance',
    'water_logs',
    'step_logs',
    'admin_notes',
    'activity_logs',
  ],
);

const enterpriseWorkflowModule = FeatureModule(
  title: 'Enterprise Workflow',
  description: 'End-to-end flow from plan assignment to streak reward.',
  icon: Icons.account_tree_rounded,
  features: [
    'Admin Creates Diet',
    'Assign Diet to Client',
    'Client Receives Notification',
    'Client Uploads Breakfast Photo',
    'Status: Pending',
    'Admin Reviews',
    'Approve / Reject',
    'Client Uploads Lunch',
    'Approve / Reject Lunch',
    'Client Uploads Dinner',
    'Approve / Reject Dinner',
    'Workout Completed',
    'Daily Check Completed',
    'System Validates Required Tasks',
    'All Complete: Streak +1',
    'Award XP',
    'Not Complete: Reset Streak to 0',
  ],
);

const settingsModule = FeatureModule(
  title: 'Settings',
  description: 'App settings, privacy, reminders, and preferences.',
  icon: Icons.settings_rounded,
  features: [
    'Profile Settings',
    'Notification Settings',
    'Privacy',
    'Theme Preferences',
    'Language',
    'Support'
  ],
);

const securityModule = FeatureModule(
  title: 'Security',
  description: 'Security defaults for a future integrated production app.',
  icon: Icons.verified_user_rounded,
  features: [
    'Biometric Lock',
    'Secure Sessions',
    'Cloud Backup',
    'Device Management',
    'Privacy Controls'
  ],
);

void _openFeature(BuildContext context, FeatureModule module) {
  Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => FeatureDetailPage(module: module)));
}

String _featureSubtitle(String module, String feature) {
  if (module.contains('Verification') || feature.contains('Approve')) {
    return 'Review the submitted item, add a decision, and update the client status.';
  }
  if (feature.contains('Upload') ||
      feature.contains('Photo') ||
      feature.contains('Image')) {
    return 'Open the capture flow, attach media, and save it into the active client record.';
  }
  if (feature.contains('Report') ||
      feature.contains('Graph') ||
      feature.contains('Analytics')) {
    return 'Open the live report view with progress metrics and export-ready summaries.';
  }
  if (feature.contains('Chat') || feature.contains('Message')) {
    return 'Open the conversation workspace with read status and attachments.';
  }
  return 'Open this workspace, update the status, and keep the session data in sync.';
}

void _openFeatureAction(BuildContext context, String module, String feature) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(feature,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text(module, style: const TextStyle(color: HGColors.muted)),
          const SizedBox(height: 18),
          HGCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileRow(label: 'Status', value: 'Ready'),
                ProfileRow(label: 'Assigned', value: 'Bhadri'),
                ProfileRow(label: 'Coach', value: 'Manoj'),
                ProfileRow(label: 'Last Update', value: 'Today'),
              ],
            ),
          ),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _toast(context, '$feature saved');
                  },
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Save'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    _toast(context, '$feature opened');
                  },
                  icon: const Icon(Icons.open_in_new_rounded),
                  label: const Text('Open'),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

void _openMealReview(
    BuildContext context, HighgradeStore store, DemoMealLog meal) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: .9,
      minChildSize: .55,
      maxChildSize: .96,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text('${meal.client} - ${meal.meal}',
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('Review food details and photo proof before verification.',
              style: const TextStyle(color: HGColors.muted)),
          const SizedBox(height: 16),
          const _MealPhotoPreview(title: 'Uploaded Meal Photo'),
          const SizedBox(height: 12),
          Row(
            children: const [
              Expanded(child: _MealPhotoPreview(title: 'Before')),
              SizedBox(width: 10),
              Expanded(child: _MealPhotoPreview(title: 'After')),
            ],
          ),
          const SizedBox(height: 12),
          HGCard(
            child: Column(
              children: [
                ProfileRow(label: 'Food', value: meal.food),
                ProfileRow(label: 'Calories', value: '${meal.calories} kcal'),
                ProfileRow(label: 'Protein', value: '${meal.protein} g'),
                const ProfileRow(label: 'Carbs', value: '54 g'),
                const ProfileRow(label: 'Fat', value: '14 g'),
                ProfileRow(label: 'Current Status', value: meal.status),
                if (meal.reason.isNotEmpty)
                  ProfileRow(label: 'Reject Reason', value: meal.reason),
              ],
            ),
          ),
          if (meal.status == 'Pending')
            Row(
              children: [
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      store.approveMeal(meal);
                      Navigator.pop(context);
                      _toast(
                          context, 'Meal approved, locked, and streak checked');
                    },
                    icon: const Icon(Icons.check_rounded),
                    label: const Text('Verify Meal'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      store.rejectMeal(meal);
                      Navigator.pop(context);
                      _toast(context, 'Meal rejected with reason');
                    },
                    icon: const Icon(Icons.close_rounded),
                    label: const Text('Reject'),
                  ),
                ),
              ],
            ),
        ],
      ),
    ),
  );
}

void _openClientMonitor(
    BuildContext context, HighgradeStore store, DemoClient client) {
  showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => DraggableScrollableSheet(
      expand: false,
      initialChildSize: .86,
      minChildSize: .5,
      maxChildSize: .96,
      builder: (context, controller) => ListView(
        controller: controller,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
        children: [
          Text(client.name,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
          const SizedBox(height: 6),
          Text('${client.goal} | Coach ${client.coach}',
              style: const TextStyle(color: HGColors.muted)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                    onPressed: () =>
                        _openSocioProfile(context, store, client.name),
                    icon: const Icon(Icons.account_circle_rounded),
                    label: const Text('View Profile')),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                    onPressed: () {
                      store.setClientActive(client, !client.active);
                      Navigator.pop(context);
                      _toast(
                          context,
                          client.active
                              ? 'User activated'
                              : 'User made inactive');
                    },
                    icon: Icon(client.active
                        ? Icons.person_off_rounded
                        : Icons.person_add_alt_rounded),
                    label: Text(client.active ? 'Inactive' : 'Activate')),
              ),
            ],
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
              onPressed: () {
                store.deleteClient(client);
                Navigator.pop(context);
                _toast(context, 'User deleted by admin');
              },
              icon: const Icon(Icons.delete_outline_rounded),
              label: const Text('Delete User')),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                  child: MetricTile(
                      label: 'Current',
                      value: '${client.weight.toStringAsFixed(0)}kg',
                      suffix: 'weight',
                      icon: Icons.monitor_weight_rounded,
                      color: HGColors.red)),
              const SizedBox(width: 10),
              Expanded(
                  child: MetricTile(
                      label: 'Goal',
                      value: '${client.goalWeight.toStringAsFixed(0)}kg',
                      suffix: 'target',
                      icon: Icons.flag_rounded,
                      color: HGColors.green)),
            ],
          ),
          const SizedBox(height: 12),
          HGCard(
            child: Column(
              children: [
                ProfileRow(label: 'Age / Gender', value: '29 | Male'),
                const ProfileRow(label: 'Height', value: '174 cm'),
                const ProfileRow(
                    label: 'Medical', value: 'No major conditions'),
                const ProfileRow(label: 'Allergies', value: 'None'),
                const ProfileRow(label: 'Activity Level', value: 'Moderate'),
                const ProfileRow(
                    label: 'BMR / BMI / TDEE', value: '1618 / 25.1 / 2346'),
              ],
            ),
          ),
          SectionHeader(title: 'Daily Check-in'),
          HGCard(
            child: Column(
              children: const [
                ProfileRow(
                    label: 'Morning',
                    value: 'Weight 76kg | Waist 82cm | Sleep 7h'),
                ProfileRow(label: 'Water / Mood', value: '2.4L | Focused'),
                ProfileRow(
                    label: 'Evening',
                    value: 'Workout yes | Cardio yes | 8420 steps'),
                ProfileRow(label: 'Admin Status', value: 'Pending approval'),
              ],
            ),
          ),
          SectionHeader(title: 'Meal Logs'),
          for (final meal
              in store.meals.where((meal) => meal.client == client.name))
            HGCard(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const CircleAvatar(
                    backgroundColor: HGColors.black,
                    child: Icon(Icons.restaurant_rounded, color: Colors.white)),
                title: Text('${meal.meal} - ${meal.status}',
                    style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(
                    '${meal.food}\n${meal.calories} kcal | ${meal.protein}g protein'),
              ),
            ),
          SectionHeader(title: 'Progress'),
          const ChartCard(
              title: 'Weight / Calories / Protein',
              subtitle: 'Weekly graph summary'),
          const ChartCard(
              title: 'Photos & Measurements',
              subtitle: 'Front, back, left, right comparison ready'),
        ],
      ),
    ),
  );
}

void _openNotifications(BuildContext context) {
  _openFeature(context, notificationsModule);
}

void _toast(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}
