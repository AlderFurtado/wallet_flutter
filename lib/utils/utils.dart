import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Utils {
  static Color getColor(String categoria) {
    switch (categoria) {
      case 'Lazer':
        {
          return Colors.yellow;
        }
        break;

      case 'Transporte':
        {
          return Colors.blue;
        }
        break;

      case 'Alimentação':
        {
          return Colors.red;
        }
        break;

      case 'Saúde':
        {
          return Colors.green;
        }
        break;

      case 'Educação':
        {
          return Colors.brown;
        }
        break;

      case 'Outros':
        {
          return Colors.purple;
        }
        break;

      default:
        {
          return Colors.black;
        }
    }
  }

  static formatData(data) {
    return new DateFormat.yMd().format(data);
  }
}
