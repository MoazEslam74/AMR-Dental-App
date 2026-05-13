import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'About Us',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_right, size: 30, color: Colors.green),
                  Text(
                    'Our Team',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),

              SizedBox(height: 10),
              Text(
                textAlign: TextAlign.justify,
                ' We are a team of healthcare professionals, pharmacists, and developers committed to improving antibiotic stewardship and patient care through technology.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.arrow_right, size: 30, color: Colors.green),
                  Text(
                    'Contact Us',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'visit our Facebook page ',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              GestureDetector(
                onTap: () async {
                  final url = 'https://www.facebook.com/share/14M31847t7x/';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: Text(
                  'https://www.facebook.com/share/14M31847t7x/',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),

              SizedBox(height: 20),
              Row(
                children: [
                  Icon(Icons.arrow_right, size: 30, color: Colors.green),
                  Text(
                    'Developed by Moaz Eslam',
                    style: Theme.of(context).textTheme.headlineLarge,
                  ),
                ],
              ),
              SizedBox(height: 10),
              Text(
                'if you have any questions or feedback, feel free to reach out to me on Facebook:',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              SizedBox(height: 20),
              InkWell(
                onTap: () async {
                  final url = 'https://www.facebook.com/moaz.eslam.39/';
                  if (await canLaunchUrl(Uri.parse(url))) {
                    await launchUrl(
                      Uri.parse(url),
                      mode: LaunchMode.externalApplication,
                    );
                  }
                },
                child: Center(
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(
                                255,
                                0,
                                0,
                                0,
                              ).withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(1, 3),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 110,
                          backgroundImage: AssetImage('images/Moaz.png'),
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Moaz Eslam NourEldin',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'ICS student & Mobile Developer',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
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
}
