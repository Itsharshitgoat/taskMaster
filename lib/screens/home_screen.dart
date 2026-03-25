import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/task_item.dart';
import 'add_task_screen.dart';
import 'profile_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
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
    return Scaffold(
      backgroundColor: const Color(0xFFFAF8F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Morning Briefing',
          style: TextStyle(
            color: Color(0xFF2E6562),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                SvgPicture.asset('assets/icons/search.svg', width: 16, height: 16),
                const SizedBox(width: 8),
                const Text('Search', style: TextStyle(color: Colors.black54)),
              ],
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
              // Hero Section
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFEBE6DF), Color(0xFFDED0C1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('TODAY\'S FOCUS', style: TextStyle(letterSpacing: 1.2, fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 8),
                    const Text(
                      'Review the Eames Lounge Design Proposal',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E6562),
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2E6562),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text('Start Task'),
                        ),
                        const SizedBox(width: 16),
                        TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.notifications_active, color: Colors.brown, size: 16),
                          label: const Text('Decline', style: TextStyle(color: Colors.brown)),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Today Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Today', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  Text('${todayTasks.length} tasks', style: const TextStyle(color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 16),
              ...todayTasks.map((task) => TaskItem(
                    task: task,
                    onToggle: () => taskProvider.toggleTaskCompletion(task.id),
                    onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(task: task))),
                    onDelete: () => taskProvider.deleteTask(task.id),
                  )),

              const SizedBox(height: 32),

              // Upcoming Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Upcoming', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(color: Color(0xFF2E6562)))),
                ],
              ),
              const SizedBox(height: 16),
              ...upcomingTasks.map((task) => Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SvgPicture.asset('assets/icons/calendar.svg', width: 20, height: 20, color: Colors.brown),
                    const SizedBox(height: 8),
                    Text(
                      task.dueDate != null ? DateFormat('EEEE').format(task.dueDate!).toUpperCase() : 'UPCOMING',
                      style: const TextStyle(fontSize: 10, letterSpacing: 1.5, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(task.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                  ],
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
                      onEdit: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen(task: task))),
                      onDelete: () => taskProvider.deleteTask(task.id),
                    )),
              ],
            ],
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ]
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.list, color: Color(0xFF2E6562)),
              onPressed: () {},
            ),
            GestureDetector(
              onTap: () => showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                builder: (context) => AddTaskScreen()
              ),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Color(0xFF2E6562),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.person, color: Color(0xFF2E6562)),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
