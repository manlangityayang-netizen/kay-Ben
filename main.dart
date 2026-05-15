import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MoodApp());
}

ValueNotifier<bool> isDarkMode = ValueNotifier(false);

class MoodEntry {
  final Color color;
  final String note;
  final DateTime date;

  MoodEntry({
    required this.color,
    required this.note,
    required this.date,
  });
}

List<MoodEntry> moodEntries = [];


class MoodApp extends StatelessWidget {
  const MoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isDarkMode,
      builder: (context, dark, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Mood Gradient Journal',

          // 🌸 LIGHT THEME (BABY PINK)
          theme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.light,
            scaffoldBackgroundColor: const Color(0xFFFFF5F8),

            colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xFFFFB6C1),
              brightness: Brightness.light,
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFFFD6E0),
              foregroundColor: Color(0xFF5A3E4B),
              centerTitle: true,
              elevation: 4,
            ),

            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFFFC1D6),
                foregroundColor: Color(0xFF5A3E4B),
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),

          // 🌙 DARK THEME
          darkTheme: ThemeData(
            useMaterial3: true,
            brightness: Brightness.dark,
            scaffoldBackgroundColor: const Color(0xFF121212),

            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              brightness: Brightness.dark,
            ),

            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFF1E1E1E),
              foregroundColor: Colors.white,
              centerTitle: true,
              elevation: 4,
            ),

            cardColor: const Color(0xFF1E1E1E),
          ),

          // 🌙 SWITCH THEME
          themeMode: dark ? ThemeMode.dark : ThemeMode.light,

          home: const MainNavigation(),
        );
      },
    );
  }
}

// ================= MAIN NAVIGATION =================

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int currentIndex = 0;

  final screens = const [
    HomeScreen(),
    CalendarScreen(),
    InsightsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      body: screens[currentIndex],

      // 🌸 3D FLOATING NAVIGATION
      bottomNavigationBar: Padding(
  padding: const EdgeInsets.all(14),
  child: Container(
    decoration: BoxDecoration(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(35),
      boxShadow: [
        BoxShadow(
          color: Colors.pink.withOpacity(0.2),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    ),
    child: NavigationBar(
      backgroundColor: Colors.transparent,

      indicatorColor: Theme.of(context).brightness ==
              Brightness.dark
          ? Colors.pink.shade700
          : const Color(0xFFFFD6E0),

      selectedIndex: currentIndex,

      labelBehavior:
          NavigationDestinationLabelBehavior.onlyShowSelected,

      onDestinationSelected: (index) {
        setState(() {
          currentIndex = index;
        });
      },

      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          label: 'Home',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.calendar_month_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          label: 'Calendar',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.bar_chart_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          label: 'Insights',
        ),

        NavigationDestination(
          icon: Icon(
            Icons.settings_rounded,
            color: Theme.of(context).iconTheme.color,
          ),
          label: 'Settings',
        ),
      ],
    ),
  ),
),
    );
  }
}

// ================= DRAWER =================

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFFFFF5F8),
      child: ListView(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 20),
            height: 180,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFFFB6C1),
                  Color(0xFFFFD6E0),
                ],
              ),
            ),
            child: const Text(
              'Mood Gradient\nJournal 🌸',
              style: TextStyle(
                color: Color(0xFF5A3E4B),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const ListTile(
            leading: Icon(Icons.home_rounded),
            title: Text('Home'),
          ),

          const ListTile(
            leading: Icon(Icons.calendar_today_rounded),
            title: Text('Calendar'),
          ),

          const ListTile(
            leading: Icon(Icons.bar_chart_rounded),
            title: Text('Insights'),
          ),

          const ListTile(
            leading: Icon(Icons.settings_rounded),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}

// ================= COLOR WHEEL =================

/// Replace your current ColorWheel and WheelPainter with this version.
/// It shows a true multi-color gradient wheel and lets the user select
/// any color by dragging or tapping.

class ColorWheel extends StatefulWidget {
  final ValueChanged<Color> onColorChanged;

  const ColorWheel({
    super.key,
    required this.onColorChanged,
  });

  @override
  State<ColorWheel> createState() => _ColorWheelState();
}

class _ColorWheelState extends State<ColorWheel> {
  static const double wheelSize = 200;
  static const double radius = wheelSize / 2;

  Offset? selectedPosition;

  @override
  void initState() {
    super.initState();

    // Default selected color (center = white/pastel)
    selectedPosition = const Offset(radius, radius);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      widget.onColorChanged(Colors.white);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) => _updateColor(details.localPosition),
      onPanDown: (details) => _updateColor(details.localPosition),
      onPanUpdate: (details) => _updateColor(details.localPosition),
      child: SizedBox(
        width: wheelSize,
        height: wheelSize,
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(wheelSize, wheelSize),
              painter: WheelPainter(),
            ),

            // Selection indicator
            if (selectedPosition != null)
              Positioned(
                left: selectedPosition!.dx - 14,
                top: selectedPosition!.dy - 14,
                child: Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 4,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _updateColor(Offset position) {
    const center = Offset(radius, radius);

    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;

    final distance = sqrt(dx * dx + dy * dy);

    // Ignore touches outside the wheel
    if (distance > radius) return;

    // Hue based on angle
    final angle = atan2(dy, dx);
    final hue = (angle * 180 / pi + 360) % 360;

    // Saturation increases toward the edge
    final saturation = (distance / radius).clamp(0.0, 1.0);

    // Full brightness for vivid colors
    final color = HSVColor.fromAHSV(
      1.0,
      hue,
      saturation,
      1.0,
    ).toColor();

    setState(() {
      selectedPosition = position;
    });

    widget.onColorChanged(color);
  }
}

class WheelPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Outer rainbow wheel
    final sweepPaint = Paint()
      ..shader = SweepGradient(
        colors: const [
          Colors.red,
          Colors.orange,
          Colors.yellow,
          Colors.lime,
          Colors.green,
          Colors.teal,
          Colors.cyan,
          Colors.lightBlue,
          Colors.blue,
          Colors.indigo,
          Colors.purple,
          Colors.pink,
          Colors.red,
        ],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, sweepPaint);

    // White center fade to create pastel-to-vivid gradient
    final radialPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white,
          Colors.white.withOpacity(0.0),
        ],
        stops: const [0.0, 1.0],
      ).createShader(
        Rect.fromCircle(center: center, radius: radius),
      );

    canvas.drawCircle(center, radius, radialPaint);

    // Soft outer border
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = Colors.white.withOpacity(0.8);

    canvas.drawCircle(center, radius - 1.5, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ================= HOME SCREEN =================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color selectedColor = Colors.pink;
  final TextEditingController noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  String getMood(Color color) {
    final hue = HSLColor.fromColor(color).hue;

    if (hue < 30) return "Energetic 🔥";
    if (hue < 70) return "Happy ☀️";
    if (hue < 160) return "Peaceful 🌿";
    if (hue < 240) return "Calm 💙";
    if (hue < 300) return "Creative 💜";
    return "Relaxed 🌸";
  }

  void saveMood() {
    final mood = getMood(selectedColor);
    final note = noteController.text.trim();

    setState(() {
      moodEntries.insert(
        0,
        MoodEntry(
          color: selectedColor,
          note: note.isEmpty ? mood : note,
          date: DateTime.now(),
        ),
      );
    });

    noteController.clear();

    setState(() {}); // 🔥 refresh Home screen UI

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Saved: $mood 🌸")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mood Journal 🌸")),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [
            const Text("Select Mood"),

            const SizedBox(height: 20),

            ColorWheel(
              onColorChanged: (c) {
                setState(() => selectedColor = c);
              },
            ),

            const SizedBox(height: 20),

            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: selectedColor,
                shape: BoxShape.circle,
              ),
            ),

            const SizedBox(height: 20),

            TextField(
              controller: noteController,
              decoration: const InputDecoration(
                hintText: "Optional note",
              ),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: saveMood,
              child: const Text("Save Mood"),
            ),

            const SizedBox(height: 30),

            // ✅ ALWAYS SHOW SAVED MOODS HERE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Saved Moods (${moodEntries.length})",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 10),

            ...moodEntries.map((m) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: m.color),
                  title: Text(m.note),
                  subtitle: Text(m.date.toString()),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
// ================= CALENDAR SCREEN =================

// ================= CALENDAR SCREEN =================

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime selectedMonth = DateTime.now();

  // ✅ GET ALL MOODS FOR A DAY
  List<MoodEntry> getMoodsForDay(DateTime day) {
    return moodEntries.where((mood) {
      return mood.date.year == day.year &&
          mood.date.month == day.month &&
          mood.date.day == day.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth =
        DateUtils.getDaysInMonth(selectedMonth.year, selectedMonth.month);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mood Calendar 📅'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Text(
            '${selectedMonth.month}/${selectedMonth.year}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
              ),
              itemCount: daysInMonth,
              itemBuilder: (context, index) {

                final day = DateTime(
                  selectedMonth.year,
                  selectedMonth.month,
                  index + 1,
                );

                // ✅ ALL MOODS FOR THIS DAY
                final moods = getMoodsForDay(day);

                // ✅ NEWEST MOOD
                final latestMood =
                    moods.isNotEmpty ? moods.first : null;

                return GestureDetector(
                  onTap: () {

                    if (moods.isNotEmpty) {

                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            'Moods for ${day.day}/${day.month}',
                          ),

                          content: SizedBox(
                            width: double.maxFinite,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: moods.length,

                              itemBuilder: (context, i) {
                                final mood = moods[i];

                                return Card(
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: mood.color,
                                    ),

                                    title: Text(mood.note),

                                    subtitle: Text(
                                      '${mood.date.hour.toString().padLeft(2, '0')}:'
                                      '${mood.date.minute.toString().padLeft(2, '0')}',
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                  },

                  child: Container(
                    decoration: BoxDecoration(

                      // ✅ COLOR BASED ON NEWEST MOOD
                      color: latestMood?.color ??
                          Colors.grey.shade200,

                      borderRadius: BorderRadius.circular(10),
                    ),

                    child: Center(
                      child: Text(
                        '${index + 1}',

                        style: TextStyle(
                          fontWeight: FontWeight.bold,

                          color: latestMood != null
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
// ================= INSIGHTS SCREEN =================

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  Map<String, int> getMoodStats() {
    Map<String, int> stats = {
      "Energetic 🔥": 0,
      "Happy ☀️": 0,
      "Peaceful 🌿": 0,
      "Calm 💙": 0,
      "Creative 💜": 0,
      "Relaxed 🌸": 0,
    };

    for (final m in moodEntries) {
      final hue = HSLColor.fromColor(m.color).hue;

      String mood;
      if (hue < 30) mood = "Energetic 🔥";
      else if (hue < 70) mood = "Happy ☀️";
      else if (hue < 160) mood = "Peaceful 🌿";
      else if (hue < 240) mood = "Calm 💙";
      else if (hue < 300) mood = "Creative 💜";
      else mood = "Relaxed 🌸";

      stats[mood] = (stats[mood] ?? 0) + 1;
    }

    return stats;
  }
@override
Widget build(BuildContext context) {
  final stats = getMoodStats();

  final maxValue =
      stats.values.reduce((a, b) => a > b ? a : b);

  // Prevent division by zero
  final safeMaxValue = maxValue == 0 ? 1 : maxValue;

  return Scaffold(
    appBar: AppBar(title: const Text("Mood Analytics 📊")),
    body: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Your Mood Trends",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: stats.entries.map((entry) {

                final heightFactor =
                    entry.value / safeMaxValue;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(entry.value.toString()),

                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 30,
                      height: 200 * heightFactor,
                      decoration: BoxDecoration(
                        color: Colors.pink.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),

                    const SizedBox(height: 8),

                    SizedBox(
                      width: 60,
                      child: Text(
                        entry.key.split(" ")[0],
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
}
// ================= SETTINGS SCREEN =================

// ================= SETTINGS SCREEN =================

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void showInfo(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Widget settingsTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.4)
                : Colors.pink.withOpacity(0.15),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.pink,
        ),
        title: Text(
          title,
          style: TextStyle(
            color:
                Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings ⚙️"),
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  colors: [
                    Color(0xFF121212),
                    Color(0xFF1E1E1E),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : const LinearGradient(
                  colors: [
                    Color(0xFFFFF5F8),
                    Color(0xFFFFE4EC),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),

        child: Padding(
          padding: const EdgeInsets.all(16),

          child: Column(
            children: [
              // 🌙 DARK MODE
              ValueListenableBuilder<bool>(
                valueListenable: isDarkMode,
                builder: (context, value, _) {
                  return settingsTile(
                    context,
                    icon: Icons.dark_mode,
                    title: "Dark Mode",

                    trailing: Switch(
                      value: value,
                      activeColor: Colors.pink,

                      onChanged: (newValue) {
                        isDarkMode.value = newValue;
                      },
                    ),
                  );
                },
              ),

              // 🎨 COLOR MEANINGS
              settingsTile(
                context,
                icon: Icons.palette,
                title: "Color Meanings",

                onTap: () {
                  showInfo(
                    context,
                    "Color Meanings 🎨",

                    "🔥 Red/Orange = Energetic\n"
                    "💛 Yellow = Happy\n"
                    "💚 Green = Peaceful\n"
                    "💙 Blue = Calm\n"
                    "💜 Purple = Creative\n"
                    "🌸 Pink = Relaxed",
                  );
                },
              ),

              // 🔒 PRIVACY POLICY
              settingsTile(
                context,
                icon: Icons.lock,
                title: "Privacy Policy",

                onTap: () {
                  showInfo(
                    context,
                    "Privacy 🔒",
                    "All moods are stored locally on your device only.",
                  );
                },
              ),

              // 📊 ABOUT APP
              settingsTile(
                context,
                icon: Icons.info,
                title: "About App",

                onTap: () {
                  showInfo(
                    context,
                    "Mood Journal 🌸",
                    "A beautiful mood tracking app with "
                    "color-based emotions and analytics.",
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🌸 VERSION TEXT
              Text(
                "Version 1.0.0",
                style: TextStyle(
                  color: isDark
                      ? Colors.white54
                      : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}