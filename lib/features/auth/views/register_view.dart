import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';

class RegisterView extends ConsumerStatefulWidget {
  const RegisterView({super.key});

  @override
  ConsumerState<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends ConsumerState<RegisterView> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _acceptedTerms = false;
  bool _marketingOptIn = true; // HTML'deki checked="" ile uyumlu
  int _passwordScore = 0;

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_updatePasswordStrength);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_updatePasswordStrength);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _updatePasswordStrength() {
    final val = _passwordController.text;
    if (val.isEmpty) {
      setState(() => _passwordScore = 0);
      return;
    }

    final hasLength = val.length >= 8;
    final hasLetter = RegExp(r'[a-zA-ZğüşıöçĞÜŞİÖÇ]').hasMatch(val);
    final hasDigit = RegExp(r'[0-9]').hasMatch(val);

    int score = 1;
    if (hasLength && (hasLetter || hasDigit)) score = 2;
    if (hasLength && hasLetter && hasDigit) score = 3;

    setState(() => _passwordScore = score);
  }

  Color _strengthBarColor(int barIndex) {
    if (_passwordScore < barIndex) return AppColors.surfaceHighest;
    if (_passwordScore == 1) return AppColors.error;
    if (_passwordScore == 2) return AppColors.secondaryContainer;
    return AppColors.success;
  }

  void _handleRegister() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final password = _passwordController.text;

    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen zorunlu alanları doldurun.')),
      );
      return;
    }

    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen Kullanım Koşulları ve KVKK metnini onaylayın.'),
        ),
      );
      return;
    }

    ref.read(authViewModelProvider.notifier).register(
          firstName: firstName,
          lastName: lastName,
          email: email,
          phone: phone.isEmpty ? null : phone,
          password: password,
          marketingOptIn: _marketingOptIn,
        );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    ref.listen(authViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (user) {
          if (user != null && context.mounted) {
            context.goNamed('home');
          }
        },
        error: (error, _) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  error.toString().replaceFirst('Exception: ', ''),
                ),
              ),
            );
          }
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => context.goNamed('login'),
        ),
        title: const Row(
          children: [
            Icon(Icons.directions_bus_rounded, color: AppColors.secondary, size: 22),
            SizedBox(width: 8),
            Text(
              'Kayıt Ol',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Top Welcome & Loyalty Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLowest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'Hesap Oluştur',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Puan kazanın, biletlerinizi kolayca takip edin ve indirimli seyahat edin.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryFixed.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        '🎁 İlk biletinize özel 50 TL indirim puanı!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.onSecondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Main Registration Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLowest,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // First & Last Name
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'AD'),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _firstNameController,
                                textInputAction: TextInputAction.next,
                                decoration: _filledInputDecoration(hintText: 'Adınız'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel(text: 'SOYAD'),
                              const SizedBox(height: 4),
                              TextField(
                                controller: _lastNameController,
                                textInputAction: TextInputAction.next,
                                decoration: _filledInputDecoration(hintText: 'Soyadınız'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Email
                    const _FieldLabel(text: 'E-POSTA ADRESİ'),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: _filledInputDecoration(
                        hintText: 'ad.soyad@ornek.com',
                        prefixIcon: Icons.mail_outline,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Phone with TR +90 prefix
                    const _FieldLabel(text: 'CEP TELEFONU'),
                    const SizedBox(height: 4),
                    Container(
                      height: 48,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: AppColors.outlineVariant.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('🇹🇷', style: TextStyle(fontSize: 16)),
                                SizedBox(width: 4),
                                Text(
                                  '+90',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              maxLength: 10,
                              buildCounter: (_, {required currentLength, required isFocused, maxLength}) =>
                                  null,
                              textInputAction: TextInputAction.next,
                              decoration: const InputDecoration(
                                hintText: '5XX XXX XX XX',
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Password & Strength Meter
                    const _FieldLabel(text: 'ŞİFRE'),
                    const SizedBox(height: 4),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => authState.isLoading ? null : _handleRegister(),
                      decoration: _filledInputDecoration(
                        hintText: 'En az 8 karakter',
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                            size: 20,
                            color: AppColors.outline,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: _strengthBarColor(1),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: _strengthBarColor(2),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(
                              color: _strengthBarColor(3),
                              borderRadius: BorderRadius.circular(999),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Row(
                      children: [
                        Icon(Icons.info_outline, size: 14, color: AppColors.onSurfaceVariant),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'En az 8 karakter, 1 harf ve 1 rakam',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Terms & KVKK Checkbox
                    _ConsentRow(
                      checked: _acceptedTerms,
                      onTap: () => setState(() => _acceptedTerms = !_acceptedTerms),
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 12,
                            height: 1.45,
                            color: AppColors.onSurfaceVariant,
                          ),
                          children: [
                            TextSpan(
                              text: 'Kullanım Koşulları',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.tertiaryContainer,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: ' ve '),
                            TextSpan(
                              text: 'KVKK Aydınlatma Metni',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppColors.tertiaryContainer,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            TextSpan(text: '\'ni okudum, kabul ediyorum.'),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Marketing Opt-In Checkbox -> SQLite MarketingOptIn (1 / 0)
                    _ConsentRow(
                      checked: _marketingOptIn,
                      onTap: () => setState(() => _marketingOptIn = !_marketingOptIn),
                      child: const Text(
                        'Kampanyalardan, indirim kuponlarından SMS ve e-posta ile haberdar olmak istiyorum.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.45,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Primary Submit CTA
                    SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: authState.isLoading ? null : _handleRegister,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.secondaryContainer,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: authState.isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Ücretsiz Kayıt Ol',
                                    style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(width: 6),
                                  Icon(Icons.arrow_forward, size: 20),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // Divider
              const Row(
                children: [
                  Expanded(child: Divider(color: AppColors.surfaceHigh, thickness: 1)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'veya hızlı kayıt ol',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.outline,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: AppColors.surfaceHigh, thickness: 1)),
                ],
              ),
              const SizedBox(height: 12),

              // Google & Apple Quick Signups
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surfaceLowest,
                    foregroundColor: AppColors.onSurface,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'G',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF4285F4),
                        ),
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Google ile Kayıt Ol',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 1,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.apple, size: 22),
                      SizedBox(width: 8),
                      Text(
                        'Apple ile Kayıt Ol',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Login Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Zaten bir hesabınız var mı? ',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => context.goNamed('login'),
                    child: const Text(
                      'Giriş Yap',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.secondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // KVKK Trust Badge
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.verified_user, size: 18, color: AppColors.outline),
                    SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        'Kişisel verileriniz 6698 sayılı KVKK kapsamında korunmaktadır.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
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

  InputDecoration _filledInputDecoration({
    required String hintText,
    IconData? prefixIcon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.outline, fontSize: 14),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, size: 20, color: AppColors.outline)
          : null,
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: AppColors.surfaceLow,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: AppColors.secondary, width: 1.5),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _ConsentRow extends StatelessWidget {
  final bool checked;
  final VoidCallback onTap;
  final Widget child;

  const _ConsentRow({
    required this.checked,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 140),
            margin: const EdgeInsets.only(top: 2),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: checked ? AppColors.secondary : AppColors.surfaceHigh,
              borderRadius: BorderRadius.circular(4),
            ),
            child: checked
                ? const Icon(Icons.check, size: 15, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 8),
          Expanded(child: child),
        ],
      ),
    );
  }
}