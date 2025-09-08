import 'dart:math';

import 'package:flutter/material.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Navigation functions
  void _navigateToHome() {
    Navigator.pushNamed(context, '/');
  }

  void _navigateToProgress() {
    Navigator.pushNamed(context, '/progress');
  }

  void _navigateToResults() {
    // Already on results page
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
          // ======= TOP NAV BAR =======
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
                    _buildTopNavItem("Progress", false, _navigateToProgress),
                    _buildTopNavItem("Results", true, _navigateToResults),
                    _buildTopNavItem("Reports", false, _navigateToReports),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Center(
                    child: Text(
                      "WebSec Scanner",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 5),
                  Center(
                    child: Text(
                      "AI Password Vulnerability Assessment",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  // Stats Cards with Icons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatCard("47", "Pages Crawled", Icons.web, Colors.blue),
                      _buildStatCard("0", "Forms Analyzed", Icons.description, Colors.green),
                      _buildStatCard("8", "Vulnerabilities", Icons.warning, Colors.orange),
                      _buildStatCard("3", "Critical Issues", Icons.dangerous, Colors.red),
                    ],
                  ),
                  
                  SizedBox(height: 30),
                  Divider(color: Colors.grey[700]),
                  SizedBox(height: 20),

                  // AI Analysis Summary
                  Text(
                    "AI Analysis Summary",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 15),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      "Based on my analysis of your web application, I've identified several security concerns that require attention:\n\n"
                      "- Critical SQL injection vulnerabilities were detected in your login and search functionality\n"
                      "- High Risk: Multiple XSS vulnerabilities found in user input fields\n"
                      "- Medium Risk: CSRF protection is missing from several forms\n"
                      "- Low Risk: Some security headers are missing but don't pose immediate threats\n\n"
                      "AI Recommendation: Practice bringing the SQL injection vulnerabilities first as they pose the most significant risk to your data security. Implement parameterized queries and input validation across all user inputs.",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                  
                  SizedBox(height: 30),
                  Divider(color: Colors.grey[700]),
                  SizedBox(height: 20),

                  // Charts Section
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Vulnerability Distribution Pie Chart (Left)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Vulnerability Distribution",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 300, // Increased height for larger chart
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF161B22),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: _buildPieChart(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SizedBox(width: 20),
                      
                      // Severity Breakdown Bar Chart (Right)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Severity Breakdown",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 300,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Color(0xFF161B22),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: _buildBarChart(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Chart Legends
                  Row(
                    children: [
                      Expanded(
                        child: _buildPieChartLegend(),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: _buildBarChartLegend(),
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 30),
                  
                  // Action Buttons
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Generate report functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Generate Full Report",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Export results functionality
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Export Results",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Custom Pie Chart Widget with larger size
  Widget _buildPieChart() {
    return CustomPaint(
      size: Size(200, 200), // Increased size for larger diameter
      painter: PieChartPainter(
        data: [
          PieChartData(4, Colors.red, "SQL Injection"),
          PieChartData(2, Colors.orange, "XSS"),
          PieChartData(1, Colors.yellow, "CSRF"),
          PieChartData(1, Colors.blue, "Other"),
        ],
      ),
    );
  }

  // Bar Chart Widget
  Widget _buildBarChart() {
    return CustomPaint(
      size: Size(double.infinity, 200),
      painter: BarChartPainter(
        data: [
          BarChartData(3, Colors.red, "Critical"),
          BarChartData(2, Colors.orange, "High"),
          BarChartData(2, Colors.yellow, "Medium"),
          BarChartData(1, Colors.blue, "Low"),
        ],
      ),
    );
  }

  // Pie Chart Legend
  Widget _buildPieChartLegend() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildLegendItem(Colors.red, "SQL Injection (4)"),
          _buildLegendItem(Colors.orange, "XSS (2)"),
          _buildLegendItem(Colors.yellow, "CSRF (1)"),
          _buildLegendItem(Colors.blue, "Other (1)"),
        ],
      ),
    );
  }

  // Bar Chart Legend
  Widget _buildBarChartLegend() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          _buildLegendItem(Colors.red, "Critical (3)"),
          _buildLegendItem(Colors.orange, "High (2)"),
          _buildLegendItem(Colors.yellow, "Medium (2)"),
          _buildLegendItem(Colors.blue, "Low (1)"),
        ],
      ),
    );
  }

  Widget _buildLegendItem(Color color, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // Updated Stat Card with Icons
  Widget _buildStatCard(String value, String label, IconData icon, Color iconColor) {
    return Container(
      width: 150,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 40,
            color: iconColor,
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
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

// Data class for charts
class PieChartData {
  final double value;
  final Color color;
  final String label;

  PieChartData(this.value, this.color, this.label);
}

class BarChartData {
  final double value;
  final Color color;
  final String label;

  BarChartData(this.value, this.color, this.label);
}

// Pie Chart Painter
class PieChartPainter extends CustomPainter {
  final List<PieChartData> data;

  PieChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    
    double total = data.fold(0, (sum, item) => sum + item.value);
    double startRadian = -pi / 2; // Start from top

    for (var item in data) {
      final sweepRadian = 2 * pi * (item.value / total);
      
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;
      
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startRadian,
        sweepRadian,
        true,
        paint,
      );
      
      startRadian += sweepRadian;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Bar Chart Painter
class BarChartPainter extends CustomPainter {
  final List<BarChartData> data;

  BarChartPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final double barWidth = size.width / (data.length * 2 - 1);
    final double maxValue = data.fold(0, (max, item) => item.value > max ? item.value : max);
    final double scale = size.height / (maxValue + 1);

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final double barHeight = item.value * scale;
      final double x = i * barWidth * 2;
      final double y = size.height - barHeight;

      // Draw bar
      final paint = Paint()
        ..color = item.color
        ..style = PaintingStyle.fill;
      
      canvas.drawRect(
        Rect.fromLTWH(x, y, barWidth, barHeight),
        paint,
      );

      // Draw label
      final textPainter = TextPainter(
        text: TextSpan(
          text: item.value.toInt().toString(),
          style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x + barWidth / 2 - textPainter.width / 2, y - 20));

      // Draw category label
      final labelPainter = TextPainter(
        text: TextSpan(
          text: item.label,
          style: TextStyle(color: Colors.white70, fontSize: 10),
        ),
        textDirection: TextDirection.ltr,
      );
      labelPainter.layout();
      labelPainter.paint(canvas, Offset(x + barWidth / 2 - labelPainter.width / 2, size.height - 15));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}