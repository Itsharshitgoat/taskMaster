import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/task_item.dart';
import '../widgets/search_bottom_sheet.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TaskProvider>().loadTasks());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Morning Briefing',
          style: TextStyle(
            color: isDark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => const SearchBottomSheet(),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  SvgPicture.asset('assets/icons/search.svg', width: 16, height: 16, colorFilter: ColorFilter.mode(isDark ? Colors.white70 : Colors.black54, BlendMode.srcIn)),
                  const SizedBox(width: 8),
                  Text('Search', style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
                ],
              ),
            ),
          )
        ],
      ),
      body: Consumer<TaskProvider>(
        builder: (context, taskProvider, child) {
          final todayTasks = taskProvider.todayTasks;
          final upcomingTasks = taskProvider.upcomingTasks;
          final completedTasks = taskProvider.completedTasks;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Hero Section (Dynamic Morning Briefing)
              if (todayTasks.isNotEmpty) ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : const Color(0xFFEBE6DF),
                        Theme.of(context).brightness == Brightness.dark ? const Color(0xFF334155) : const Color(0xFFDED0C1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('TODAY\'S FOCUS', style: TextStyle(letterSpacing: 1.2, fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
                      const SizedBox(height: 8),
                      Text(
                        todayTasks.first.title,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              taskProvider.toggleTaskCompletion(todayTasks.first.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E6562),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text('Complete Task', style: TextStyle(color: Colors.white)),
                          ),
                          const SizedBox(width: 16),
                          TextButton.icon(
                            onPressed: () {
                              taskProvider.deleteTask(todayTasks.first.id);
                            },
                            icon: const Icon(Icons.close, color: Colors.brown, size: 16),
                            label: const Text('Dismiss', style: TextStyle(color: Colors.brown)),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ] else ...[
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : const Color(0xFFEBE6DF),
                        Theme.of(context).brightness == Brightness.dark ? const Color(0xFF334155) : const Color(0xFFDED0C1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ALL CAUGHT UP!', style: TextStyle(letterSpacing: 1.2, fontSize: 12, color: Theme.of(context).brightness == Brightness.dark ? Colors.white70 : Colors.black54)),
                      const SizedBox(height: 8),
                      Text(
                        'No remaining tasks for today. Great job!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562),
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],

              // Today Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Today', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                  Text('${todayTasks.length} tasks', style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              ...todayTasks.map((task) => TaskItem(
                    task: task,
                    onToggle: () => taskProvider.toggleTaskCompletion(task.id),
                    onDelete: () => taskProvider.deleteTask(task.id),
                  )),

              const SizedBox(height: 32),

              // Upcoming Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Upcoming', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor)),
                  Text('${upcomingTasks.length} tasks', style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              ...upcomingTasks.map((task) => Dismissible(
                key: Key(task.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => taskProvider.deleteTask(task.id),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E1E1E) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SvgPicture.asset('assets/icons/calendar.svg', width: 20, height: 20, colorFilter: const ColorFilter.mode(Colors.brown, BlendMode.srcIn)),
                          GestureDetector(
                            onTap: () => taskProvider.toggleTaskCompletion(task.id),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.grey, width: 2),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        task.dueDate != null ? DateFormat('EEEE').format(task.dueDate!).toUpperCase() : 'UPCOMING',
                        style: const TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(task.title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: textColor)),
                    ],
                  ),
                ),
              )),

              const SizedBox(height: 32),

              // Completed Section
              if (completedTasks.isNotEmpty) ...[
                const Text('Completed', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 16),
                ...completedTasks.map((task) => TaskItem(
                      task: task,
                      onToggle: () => taskProvider.toggleTaskCompletion(task.id),
                      onDelete: () => taskProvider.deleteTask(task.id),
                    )),
              ],
            ],
          );
        },
      ),
    );
  }
}
