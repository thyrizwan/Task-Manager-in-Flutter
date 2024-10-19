import 'package:flutter/material.dart';

class TaskSummaryCard extends StatelessWidget {
  const TaskSummaryCard({
    super.key,
    required this.title,
    required this.count,
  });

  final String title;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colors = getColorFromString(title);

    return Card(
      color: colors.bgColor,
      shadowColor: Colors.grey,
      elevation: 0,
      child: SizedBox(
        width: 110,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$count',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colors.textColor,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  color: colors.textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  getColorFromString(String color) {
    switch (color) {
      case 'New':
        return (
          bgColor: Colors.blue.shade200,
          textColor: Colors.blue.shade900,
        );
      case 'Completed':
        return (
          bgColor: Colors.green.shade200,
          textColor: Colors.green.shade900,
        );
      case 'Progress':
        return (
          bgColor: Colors.orange.shade200,
          textColor: Colors.orange.shade900,
        );
      case 'Cancelled':
        return (
          bgColor: Colors.red.shade200,
          textColor: Colors.red.shade900,
        );
      default:
        return (
          bgColor: Colors.white,
          textColor: Colors.grey,
        );
    }
  }
}
