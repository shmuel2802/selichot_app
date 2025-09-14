import 'dart:convert';
import 'package:flutter/services.dart';

class SelichotService {
  // מחזיר מיפוי של מפתחות ימים באנגלית לשמות בעברית (אם קיים schema)
  static Future<Map<String, String>?> getDayKeyToHebrewName(String nusachKey) async {
    try {
      String assetPath = _getAssetPath(nusachKey);
      final jsonStr = await rootBundle.loadString(assetPath);
      final data = json.decode(jsonStr);
      final schema = data['schema'] as Map<String, dynamic>?;
      if (schema == null || schema['nodes'] == null) {
        return null;
      }
      final nodes = schema['nodes'] as List<dynamic>;
      // יוצר מיפוי: אנגלית -> עברית
      final Map<String, String> keyToHebrew = {};
      for (final node in nodes) {
        if (node is Map<String, dynamic> && node['enTitle'] != null && node['heTitle'] != null) {
          keyToHebrew[node['enTitle']] = node['heTitle'];
        }
      }
      return keyToHebrew;
    } catch (e) {
      print('שגיאה בטעינת schema של ימים: $e');
      return null;
    }
  }
  // טוען את כל הסליחות מהקובץ המתאים לפי נוסח ומחזיר מפה של ימים לרשימות טקסט
  static Future<Map<String, List<String>>?> getSelichotDays(String nusachKey) async {
    try {
      String assetPath = _getAssetPath(nusachKey);
      final jsonStr = await rootBundle.loadString(assetPath);
      final data = json.decode(jsonStr);
      final text = data['text'];
      if (text == null) {
        print('שגיאה: לא נמצא מפתח "text" בקובץ הסליחות');
        return null;
      }
      if (text is Map<String, dynamic>) {
        // מבנה רגיל: ימים -> טקסטים
        return text.map((day, value) {
          if (value is List) {
            if (value.isNotEmpty && value.first is List) {
              return MapEntry(day, value.expand((e) => List<String>.from(e)).toList());
            } else {
              return MapEntry(day, List<String>.from(value));
            }
          } else {
            return MapEntry(day, <String>[]);
          }
        });
      } else if (text is List) {
        // מבנה של עדות מזרח: כל הסליחות ברשימה אחת
        return {'all': List<String>.from(text)};
      } else {
        print('שגיאה: מבנה לא נתמך של text');
        return null;
      }
    } catch (e) {
      print('שגיאה בטעינת קובץ סליחות: $e');
      return null;
    }
  }

  // מחזיר את הנתיב לקובץ המתאים לפי נוסח
  static String _getAssetPath(String nusachKey) {
    switch (nusachKey) {
      case 'ashkenaz':
        return 'assets/selichot/ashkenaz.json';
      case 'sefard':
        return 'assets/selichot/sefard.json';
      case 'edot_mizrach':
        return 'assets/selichot/edot_mizrach.json';
      default:
        return 'assets/selichot/ashkenaz.json';
    }
  }
}
