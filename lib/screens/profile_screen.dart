import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    const CircleAvatar(radius: 40, backgroundColor: Colors.orangeAccent, child: Icon(Icons.person, color: Colors.white, size: 40)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(userProvider.userName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textColor)),
                        IconButton(icon: const Icon(Icons.edit, size: 16, color: Colors.grey), onPressed: () => _editName(context, userProvider)),
                      ],
                    ),
                    Text('Focus Architect • Joined $joinDateFormatted', style: const TextStyle(color: Colors.grey)),
                    const SizedBox(height: 24),
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
