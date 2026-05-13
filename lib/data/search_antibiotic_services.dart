class SearchAntibioticServices {
  static List<Map<String, String>> antibioticNames = [
    {'Amoxicillin': 'an1'},
    {'Penicillin V': 'an2'},
    {'Amoxicillin-Clavulanate': 'an3'},
    {'Clindamycin': 'an4'},
    {'Metronidazole': 'an5'},
    {'Azithromycin': 'an6'},
  ];
  static List<String> getAntibioticSuggestions(String query) {
    List<String> matches = [];
    matches.addAll(antibioticNames.map((e) => e.keys.first));
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}
