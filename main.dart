import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const EasyAttendApp());
}

class EasyAttendApp extends StatelessWidget {
  const EasyAttendApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EasyAttend',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F6FA),
      ),
      home: const DashboardScreen(),
    );
  }
}

// ---------------- DATA MODEL ----------------
class AttendanceRecord {
  final String studentId;
  final String dateTime;
  final String status;

  AttendanceRecord({
    required this.studentId,
    required this.dateTime,
    required this.status,
  });
}

// ---------------- MOCK DATABASE ----------------
List<AttendanceRecord> attendanceList = [];

// ---------------- DASHBOARD ----------------
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EasyAttend"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCard(
              context,
              title: "Scan Attendance",
              icon: Icons.qr_code_scanner,
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ScannerScreen()),
                );
              },
            ),
            const SizedBox(height: 16),
            _buildCard(
              context,
              title: "Attendance Records",
              icon: Icons.list_alt,
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RecordsScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
      required IconData icon,
      required Color color,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 40),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}

// ---------------- QR SCANNER ----------------
class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  bool scanned = false;

  void markAttendance(String code) {
    final now = DateTime.now();
    attendanceList.add(
      AttendanceRecord(
        studentId: code,
        dateTime: DateFormat('yyyy-MM-dd HH:mm').format(now),
        status: "Present",
      ),
    );

    setState(() {
      scanned = true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Attendance marked for $code")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Scan QR Attendance")),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              onDetect: (capture) {
                if (!scanned) {
                  final barcode = capture.barcodes.first;
                  if (barcode.rawValue != null) {
                    markAttendance(barcode.rawValue!);
                  }
                }
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              "Point camera to QR Code",
              style: TextStyle(fontSize: 16),
            ),
          )
        ],
      ),
    );
  }
}

// ---------------- RECORDS SCREEN ----------------
class RecordsScreen extends StatefulWidget {
  const RecordsScreen({super.key});

  @override
  State<RecordsScreen> createState() => _RecordsScreenState();
}

class _RecordsScreenState extends State<RecordsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Attendance Records")),
      body: attendanceList.isEmpty
          ? const Center(child: Text("No records yet"))
          : ListView.builder(
              itemCount: attendanceList.length,
              itemBuilder: (context, index) {
                final item = attendanceList[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text("Student ID: ${item.studentId}"),
                    subtitle: Text("Time: ${item.dateTime}"),
                    trailing: const Icon(Icons.check_circle,
                        color: Colors.green),
                  ),
                );
              },
            ),
    );
  }
}