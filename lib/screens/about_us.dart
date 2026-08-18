import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  // الألوان الموحدة للتصميم العصري
  final Color bgColor = const Color(0xFFF4F7FC);
  final Color primaryBlue = const Color(0xFF1976D2);
  final Color darkText = const Color(0xFF102A43);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        iconTheme: IconThemeData(color: darkText),
        title: Text(
          'About Us',
          style: TextStyle(color: darkText, fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. بطاقة فريق العمل
            _buildSectionCard(
              icon: Icons.groups_rounded,
              title: 'Our Team',
              content: const Text(
                'We are a team of healthcare professionals, pharmacists, and developers committed to improving antibiotic stewardship and patient care through technology.',
                style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 20),

            // 2. بطاقة التواصل
            _buildSectionCard(
              icon: Icons.contact_support_rounded,
              title: 'Contact Us',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'For inquiries, feedback, or support, please visit our official Facebook page:',
                    style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 16),
                  _buildSocialButton(
                    title: 'Visit our Facebook Page',
                    icon: Icons.facebook,
                    url: 'https://www.facebook.com/share/14M31847t7x/',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // 3. بطاقة المطور
            _buildSectionCard(
              icon: Icons.code_rounded,
              title: 'Developed By',
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'If you have any questions or technical feedback, feel free to reach out to me directly:',
                    style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  
                  // تصميم البروفايل الخاص بك
                  InkWell(
                    onTap: () async {
                      final url = 'https://www.facebook.com/moaz.eslam.39/';
                      if (await canLaunchUrl(Uri.parse(url))) {
                        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Column(
                          children: [
                            // إطار متدرج حول الصورة
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [primaryBlue, Colors.lightBlueAccent],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: primaryBlue.withOpacity(0.25),
                                    spreadRadius: 2,
                                    blurRadius: 15,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: const CircleAvatar(
                                radius: 55, // حجم متناسق وعصري
                                backgroundImage: AssetImage('images/Moaz.png'),
                                backgroundColor: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Moaz Eslam NourEldin',
                              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: darkText),
                            ),
                            const SizedBox(height: 8),
                            // Badge للمسمى الوظيفي
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'AI Engineer & Mobile Developer',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: primaryBlue),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.touch_app_rounded, size: 16, color: Colors.grey),
                                SizedBox(width: 8),
                                Text('Tap to connect on Facebook', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  // دوال مساعدة لبناء واجهة نظيفة (Helper Methods)
  // ---------------------------------------------------------

  // 1. دالة بناء البطاقة الأساسية
  Widget _buildSectionCard({required IconData icon, required String title, required Widget content}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: primaryBlue.withOpacity(0.06),
            blurRadius: 15,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryBlue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: primaryBlue, size: 24),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: darkText),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFE0E5EC), thickness: 1.5, height: 0),
          ),
          content,
        ],
      ),
    );
  }

  // 2. دالة بناء زر الروابط (Social Button)
  Widget _buildSocialButton({required String title, required IconData icon, required String url}) {
    return InkWell(
      onTap: () async {
        if (await canLaunchUrl(Uri.parse(url))) {
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F0FE), // لون أزرق فاتح جداً مريح
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: primaryBlue.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1877F2), size: 28), // لون فيسبوك الرسمي
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Color(0xFF1877F2), fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
            const Icon(Icons.open_in_new_rounded, color: Color(0xFF1877F2), size: 20),
          ],
        ),
      ),
    );
  }
}