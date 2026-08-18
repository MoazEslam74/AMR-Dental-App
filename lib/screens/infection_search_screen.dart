import 'package:eda_pharma/data/infection_data.dart';
import 'package:eda_pharma/data/search_infection_servies.dart';
import 'package:eda_pharma/model/infection.dart';
import 'package:eda_pharma/screens/webView_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:url_launcher/url_launcher.dart';

class InfectionSearchScreen extends StatefulWidget {
  const InfectionSearchScreen({super.key});

  @override
  State<InfectionSearchScreen> createState() => _InfectionSearchScreenState();
}

class _InfectionSearchScreenState extends State<InfectionSearchScreen> {
  final TextEditingController _searchBarController = TextEditingController();
  final List<String> _filiter = [];
  Infection? _resultInfection;
  bool clicked = false;
  bool hasValues = false;
  bool isHovered = false;
  bool isImageTapped = false;
  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  Infection? _searchInfection(List<String> filiter) {
    Infection? infc;
    int evaluation = 0;
    int maxEvaluation = 0;
    for (int i = 0; i < infections_data.length; i++) {
      evaluation = 0;
      for (int j = 0; j < _filiter.length; j++) {
        if (infections_data[i].symptoms.contains(_filiter[j])) {
          evaluation++;
        }
      }
      if (maxEvaluation < evaluation) {
        maxEvaluation = evaluation;
        infc = infections_data[i];
      }
    }
    return infc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.red,
      ),
      body: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Padding(
            padding: const EdgeInsets.only(top: 1.0),
            child: Column(
              children: [
                SizedBox(height: 20),
                Text(
                  'Infection Search Screen',
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TypeAheadField(
                    builder: (context, controller, focusNode) {
                      return TextField(
                        controller: controller,
                        focusNode: focusNode,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Search for infections',
                        ),
                      );
                    },
                    itemBuilder: (context, String value) =>
                        ListTile(title: Text(value)),
                    onSelected: (suggestion) {
                      setState(() {
                        _searchBarController.text = suggestion;
                      });
                    },
                    suggestionsCallback: (String pattern) {
                      return SearchService.getSuggestions(pattern);
                    },
                  ),
                ),
                Text(
                  _searchBarController.text,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: Colors.blue),
                ),
                Container(
                  child: Text(
                    _filiter.join(', '),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                InkWell(
                  onTap: () {
                    final text = _searchBarController.text.trim();
                    if (text.isNotEmpty && !_filiter.contains(text)) {
                      setState(() {
                        _filiter.add(text);
                        _searchBarController.clear();
                      });
                    }
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),

                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      color: Colors.blue[200],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text('add symptoms'),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_filiter.isNotEmpty) {
                      setState(() {
                        _resultInfection = _searchInfection(_filiter);
                        hasValues = true;
                        _filiter.clear();
                        _searchBarController.clear();
                        clicked = true;
                      });
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Please add at least one symptom.'),
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: double.infinity * 0.8,
                    margin: EdgeInsets.all(20),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber[200],
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: Colors.amber),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search),
                        SizedBox(width: 10),
                        Text(
                          'get the results',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10),
                clicked != false && _resultInfection != null && hasValues
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 5,
                              offset: Offset(1, 5),
                            ),
                          ],
                        ),
                        height: 500,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 1.0,
                            horizontal: 8,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isImageTapped = !isImageTapped;
                                    });
                                  },
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Image.asset(
                                        _resultInfection!.img,
                                        height: 200,
                                      ),
                                      if (isImageTapped)
                                        GestureDetector(
                                          onTap: () async {
                                            final query = Uri.encodeComponent(
                                              _resultInfection!.name,
                                            );
                                            final url =
                                                'https://www.google.com/search?tbm=isch&q=$query';

                                            // Check platform
                                            if (Theme.of(context).platform ==
                                                TargetPlatform.android) {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      WebViewScreen(
                                                        url: url,
                                                      ),
                                                ),
                                              );
                                            } else {
                                              // Open in browser for non-Android platforms

                                              if (await canLaunchUrl(
                                                Uri.parse(url),
                                              )) {
                                                await launchUrl(
                                                  Uri.parse(url),
                                                  mode: LaunchMode
                                                      .externalApplication,
                                                );
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: 150,
                                            color: Colors.black.withOpacity(
                                              0.5,
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                              'Tap again to see more images',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                Text(
                                  _resultInfection!.name,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineLarge,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    'Infection type: ${_resultInfection!.type}',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '- Symptoms: ${_resultInfection!.symptoms.join(', ')}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '- Treatment: ${_resultInfection!.treatment}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        '- Causing Agent: ${_resultInfection!.causingAgent}',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyMedium,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
