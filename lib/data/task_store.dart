import 'package:flutter/material.dart';

class TaskStore extends ChangeNotifier {
  static final TaskStore instance = TaskStore._internal();

  TaskStore._internal();

  final List<Map<String, dynamic>> tasks = [
    {
      'title': 'Exercícios de equação',
      'subject': 'Matemática',
      'date': '25/11/2026',
      'status': 'Pendente',
      'icon': Icons.calculate_outlined,
    },
    {
      'title': 'Leitura do capítulo 5',
      'subject': 'Português',
      'date': '25/11/2026',
      'status': 'Em andamento',
      'icon': Icons.menu_book_outlined,
    },
    {
      'title': 'Resumo sobre células',
      'subject': 'Biologia',
      'date': '26/11/2026',
      'status': 'Concluída',
      'icon': Icons.biotech_outlined,
    },
    {
      'title': 'Revisão da Revolução Francesa',
      'subject': 'História',
      'date': '27/11/2026',
      'status': 'Pendente',
      'icon': Icons.account_balance_outlined,
    },
  ];

  void updateTasks() {
    notifyListeners();
  }

  double getProgress(String subject) {
    final subjectTasks = tasks.where(
      (task) => task['subject'] == subject,
    ).toList();

    if (subjectTasks.isEmpty) return 0;

    final completed = subjectTasks.where(
      (task) => task['status'] == 'Concluída',
    ).length;

    return completed / subjectTasks.length;
  }

  int getTaskCount(String subject) {
    return tasks.where(
      (task) => task['subject'] == subject,
    ).length;
  }

  int getCompletedCount(String subject) {
    return tasks.where(
      (task) =>
          task['subject'] == subject &&
          task['status'] == 'Concluída',
    ).length;
  }
}