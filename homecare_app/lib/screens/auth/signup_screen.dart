import 'package:flutter/material.dart';
import '../../design_system/radix_design_system.dart';
import '../../models/user_models.dart';
import '../../services/api/user_api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedBirthDate;
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscurePassword = !_obscurePassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureConfirmPassword = !_obscureConfirmPassword;
    });
  }

  Future<void> _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    
    if (picked != null) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  String _formatBirthDate() {
    if (_selectedBirthDate == null) return '생년월일 선택';
    return '${_selectedBirthDate!.year}년 ${_selectedBirthDate!.month}월 ${_selectedBirthDate!.day}일';
  }

  Future<void> _handleSignup() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedBirthDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('생년월일을 선택해주세요')),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      final request = ConsumerCreateRequest(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        phone: _phoneController.text.trim(),
        birthDate: _selectedBirthDate!,
      );
      
      await UserApiService.registerConsumer(request);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('회원가입이 완료되었습니다. 로그인해주세요.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = '회원가입에 실패했습니다.';
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

  void _navigateToLogin() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: RadixTokens.slate1,
      appBar: AppBar(
        backgroundColor: RadixTokens.slate1,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: RadixTokens.slate12),
          onPressed: _navigateToLogin,
        ),
        title: Text(
          '회원가입',
          style: RadixTokens.heading3.copyWith(
            color: RadixTokens.slate12,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(RadixTokens.space6),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 제목
                Text(
                  '스마트 케어 매치에 가입하세요',
                  style: RadixTokens.heading2.copyWith(
                    color: RadixTokens.slate12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: RadixTokens.space2),
                Text(
                  '홈케어 서비스를 이용하기 위해 가입해주세요',
                  style: RadixTokens.body1.copyWith(
                    color: RadixTokens.slate11,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                const SizedBox(height: RadixTokens.space8),
                
                // 회원가입 폼
                RadixCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // 이름 입력
                      Text(
                        '이름',
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space2),
                      TextFormField(
                        controller: _nameController,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: '홍길동',
                          hintStyle: RadixTokens.body2.copyWith(
                            color: RadixTokens.slate9,
                          ),
                          prefixIcon: const Icon(Icons.person_outline),
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
                          if (value == null || value.trim().isEmpty) {
                            return '이름을 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: RadixTokens.space4),
                      
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
                          if (value == null || value.trim().isEmpty) {
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
                          hintText: '6자 이상 입력하세요',
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
                      
                      const SizedBox(height: RadixTokens.space4),
                      
                      // 비밀번호 확인
                      Text(
                        '비밀번호 확인',
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space2),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: _obscureConfirmPassword,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: '비밀번호를 다시 입력하세요',
                          hintStyle: RadixTokens.body2.copyWith(
                            color: RadixTokens.slate9,
                          ),
                          prefixIcon: const Icon(Icons.lock_outline),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                            ),
                            onPressed: _toggleConfirmPasswordVisibility,
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
                            return '비밀번호를 다시 입력해주세요';
                          }
                          if (value != _passwordController.text) {
                            return '비밀번호가 일치하지 않습니다';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: RadixTokens.space4),
                      
                      // 전화번호 입력
                      Text(
                        '전화번호',
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space2),
                      TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        enabled: !_isLoading,
                        decoration: InputDecoration(
                          hintText: '010-1234-5678',
                          hintStyle: RadixTokens.body2.copyWith(
                            color: RadixTokens.slate9,
                          ),
                          prefixIcon: const Icon(Icons.phone_outlined),
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
                          if (value == null || value.trim().isEmpty) {
                            return '전화번호를 입력해주세요';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: RadixTokens.space4),
                      
                      // 생년월일 선택
                      Text(
                        '생년월일',
                        style: RadixTokens.body2.copyWith(
                          color: RadixTokens.slate12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: RadixTokens.space2),
                      GestureDetector(
                        onTap: _isLoading ? null : _selectBirthDate,
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: RadixTokens.slate1,
                            border: Border.all(
                              color: _selectedBirthDate == null 
                                  ? RadixTokens.slate7 
                                  : RadixTokens.indigo8,
                            ),
                            borderRadius: BorderRadius.circular(RadixTokens.radius3),
                          ),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: RadixTokens.space4),
                                child: Icon(Icons.calendar_today_outlined),
                              ),
                              const SizedBox(width: RadixTokens.space3),
                              Expanded(
                                child: Text(
                                  _formatBirthDate(),
                                  style: RadixTokens.body2.copyWith(
                                    color: _selectedBirthDate == null 
                                        ? RadixTokens.slate9 
                                        : RadixTokens.slate12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: RadixTokens.space6),
                      
                      // 회원가입 버튼
                      SizedBox(
                        height: 48,
                        child: RadixButton(
                          text: '회원가입',
                          variant: RadixButtonVariant.solid,
                          size: RadixButtonSize.large,
                          fullWidth: true,
                          loading: _isLoading,
                          onPressed: _isLoading ? null : _handleSignup,
                        ),
                      ),
                      
                      const SizedBox(height: RadixTokens.space4),
                      
                      // 로그인 링크
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '이미 계정이 있으신가요? ',
                            style: RadixTokens.body2.copyWith(
                              color: RadixTokens.slate11,
                            ),
                          ),
                          GestureDetector(
                            onTap: _navigateToLogin,
                            child: Text(
                              '로그인',
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