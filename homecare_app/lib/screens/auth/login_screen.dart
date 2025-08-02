import 'package:flutter/material.dart';
import '../../design_system/radix_design_system.dart';
import '../../models/user_models.dart';
import '../../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isLoading = true);
    
    try {
      final request = UserLoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      
      await AuthService.login(request);
      
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '로그인에 실패했습니다.';
        if (e is ApiError) {
          errorMessage = e.message;
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red.shade600,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _navigateToSignup() {
    Navigator.pushNamed(context, '/signup');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RadixTokens.space6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: RadixTokens.space9),
                
                // 로고 및 제목
                Column(
                  children: [
                    Icon(
                      Icons.medical_services,
                      size: 80,
                      color: RadixTokens.indigo9,
                    ),
                    const SizedBox(height: RadixTokens.space4),
                    Text(
                      '스마트 케어 매치',
                      style: RadixTokens.heading1.copyWith(
                        color: RadixTokens.slate12,
                      ),
                    ),
                    const SizedBox(height: RadixTokens.space2),
                    Text(
                      '홈케어 서비스에 로그인하세요',
                      style: RadixTokens.body1.copyWith(
                        color: RadixTokens.slate11,
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: RadixTokens.space8),
                
                // 로그인 폼
                RadixCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        '로그인',
                        style: RadixTokens.heading3.copyWith(
                          color: RadixTokens.slate12,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space6),
                      
                      // 이메일 입력
                      Text(
                        '이메일',
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space2),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: 'example@email.com',
                          hintStyle: RadixTokens.body2.copyWith(
                            color: RadixTokens.slate9,
                          ),
                          prefixIcon: const Icon(Icons.email_outlined),
                          filled: true,
                          fillColor: RadixTokens.slate1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: RadixTokens.slate7),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: RadixTokens.slate7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: RadixTokens.indigo8, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: Colors.red.shade400),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: RadixTokens.space4,
                            vertical: RadixTokens.space3,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '이메일을 입력해주세요';
                          }
                          if (!value.contains('@')) {
                            return '올바른 이메일 형식을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: RadixTokens.space4),
                      
                      // 비밀번호 입력
                      Text(
                        '비밀번호',
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space2),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: '비밀번호를 입력하세요',
                          hintStyle: RadixTokens.body2.copyWith(
                            color: RadixTokens.slate9,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: _togglePasswordVisibility,
                          ),
                          filled: true,
                          fillColor: RadixTokens.slate1,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: RadixTokens.slate7),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: RadixTokens.slate7),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: RadixTokens.indigo8, width: 2),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                            borderSide: BorderSide(color: Colors.red.shade400),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: RadixTokens.space4,
                            vertical: RadixTokens.space3,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '비밀번호를 입력해주세요';
                          }
                          if (value.length < 6) {
                            return '비밀번호는 6자 이상이어야 합니다';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: RadixTokens.space6),
                      
                      // 로그인 버튼
                      SizedBox(
                        height: 48,
                        child: RadixButton(
                          text: '로그인',
                          variant: RadixButtonVariant.solid,
                          size: RadixButtonSize.large,
                          fullWidth: true,
                          loading: _isLoading,
                          onPressed: _isLoading ? null : _handleLogin,
                        ),
                      ),
                      
                      const SizedBox(height: RadixTokens.space4),
                      
                      // 회원가입 링크
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '계정이 없으신가요? ',
                            style: RadixTokens.body2.copyWith(
                              color: RadixTokens.slate11,
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToSignup,
                            child: Text(
                              '회원가입',
                              style: RadixTokens.body2.copyWith(
                                color: RadixTokens.indigo11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}