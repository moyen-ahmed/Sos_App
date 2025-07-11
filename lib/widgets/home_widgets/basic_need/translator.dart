import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EnglishToBanglaTranslator extends StatefulWidget {
  const EnglishToBanglaTranslator({Key? key}) : super(key: key);

  @override
  State<EnglishToBanglaTranslator> createState() => _EnglishToBanglaTranslatorState();
}

class _EnglishToBanglaTranslatorState extends State<EnglishToBanglaTranslator> {
  final TextEditingController _englishController = TextEditingController();
  String _banglaText = '';
  bool _isLoading = false;
  bool _showError = false;
  String _errorMessage = '';

  // Map of common English to Bangla translations (as a basic example)
  // In a real app, you would use an API service for translation
  final Map<String, String> _commonTranslations = {
    'hello': 'হ্যালো',
    'hi': 'হাই',
    'good morning': 'শুভ সকাল',
    'good afternoon': 'শুভ অপরাহ্ন',
    'good evening': 'শুভ সন্ধ্যা',
    'how are you': 'আপনি কেমন আছেন',
    'thank you': 'ধন্যবাদ',
    'welcome': 'স্বাগতম',
    'yes': 'হ্যাঁ',
    'no': 'না',
    'food': 'খাবার',
    'water': 'পানি',
    'help': 'সাহায্য',
    'emergency': 'জরুরী',
    'hospital': 'হাসপাতাল',
    'doctor': 'ডাক্তার',
    'medicine': 'ঔষধ',
    'police': 'পুলিশ',
    'fire': 'আগুন',
    'money': 'টাকা',
    'where': 'কোথায়',
    'when': 'কখন',
    'why': 'কেন',
    'what': 'কি',
    'how': 'কিভাবে',
    'who': 'কে',
    'friend': 'বন্ধু',
    'family': 'পরিবার',
    'home': 'বাড়ি',
    'school': 'বিদ্যালয়',
    'college': 'কলেজ',
    'university': 'বিশ্ববিদ্যালয়',
    'teacher': 'শিক্ষক',
    'student': 'ছাত্র',
    'boy': 'ছেলে',
    'girl': 'মেয়ে',
    'man': 'পুরুষ',
    'woman': 'নারী',
    'child': 'শিশু',
    'baby': 'বাচ্চা',
    'father': 'বাবা',
    'mother': 'মা',
    'brother': 'ভাই',
    'sister': 'বোন',
    'husband': 'স্বামী',
    'wife': 'স্ত্রী',
    'son': 'ছেলে সন্তান',
    'daughter': 'মেয়ে সন্তান',
    'bus': 'বাস',
    'train': 'ট্রেন',
    'car': 'গাড়ি',
    'bicycle': 'সাইকেল',
    'motorcycle': 'মোটরসাইকেল',
    'airport': 'বিমানবন্দর',
    'station': 'স্টেশন',
    'road': 'রাস্তা',
    'street': 'সড়ক',
    'hotel': 'হোটেল',
    'room': 'কক্ষ',
    'bed': 'বিছানা',
    'door': 'দরজা',
    'window': 'জানালা',
    'chair': 'চেয়ার',
    'table': 'টেবিল',
    'light': 'আলো',
    'fan': 'পাখা',
    'phone': 'ফোন',
    'mobile': 'মোবাইল',
    'computer': 'কম্পিউটার',
    'internet': 'ইন্টারনেট',
    'email': 'ইমেইল',
    'message': 'বার্তা',
    'call': 'কল',
    'speak': 'বলুন',
    'listen': 'শুনুন',
    'read': 'পড়ুন',
    'write': 'লিখুন',
    'language': 'ভাষা',
    'bangla': 'বাংলা',
    'english': 'ইংরেজি',
    'day': 'দিন',
    'night': 'রাত',
    'morning': 'সকাল',
    'evening': 'সন্ধ্যা',
    'today': 'আজ',
    'tomorrow': 'আগামীকাল',
    'yesterday': 'গতকাল',
    'week': 'সপ্তাহ',
    'month': 'মাস',
    'year': 'বছর',
    'hour': 'ঘণ্টা',
    'minute': 'মিনিট',
    'second': 'সেকেন্ড',
    'now': 'এখন',
    'later': 'পরে',
    'early': 'আগে',
    'late': 'দেরিতে',
    'happy': 'খুশি',
    'sad': 'দুঃখিত',
    'angry': 'রাগান্বিত',
    'tired': 'ক্লান্ত',
    'sick': 'অসুস্থ',
    'healthy': 'সুস্থ',
    'hot': 'গরম',
    'cold': 'ঠান্ডা',
    'rain': 'বৃষ্টি',
    'sun': 'সূর্য',
    'moon': 'চাঁদ',
    'star': 'তারা',
    'sky': 'আকাশ',
    'earth': 'পৃথিবী',
    'tree': 'গাছ',
    'flower': 'ফুল',
    'fruit': 'ফল',
    'vegetable': 'সবজি',
    'rice': 'ভাত',
    'fish': 'মাছ',
    'meat': 'মাংস',
    'egg': 'ডিম',
    'milk': 'দুধ',
    'sugar': 'চিনি',
    'salt': 'লবণ',
    'bread': 'পাউরুটি',
    'tea': 'চা',
    'coffee': 'কফি',
    'breakfast': 'নাশতা',
    'lunch': 'দুপুরের খাবার',
    'dinner': 'রাতের খাবার',
    'eat': 'খাওয়া',
    'drink': 'পান করা',
    'sleep': 'ঘুম',
    'wake up': 'জেগে উঠুন',
    'go': 'যান',
    'come': 'আসুন',
    'sit': 'বসুন',
    'stand': 'দাঁড়ান',
    'walk': 'হাঁটা',
    'run': 'দৌড়ানো',
    'play': 'খেলা',
    'work': 'কাজ',
    'study': 'অধ্যয়ন',
    'buy': 'কেনা',
    'sell': 'বিক্রি করা',
    'open': 'খোলা',
    'close': 'বন্ধ',
    'clean': 'পরিষ্কার',
    'dirty': 'নোংরা',
    'big': 'বড়',
    'small': 'ছোট',
    'long': 'দীর্ঘ',
    'short': 'সংক্ষিপ্ত',
    'fast': 'দ্রুত',
    'slow': 'ধীরে',
    'good': 'ভালো',
    'bad': 'খারাপ',
    'beautiful': 'সুন্দর',
    'ugly': 'কুৎসিত',
    'easy': 'সহজ',
    'difficult': 'কঠিন',
    'new': 'নতুন',
    'old': 'পুরানো',
    'young': 'তরুণ',
    'strong': 'শক্তিশালী',
    'weak': 'দুর্বল',
    'expensive': 'দামি',
    'cheap': 'সস্তা',
    'correct': 'সঠিক',
    'wrong': 'ভুল',
    'left': 'বাম',
    'right': 'ডান',
    'up': 'উপর',
    'down': 'নিচে',
    'inside': 'ভিতরে',
    'outside': 'বাইরে',
    'near': 'কাছাকাছি',
    'far': 'দূরে',
    'here': 'এখানে',
    'there': 'ওখানে',
  };

  // In a real application, you would use an API service like Google Translate API
  Future<void> _translateText() async {
    String englishText = _englishController.text.trim().toLowerCase();

    if (englishText.isEmpty) {
      setState(() {
        _banglaText = '';
        _showError = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showError = false;
    });

    // Simulate API call with a delay
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      // Check if the text is in our basic dictionary
      if (_commonTranslations.containsKey(englishText)) {
        setState(() {
          _banglaText = _commonTranslations[englishText]!;
          _isLoading = false;
        });
      } else {
        // In a real app, you would call a translation API here
        // For now, we'll show a message about limited translations
        setState(() {
          _showError = true;
          _errorMessage = 'Translation not available. Please try basic phrases or connect to internet.';
          _banglaText = '';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _showError = true;
        _errorMessage = 'Translation failed. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('English to Bangla'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Input field for English text
            TextField(
              controller: _englishController,
              decoration: InputDecoration(
                labelText: 'Enter English text',
                hintText: 'Type here...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _englishController.clear();
                    setState(() {
                      _banglaText = '';
                      _showError = false;
                    });
                  },
                ),
              ),
              maxLines: 3,
              onChanged: (_) => _translateText(),
            ),

            const SizedBox(height: 20),

            // Translate button
            ElevatedButton.icon(
              onPressed: _translateText,
              icon: const Icon(Icons.translate),
              label: const Text('Translate'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Loading indicator
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(
                  color: Colors.green,
                ),
              ),

            // Error message
            if (_showError)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ),
                  ],
                ),
              ),

            // Result section
            if (_banglaText.isNotEmpty) ...[
              const SizedBox(height: 20),
              const Text(
                'Translation:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _banglaText,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.content_copy),
                          onPressed: () {
                            Clipboard.setData(ClipboardData(text: _banglaText));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Translation copied to clipboard'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          tooltip: 'Copy translation',
                          color: Colors.green,
                        ),
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {
                            // In a real app, implement text-to-speech here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Text-to-speech not available in this version'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          tooltip: 'Speak translation',
                          color: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],

            const SizedBox(height: 30),

            // Common phrases section
            const Text(
              'Common Phrases',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: ListView(
                  padding: const EdgeInsets.all(8),
                  children: [
                    _buildPhraseTile('Hello', 'হ্যালো'),
                    _buildPhraseTile('Thank you', 'ধন্যবাদ'),
                    _buildPhraseTile('Yes', 'হ্যাঁ'),
                    _buildPhraseTile('No', 'না'),
                    _buildPhraseTile('Help', 'সাহায্য'),
                    _buildPhraseTile('Emergency', 'জরুরী'),
                    _buildPhraseTile('Hospital', 'হাসপাতাল'),
                    _buildPhraseTile('Water', 'পানি'),
                    _buildPhraseTile('Food', 'খাবার'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhraseTile(String english, String bangla) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        title: Text(english),
        subtitle: Text(
          bangla,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.content_copy, size: 20),
          onPressed: () {
            Clipboard.setData(ClipboardData(text: bangla));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('"$bangla" copied to clipboard'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        onTap: () {
          _englishController.text = english;
          _translateText();
        },
      ),
    );
  }

  @override
  void dispose() {
    _englishController.dispose();
    super.dispose();
  }
}

// Icon widget for the basic_need ListView
class TranslatorIcon extends StatelessWidget {
  const TranslatorIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EnglishToBanglaTranslator()),
              );
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                height: 50,
                width: 50,
                child: const Center(
                  child: Icon(
                    Icons.translate,
                    color: Colors.green,
                    size: 30,
                  ),
                ),
              ),
            ),
          ),
          const Text('Translator')
        ],
      ),
    );
  }
}