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
  bool showEmptyWarning = false; // Add this flag
  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

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
      appBar: AppBar(
        title: Text(
          'Antibiotic Info',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.amber,
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
                  'Antibiotic Search ',
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
                          suffix: Text(_searchName),
                          hintText: 'Search for antibiotics',
                        ),
                      );
                    },
                    itemBuilder: (context, String value) =>
                        ListTile(title: Text(value)),
                    onSelected: (suggestion) {
                      setState(() {
                        _searchBarController.text = suggestion;
                        _searchName = _searchBarController.text;
                      });
                    },
                    suggestionsCallback: (String pattern) {
                      return SearchAntibioticServices.getAntibioticSuggestions(
                        pattern,
                      );
                    },
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  onTap: () {
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
                                (element) =>
                                    element.keys.first ==
                                    _searchBarController.text,
                              )
                              .values
                              .first,
                        );
                      });
                    }
                  },
                  child: Container(
                    child: Text('Search'),
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.amberAccent),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                if (showEmptyWarning)
                  Container(
                    padding: EdgeInsets.all(16),
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(
                      color: Colors.red[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Please enter value',
                      style: TextStyle(
                        color: Colors.red[800],
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                clicked != false && _resultAntibiotic != null
                    ? Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 4,
                              blurRadius: 5,
                              offset: Offset(1, 5),
                            ),
                          ],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 1.0,
                            horizontal: 8,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(height: 10),

                                Text(
                                  ' ${_resultAntibiotic!.name}',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    final query = Uri.encodeComponent(
                                      _resultAntibiotic!.name,
                                    );
                                    final url =
                                        'https://www.google.com/search?tbm=isch&q=$query';
                                    if (Theme.of(context).platform ==
                                        TargetPlatform.android) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AntibioticWebViewScreen(url: url),
                                        ),
                                      );
                                    } else {
                                      // Open in browser for non-Android platforms

                                      if (await canLaunchUrl(Uri.parse(url))) {
                                        await launchUrl(
                                          Uri.parse(url),
                                          mode: LaunchMode.externalApplication,
                                        );
                                      }
                                    }
                                  },
                                  child: Icon(
                                    Icons.image,
                                    size: 50,
                                    color: Colors.blueAccent,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 10),

                                    SizedBox(height: 10),
                                    Text(
                                      'Indication: ${_resultAntibiotic!.indecation}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Side Effects:\n${_resultAntibiotic!.sideEffect}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Caution:\n${_resultAntibiotic!.caution}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Side Effects:\n${_resultAntibiotic!.sideEffect}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Caution:\n${_resultAntibiotic!.caution}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Duration: ${_resultAntibiotic!.duration}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Adult Dose: ${_resultAntibiotic!.adDose}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Pediatric Dose: ${_resultAntibiotic!.prDose}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Source: ${_resultAntibiotic!.src}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    SizedBox(height: 10),
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
