import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'design_system/radix_design_system.dart';
import 'config/environment.dart';
import 'app_wrapper.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/service_request_screen.dart';
import 'screens/service_confirmation_screen.dart';
import 'screens/review_screen.dart';
import 'screens/schedule_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Environment.initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Homecare App - Radix UI Style',
      theme: ThemeData(
        fontFamily: GoogleFonts.inter().fontFamily,
        colorScheme: ColorScheme.fromSeed(
          seedColor: RadixTokens.indigo9,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ko', 'KR'),
      home: const AppWrapper(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/main': (context) => const MainApp(),
        '/service-request': (context) => const ServiceRequestScreen(),
        '/service-confirmation': (context) => const ServiceConfirmationScreen(),
        '/review': (context) => const ReviewScreen(),
        '/schedule-detail': (context) => const ScheduleDetailScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class RadixExamplePage extends StatefulWidget {
  const RadixExamplePage({super.key});

  @override
  State<RadixExamplePage> createState() => _RadixExamplePageState();
}

class _RadixExamplePageState extends State<RadixExamplePage> {
  String _inputValue = '';
  bool _loading = false;

  void _simulateLoading() {
    setState(() => _loading = true);
    Future.delayed(const Duration(seconds: 2), () {
      setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RadixTokens.space6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Homecare App',
                style: RadixTokens.heading1.copyWith(
                  color: RadixTokens.slate12,
                ),
              ),
              const SizedBox(height: RadixTokens.space2),
              Text(
                'Radix-UI 스타일 디자인 시스템 데모',
                style: RadixTokens.body1.copyWith(
                  color: RadixTokens.slate11,
                ),
              ),
              const SizedBox(height: RadixTokens.space8),
              
              // 버튼 섹션
              Text(
                'Buttons',
                style: RadixTokens.heading3.copyWith(
                  color: RadixTokens.slate12,
                ),
              ),
              const SizedBox(height: RadixTokens.space4),
              
              RadixCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Button Variants'),
                    const SizedBox(height: RadixTokens.space4),
                    Wrap(
                      spacing: RadixTokens.space3,
                      runSpacing: RadixTokens.space3,
                      children: [
                        RadixButton(
                          text: 'Solid',
                          variant: RadixButtonVariant.solid,
                          onPressed: _simulateLoading,
                          loading: _loading,
                        ),
                        RadixButton(
                          text: 'Soft',
                          variant: RadixButtonVariant.soft,
                          onPressed: () {},
                        ),
                        RadixButton(
                          text: 'Outline',
                          variant: RadixButtonVariant.outline,
                          onPressed: () {},
                        ),
                        RadixButton(
                          text: 'Ghost',
                          variant: RadixButtonVariant.ghost,
                          onPressed: () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: RadixTokens.space4),
                    const Text('Button Sizes'),
                    const SizedBox(height: RadixTokens.space4),
                    Wrap(
                      spacing: RadixTokens.space3,
                      runSpacing: RadixTokens.space3,
                      children: [
                        RadixButton(
                          text: 'Small',
                          size: RadixButtonSize.small,
                          onPressed: () {},
                        ),
                        RadixButton(
                          text: 'Medium',
                          size: RadixButtonSize.medium,
                          onPressed: () {},
                        ),
                        RadixButton(
                          text: 'Large',
                          size: RadixButtonSize.large,
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: RadixTokens.space6),
              
              // 입력 필드 섹션
              Text(
                'Input Fields',
                style: RadixTokens.heading3.copyWith(
                  color: RadixTokens.slate12,
                ),
              ),
              const SizedBox(height: RadixTokens.space4),
              
              RadixCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RadixInput(
                      placeholder: '이름을 입력하세요',
                      value: _inputValue,
                      onChanged: (value) => setState(() => _inputValue = value),
                      prefixIcon: const Icon(Icons.person_outline),
                    ),
                    const SizedBox(height: RadixTokens.space4),
                    RadixInput(
                      placeholder: '비밀번호',
                      obscureText: true,
                      suffixIcon: const Icon(Icons.visibility_off_outlined),
                    ),
                    const SizedBox(height: RadixTokens.space4),
                    RadixInput(
                      placeholder: '비활성화된 입력',
                      disabled: true,
                    ),
                    const SizedBox(height: RadixTokens.space4),
                    RadixInput(
                      placeholder: '오류가 있는 입력',
                      error: true,
                      errorText: '필수 필드입니다',
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: RadixTokens.space6),
              
              // 카드 섹션
              Text(
                'Cards',
                style: RadixTokens.heading3.copyWith(
                  color: RadixTokens.slate12,
                ),
              ),
              const SizedBox(height: RadixTokens.space4),
              
              Row(
                children: [
                  Expanded(
                    child: RadixCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '기본 카드',
                            style: RadixTokens.heading3.copyWith(
                              color: RadixTokens.slate12,
                            ),
                          ),
                          const SizedBox(height: RadixTokens.space2),
                          Text(
                            '이것은 기본 카드입니다.',
                            style: RadixTokens.body2.copyWith(
                              color: RadixTokens.slate11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: RadixTokens.space4),
                  Expanded(
                    child: RadixCard(
                      elevated: true,
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('카드를 탭했습니다!')),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '클릭 가능한 카드',
                            style: RadixTokens.heading3.copyWith(
                              color: RadixTokens.slate12,
                            ),
                          ),
                          const SizedBox(height: RadixTokens.space2),
                          Text(
                            '이 카드는 클릭할 수 있고 그림자가 있습니다.',
                            style: RadixTokens.body2.copyWith(
                              color: RadixTokens.slate11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: RadixTokens.space6),
              
              // 색상 팔레트
              Text(
                'Color Palette',
                style: RadixTokens.heading3.copyWith(
                  color: RadixTokens.slate12,
                ),
              ),
              const SizedBox(height: RadixTokens.space4),
              
              RadixCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Slate Colors'),
                    const SizedBox(height: RadixTokens.space3),
                    Wrap(
                      spacing: RadixTokens.space2,
                      runSpacing: RadixTokens.space2,
                      children: [
                        _ColorSwatch(color: RadixTokens.slate1, label: '1'),
                        _ColorSwatch(color: RadixTokens.slate2, label: '2'),
                        _ColorSwatch(color: RadixTokens.slate3, label: '3'),
                        _ColorSwatch(color: RadixTokens.slate4, label: '4'),
                        _ColorSwatch(color: RadixTokens.slate5, label: '5'),
                        _ColorSwatch(color: RadixTokens.slate6, label: '6'),
                        _ColorSwatch(color: RadixTokens.slate7, label: '7'),
                        _ColorSwatch(color: RadixTokens.slate8, label: '8'),
                        _ColorSwatch(color: RadixTokens.slate9, label: '9'),
                        _ColorSwatch(color: RadixTokens.slate10, label: '10'),
                        _ColorSwatch(color: RadixTokens.slate11, label: '11'),
                        _ColorSwatch(color: RadixTokens.slate12, label: '12'),
                      ],
                    ),
                    const SizedBox(height: RadixTokens.space4),
                    const Text('Indigo Colors (포인트 컬러)'),
                    const SizedBox(height: RadixTokens.space3),
                    Wrap(
                      spacing: RadixTokens.space2,
                      runSpacing: RadixTokens.space2,
                      children: [
                        _ColorSwatch(color: RadixTokens.indigo1, label: '1'),
                        _ColorSwatch(color: RadixTokens.indigo2, label: '2'),
                        _ColorSwatch(color: RadixTokens.indigo3, label: '3'),
                        _ColorSwatch(color: RadixTokens.indigo4, label: '4'),
                        _ColorSwatch(color: RadixTokens.indigo5, label: '5'),
                        _ColorSwatch(color: RadixTokens.indigo6, label: '6'),
                        _ColorSwatch(color: RadixTokens.indigo7, label: '7'),
                        _ColorSwatch(color: RadixTokens.indigo8, label: '8'),
                        _ColorSwatch(color: RadixTokens.indigo9, label: '9'),
                        _ColorSwatch(color: RadixTokens.indigo10, label: '10'),
                        _ColorSwatch(color: RadixTokens.indigo11, label: '11'),
                        _ColorSwatch(color: RadixTokens.indigo12, label: '12'),
                      ],
                    ),
                    const SizedBox(height: RadixTokens.space4),
                    const Text('Blue Colors'),
                    const SizedBox(height: RadixTokens.space3),
                    Wrap(
                      spacing: RadixTokens.space2,
                      runSpacing: RadixTokens.space2,
                      children: [
                        _ColorSwatch(color: RadixTokens.blue1, label: '1'),
                        _ColorSwatch(color: RadixTokens.blue2, label: '2'),
                        _ColorSwatch(color: RadixTokens.blue3, label: '3'),
                        _ColorSwatch(color: RadixTokens.blue4, label: '4'),
                        _ColorSwatch(color: RadixTokens.blue5, label: '5'),
                        _ColorSwatch(color: RadixTokens.blue6, label: '6'),
                        _ColorSwatch(color: RadixTokens.blue7, label: '7'),
                        _ColorSwatch(color: RadixTokens.blue8, label: '8'),
                        _ColorSwatch(color: RadixTokens.blue9, label: '9'),
                        _ColorSwatch(color: RadixTokens.blue10, label: '10'),
                        _ColorSwatch(color: RadixTokens.blue11, label: '11'),
                        _ColorSwatch(color: RadixTokens.blue12, label: '12'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  final Color color;
  final String label;

  const _ColorSwatch({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: RadixTokens.slate6),
        borderRadius: BorderRadius.circular(RadixTokens.radius2),
      ),
      child: Center(
        child: Text(
          label,
          style: RadixTokens.caption.copyWith(
            color: _getContrastColor(color),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Color _getContrastColor(Color backgroundColor) {
    // 간단한 명도 계산으로 텍스트 색상 결정
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? RadixTokens.slate12 : Colors.white;
  }
}
