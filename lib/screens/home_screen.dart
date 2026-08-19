import 'package:eda_pharma/widgets/feature_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    // الألوان المستوحاة من نمط التصميم العصري الجديد
    const backgroundColor = Color(0xFFF4F7FC); // رمادي فاتح مريح جداً للخلفية
    const primaryColor = Color(0xFF1976D2);    // أزرق احترافي للبانر الأساسي

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. قسم العنوان العلوي (Header)
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 8),
                child: Text(
                  'AB_Guide',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102A43), // كحلي داكن عصري
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              // 2. كرت الشرح التفاعلي (تم تحويله لـ Hero Banner أزرق جذاب)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24), // زوايا دائرية ناعمة
                  color: primaryColor,
                  boxShadow: [
                    BoxShadow(
                      color: primaryColor.withOpacity(0.25),
                      spreadRadius: 1,
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // النص الذي يتغير عند الضغط (محفوظ بالكامل)
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 400),
                        firstChild: Text(
                          'Antimicrobials are drugs that prevent and treat infectious diseases in humans, animals, and plants. They include antibiotics, antivirals, antifungals, and antiparasitics...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        secondChild: Text(
                          'Antimicrobials are drugs that prevent and treat infectious diseases in humans, animals, and plants. They include antibiotics, antivirals, antifungals, and antiparasitics. When pathogens such as bacteria, viruses, fungi, and parasites stop responding to these medications, it results in antimicrobial resistance (AMR). Antibiotics and other antimicrobials become ineffective due to this resistance, making infections hard or impossible to treat, thereby increasing the risk of disease transmission, serious illness, disability, and even death. Human actions, particularly the misuse and overuse of antimicrobials, significantly contribute to the development and spread of AMR. While AMR is a natural process arising from genetic changes in bacteria, it has been accelerated by human behavior.',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            height: 1.4,
                          ),
                        ),
                        crossFadeState: _isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                      ),

                      const SizedBox(height: 12),

                      // زر التحكم في التمدد والتقلص (محفوظ بالكامل)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded;
                          });
                        },
                        child: Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Text(
                                _isExpanded ? 'See less' : 'See more',
                                style: const TextStyle(
                                  color: Colors.greenAccent, // لون يبرز بجمالية فوق الأزرق
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Icon(
                                _isExpanded
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: Colors.greenAccent,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // عنوان جانبي منبثق لأقسام الميزات
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Text(
                  'Features & Services',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF102A43),
                  ),
                ),
              ),

              // 3. حاوية الخدمات والميزات (أصبحت بخلفية ناعمة لترتيب الـ Widgets)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  children: [
                    // الـ FeatureWidgets محفوظة بالكامل بدون تعديل في الـ Routes
                    Badge(
                      
                      label: const Text('Beta', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      backgroundColor: Colors.redAccent,
                      offset: Offset(-30, 10),
                      child: FeatureWidget(
                        featureColor: Colors.blue.shade600,
                        featureName: "Medical diagnosis with AI",
                        featureIcon: Icons.chat_rounded,
                        routeName: '/beta_chat',
                      ),
                    ),
                    FeatureWidget(
                      featureColor: Colors.amber.shade700,
                      featureName: "Antibiotic info",
                      featureIcon: Icons.science_rounded,
                      routeName: '/antibiotic',
                    ),
                    FeatureWidget(
                      featureColor: Colors.green.shade600,
                      featureName: "About us",
                      featureIcon: Icons.medical_services_rounded,
                      routeName: '/about',
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // شعار التطبيق السفلي منسق بشكل احترافي ونظيف
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              blurRadius: 10,
                              spreadRadius: 2,
                            )
                          ]
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'images/icon.jpeg',
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}