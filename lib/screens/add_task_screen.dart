import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';

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
  String _selectedCategory = 'Work';

  final List<String> _categories = ['Work', 'Studio', 'Personal'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.task?.title ?? '');
    _descController = TextEditingController(text: widget.task?.description ?? '');
    _selectedDate = widget.task?.dueDate;
    _selectedCategory = widget.task?.category ?? 'Work';
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
      category: _selectedCategory,
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
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFEBE5DF),
        borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
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
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          const Text('What are we accomplishing today?', style: TextStyle(color: Colors.black54, fontSize: 16)),
          const SizedBox(height: 32),
          const Text('TASK NAME', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.black54)),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              hintText: 'e.g. Design Studio Moodboard',
              filled: true,
              fillColor: Colors.white.withOpacity(0.5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
          ),
          const SizedBox(height: 24),
          const Text('CATEGORY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.black54)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              ..._categories.map((category) => ChoiceChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (selected) {
                  setState(() {
                    if (selected) _selectedCategory = category;
                  });
                },
                selectedColor: const Color(0xFFD4EAE8),
                backgroundColor: Colors.white.withOpacity(0.5),
                labelStyle: TextStyle(
                  color: _selectedCategory == category ? const Color(0xFF2E6562) : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
              )),
              ActionChip(
                label: const Icon(Icons.add, size: 18),
                onPressed: () {},
                backgroundColor: Colors.white.withOpacity(0.5),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide.none),
              )
            ],
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.calendar_today, size: 20, color: Color(0xFF2E6562)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Set Due Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        _selectedDate != null ? DateFormat('MMM d, yyyy').format(_selectedDate!) : 'Not set',
                        style: const TextStyle(color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _selectedDate != null,
                  onChanged: (val) async {
                    if (val) {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2100),
                      );
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
                  activeColor: const Color(0xFF2E6562),
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
                backgroundColor: const Color(0xFF2E6562),
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
