import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/theme_provider.dart';
import '../providers/user_provider.dart';
import '../providers/task_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ScreenshotController _screenshotController = ScreenshotController();

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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Edit Profile Name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: 'Enter your name',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.grey.shade100,
                  ),
                  autofocus: true,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        userProvider.updateUserName(controller.text.trim());
                      }
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Save Name', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      }
    );
  }

  Future<void> _shareProfile() async {
    try {
      final image = await _screenshotController.capture();
      if (image != null) {
        final directory = await getTemporaryDirectory();
        final imagePath = await File('${directory.path}/profile.png').create();
        await imagePath.writeAsBytes(image);
        await Share.shareXFiles([XFile(imagePath.path)], text: 'Check out my Task Master profile!');
      }
    } catch (e) {
      debugPrint("Error sharing profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text('Account', style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562), fontSize: 22, fontWeight: FontWeight.bold)),
      ),
      body: Consumer3<ThemeProvider, UserProvider, TaskProvider>(
        builder: (context, themeProvider, userProvider, taskProvider, child) {
          final completedTasksCount = taskProvider.tasks.where((t) => t.isCompleted).length;
          final totalTasksCount = taskProvider.tasks.length;
          final rank = _getRank(completedTasksCount);
          final joinDateFormatted = DateFormat('MMMM yyyy').format(userProvider.joinDate);

          final isDark = themeProvider.isDarkMode;
          final cardColor = isDark ? const Color(0xFF1E293B) : Colors.white;
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
                      isDark ? const Color(0xFF1E293B) : const Color(0xFFEBE6DF),
                      isDark ? const Color(0xFF334155) : const Color(0xFFDED0C1),
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
                    Screenshot(
                      controller: _screenshotController,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEBE6DF),
                          borderRadius: BorderRadius.circular(24),
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
                            ),
                            const SizedBox(height: 24),
                            OutlinedButton.icon(
                              onPressed: _shareProfile,
                              icon: const Icon(Icons.ios_share),
                              label: const Text('Share Profile'),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: isDark ? Colors.white : const Color(0xFF2E6562),
                                side: BorderSide(color: isDark ? Colors.white38 : Colors.black26),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
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
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFFAF8F5),
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
