import 'package:eda_pharma/model/antibiotec.dart';

const List<Antibiotec> antibiotec_data = const [
  Antibiotec(
    id: 'an1',
    name: 'Amoxicillin',
    indecation: 'First-line; broad coverage; well tolerated ',
    sideEffect:
        ' Gastrointestinal upset: nausea, vomiting, diarrhea \n Allergic reactions: rash, urticaria,anaphylaxis',
    caution:
        'Dose adjustment required in severe renal impairment\n Avoid in patients with penicillin or beta-lactam allergy',
    duration: '3–7 days ',
    adDose: '500 mg TID ',
    prDose:
        ': 20–40 mg/kg/day in divided doses every 8 hours (max 500 mg per dose).',
    src: 'ADA 2019; NICE 2020',
  ),
  Antibiotec(
    id: 'an2',
    name: 'Penicillin V ',
    indecation: 'Alternative first-line; narrower spectrum ',
    sideEffect:
        'Allergic reactions: rash, urticaria, anaphylaxis (most common with this group)\n Gastrointestinal upset: nausea, vomiting, diarrhea',
    caution:
        'Avoid in penicillin or beta-lactam allergy\nDose adjustment in renal impairmen',
    duration: '5 days',
    adDose: '500 mg QID ',
    prDose: 'N/A',
    src: 'NICE 2020',
  ),
  Antibiotec(
    id: 'an3',
    name: 'Amoxicillin-Clavulanate ',
    indecation: 'Broader coverage; used if amoxicillin fails',
    sideEffect:
        'Gastrointestinal upset: nausea, vomiting, diarrhea\n Hepatotoxicity (rare, more associated with this drug)\n Allergic reactions: rash, urticaria, anaphylaxis',
    caution:
        'Use with caution in severe hepatic impairment (risk of hepatotoxicity)\n Dose adjustment in renal impairment\n Avoid in penicillin or beta-lactam allergy',
    duration: '5-7 days',
    adDose: '875/125 mg BID',
    prDose: ' 25–45 mg/kg/day divided every 12 hours.',
    src: 'AAE 2017 ',
  ),
  Antibiotec(
    id: 'an4',
    name: 'Clindamycin',
    indecation: 'For penicillin allergy; higher risk of C. difficile',
    sideEffect:
        'Gastrointestinal upset: nausea, vomiting, diarrhea\n Clostridioides difficile infection (C. diff — major risk)\n Allergic reactions: rash, urticaria (less frequent)',
    caution:
        'Avoid if history of Clostridioides difficile infection\n Use cautiously in hepatic impairmen',
    duration: '5-7 days',
    adDose: '300 mg QID ',
    prDose: ' 10–25 mg/kg/day divided every 8 hours. ',
    src: 'ADA 2019; NICE 2020 ',
  ),
  Antibiotec(
    id: 'an5',
    name: 'Metronidazole',
    indecation: 'Often combined with amoxicillin',
    sideEffect:
        'Taste alteration (metallic taste)\n Headache\n Gastrointestinal upset: nausea, vomiting, diarrhea (less common)',
    caution:
        'Avoid alcohol (causes disulfiram-like reaction)\n Use with caution in severe hepatic impairment\n Potential drug interactions with warfarin (increases INR)',
    duration: '5 days',
    adDose: '400 mg TID ',
    prDose: 'N/A',
    src: 'AAE 2017 ',
  ),
  Antibiotec(
    id: 'an6',
    name: 'Azithromycin',
    indecation: 'Alternative in penicillin allergy',
    sideEffect:
        ' Gastrointestinal upset: nausea, vomiting, diarrhe\n Taste alteration (sometimes)\n Headache (occasional)\n Allergic reactions (rare)',
    caution:
        'Avoid with QT-prolonging drugs\n Use cautiously in severe hepatic impairment\n Alternative for penicillin-allergic patients',
    duration: '5 days ',
    adDose: '500 mg day 1, then 250 mg daily for 4 days ',
    prDose: '10 mg/kg on day 1, then 5 mg/kg once daily for 4 days',
    src: 'AAPD 2021 ',
  ),
];
