import 'package:eda_pharma/model/infection.dart';

const infections_data = const [
  Infection(
    id: 'i1',
    name: 'Dental caries',
    img: 'images/i1.png',
    type: 'bacterial',
    symptoms: [
      'Toothache',
      'Sensitivity',
      'Visible holes or dark spots',
      'Pain when biting',
    ],
    treatment:
        'Early caries: Fluoride, oral hygiene, sealants.\n Cavitated lesions: Remove decay and fill with composite, amalgam, or glass ionomer.\n Pulp involvement: Pulp capping, root canal, or extraction. ',
    causingAgent: 'Streptococcus mutans',
  ),
  Infection(
    id: 'i2',
    name: 'Periodontitis',
    img: 'images/i2.png',
    type: 'bacterial',
    symptoms: [
      'swollen or puffy receding gums',
      ' tooth ',
      'mobility',
      'gum',
      'pockets',
      ' pus',
      'bleeding',
      'painful',
      'chewing',
    ],
    treatment:
        'Non-surgical: Scaling and deep cleaning Oral hygiene improvement Antibiotics if needed , amoxicillin combined with metronidazole, Surgical:  Flap surgery Bone grafts or regeneration',
    causingAgent: 'Porphyromonas gingivalis',
  ),
  Infection(
    id: 'i3',
    name: 'Dental abscess',
    img: 'images/i3.png',
    type: 'bacterial',
    symptoms: [
      'Severe throbbing pain that can spread to the jawbone, neck or ear',
      'facial swelling',
      'pus discharge',
      'fever',
      'foul odor in mouth',
    ],
    treatment:
        'Drain the abscess. Antibiotics: Amoxicillin or Amoxicillin + Clavulanic acid or Clindamycin (if allergic to penicillin). Pain relief: NSAIDs (e.g., ibuprofen). Tooth extraction if non-restorable.',
    causingAgent: 'Streptococcus anginosus (viridans group)',
  ),
  Infection(
    id: 'i4',
    name: 'Gingivitis',
    img: 'images/i4.png',
    type: 'bacterial',
    symptoms: [
      'Red gums',
      'swollen gums',
      'bleeding gums (esp. when brushing)',
      'bad breath',
    ],
    treatment:
        'Dental cleaning: Remove plaque (scaling). Good oral hygiene: Brushing daily, flossing. Antimicrobial mouthwash. Regular dental check-ups.',
    causingAgent: 'Streptococcus sanguinis',
  ),
  Infection(
    id: 'i5',
    name: 'Pericoronitis',
    img: 'images/i5.png',
    type: 'bacterial',
    symptoms: [
      'Pain/swelling around partially erupted tooth (often wisdom tooth)',
      'bad breath',
      'swelling around jaw',
    ],
    treatment:
        'Irrigation and cleaning of the area under the flap. Pain relief: NSAIDs. Antibiotics (e.g., metronidazole). Surgical removal of the flap or wisdom tooth if recurrent.',
    causingAgent: 'Streptococcus milleri group',
  ),
  Infection(
    id: 'i6',
    name: 'Ludwig’s angina',
    img: 'images/i6.png',
    type: 'bacterial',
    symptoms: [
      'Severe neck/mouth swelling',
      'difficulty in breathing/swallowing',
      'fever',
    ],
    treatment:
        'Airway management: Secure airway. IV antibiotics: Broad-spectrum (e.g., penicillin + metronidazole or clindamycin). Surgical drainage of infected spaces. Supportive care: Hydration, pain control, monitoring.',
    causingAgent: 'Streptococcus viridans, Staphylococcus aureus',
  ),

  Infection(
    id: 'i7',
    name: 'Acute necrotising ulcerative gingivitis',
    img: 'images/i7.png',
    type: 'bacterial',
    symptoms: [
      'destructive ulceration and inflammation of the interdental gum tissue',
      'Sudden gum pain',
      'foul odor',
      'bleeding',
    ],
    treatment:
        'Debridement: Gentle cleaning of necrotic tissue. Antibiotics: Metronidazole is the drug of choice. Oral hygiene: Chlorhexidine rinses, soft brushing. Pain relief: NSAIDs. Lifestyle changes: Stop smoking, manage stress, improve nutrition.',
    causingAgent: 'Fusobacterium nucleatum',
  ),
  Infection(
    id: 'i8',
    name: 'Osteomyelitis in the jaw',
    img: 'images/i8.png',
    type: 'bacterial',
    symptoms: [
      'Jaw pain',
      'swelling',
      'fever',
      'pus',
      'sometimes numbness (if there’s nerve involvement)',
    ],
    treatment:
        'IV antibiotics: Long-term (e.g., clindamycin, or penicillin + metronidazole). Surgically remove necrotic bone. Pain control. Treat the source: Extract infected teeth or drain abscesses.',
    causingAgent: 'Staphylococcus aureus',
  ),
  Infection(
    id: 'i9',
    name: 'Oral herpes',
    img: 'images/i9.png',
    type: 'viral',
    symptoms: ['Painful blisters on lips or inside mouth', 'tingling', 'fever'],
    treatment:
        'Antivirals: Acyclovir, valacyclovir (start early). Pain relief: Lidocaine gel, NSAIDs. Supportive care: Rest, fluids, avoid triggers.',
    causingAgent: 'Human simplex virus type 1',
  ),
  Infection(
    id: 'i10',
    name: 'Herpangina',
    img: 'images/i10.png',
    type: 'viral',
    symptoms: [
      'Vesicles/ulcers in soft palate',
      'fever',
      'sore throat',
      'loss of appetite (mainly in children)',
    ],
    treatment:
        'Supportive care only. Pain relief: Paracetamol or ibuprofen. Hydration: Encourage fluids. Soft, non-irritating foods. No antibiotics needed.',
    causingAgent: 'Coxsackievirus B',
  ),
  Infection(
    id: 'i11',
    name: 'Hand, foot and mouth disease',
    img: 'images/i11.png',
    type: 'viral',
    symptoms: ['Painful mouth sores', 'skin rash on hands/feet', 'fever'],
    treatment:
        'Supportive care: No specific cure. Pain relief: Paracetamol or ibuprofen. Hydration: Prevent dehydration.',
    causingAgent: 'Coxsackievirus A16',
  ),
  Infection(
    id: 'i12',
    name: 'measles-koplik-spots',
    img: 'images/i12.png',
    type: 'viral',
    symptoms: [
      'White spots inside cheeks',
      'fever',
      'cough',
      'runny nose',
      'skin rash',
      'malaise',
    ],
    treatment:
        'Supportive care: Rest, fluids, manage fever (paracetamol/ibuprofen). Vitamin A: Reduces severity. Isolation: Prevent spread. Monitor for complications: Pneumonia, encephalitis. No antiviral cure — prevention via MMR vaccine is key.',
    causingAgent: 'Measles virus',
  ),
  Infection(
    id: 'i13',
    name: 'HIV associated oral lesions',
    img: 'images/i13.png',
    type: 'viral',
    symptoms: [
      'oral thrush',
      'hairy leukoplakia',
      'persistent ulcers',
      'gingivitis',
      'periodontitis',
    ],
    treatment:
        'Antiretroviral therapy (ART) to control HIV; specific treatments for individual lesions such as antifungals for candidiasis, antivirals for herpes-related lesions.',
    causingAgent: 'HIV 1',
  ),
  Infection(
    id: 'i14',
    name: 'Oral Candidiasis',
    img: 'images/i14.png',
    type: 'viral',
    symptoms: [
      'Creamy white patches on tongue/cheeks and sometimes on the roof of the mouth and tonsils',
      'Redness',
      'soreness',
      'burning',
    ],
    treatment:
        'Nystatin suspension or clotrimazole lozenges (topical). Fluconazole or itraconazole for severe (systemic). Improve oral hygiene, adjust dentures, clean dentures.',
    causingAgent: 'Candida albicans',
  ),
  Infection(
    id: 'i15',
    name: 'Angular Cheilitis',
    img: 'images/i15.png',
    type: 'viral',
    symptoms: [
      'Fungal or yeast infections in the mouth such as thrush',
      'Cracks at corners of the mouth',
      'redness',
      'pain',
      'crusting',
    ],
    treatment:
        'Clotrimazole or miconazole (topical, for candida). Fusidic acid or mupirocin if bacterial infection (topical for Staph aureus) is suspected. Antifungal + steroid (e.g., miconazole + hydrocortisone) for inflammation and infection. Improve denture fit, correct nutritional deficiencies (iron, B12), manage drooling or lip licking.',
    causingAgent: 'Candida albicans',
  ),
  Infection(
    id: 'i16',
    name: 'Median Rhomboid Glossitis',
    img: 'images/i16.png',
    type: 'viral',
    symptoms: ['Smooth red area on mid-tongue', 'mild burning'],
    treatment:
        'fluconazole or clotrimazole. Regular brushing, tongue cleaning. Stop smoking.',
    causingAgent: 'Candida albicans',
  ),
  Infection(
    id: 'i17',
    name: 'Denture Stomatitis',
    img: 'images/i17.png',
    type: 'viral',
    symptoms: [
      'Redness under dentures',
      'swelling',
      'inflammation',
      'canker sores',
      'white or red patches on tongue, inner cheeks, lips or gums',
    ],
    treatment:
        'Nystatin or miconazole gel. Clean dentures daily, soak in antifungal solution (e.g., chlorhexidine or sodium hypochlorite if safe for material). Remove dentures at night to allow mucosa to recover. Adjust ill-fitting dentures if needed. Control diabetes, stop smoking, improve oral hygiene.',
    causingAgent: 'Candida albicans',
  ),
];
