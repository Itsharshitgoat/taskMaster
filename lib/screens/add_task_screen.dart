import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import '../providers/user_provider.dart';
import '../widgets/custom_date_picker.dart';
import '../widgets/add_category_sheet.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? task;

  const AddTaskScreen({Key? key, this.task}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descController;
  DateTime? _selectedDate;
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _selectedDate = widget.task?.dueDate;
    _selectedCategory = widget.task?.category;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _saveTask() {
    if (_titleController.text.trim().isEmpty) return;

    final taskProvider = context.read<TaskProvider>();
    final task = Task(
      id: widget.task?.id ?? const Uuid().v4(),
      title: _titleController.text.trim(),
      description: _descController.text.trim(),
      isCompleted: widget.task?.isCompleted ?? false,
      createdAt: widget.task?.createdAt ?? DateTime.now(),
      dueDate: _selectedDate,
      category: _selectedCategory ?? context.read<UserProvider>().categories.first,
    );

    if (widget.task == null) {
      taskProvider.addTask(task);
    } else {
      taskProvider.updateTask(task, oldTask: widget.task);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF2A2A2A) : const Color(0xFFEBE5DF);
    final textColor = isDark ? Colors.white : Colors.black87;
    final hintColor = isDark ? Colors.white54 : Colors.black54;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24,
        right: 24,
        top: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            widget.task == null ? 'New Task' : 'Edit Task',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: textColor),
          ),
          const SizedBox(height: 8),
          Text('What are we accomplishing today?', style: TextStyle(color: hintColor, fontSize: 16)),
          const SizedBox(height: 32),
          Text('TASK NAME', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: hintColor)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: 'e.g. Design Studio Moodboard',
              hintStyle: TextStyle(color: hintColor),
              filled: true,
              fillColor: isDark ? const Color(0xFF333333) : Colors.white.withValues(alpha: 0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
          const SizedBox(height: 24),
          Text('CATEGORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: hintColor)),
          const SizedBox(height: 8),
          Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              final categories = userProvider.categories;
              if (_selectedCategory == null && categories.isNotEmpty) {
                _selectedCategory = categories.first;
              }
              return Wrap(
                spacing: 8,
                children: [
                  ...categories.map((category) => GestureDetector(
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Delete Category'),
                          content: Text('Are you sure you want to delete "$category"?'),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                            TextButton(
                              onPressed: () {
                                userProvider.removeCategory(category);
                                if (_selectedCategory == category) {
                                  setState(() {
                                    _selectedCategory = null;
                                  });
                                }
                                Navigator.pop(context);
                              },
                              child: const Text('Delete', style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    child: ChoiceChip(
                      label: Text(category),
                      selected: _selectedCategory == category,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) _selectedCategory = category;
                        });
                      },
                      selectedColor: isDark ? const Color(0xFF2E6562) : const Color(0xFFD4EAE8),
                      backgroundColor: isDark ? const Color(0xFF333333) : Colors.white.withValues(alpha: 0.5),
                      labelStyle: TextStyle(
                        color: _selectedCategory == category
                            ? (isDark ? Colors.white : const Color(0xFF2E6562))
                            : textColor,
                        fontWeight: FontWeight.w500,
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                    ),
                  )),
                  ActionChip(
                    label: Icon(Icons.add, size: 18, color: textColor),
                    onPressed: () async {
                      final newCat = await showAddCategorySheet(context);
                      if (newCat != null && newCat.isNotEmpty) {
                        setState(() {
                          _selectedCategory = newCat;
                        });
                      }
                    },
                    backgroundColor: isDark ? const Color(0xFF333333) : Colors.white.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
                  )
                ],
              );
            }
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF333333) : Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: Icon(Icons.calendar_today, size: 20, color: isDark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Set Due Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
                      Text(
                        _selectedDate != null ? DateFormat('MMM d, yyyy').format(_selectedDate!) : 'Not set',
                        style: TextStyle(color: hintColor),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _selectedDate != null,
                  onChanged: (val) async {
                    if (val) {
                      final date = await showCustomDatePicker(context, initialDate: DateTime.now());
                      if (date != null) {
                        setState(() {
                          _selectedDate = date;
                        });
                      }
                    } else {
                      setState(() {
                        _selectedDate = null;
                      });
                    }
                  },
                  activeColor: isDark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562),
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: _saveTask,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? const Color(0xFF4FA8A4) : const Color(0xFF2E6562),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: Text(
                widget.task == null ? 'Create Task' : 'Save Task',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
