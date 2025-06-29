import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.cyan[50],
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.cyan),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.cyan, width: 2),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _userNameController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    setState(() {
      _isButtonEnabled = _userNameController.text.trim().isNotEmpty;
    });
  }

  @override
  void dispose() {
    _userNameController.dispose();
    super.dispose();
  }

  void _onNext() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ProfilePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Login',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyan[700],
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _userNameController,
                decoration: const InputDecoration(
                  labelText: 'User Name',
                  prefixIcon: Icon(Icons.person, color: Colors.cyan),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _onNext : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan[600],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.cyan[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  double? _bmi;
  bool _isButtonEnabled = false;
  String? _selectedGender; // เพิ่มตัวแปรเก็บเพศ

  @override
  void initState() {
    super.initState();
    _ageController.addListener(_onTextChanged);
    _weightController.addListener(_onTextChanged);
    _heightController.addListener(_onTextChanged);
    _weightController.addListener(_calculateBMI);
    _heightController.addListener(_calculateBMI);
  }

  void _onTextChanged() {
    setState(() {
      _isButtonEnabled = _selectedGender != null &&
          _ageController.text.trim().isNotEmpty &&
          _weightController.text.trim().isNotEmpty &&
          _heightController.text.trim().isNotEmpty &&
          double.tryParse(_ageController.text.trim()) != null &&
          double.tryParse(_weightController.text.trim()) != null &&
          double.tryParse(_heightController.text.trim()) != null;
    });
  }

  void _onGenderChanged(String? value) {
    setState(() {
      _selectedGender = value;
      _onTextChanged();
    });
  }

  void _calculateBMI() {
    final weight = double.tryParse(_weightController.text);
    final height = double.tryParse(_heightController.text);
    if (weight != null && height != null && height > 0) {
      setState(() {
        _bmi = weight / ((height / 100) * (height / 100));
      });
    } else {
      setState(() {
        _bmi = null;
      });
    }
  }

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _onNextProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const MusicGenrePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[100],
        title:
            const Text('ข้อมูลส่วนตัว', style: TextStyle(color: Colors.cyan)),
        iconTheme: const IconThemeData(color: Colors.cyan),
        elevation: 0,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedGender,
                decoration: const InputDecoration(
                  labelText: 'เพศ',
                  prefixIcon: Icon(Icons.person, color: Colors.cyan),
                ),
                items: const [
                  DropdownMenuItem(value: 'ชาย', child: Text('ชาย')),
                  DropdownMenuItem(value: 'หญิง', child: Text('หญิง')),
                ],
                onChanged: _onGenderChanged,
                validator: (value) => value == null ? 'กรุณาเลือกเพศ' : null,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _ageController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'อายุ (ปี)',
                  prefixIcon: Icon(Icons.cake, color: Colors.cyan),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'น้ำหนัก (กก.)',
                  prefixIcon: Icon(Icons.monitor_weight, color: Colors.cyan),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _heightController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'ส่วนสูง (ซม.)',
                  prefixIcon: Icon(Icons.height, color: Colors.cyan),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                ],
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.cyan[50],
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.cyan.shade100),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.fitness_center, color: Colors.cyan),
                    const SizedBox(width: 12),
                    Text(
                      'BMI: ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.cyan[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _bmi != null ? _bmi!.toStringAsFixed(2) : '-',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.cyan[900],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isButtonEnabled ? _onNextProfile : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan[600],
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.cyan[200],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

class MusicGenrePage extends StatefulWidget {
  const MusicGenrePage({super.key});

  @override
  State<MusicGenrePage> createState() => _MusicGenrePageState();
}

class _MusicGenrePageState extends State<MusicGenrePage> {
  final List<String> genres = [
    'Classical',
    'Country',
    'EDM',
    'Folk',
    'Gospel',
    'Hip hop',
    'Jazz',
    'K pop',
    'Latin',
    'Lofi',
    'Metal',
    'Pop',
    'R&B',
    'Rap',
    'Rock',
    'Video game music'
  ];
  final Set<String> selectedGenres = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[100],
        title: const Text('เลือกแนวเพลงที่ชอบ',
            style: TextStyle(color: Colors.cyan)),
        iconTheme: const IconThemeData(color: Colors.cyan),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'เลือกแนวเพลงที่คุณชอบ (เลือกได้มากกว่า 1)',
              style: TextStyle(
                fontSize: 18,
                color: Colors.cyan,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: genres.map((genre) {
                  return CheckboxListTile(
                    value: selectedGenres.contains(genre),
                    activeColor: Colors.cyan,
                    title:
                        Text(genre, style: TextStyle(color: Colors.cyan[900])),
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selectedGenres.add(genre);
                        } else {
                          selectedGenres.remove(genre);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedGenres.isNotEmpty
                    ? () {
                        // ไปหน้าถัดไปหรือทำอย่างอื่น
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ExercisePlanPage(),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[600],
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.cyan[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExercisePlanPage extends StatefulWidget {
  const ExercisePlanPage({super.key});

  @override
  State<ExercisePlanPage> createState() => _ExercisePlanPageState();
}

class _ExercisePlanPageState extends State<ExercisePlanPage> {
  int? _selectedPlan;

  final List<Map<String, String>> plans = [
    {
      'title': 'Beginner Fit',
      'desc': 'ออกกำลังกายเบาๆ 3 วัน/สัปดาห์ เหมาะสำหรับผู้เริ่มต้น',
    },
    {
      'title': 'Active Lifestyle',
      'desc': 'ออกกำลังกายปานกลาง 5 วัน/สัปดาห์ สำหรับคนที่ต้องการความแข็งแรง',
    },
    {
      'title': 'Pro Athlete',
      'desc': 'ออกกำลังกายเข้มข้น 6-7 วัน/สัปดาห์ สำหรับสายฟิตจริงจัง',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan[100],
        title: const Text('เลือกแผนการออกกำลังกาย',
            style: TextStyle(color: Colors.cyan)),
        iconTheme: const IconThemeData(color: Colors.cyan),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: plans.length,
                itemBuilder: (context, index) {
                  final plan = plans[index];
                  final isSelected = _selectedPlan == index;
                  return Card(
                    color: isSelected ? Colors.cyan[100] : Colors.white,
                    elevation: isSelected ? 6 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                      side: BorderSide(
                        color: isSelected ? Colors.cyan : Colors.cyan.shade100,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(20),
                      title: Text(
                        plan['title']!,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.cyan[800],
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          plan['desc']!,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.cyan[700],
                          ),
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle,
                              color: Colors.cyan, size: 32)
                          : null,
                      onTap: () {
                        setState(() {
                          _selectedPlan = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedPlan != null
                    ? () {
                        // ไปหน้าถัดไปหรือแสดงผลลัพธ์
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MyHomePage(title: 'Flutter Demo Home Page'),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyan[600],
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: Colors.cyan[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
