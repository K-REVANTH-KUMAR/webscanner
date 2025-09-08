import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _urlController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String _selectedScanType = "Quick Scan (1 min)";
  bool _isScanning = false;
  Map<String, dynamic>? scanData;

  Future<void> startScan() async {
    if (_urlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("⚠ Please enter a valid URL")),
      );
      return;
    }

    setState(() {
      _isScanning = true;
      scanData = null;
    });

    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:5000/scan"), // Flask API endpoint
        headers: {"Content-Type": "application/json"},
        body: json.encode({"url": _urlController.text}),
      );

      if (response.statusCode == 200) {
        setState(() {
          scanData = json.decode(response.body);
        });
      } else {
        setState(() {
          scanData = {"error": "Unable to scan website"};
        });
      }
    } catch (e) {
      setState(() {
        scanData = {"error": "❌ Failed to connect to the scanner API"};
      });
    }

    setState(() {
      _isScanning = false;
    });
  }

  Color _getRiskColor(String type) {
    if (type.contains("SQL Injection") || type.contains("XSS")) {
      return Colors.redAccent;
    } else if (type.contains("High")) {
      return Colors.redAccent;
    } else if (type.contains("Medium")) {
      return Colors.orangeAccent;
    } else if (type.contains("Low")) {
      return Colors.yellowAccent;
    }
    return Colors.greenAccent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFF0D1117),
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
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.menu, color: Colors.white),
                      onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                    ),
                    Icon(Icons.security,
                        color: Colors.blueAccent, size: 28),
                    SizedBox(width: 5),
                    Text(
                      "VulScanner",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    _buildTopNavItem("Home", true, () {}),
                    _buildTopNavItem("Progress", false, () {}),
                    _buildTopNavItem("Results", false, () {}),
                    _buildTopNavItem("Reports", false, () {}),
                  ],
                ),
              ],
            ),
          ),

          // ====== SCANNER BODY ======
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: Column(
                children: [
                  Text(
                    "Advanced WebSec Scanner",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    "AI-powered scanning, real-time analytics, and developer education\nto secure modern web applications.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                  SizedBox(height: 30),

                  // URL INPUT + SCAN BUTTON
                  Container(
                    width: 600,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Color(0xFF161B22),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextField(
                          controller: _urlController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Target URL",
                            labelStyle: TextStyle(color: Colors.white70),
                            hintText: "https://your-app.com",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Color(0xFF0D1117),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade700),
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _isScanning ? null : startScan,
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            backgroundColor: Colors.blueAccent,
                          ),
                          child: _isScanning
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                                  "🔍 Start Scan",
                                  style: TextStyle(fontSize: 20, color: Colors.white),
                                ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),

                  // ===== FORMATTED SCAN RESULTS =====
                  scanData == null
                      ? Container()
                      : scanData!.containsKey("error")
                          ? _buildErrorCard(scanData!["error"])
                          : _buildResultsCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsCard() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Color(0xFF161B22),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.security, color: Colors.greenAccent, size: 24),
              SizedBox(width: 8),
              Text("Scan Results",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Chip(
                label: Text("Completed", style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            ],
          ),
          SizedBox(height: 15),
          Text("Scanned URL: ${scanData!["url"]}",
              style: TextStyle(color: Colors.white70, fontSize: 14)),
          SizedBox(height: 20),
          
          // Traditional vulnerability results
          _buildVulnerabilityList("SQL Injection", scanData!["sqli_vulnerabilities"]),
          SizedBox(height: 15),
          _buildVulnerabilityList("XSS Vulnerabilities", scanData!["xss_vulnerabilities"]),
          SizedBox(height: 20),
          
          // AI Analysis Section
          _buildAIAnalysisSection(scanData!["ai_analysis"]),
        ],
      ),
    );
  }

  Widget _buildAIAnalysisSection(dynamic aiAnalysis) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.auto_awesome, color: Colors.purpleAccent, size: 20),
            SizedBox(width: 8),
            Text("🤖 AI Security Analysis",
                style: TextStyle(
                    color: Colors.purpleAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 12),
        
        if (aiAnalysis is String && aiAnalysis.contains("Gemini analysis failed"))
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.redAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.redAccent),
            ),
            child: Row(
              children: [
                Icon(Icons.error, color: Colors.redAccent, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text("❌ AI analysis unavailable: $aiAnalysis",
                      style: TextStyle(color: Colors.redAccent)),
                ),
              ],
            ),
          ),
        
        if (aiAnalysis is String && aiAnalysis.isNotEmpty && !aiAnalysis.contains("Gemini analysis failed"))
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.purpleAccent),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.psychology, color: Colors.purpleAccent, size: 20),
                    SizedBox(width: 8),
                    Text("AI Insights",
                        style: TextStyle(
                            color: Colors.purpleAccent,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 10),
                Text(aiAnalysis,
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                SizedBox(height: 10),
                Divider(color: Colors.grey.shade700),
                SizedBox(height: 5),
                Text("💡 Powered by Gemini AI",
                    style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildVulnerabilityList(String title, List<dynamic> vulns) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              vulns.isEmpty ? Icons.check_circle : Icons.warning,
              color: vulns.isEmpty ? Colors.greenAccent : Colors.orangeAccent,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(title,
                style: TextStyle(
                    color: vulns.isEmpty ? Colors.greenAccent : Colors.orangeAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            SizedBox(width: 8),
            Chip(
              label: Text("${vulns.length} found", 
                  style: TextStyle(color: Colors.white, fontSize: 12)),
              backgroundColor: vulns.isEmpty ? Colors.green : Colors.orange,
            ),
          ],
        ),
        SizedBox(height: 8),
        vulns.isEmpty
            ? Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green, size: 16),
                    SizedBox(width: 8),
                    Text("✅ No vulnerabilities found",
                        style: TextStyle(color: Colors.greenAccent, fontSize: 14)),
                  ],
                ),
              )
            : Column(
                children: vulns.map((vuln) {
                  return Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getRiskColor(vuln["type"]).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _getRiskColor(vuln["type"]),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.warning, 
                                color: _getRiskColor(vuln["type"]), 
                                size: 16),
                            SizedBox(width: 8),
                            Text("Type: ${vuln["type"]}",
                                style: TextStyle(
                                    color: _getRiskColor(vuln["type"]),
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(height: 6),
                        Text("Payload: ${vuln["payload"]}",
                            style: TextStyle(color: Colors.white70, fontSize: 14)),
                        SizedBox(height: 4),
                        Text("Form: ${vuln["form_action"]}",
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
      ],
    );
  }

  Widget _buildErrorCard(String message) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.redAccent),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent),
          SizedBox(width: 12),
          Expanded(
            child: Text(message,
                style: TextStyle(color: Colors.redAccent, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildTopNavItem(String title, bool isActive, VoidCallback onPressed) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5),
      decoration: isActive
          ? BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.blue, width: 2)),
            )
          : null,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.blueAccent : Colors.grey,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Color(0xFF161B22),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF0D1117)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security, color: Colors.blueAccent, size: 32),
                    SizedBox(width: 12),
                    Text(
                      "VulScanner",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  "AI-Powered Security Scanner",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home, color: Colors.white),
            title: Text("Dashboard", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.history, color: Colors.white),
            title: Text("Scan History", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.auto_awesome, color: Colors.purpleAccent),
            title: Text("AI Analysis", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.settings, color: Colors.white),
            title: Text("Settings", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          Divider(color: Colors.grey.shade700),
          ListTile(
            leading: Icon(Icons.help, color: Colors.blueAccent),
            title: Text("Help & Support", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: Icon(Icons.info, color: Colors.blueAccent),
            title: Text("About", style: TextStyle(color: Colors.white)),
            onTap: () {},
          ),
          Divider(color: Colors.grey.shade700),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text("Logout", style: TextStyle(color: Colors.red)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}