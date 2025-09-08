import 'package:flutter/material.dart';

class ScanProgressPage extends StatefulWidget {
  @override
  _ScanProgressPageState createState() => _ScanProgressPageState();
}

class _ScanProgressPageState extends State<ScanProgressPage> with SingleTickerProviderStateMixin {
  double progress = 0.0;
  List<String> scanActivities = [
    "[3:48:42 AM] Analyzing HTTP headers for security issues",
    "[3:48:45 AM] Testing for XSS vulnerabilities",
    "[3:48:47 AM] Checking for security misconfigurations",
    "[3:48:49 AM] Crawling pages /context",
    "[3:48:52 AM] Analyzing HTTP headers for security issues",
    "[3:48:54 AM] Crawling pages /context",
    "[3:48:56 AM] Screening AI browser security assessment",
    "[3:48:58 AM] Checking for security misconfigurations",
    "[3:49:01 AM] AI security scan completed successfully",
    "[3:49:03 AM] Generating security report with 12 vulnerabilities found",
    "[3:49:05 AM] Analyzing form inputs for vulnerabilities",
    "[3:49:07 AM] Finalizing scan results",
  ];
  int currentActivity = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    
    // Animation controller for circular scanning effect
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    
    _simulateProgress();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _simulateProgress() async {
    for (int i = 1; i <= 100; i++) {
      await Future.delayed(Duration(milliseconds: 60));
      setState(() {
        progress = i / 100;
        // Update activity every 8% progress
        if (i % 8 == 0 && currentActivity < scanActivities.length - 1) {
          currentActivity++;
        }
      });
    }
    // Uncomment to navigate to results when complete
    // Navigator.pushReplacementNamed(context, '/results');
  }

  // Navigation functions
  void _navigateToHome() {
    Navigator.pushNamed(context, '/');
  }

  void _navigateToProgress() {
    // Already on progress page
  }

  void _navigateToResults() {
    Navigator.pushNamed(context, '/results');
  }

  void _navigateToReports() {
    Navigator.pushNamed(context, '/reports');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Color(0xFF0D1117),
      drawer: _buildDrawer(),
      
      body: Column(
        children: [
          // ======= TOP NAVIGATION BAR =======
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Color(0xFF161B22),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Left side: Menu icon and website name
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    IconButton(
                      icon: Icon(Icons.security, color: const Color.fromARGB(255, 10, 137, 255)),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    SizedBox(width: 1),
                    Text("VulScanner",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                
                // Right side: Navigation items
                Row(
                  children: [
                    _buildTopNavItem("Home", false, _navigateToHome),
                    _buildTopNavItem("Progress", true, _navigateToProgress),
                    _buildTopNavItem("Results", false, _navigateToResults),
                    _buildTopNavItem("Reports", false, _navigateToReports),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Container - Progress Checking
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF161B22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Center(
                            child: Text(
                              "AI-Forward Vulnerability Assessment",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // AI Scan Progress Section
                          Text(
                            "AI Scan Progress",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          
                          // Circular Progress Indicator
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 150,
                                  height: 150,
                                  child: CircularProgressIndicator(
                                    value: progress,
                                    strokeWidth: 10,
                                    backgroundColor: Colors.grey[800],
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                                  ),
                                ),
                                // Gradient scanning effect
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (context, child) {
                                    return Container(
                                      width: 200,
                                      height:200,
                                      child: CustomPaint(
                                        painter: _CircularScanPainter(
                                          progress: progress,
                                          scanValue: _animation.value,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${(progress * 100).toStringAsFixed(0)}%",
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      "Complete",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          SizedBox(height: 20),
                          
                          // Progress Indicators
                          _buildProgressItem("Pages Crawled", "44", 1.0),
                          _buildProgressItem("Forms Found", "47", 1.0),
                          _buildProgressItem("AI Analysis", "Completed", 1.0, isBold: true),
                          _buildProgressItem("Vulnerabilities", "12", 1.0),
                          
                          SizedBox(height: 20),
                          Divider(color: Colors.grey[700]),
                          SizedBox(height: 20),
                          
                          // Scan Status
                          Center(
                            child: Text(
                              "Scanning AI security scan:",
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          
                          // Control Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Pause scan functionality
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Pause Scan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  // Stop scan functionality
                                  Navigator.pop(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: Text(
                                  "Stop Scan",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(width: 20),
                  
                  // Right Container - Live Scanning Logs
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Color(0xFF161B22),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Live Scanning Logs",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 15),
                          
                          // Activity Log
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: Color(0xFF0D1117),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListView.builder(
                                itemCount: scanActivities.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                                    child: Text(
                                      scanActivities[index],
                                      style: TextStyle(
                                        color: index <= currentActivity 
                                            ? Colors.greenAccent 
                                            : Colors.grey[600],
                                        fontSize: 14,
                                        fontFamily: 'Monospace',
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressItem(String title, String value, double progressValue, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              value,
              style: TextStyle(
                color: isBold ? Colors.green : Colors.white,
                fontSize: 16,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          SizedBox(width: 15),
          Expanded(
            flex: 3,
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey[800],
              color: Colors.green,
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ],
      ),
    );
  }

  // ===== Drawer =====
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF161B22),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0D1117)),
            child: Row(
              children: [
                Icon(Icons.security, color: Colors.blueAccent, size: 28),
                SizedBox(width: 8),
                Text("VulScanner",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text("Dashboard", style: TextStyle(color: Colors.white)),
            onTap: _navigateToHome,
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.white),
            title: Text("Scan History", style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to scan history
            },
          ),
          ListTile(
            leading: Icon(Icons.people, color: Colors.white),
            title: Text("User Communication", style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to user communication
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text("Settings", style: TextStyle(color: Colors.white)),
            onTap: () {
              // Navigate to settings
            },
          ),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {
              // Implement logout logic
              Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
            },
          ),
        ],
      ),
    );
  }

  // ===== Top Nav Item =====
  Widget _buildTopNavItem(String title, bool isActive, VoidCallback onPressed) {
    return Container(
      decoration: isActive
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.blue, width: 2)),
            )
          : null,
      child: TextButton(
        onPressed: onPressed,
        child: Text(title,
            style: TextStyle(
              color: isActive ? Colors.blueAccent : Colors.grey,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            )),
      ),
    );
  }
}

// Custom painter for circular scanning effect
class _CircularScanPainter extends CustomPainter {
  final double progress;
  final double scanValue;

  _CircularScanPainter({required this.progress, required this.scanValue});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width/2 ;
    
    // Create a gradient for the scanning effect
    final gradient = SweepGradient(
      startAngle: 0,
      endAngle: 3.14 * 2,
      colors: [
        Colors.transparent,
        Colors.blueAccent.withOpacity(0.7),
        const Color.fromARGB(255, 0, 174, 255),
        const Color.fromARGB(0, 19, 6, 6),
      ],
      stops: [0.0, scanValue, scanValue + 0.1, 1.0],
    );
    
    final rect = Rect.fromCircle(center: center, radius: radius);
    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    
    // Draw the scanning arc
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -8, // Start at top (-π/2 radians)
      3.14 * 2 * progress, // Sweep angle based on progress
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularScanPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.scanValue != scanValue;
  }
}