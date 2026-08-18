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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 1),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const SizedBox(height: 60),
                    const Text(
                      'AB_Guide',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 12, 172, 196),
                      ),
                    ),

                    // النص اللي بيتغير عند الضغط
                    AnimatedCrossFade(
                      duration: const Duration(milliseconds: 400),
                      firstChild: Text(
                        'Antimicrobials are drugs that prevent and treat infectious diseases in humans, animals, and plants. They include antibiotics, antivirals, antifungals, and antiparasitics...',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      secondChild: Text(
                        'Antimicrobials are drugs that prevent and treat infectious diseases in humans, animals, and plants. They include antibiotics, antivirals, antifungals, and antiparasitics. When pathogens such as bacteria, viruses, fungi, and parasites stop responding to these medications, it results in antimicrobial resistance (AMR). Antibiotics and other antimicrobials become ineffective due to this resistance, making infections hard or impossible to treat, thereby increasing the risk of disease transmission, serious illness, disability, and even death. Human actions, particularly the misuse and overuse of antimicrobials, significantly contribute to the development and spread of AMR. While AMR is a natural process arising from genetic changes in bacteria, it has been accelerated by human behavior.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      crossFadeState: _isExpanded
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                    ),

                    const SizedBox(height: 8),

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
                                color: Colors.amber,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Icon(
                              _isExpanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                              color: Colors.amber,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height,
              ),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(1, 3),
                  ),
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                color: Color.fromARGB(255, 12, 172, 196),
                // borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  // FeatureWidget(
                  //   featureColor: Colors.red,
                  //   featureName: "Search using symptoms",
                  //   featureIcon: Icons.search,
                  //   routeName: '/infection',
                  // ),
                  
                  FeatureWidget(
                    featureColor: Colors.blue,
                    featureName: "Search using AI",
                    featureIcon: Icons.chat,
                    routeName: '/beta_chat',
                  ),
                  FeatureWidget(
                    featureColor: Colors.amber,
                    featureName: "Antibiotic info",
                    featureIcon: Icons.science,
                    routeName: '/antibiotic',
                  ),
                  FeatureWidget(
                    featureColor: Colors.green,
                    featureName: "About us",
                    featureIcon: Icons.medical_services,
                    routeName: '/about',
                  ),
                  SizedBox(height: 20),
                  ClipOval(
                    child: Image.asset(
                      'images/icon.jpeg',
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
