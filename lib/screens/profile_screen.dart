import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Account', style: TextStyle(color: Color(0xFF2E6562), fontSize: 22, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E6562)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(radius: 40, backgroundColor: Colors.orangeAccent),
                    const SizedBox(height: 16),
                    const Text('Elena Vance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text('Focus Architect • Joined March 2024', style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatBox('RANK', 'Deep\nThinker'),
                        _buildStatBox('IMPACT', '1.2k\nTasks'),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xFF2E6562),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.show_chart, color: Colors.white),
                        Text('WEEKLY EFFICIENCY', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
                      ],
                    ),
                    SizedBox(height: 16),
                    Text('+24%', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Text('Vs. last week peak hours', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Midnight Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        SizedBox(height: 4),
                        Text('Soften the interface for tonight', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (val) => themeProvider.toggleTheme(),
                      activeColor: const Color(0xFF2E6562),
                    )
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF2E6562), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, height: 1.2)),
        ],
      ),
    );
  }
}
