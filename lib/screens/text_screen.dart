
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import '../services/selichot_service.dart';

class TextScreen extends StatefulWidget {
  final String nusachName;
  final String nusachKey;
  TextScreen({required this.nusachName, required this.nusachKey});

  @override
  _TextScreenState createState() => _TextScreenState();
}


class _TextScreenState extends State<TextScreen> {
  // משתנים
  Map<String, List<String>>? selichotDays;
  Map<String, String>? dayKeyToHebrew;
  String? selectedDay;
  bool isLoading = true;
  bool isError = false;
  double fontSize = 22;
  String? selectedNusachName;
  String? selectedNusachKey;

  // רשימת נוסחים לדוגמה
  final List<Map<String, String>> nusachList = [
    {'key': 'ashkenaz', 'name': 'אשכנז / ליטא'},
    {'key': 'sefard', 'name': 'ספרד / פולין'},
    {'key': 'edot_mizrach', 'name': 'עדות מזרח'},
  ];

  // כותרת יום
  String dayTitle = '';

  @override
  void initState() {
    super.initState();
    selectedNusachName = widget.nusachName;
    selectedNusachKey = widget.nusachKey;
    // טוען את הסליחות כבר בהתחלה
    loadSelichotDays(nusachKey: selectedNusachKey);
  }

  // פונקציה לאסינכרון טעינת סליחות
  Future<void> loadSelichotDays({String? nusachKey}) async {
    setState(() {
      isLoading = true;
      isError = false;
    });
    try {
      final key = nusachKey ?? selectedNusachKey ?? widget.nusachKey;
      selichotDays = await SelichotService.getSelichotDays(key);
      dayKeyToHebrew = await SelichotService.getDayKeyToHebrewName(key);
      selectedDay = selichotDays?.keys.first;
      dayTitle = selectedDay ?? '';
    } catch (e) {
      isError = true;
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: Drawer(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFF5E7C2),
                  Color(0xFFEAD7A1),
                  Color(0xFFD6B97B),
                ],
              ),
            ),
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 32, horizontal: 16),
              children: [
                Text(
                  'בחר נוסח:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'David',
                    color: Color(0xFF8B6F43),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedNusachKey,
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down, color: Color(0xFF8B6F43)),
                    style: TextStyle(
                      fontFamily: 'David',
                      fontSize: 18,
                      color: Color(0xFF8B6F43),
                    ),
                    items: nusachList.map((nusach) {
                      return DropdownMenuItem<String>(
                        value: nusach['key'],
                        child: Text(nusach['name']!, textDirection: TextDirection.rtl, textAlign: TextAlign.center),
                      );
                    }).toList(),
                    onChanged: (val) async {
                      final nusach = nusachList.firstWhere((n) => n['key'] == val);
                      setState(() {
                        selectedNusachKey = val;
                        selectedNusachName = nusach['name'];
                      });
                      await loadSelichotDays(nusachKey: val);
                    },
                  ),
                ),
                SizedBox(height: 24),
                if (selichotDays != null && selichotDays!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'בחר יום:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'David',
                          color: Color(0xFF8B6F43),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedDay,
                          isExpanded: true,
                          icon: Icon(Icons.arrow_drop_down, color: Color(0xFF8B6F43)),
                          style: TextStyle(
                            fontFamily: 'David',
                            fontSize: 18,
                            color: Color(0xFF8B6F43),
                          ),
                          items: selichotDays!.keys.map((dayKey) {
                            final hebrewName = (dayKeyToHebrew != null && dayKeyToHebrew![dayKey] != null)
                                ? dayKeyToHebrew![dayKey]!
                                : dayKey;
                            return DropdownMenuItem<String>(
                              value: dayKey,
                              child: Text(hebrewName, textDirection: TextDirection.rtl, textAlign: TextAlign.center),
                            );
                          }).toList(),
                          onChanged: (val) {
                            setState(() {
                              selectedDay = val;
                              dayTitle = (val != null && dayKeyToHebrew != null && dayKeyToHebrew![val] != null)
                                  ? dayKeyToHebrew![val]!
                                  : val ?? '';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 32),
                Text(
                  'גודל גופן:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'David',
                    color: Color(0xFF8B6F43),
                  ),
                  textAlign: TextAlign.center,
                ),
                Slider(
                  value: fontSize,
                  min: 16,
                  max: 60,
                  divisions: 12,
                  label: fontSize.round().toString(),
                  onChanged: (val) {
                    setState(() {
                      fontSize = val;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : selichotDays == null || selichotDays!.isEmpty
                ? Center(child: Text('לא נמצאו סליחות', textAlign: TextAlign.center,))
                : Container(
                    width: double.infinity,
                    color: Color(0xFFF9F3E6),
                    child: CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          backgroundColor: Color(0xFF5C3A1A),
                          expandedHeight: 90,
                          flexibleSpace: FlexibleSpaceBar(
                            centerTitle: true,
                            title: Text(
                              // הצג את שם הנוסח בעברית בלבד
                              nusachList.firstWhere((n) => n['key'] == (selectedNusachKey ?? widget.nusachKey))['name'] ?? '',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'David',
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                                color: Color(0xFFF5E7C2),
                                letterSpacing: 1.1,
                                shadows: [
                                  Shadow(
                                    blurRadius: 6,
                                    color: Colors.brown.shade400,
                                    offset: Offset(1, 2),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 18.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                if (selectedDay != null && (dayKeyToHebrew?[selectedDay] ?? '').isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 16.0),
                                    child: Text(
                                      dayKeyToHebrew![selectedDay!] ?? selectedDay!,
                                      style: TextStyle(
                                        fontFamily: 'David',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Color(0xFF8B6F43),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                Html(
                                  data: selichotDays![selectedDay]?.join('<br><br>') ?? '',
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(fontSize),
                                      fontFamily: 'David',
                                      direction: TextDirection.rtl,
                                      textAlign: TextAlign.center,
                                      color: Color(0xFF4E3B1F),
                                      backgroundColor: Color(0xFFF9F3E6),
                                      padding: HtmlPaddings.zero,
                                      margin: Margins.zero,
                                    ),
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        floatingActionButton: isError
            ? FloatingActionButton(
                onPressed: () => loadSelichotDays(nusachKey: selectedNusachKey),
                child: Icon(Icons.refresh),
                tooltip: 'נסה שוב',
              )
            : null,
      ),
    );
  }
}
