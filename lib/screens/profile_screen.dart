import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../providers/task_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  String _getRank(int completedTasks) {
    if (completedTasks < 5) return 'Beginner';
    if (completedTasks < 10) return 'Novice';
    if (completedTasks < 20) return 'Learner';
    if (completedTasks < 35) return 'Achiever';
    if (completedTasks < 50) return 'Deep Thinker';
    if (completedTasks < 75) return 'Focused Mind';
    if (completedTasks < 100) return 'Task Master';
    if (completedTasks < 150) return 'Productivity Guru';
    if (completedTasks < 200) return 'Elite Performer';
    if (completedTasks < 300) return 'Legend';
    return 'Supreme Architect';
  }

  Future<void> _pickImage(UserProvider userProvider) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      await userProvider.updateProfileImage(image.path);
    }
  }

  void _editName(BuildContext context, UserProvider userProvider) {
    final controller = TextEditingController(text: userProvider.userName);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Name'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Enter your name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  userProvider.updateUserName(controller.text.trim());
                }
                Navigator.pop(context);
              },
              child: const Text('Save'),
            )
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: const Text('Account', style: TextStyle(color: Color(0xFF2E6562), fontSize: 22, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF2E6562)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer3<ThemeProvider, UserProvider, TaskProvider>(
        builder: (context, themeProvider, userProvider, taskProvider, child) {
          final completedTasksCount = taskProvider.tasks.where((t) => t.isCompleted).length;
          final totalTasksCount = taskProvider.tasks.length;
          final rank = _getRank(completedTasksCount);
          final joinDateFormatted = DateFormat('MMMM yyyy').format(userProvider.joinDate);

          final isDark = themeProvider.isDarkMode;
          final cardColor = isDark ? const Color(0xFF1E1E1E) : Colors.white;
          final textColor = isDark ? Colors.white : Colors.black87;
          final weeklyEff = taskProvider.weeklyEfficiency;
          final effText = weeklyEff > 0 ? '+$weeklyEff%' : '$weeklyEff%';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      isDark ? const Color(0xFF3E3A35) : const Color(0xFFEBE6DF),
                      isDark ? const Color(0xFF2A2722) : const Color(0xFFDED0C1),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))
                  ]
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => _pickImage(userProvider),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: isDark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562), width: 3),
                        ),
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.orangeAccent,
                          backgroundImage: userProvider.profileImagePath != null ? FileImage(File(userProvider.profileImagePath!)) : null,
                          child: userProvider.profileImagePath == null ? const Icon(Icons.person, color: Colors.white, size: 50) : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userProvider.userName, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF2E6562))),
                        IconButton(icon: Icon(Icons.edit, size: 20, color: isDark ? Colors.white70 : Colors.black54), onPressed: () => _editName(context, userProvider)),
                      ],
                    ),
                    Text('Focus Architect • Joined $joinDateFormatted', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54, fontSize: 14)),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildStatBox('RANK', rank, isDark),
                        _buildStatBox('IMPACT', '$totalTasksCount\nTasks', isDark),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Icon(Icons.show_chart, color: Colors.white),
                        Text('WEEKLY EFFICIENCY', style: TextStyle(color: Colors.white70, fontSize: 12, letterSpacing: 1.2)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(effText, style: const TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    const Text('Vs. last 7 days completed tasks', style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Midnight Mode', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
                        const SizedBox(height: 4),
                        const Text('Soften the interface for tonight', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    Switch(
                      value: themeProvider.isDarkMode,
                      onChanged: (val) => themeProvider.toggleTheme(),
                      activeColor: isDark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Center(
                child: Text('Made with love by Harshit, Anupam and Yash', style: TextStyle(color: Colors.grey.shade500, fontSize: 12, fontStyle: FontStyle.italic)),
              ),
              const SizedBox(height: 24),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatBox(String title, String value, bool isDark) {
    return Container(
      width: 120,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.transparent : Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Color(0xFF2E6562), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, height: 1.2, color: isDark ? Colors.white : Colors.black87)),
        ],
      ),
    );
  }
}
