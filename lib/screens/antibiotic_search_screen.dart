import 'package:eda_pharma/data/antibiotec_data.dart';
import 'package:eda_pharma/data/search_antibiotic_services.dart';
import 'package:eda_pharma/model/antibiotec.dart';
import 'package:eda_pharma/screens/webView_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';

class AntibioticSearchScreen extends StatefulWidget {
  const AntibioticSearchScreen({super.key});

  @override
  State<AntibioticSearchScreen> createState() => _AntibioticSearchScreenState();
}

class _AntibioticSearchScreenState extends State<AntibioticSearchScreen> {
  final TextEditingController _searchBarController = TextEditingController();
  String _searchName = '';
  final String _searchKey = '';
  Antibiotec? _resultAntibiotic;
  bool clicked = false;
  bool showEmptyWarning = false;

  // الألوان المستوحاة من التصميم العصري الجديد
  final Color bgColor = const Color(0xFFF4F7FC);
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color darkText = const Color(0xFF102A43);

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  // الدالة كما هي بدون تغيير
  Antibiotec? _searchAntibiotic(String key) {
    Antibiotec antibiotic;
    for (int i = 0; i < antibiotec_data.length; i++) {
      if (antibiotec_data[i].id == key) {
        antibiotic = antibiotec_data[i];
        return antibiotic;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: darkText),
        title: Text(
          'Antibiotic Info',
          style: TextStyle(
            color: darkText, 
            fontWeight: FontWeight.bold, 
            fontSize: 20
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text(
                'Find Antibiotic',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: darkText,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Search our database for indications, side effects, and dosage.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 24),

              // حقل البحث العصري
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: TypeAheadField(
                  controller: _searchBarController,
                  builder: (context, controller, focusNode) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      // تم إيقاف الـ autofocus لحل مشكلة تباطؤ انتقال الشاشة (Performance Fix)
                      autofocus: false, 
                      style: TextStyle(color: darkText),
                      decoration: InputDecoration(
                        hintText: 'Search for antibiotics...',
                        hintStyle: TextStyle(color: Colors.grey.shade400),
                        prefixIcon: Icon(Icons.search, color: primaryBlue),
                        suffixIcon: _searchName.isNotEmpty 
                          ? const Icon(Icons.check_circle, color: Colors.green, size: 20) 
                          : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      ),
                    );
                  },
                  itemBuilder: (context, String value) => ListTile(
                    leading: Icon(Icons.medication_liquid, color: primaryBlue.withOpacity(0.5)),
                    title: Text(value, style: TextStyle(color: darkText, fontWeight: FontWeight.w500)),
                  ),
                  onSelected: (suggestion) {
                    setState(() {
                      _searchBarController.text = suggestion;
                      _searchName = _searchBarController.text;
                    });
                  },
                  suggestionsCallback: (String pattern) {
                    return SearchAntibioticServices.getAntibioticSuggestions(pattern);
                  },
                ),
              ),
              const SizedBox(height: 20),

              // زر البحث الاحترافي
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // إخفاء الكيبورد عند الضغط على زر البحث
                    FocusScope.of(context).unfocus(); 
                    
                    if (_searchBarController.text.trim().isEmpty) {
                      setState(() {
                        showEmptyWarning = true;
                        clicked = false;
                        _resultAntibiotic = null;
                      });
                    } else {
                      setState(() {
                        showEmptyWarning = false;
                        clicked = true;
                        _resultAntibiotic = _searchAntibiotic(
                          SearchAntibioticServices.antibioticNames
                              .firstWhere(
                                (element) => element.keys.first == _searchBarController.text,
                                orElse: () => {'': ''},
                              )
                              .values
                              .first,
                        );
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                  ),
                  child: const Text('Search Database', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(height: 16),

              // رسالة التحذير بتصميم نظيف
              if (showEmptyWarning)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 12),
                      Text(
                        'Please enter an antibiotic name',
                        style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),

              // بطاقة النتيجة (تمت إزالة النصوص المكررة وتنسيقها بشكل عصري)
              if (clicked && _resultAntibiotic != null)
                Container(
                  margin: const EdgeInsets.only(top: 10, bottom: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryBlue.withOpacity(0.08),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // الهيدر الخاص باسم الدواء وزر البحث عن الصور
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.shade100,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(Icons.science, color: Colors.amber.shade800, size: 28),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      _resultAntibiotic!.name,
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: darkText,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // زر البحث عن الصور (تم تحسين مظهره)
                            IconButton(
                              onPressed: () async {
                                final query = Uri.encodeComponent(_resultAntibiotic!.name);
                                final url = 'https://www.google.com/search?tbm=isch&q=$query';
                                if (Theme.of(context).platform == TargetPlatform.android) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => WebViewScreen(url: url),
                                    ),
                                  );
                                } else {
                                  if (await canLaunchUrl(Uri.parse(url))) {
                                    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                                  }
                                }
                              },
                              icon: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(Icons.image_search, color: primaryBlue, size: 24),
                              ),
                              tooltip: 'View Images',
                            ),
                          ],
                        ),
                        
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Divider(color: Color(0xFFE0E5EC), thickness: 1.5),
                        ),

                        // استدعاء دالة التنسيق لعرض البيانات بوضوح (بدون تكرار)
                        _buildInfoSection('Indication', _resultAntibiotic!.indecation),
                        _buildInfoSection('Side Effects', _resultAntibiotic!.sideEffect),
                        _buildInfoSection('Caution', _resultAntibiotic!.caution),
                        _buildInfoSection('Duration', _resultAntibiotic!.duration),
                        
                        // جرعات الدواء بخلفية مختلفة لتمييزها
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.monitor_weight_outlined, size: 20, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Text('Dosage Information', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue)),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildDosageRow('Adult Dose', _resultAntibiotic!.adDose),
                              const SizedBox(height: 8),
                              _buildDosageRow('Pediatric Dose', _resultAntibiotic!.prDose),
                            ],
                          ),
                        ),

                        _buildInfoSection('Source', _resultAntibiotic!.src),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // أدوات مساعدة لتنسيق النصوص (لجعل الكود نظيفاً وسهل القراءة)
  Widget _buildInfoSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: primaryBlue, fontSize: 15),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: const TextStyle(color: Colors.black87, fontSize: 15, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildDosageRow(String title, String content) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 110,
          child: Text(
            '$title:',
            style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87, fontSize: 14),
          ),
        ),
        Expanded(
          child: Text(
            content,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
        ),
      ],
    );
  }
}