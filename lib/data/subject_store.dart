
import 'package:flutter/material.dart';

// Gerencia as matérias do aplicativo.
class SubjectStore extends ChangeNotifier {
  SubjectStore._();

  static final SubjectStore instance = SubjectStore._();

  final List<Map<String, dynamic>> subjects = [
    {
      'name': 'Matemática',
      'icon': Icons.calculate_outlined,
      'color': Color(0xFF7561D8),
    },
    {
      'name': 'Português',
      'icon': Icons.menu_book_outlined,
      'color': Color(0xFFE58B65),
    },
    {
      'name': 'Biologia',
      'icon': Icons.biotech_outlined,
      'color': Color(0xFF45A985),
    },
    {
      'name': 'História',
      'icon': Icons.account_balance_outlined,
      'color': Color(0xFF5D91D5),
    },
  ];

  // Identifica automaticamente o ícone pelo nome.
  IconData getIcon(String name) {
    final subject = name.toLowerCase();

    if (subject.contains('matem')) {
      return Icons.calculate_outlined;
    }

    if (subject.contains('portugu') ||
        subject.contains('literat') ||
        subject.contains('redação')) {
      return Icons.menu_book_outlined;
    }

    if (subject.contains('biolog') ||
        subject.contains('ciências') ||
        subject.contains('natureza')) {
      return Icons.biotech_outlined;
    }

    if (subject.contains('hist')) {
      return Icons.account_balance_outlined;
    }

    if (subject.contains('geograf')) {
      return Icons.public_outlined;
    }

    if (subject.contains('físic')) {
      return Icons.science_outlined;
    }

    if (subject.contains('quím')) {
      return Icons.science_outlined;
    }

    if (subject.contains('art')) {
      return Icons.palette_outlined;
    }

    if (subject.contains('ingl') ||
        subject.contains('espan') ||
        subject.contains('idioma')) {
      return Icons.translate_outlined;
    }

    if (subject.contains('educação física')) {
      return Icons.fitness_center_outlined;
    }

    if (subject.contains('inform') ||
        subject.contains('comput')) {
      return Icons.computer_outlined;
    }

    return Icons.book_outlined;
  }

  // Define automaticamente a cor da matéria.
  Color getColor(String name) {
    final subject = name.toLowerCase();

    if (subject.contains('matem')) {
      return Color(0xFF7561D8);
    }

    if (subject.contains('portugu') ||
        subject.contains('literat') ||
        subject.contains('redação')) {
      return Color(0xFFE58B65);
    }

    if (subject.contains('biolog') ||
        subject.contains('ciências') ||
        subject.contains('natureza')) {
      return Color(0xFF45A985);
    }

    if (subject.contains('hist')) {
      return Color(0xFF5D91D5);
    }

    if (subject.contains('geograf')) {
      return Color(0xFF45A985);
    }

    if (subject.contains('físic') ||
        subject.contains('quím')) {
      return Color(0xFF5D91D5);
    }

    if (subject.contains('art')) {
      return Color(0xFFE58B65);
    }

    if (subject.contains('ingl') ||
        subject.contains('espan') ||
        subject.contains('idioma')) {
      return Color(0xFF7561D8);
    }

    return Color(0xFF8B8B8B);
  }

  // Adiciona uma matéria.
  void addSubject(String name) {
    if (subjects.any(
      (subject) =>
          subject['name'].toString().toLowerCase() ==
          name.trim().toLowerCase(),
    )) {
      return;
    }

    subjects.add({
      'name': name.trim(),
      'icon': getIcon(name),
      'color': getColor(name),
    });

    notifyListeners();
  }

  // Edita o nome de uma matéria.
  void editSubject(int index, String newName) {
    subjects[index] = {
      'name': newName.trim(),
      'icon': getIcon(newName),
      'color': getColor(newName),
    };

    notifyListeners();
  }

  // Exclui uma matéria.
  void deleteSubject(int index) {
    subjects.removeAt(index);
    notifyListeners();
  }
}
