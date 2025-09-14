
import 'package:flutter/material.dart';
import 'text_screen.dart';

class HomeScreen extends StatelessWidget {
  // מסך הבית עם תפריט בחירת נוסח
  final List<Map<String, String>> nusachList = [
    {'name': 'אשכנז / ליטא', 'key': 'ashkenaz'},
    {'name': 'ספרד / פולין', 'key': 'sefard'},
    {'name': 'עדות מזרח', 'key': 'edot_mizrach'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F43),
        elevation: 0,
        title: Text(
          'בחירת נוסח סליחות',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontFamily: 'David',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Color(0xFFF5E7C2),
            shadows: [
              Shadow(
                blurRadius: 6,
                color: Colors.brown.shade700,
                offset: Offset(1, 2),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF5E7C2), // parchment
              Color(0xFFEAD7A1),
              Color(0xFFD6B97B),
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: nusachList.length,
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 16),
          itemBuilder: (context, index) {
            return Card(
              color: Color(0xFFF9F3E6),
              elevation: 6,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
                side: BorderSide(color: Color(0xFF8B6F43), width: 2),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                title: Center(
                  child: Text(
                    nusachList[index]['name']!,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: 'David',
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Color(0xFF8B6F43),
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          blurRadius: 3,
                          color: Colors.brown.shade200,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => TextScreen(
                        nusachName: nusachList[index]['name']!,
                        nusachKey: nusachList[index]['key']!,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
