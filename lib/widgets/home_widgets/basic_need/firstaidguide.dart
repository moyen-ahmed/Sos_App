import 'package:flutter/material.dart';

class FirstAidGuide extends StatelessWidget {
  const FirstAidGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Aid Guide'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader('Emergency First Aid Guide'),
              _buildCategory(
                context,
                'CPR Instructions',
                'assets/cpr.png',
                'How to perform CPR correctly',
                const CPRGuide(),
              ),
              _buildCategory(
                context,
                'Bleeding Control',
                'assets/blood.jpg',
                'How to stop bleeding and treat wounds',
                const BleedingGuide(),
              ),
              _buildCategory(
                context,
                'Burn Treatment',
                'assets/burn.png',
                'First aid for different burn types',
                const BurnGuide(),
              ),
              _buildCategory(
                context,
                'Choking',
                'assets/Choking.png',
                'Heimlich maneuver and choking relief',
                const ChokingGuide(),
              ),
              _buildCategory(
                context,
                'Fractures & Sprains',
                'assets/spa.jpg',
                'How to immobilize injuries',
                const FractureGuide(),
              ),
              _buildEmergencyContact(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Important: In case of serious emergency, call emergency services immediately.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'This guide provides basic first aid information. Always seek professional medical help when needed.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategory(
      BuildContext context,
      String title,
      String imagePath,
      String description,
      Widget detailPage,
      ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => detailPage),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.red.shade100,
                      child: const Icon(Icons.healing, color: Colors.red, size: 40),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.red),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContact() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.phone_in_talk, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Emergency Contacts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildContactItem('Emergency Services', '911'),
          _buildContactItem('Poison Control', '1-800-222-1222'),
          // _buildContactItem('Local Hospital', 'Add your local number'),
        ],
      ),
    );
  }

  Widget _buildContactItem(String label, String number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            number,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Detail pages for each first aid category
class CPRGuide extends StatelessWidget {
  const CPRGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPR Guide'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/cpr-.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.red.shade100,
                    child: const Center(child: Icon(Icons.healing, size: 64, color: Colors.red)),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'Adult CPR Instructions',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStep('1. Check for responsiveness', 'Tap the person and shout "Are you OK?"'),
              _buildStep('2. Call for help', 'Have someone call emergency services (911)'),
              _buildStep('3. Open the airway', 'Tilt head back slightly, lift chin'),
              _buildStep('4. Check for breathing', 'Look, listen, and feel for breathing for 5-10 seconds'),
              _buildStep('5. Begin chest compressions', 'Place hands on center of chest, push hard and fast (100-120 compressions per minute)'),
              _buildStep('6. Give rescue breaths', 'After 30 compressions, give 2 rescue breaths'),
              _buildStep('7. Continue CPR', 'Repeat cycles of 30 compressions and 2 breaths until help arrives'),
              const SizedBox(height: 24),
              const Text(
                'Child CPR (1-8 years)',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStep('1. Follow the same steps as adult CPR but:', ''),
              _buildStep('', '• Use one or two hands for compressions (depending on child\'s size)'),
              _buildStep('', '• Use gentler compressions'),
              _buildStep('', '• Give 2 breaths after every 30 compressions'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'IMPORTANT: This is a simplified guide. Proper CPR training is strongly recommended for everyone.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                description,
                style: const TextStyle(fontSize: 15),
              ),
            ),
        ],
      ),
    );
  }
}

class BleedingGuide extends StatelessWidget {
  const BleedingGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bleeding Control'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                'assets/blod.png',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.red.shade100,
                    child: const Center(child: Icon(Icons.healing, size: 64, color: Colors.red)),
                  );
                },
              ),
              const SizedBox(height: 16),
              const Text(
                'How to Control Bleeding',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildStep('1. Apply direct pressure', 'Use clean cloth or bandage and press firmly on the wound'),
              _buildStep('2. Elevate the wound', 'If possible, raise the injured area above heart level'),
              _buildStep('3. Apply more padding', 'If blood soaks through, add more padding without removing the first layer'),
              _buildStep('4. Use pressure points', 'If bleeding continues, apply pressure to the major artery'),
              _buildStep('5. Use tourniquet as last resort', 'Only for severe, life-threatening bleeding that cannot be controlled'),
              const SizedBox(height: 24),
              const Text(
                'Types of Wounds',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildWoundType('Abrasion (Scrape)', 'Clean with mild soap and water, apply antibiotic ointment'),
              _buildWoundType('Laceration (Cut)', 'Apply pressure, clean thoroughly, close with butterfly bandages if deep'),
              _buildWoundType('Puncture', 'Let it bleed briefly, clean well, watch for signs of infection'),
              _buildWoundType('Avulsion (Torn skin)', 'Save any detached tissue, keep it clean and cool, seek medical help'),
              Container(
                margin: const EdgeInsets.only(top: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'IMPORTANT: Seek medical attention for deep wounds, wounds that won\'t stop bleeding, or any animal/human bites.',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4),
            child: Text(
              description,
              style: const TextStyle(fontSize: 15),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWoundType(String type, String treatment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              treatment,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

// Similar implementation for other guide pages
class BurnGuide extends StatelessWidget {
  const BurnGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Burn Treatment'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/Burns.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.red.shade100,
                  child: const Center(child: Icon(Icons.healing, size: 64, color: Colors.red)),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Burn Treatment Guide',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildBurnType(
              'First-Degree Burns',
              'Affects only the outer layer of skin. Skin is red, painful, and may be swollen.',
              '• Cool the burn with cool (not cold) running water for 10-15 minutes\n• Apply aloe vera gel or moisturizer\n• Take over-the-counter pain reliever if needed\n• Protect the area with a sterile, non-stick bandage',
            ),
            _buildBurnType(
              'Second-Degree Burns',
              'Affects both the outer and underlying layer of skin. Causes pain, redness, swelling, and blistering.',
              '• Cool the burn with cool (not cold) running water for 15-20 minutes\n• Don\'t break blisters\n• Apply antibiotic ointment\n• Cover with sterile, non-stick bandage\n• Seek medical attention for large burns',
            ),
            _buildBurnType(
              'Third-Degree Burns',
              'Extends through all layers of skin. Area may appear charred or white.',
              '• Call emergency services immediately\n• Do not remove clothing stuck to the burn\n• Cover the area with a cool, moist, sterile bandage\n• Elevate the burned area above heart level if possible',
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WARNING:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Never use ice, butter, or oils on burns\n• Seek immediate medical attention for large or third-degree burns\n• Chemical and electrical burns always require medical attention',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBurnType(String title, String description, String treatment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
            ),
            const Divider(height: 24),
            const Text(
              'Treatment:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              treatment,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}

class ChokingGuide extends StatelessWidget {
  const ChokingGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choking Relief'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/ck.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.red.shade100,
                  child: const Center(child: Icon(Icons.healing, size: 64, color: Colors.red)),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Heimlich Maneuver (Abdominal Thrusts)',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStep(
                '1. Recognize choking',
                'Person cannot speak, cough, or breathe; they may hold their throat'
            ),
            _buildStep(
                '2. Stand behind the person',
                'Wrap your arms around their waist'
            ),
            _buildStep(
                '3. Position your hands',
                'Make a fist with one hand, place the thumb side against the middle of the person\'s abdomen, just above the navel'
            ),
            _buildStep(
                '4. Grasp your fist with your other hand',
                'Press into the abdomen with quick, upward thrusts'
            ),
            _buildStep(
                '5. Repeat thrusts',
                'Continue until the object is expelled or the person becomes unconscious'
            ),
            const SizedBox(height: 24),
            const Text(
              'For Unconscious Person',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildStep(
                '1. Place the person on their back',
                ''
            ),
            _buildStep(
                '2. Begin CPR',
                'Start with chest compressions which may help dislodge the object'
            ),
            _buildStep(
                '3. Look in the mouth',
                'Before giving breaths, check if you can see the object'
            ),
            _buildStep(
                '4. Remove the object if visible',
                'Only if you can see it clearly, try to remove it'
            ),
            _buildStep(
                '5. Continue CPR if needed',
                ''
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Special Situations:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• For pregnant or obese persons: Position hands at the base of the breastbone\n• Self-Heimlich: Use a chair back or counter edge to apply pressure to your abdomen\n• For children: Use gentler thrusts',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (description.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(left: 16, top: 4),
              child: Text(
                description,
                style: const TextStyle(fontSize: 15),
              ),
            ),
        ],
      ),
    );
  }
}

class FractureGuide extends StatelessWidget {
  const FractureGuide({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fractures & Sprains'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/spa1.png',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 200,
                  color: Colors.red.shade100,
                  child: const Center(child: Icon(Icons.healing, size: 64, color: Colors.red)),
                );
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'Fractures, Sprains & Strains',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInjuryType(
              'Fractures (Broken Bones)',
              '• Pain that increases with movement\n• Swelling and bruising\n• Deformity or abnormal position\n• Limited mobility\n• Possible grinding sensation',
              '• Immobilize the injury - don\'t move the injured area\n• Apply ice wrapped in cloth for 20 minutes\n• Elevate the injured area if possible\n• Seek medical attention immediately',
            ),
            _buildInjuryType(
              'Sprains (Ligament Injury)',
              '• Pain around a joint\n• Swelling and bruising\n• Limited flexibility\n• Possible "pop" sound at time of injury',
              '• Follow the R.I.C.E method:\n  - Rest: Avoid using the injured area\n  - Ice: Apply for 20 minutes, 4-8 times daily\n  - Compression: Use elastic bandage\n  - Elevation: Keep area above heart level\n• Seek medical attention for severe sprains',
            ),
            _buildInjuryType(
              'Strains (Muscle/Tendon Injury)',
              '• Muscle pain and tenderness\n• Muscle weakness\n• Muscle spasm\n• Swelling\n• Limited movement',
              '• Follow the R.I.C.E method as above\n• Take over-the-counter pain relievers if needed\n• Seek medical attention if severe or not improving',
            ),
            Container(
              margin: const EdgeInsets.only(top: 16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'WARNING:',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '• Do not try to straighten broken bones\n• Do not move a person with suspected back, neck, or head injury\n• Seek immediate medical attention for open fractures (bone piercing skin)',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInjuryType(String title, String symptoms, String treatment) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Symptoms:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              symptoms,
              style: const TextStyle(fontSize: 15),
            ),
            const Divider(height: 24),
            const Text(
              'Treatment:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              treatment,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}