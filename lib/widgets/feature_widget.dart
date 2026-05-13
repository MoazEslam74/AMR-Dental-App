import 'package:eda_pharma/screens/about_us.dart';
import 'package:flutter/material.dart';
import 'package:eda_pharma/screens/antibiotic_search_screen.dart';
import 'package:eda_pharma/screens/infection_search_screen.dart';

class FeatureWidget extends StatelessWidget {
  const FeatureWidget({
    super.key,
    required this.featureColor,
    required this.featureName,
    required this.featureIcon,
    required this.routeName, // Add this
  });
  final Color featureColor;
  final String featureName;
  final IconData featureIcon;
  final String routeName; // Add this

  Widget _getPage(String routeName) {
    switch (routeName) {
      case '/infection':
        return InfectionSearchScreen();
      case '/antibiotic':
        return AntibioticSearchScreen();
      case '/about':
        return AboutUsScreen();
      default:
        return SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final page = _getPage(routeName);
        if (page is SizedBox) return; // Do nothing if route not found
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => page,
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
                  const begin = Offset(1.0, 0.0);
                  const end = Offset.zero;
                  final tween = Tween(begin: begin, end: end);
                  final offsetAnimation = animation.drive(tween);

                  return SlideTransition(
                    position: offsetAnimation,
                    child: child,
                  );
                },
          ),
        );
      },
      splashColor: (featureColor.withAlpha(100)),
      borderRadius: BorderRadius.circular(15),
      child: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Icon(featureIcon, color: Colors.white, size: 40),
                Text(
                  featureName,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ],
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: Colors.white, width: 2),
              color: featureColor,
            ),
            margin: EdgeInsets.all(10),
          ),
        ],
      ),
    );
  }
}
