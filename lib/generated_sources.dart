class GeneratedSources {
  static const Map<String, String> implementationCode = {
    'NetBankingLoginPage': r'''import 'package:flutter/material.dart';
import '../../components/organisms/left_info_section.dart';
import '../../components/organisms/right_login_container.dart';
import '../templates/login_template.dart';

class NetBankingLoginPage extends StatelessWidget {
  final double width;
  final double height;
  final bool isFullScreen;

  const NetBankingLoginPage({
    super.key,
    this.width = 1440,
    this.height = 900,
    this.isFullScreen = false,
  });

  @override
  Widget build(BuildContext context) {
    return LoginTemplate(
      width: width,
      height: height,
      isFullScreen: isFullScreen,
      leftSection: const LeftInfoSection(),
      rightSection: const RightLoginContainer(),
    );
  }
}''',

    'Landing Form Organism': r'''import 'package:flutter/material.dart' hide Text;
import '../atoms/text_field.dart' as dk;
import '../atoms/glass_card.dart' as dk;
import '../atoms/login_button.dart' as dk;
import '../atoms/text.dart' as dk;
import '../atoms/image_atom.dart';
import '../molecules/qr_login.dart';
import '../molecules/digicart_security.dart';
import '../molecules/labeled_input_field.dart';
import '../molecules/password_field.dart';
import '../../core/tokens/colors.dart';
import '../../core/tokens/typography.dart';
import '../../core/tokens/spacing.dart';
import '../../core/tokens/radius.dart';

class LandingFormOrganism extends StatelessWidget {
  final double width;
  final double height;
  final Color tintColor;
  final VoidCallback? onSetResetPassword;
  final VoidCallback? onRegisterNow;

  const LandingFormOrganism({
    super.key,
    this.width = 550,
    this.height = 720,
    this.tintColor = const Color(0x33FFFFFF),
    this.onSetResetPassword,
    this.onRegisterNow,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmall = constraints.maxWidth < 500;
        final isVeryShort = constraints.maxHeight < 700;
        // Dynamically compute gap sizes based on available height
        final double gap = isVeryShort ? AppSpacing.xSmall : AppSpacing.medium;
        final double smallGap = isVeryShort ? AppSpacing.xxSmall : AppSpacing.xSmall;

        return Center(
          child: SizedBox(
            width: width,
            height: height,
            child: Column(
              children: [
                // GlassCard takes all available space minus footer
                Expanded(
                  child: dk.GlassCard(
                    width: width,
                    tintColor: tintColor,
                    borderRadius: AppRadius.circular,
                    padding: EdgeInsets.symmetric(
                      horizontal: isSmall ? AppSpacing.medium : AppSpacing.large,
                      vertical: isVeryShort ? AppSpacing.medium : AppSpacing.large,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        /// WELCOME HEADER
                        dk.Text(
                          text: "Welcome to NetBanking",
                          fontSize: isSmall ? AppTypography.fontLargePlus : AppTypography.fontH2,
                          fontWeight: FontWeight.bold,
                          color: AppColors.hdfcBlue,
                        ),

                        /// LOGO SECTION
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            dk.Text(
                              text: "MADE DIGITAL BY",
                              fontSize: isSmall ? AppTypography.fontSmall : AppTypography.fontMedium,
                              fontWeight: FontWeight.bold,
                              color: AppColors.hdfcBlue,
                              letterSpacing: 0.5,
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                dkImage(imagePath: 'assets/hdfc_logo.png', height: isSmall ? 15 : 18),
                                const SizedBox(width: 12),
                                dkImage(imagePath: 'assets/now_logo.png', height: isSmall ? 11 : 14),
                              ],
                            ),
                          ],
                        ),

                        /// QR SCANNER BOX
                        QrLogin(
                          title: "Click to scan QR and login",
                          subtitle: "New HDFC Bank Early Access App Required",
                          width: double.infinity,
                          height: isVeryShort ? 70 : 85,
                          imagePath: 'assets/qr_login.png',
                          opacity: 0.3,
                        ),

                        LabeledInputField(
                          label: "Customer ID/User ID",
                          hintText: "Customer ID/ User ID",
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => debugPrint("Get Customer ID Pressed"),
                            child: dk.Text(
                               text: "Get Customer ID",
                               color: AppColors.accentBlue,
                               fontSize: isSmall ? AppTypography.fontMedium : AppTypography.fontLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        PasswordField(
                          label: "Password",
                          hintText: "Password",
                        ),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: onSetResetPassword ?? () => debugPrint("Set/Reset Password Pressed"),
                            child: dk.Text(
                               text: "Set/Reset Password",
                               color: AppColors.accentBlue,
                               fontSize: isSmall ? AppTypography.fontMedium : AppTypography.fontLarge,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        /// SECURITY BANNER
                        DigicartSecurity(
                          title: "Goodbye, Secure Text & Image",
                          subtitle: "Hello, Digicert Security",
                          imagePath: 'assets/lock.png',
                          width: double.infinity,
                          height: isVeryShort ? 70 : 85,
                          opacity: 0.3,
                        ),

                        /// LOGIN BUTTON
                        dk.LoginButton(
                          onTap: () => debugPrint("Login Pressed"),
                          width: double.infinity,
                          height: isVeryShort ? 46 : 52,
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),

                /// FOOTER (Outside GlassCard)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     dk.Text(
                       text: "Not registered for NetBanking? ",
                       fontSize: isSmall ? AppTypography.fontSmall : AppTypography.fontMedium,
                       color: Colors.black87,
                     ),
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: onRegisterNow ?? () => debugPrint("Register Now Pressed"),
                         child: dk.Text(
                           text: "Register Now",
                           fontSize: isSmall ? AppTypography.fontSmall : AppTypography.fontMedium,
                           color: AppColors.hdfcBlue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}''',

    'Left Info Section': r'''import 'package:flutter/material.dart' hide Text;
import '../atoms/button.dart' as dk;
import '../atoms/text.dart' as dk;
import '../../core/tokens/colors.dart';
import '../../core/tokens/typography.dart';
import '../../core/tokens/spacing.dart';

class LeftInfoSection extends StatelessWidget {
  final double? width;
  final double? height;

  const LeftInfoSection({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/left_image.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmall = constraints.maxWidth < 600;
          return Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSpacing.none,
              horizontal: isSmall ? AppSpacing.large : AppSpacing.xxLarge,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top Writing Part
                Column(
                  children: [
                    const SizedBox(height: 60),
                    dk.Text(
                      text: "Digital Arrest is Fake!",
                      textAlign: TextAlign.center,
                      fontSize: isSmall ? AppTypography.fontH2 : AppTypography.fontExtraLarge,
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 10),
                    dk.Text(
                      text: "Genuine officers will never detain you\nor ask for money",
                      textAlign: TextAlign.center,
                      fontSize: isSmall ? AppTypography.fontLarge : AppTypography.fontLargePlus,
                      color: AppColors.white.withAlpha(178), // 0.7 * 255
                    ),
                  ],
                ),
    
                // Bottom Writing Part & Know More Button
                Column(
                  children: [
                    dk.Text(
                      text: "When in doubt reach out to your bank.",
                      textAlign: TextAlign.center,
                      fontSize: isSmall ? AppTypography.fontLarge : AppTypography.fontLargePlus,
                      fontWeight: FontWeight.w500,
                      color: AppColors.white,
                    ),
                    const SizedBox(height: 8),
                    dk.Text(
                      text: "Click here to know more about Investment and APK Fraud",
                      textAlign: TextAlign.center,
                      fontSize: isSmall ? AppTypography.fontMedium : AppTypography.fontLarge,
                      color: AppColors.white.withAlpha(153), // 0.6 * 255
                    ),
                    const SizedBox(height: 30),
                    
                    // Know More Button
                    dk.Button(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: dk.Text(text: "Loading detailed fraud prevention guide...", fontSize: 16),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      text: "Know More",
                      width: isSmall ? 250 : 350,
                      height: 55,
                      color: AppColors.hdfcBlue,
                      opacity: 0.8,
                    ),
                    const SizedBox(height: 60),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    // In standalone preview mode (explicit dimensions), center the component
    if (width != null && height != null) {
      return Center(child: content);
    }
    // Inside Expanded (NetBankingLoginPage), fill the parent
    return content;
  }
}''',

    'Right Login Container': r'''import 'package:flutter/material.dart';
import '../../core/tokens/spacing.dart';
import 'landing_form.dart';

class RightLoginContainer extends StatelessWidget {
  final double? width;
  final double? height;

  const RightLoginContainer({
    super.key,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/right_back.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.large),
              child: LandingFormOrganism(
                width: constraints.maxWidth * 0.85, // Slightly wider form
                height: constraints.maxHeight * 0.95, // Slightly taller form
                tintColor: const Color(0x33FFFFFF),
              ),
            ),
          );
        },
      ),
    );

    // In standalone preview mode (explicit dimensions), center the component
    if (width != null && height != null) {
      return Center(child: content);
    }
    // Inside Expanded (NetBankingLoginPage), fill the parent
    return content;
  }
}''',

    'QR Login': r'''import 'dart:ui';
import 'package:flutter/material.dart' hide Text;
import '../atoms/text.dart' as dk;
import '../atoms/image_atom.dart';
import '../atoms/glass_card.dart' as dk;
import '../../core/tokens/typography.dart';
import '../../core/tokens/colors.dart';

class QrLogin extends StatelessWidget {
  final String title;
  final String subtitle;
  final String popupTitle;
  final String qrData;
  final IconData icon;
  final String? imagePath;
  final Color accentColor;
  final double width;
  final double height;
  final double blur;
  final double opacity;

  const QrLogin({
    super.key,
    required this.title,
    required this.subtitle,
    this.popupTitle = "Scan QR Code",
    this.qrData = "",
    this.icon = Icons.qr_code_2,
    this.imagePath,
    this.accentColor = Colors.black54,
    this.width = 484,
    this.height = 120,
    this.blur = 15,
    this.opacity = 0.2,
  });

  void _showQrPopup(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  dk.Text(
                    text: popupTitle,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: imagePath != null
                        ? dkImage(imagePath: imagePath!, width: 180, height: 180)
                        : Icon(icon, size: 180, color: Colors.black),
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: dk.Text(
                      text: "Dismiss",
                      fontSize: AppTypography.fontLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isVerySmall = constraints.maxWidth < 450;
        
        return dk.GlassCard(
          width: width,
          height: height,
          blur: blur,
          opacity: opacity,
          borderRadius: 20,
          padding: EdgeInsets.symmetric(
            horizontal: isVerySmall ? 12 : 20,
            vertical: height < 80 ? 4 : 8,
          ),
          showShadow: false,
          tintColor: AppColors.grey,
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _showQrPopup(context),
              borderRadius: BorderRadius.circular(20),
              child: Row(
                children: [
                  if (height > 40) _buildIconTile(isVerySmall, height),
                  if (height > 40) SizedBox(width: isVerySmall ? 10 : 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        dk.Text(
                          text: title,
                          maxLines: 1,
                          fontSize: height < 50 ? AppTypography.fontSmall : (isVerySmall ? AppTypography.fontLarge : AppTypography.fontLargePlus),
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                        if (height > 60) ...[
                          const SizedBox(height: 4),
                            dk.Text(
                              text: subtitle,
                              maxLines: height > 100 ? 2 : 1,
                              fontSize: isVerySmall ? AppTypography.fontSmall : AppTypography.fontMedium,
                              color: AppColors.black.withValues(alpha: 0.87),
                            ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIconTile(bool isSmall, double containerHeight) {
    final double maxSize = (containerHeight - 16).clamp(20, 200);
    final double size = (isSmall ? 55.0 : 70.0).clamp(20, maxSize);
    final double iconSize = (size - 15).clamp(10, 45);
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.white.withValues(alpha: 0.5),
          width: 2.5,
        ),
      ),
      child: Center(
        child: imagePath != null
            ? dkImage(
                imagePath: imagePath!,
                width: 40,
                height: 40,
                fit: BoxFit.contain,
              )
            : Icon(
                icon,
                size: iconSize,
                color: accentColor,
              ),
      ),
    );
  }
}''',

    'Digicart Security': r'''import 'package:flutter/material.dart' hide Text;
import '../atoms/text.dart' as dk;
import '../atoms/glass_card.dart' as dk;
import '../atoms/image_atom.dart';
import '../../core/tokens/typography.dart';
import '../../core/tokens/colors.dart';

class DigicartSecurity extends StatefulWidget {
  final String title;
  final String subtitle;
  final String imagePath;
  final double width;
  final double height;
  final double blur;
  final double opacity;
  final VoidCallback? onTap;

  const DigicartSecurity({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imagePath,
    this.width = 484,
    this.height = 120,
    this.blur = 15,
    this.opacity = 0.2,
    this.onTap,
  });

  @override
  State<DigicartSecurity> createState() => _DigicartSecurityState();
}

class _DigicartSecurityState extends State<DigicartSecurity> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isPressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: dk.GlassCard(
            width: widget.width,
            height: widget.height,
            blur: widget.blur,
            opacity: widget.opacity,
            borderRadius: 20,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            showShadow: false,
            tintColor: AppColors.grey,
            child: Row(
              children: [
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        dk.Text(
                          text: widget.title,
                          color: const Color(0xFF004C8F),
                          fontSize: 19,
                        ),
                        const SizedBox(height: 6),
                        dk.Text(
                          text: widget.subtitle,
                          color: const Color(0xFF004C8F),
                          fontWeight: FontWeight.bold,
                          fontSize: AppTypography.fontLargePlus,
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.white.withAlpha(25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(7),
                    child: dkImage(imagePath: widget.imagePath),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}''',

    'Labeled Input Field': r'''import 'package:flutter/material.dart' hide Text;
import '../atoms/text_field.dart' as dk;
import '../atoms/text.dart' as dk;
import '../../core/tokens/typography.dart';

class LabeledInputField extends StatelessWidget {
  final String label;
  final String hintText;
  final double? width;

  const LabeledInputField({
    super.key,
    required this.label,
    required this.hintText,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        dk.Text(
          text: label,
          color: Colors.black54,
          fontSize: AppTypography.fontMedium,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        dk.TextField(
          hintText: hintText,
          width: width,
        ),
      ],
    );
  }
}''',

    'Password Field': r'''import 'package:flutter/material.dart' hide Text;
import '../atoms/text_field.dart' as dk;
import '../atoms/text.dart' as dk;
import '../../core/tokens/typography.dart';

class PasswordField extends StatelessWidget {
  final String label;
  final String hintText;
  final double? width;

  const PasswordField({
    super.key,
    required this.label,
    required this.hintText,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        dk.Text(
          text: label,
          color: Colors.black54,
          fontSize: AppTypography.fontMedium,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 6),
        dk.TextField(
          hintText: hintText,
          isPassword: true,
          width: width,
        ),
      ],
    );
  }
}''',

    'Dropdown': r'''import 'package:flutter/material.dart' hide Text;
import 'text.dart' as dk;
import '../../core/tokens/colors.dart';
import '../../core/tokens/typography.dart';

class Dropdown extends StatefulWidget {
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? label;
  final String hint;
  final double width;
  final Color activeColor;
  final double size;
  final Offset offset;

  const Dropdown({
    super.key,
    this.value,
    required this.items,
    this.onChanged,
    this.label,
    this.hint = "Select option",
    this.width = 200,
    this.activeColor = AppColors.darkBlue,
    this.size = 1.0,
    this.offset = Offset.zero,
  });

  @override
  State<Dropdown> createState() => _DropdownState();
}

class _DropdownState extends State<Dropdown> {
  String? _selectedValue;
  final MenuController _menuController = MenuController();

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  void didUpdateWidget(Dropdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _selectedValue = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: widget.offset,
      child: Transform.scale(
        scale: widget.size,
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.AxisSize.min,
          children: [
            if (widget.label != null) ...[
              dk.Text(
                text: widget.label!,
                color: Colors.black54,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(height: 8),
            ],
            MenuAnchor(
              controller: _menuController,
              alignmentOffset: const Offset(0, 4),
              style: MenuStyle(
                backgroundColor: WidgetStateProperty.all(Colors.white),
                surfaceTintColor: WidgetStateProperty.all(Colors.white),
                elevation: WidgetStateProperty.all(8),
                padding: WidgetStateProperty.all(EdgeInsets.zero),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Colors.black12),
                  ),
                ),
                fixedSize: WidgetStateProperty.all(Size.fromWidth(widget.width)),
              ),
              menuChildren: widget.items.map((item) {
                return MenuItemButton(
                  onPressed: () {
                    setState(() {
                      _selectedValue = item;
                    });
                    widget.onChanged?.call(item);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: dk.Text(
                      text: item,
                      color: Colors.black87,
                      fontSize: 15,
                    ),
                  ),
                );
              }).toList(),
              builder: (context, controller, child) {
                return GestureDetector(
                  onTap: () {
                    if (controller.isOpen) {
                      controller.close();
                    } else {
                      controller.open();
                    }
                  },
                  child: Container(
                    width: widget.width,
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: controller.isOpen ? widget.activeColor : Colors.black12,
                        width: controller.isOpen ? 1.5 : 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: dk.Text(
                            text: _selectedValue ?? widget.hint,
                            color: _selectedValue == null ? Colors.black38 : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        Icon(
                          controller.isOpen 
                              ? Icons.keyboard_arrow_up 
                              : Icons.keyboard_arrow_down, 
                          color: widget.activeColor
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}''',

    'Glass Card': r'''import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/tokens/radius.dart';
import '../../core/tokens/spacing.dart';
import '../../core/tokens/shadows.dart';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final double borderRadius;
  final double opacity;
  final double blur;
  final double borderOpacity;
  final EdgeInsets padding;
  final bool showShadow;
  final Color tintColor;

  const GlassCard({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.borderRadius = AppRadius.xLarge,
    this.opacity = 0.15,
    this.blur = 20,
    this.borderOpacity = 0.3,
    this.padding = const EdgeInsets.all(AppSpacing.large),
    this.showShadow = true,
    this.tintColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            color: tintColor.withAlpha((opacity * 255).round()),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: tintColor.withAlpha((borderOpacity * 255).round())),
            boxShadow: showShadow ? AppShadows.card : [],
          ),
          child: child,
        ),
      ),
    );
  }
}''',

    'Text': r'''import 'package:flutter/material.dart' as m;
import 'package:flutter/material.dart' show StatelessWidget, Widget, BuildContext, Color, FontWeight, TextAlign, TextOverflow, TextStyle, Colors, Container, Alignment;
import '../../core/tokens/typography.dart';

class Text extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final int? maxLines;
  final double? letterSpacing;

  const Text({
    super.key,
    required this.text,
    this.fontSize = AppTypography.fontH1,
    this.color = Colors.black,
    this.fontWeight = FontWeight.normal,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return m.Text(
      text,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      style: TextStyle(
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
        fontFamily: AppTypography.fontFamily,
        letterSpacing: letterSpacing,
      ),
    );
  }
}''',

    'Text Field': r'''import 'package:flutter/material.dart' hide TextField, Text;
import 'package:flutter/material.dart' as m show TextField, TextEditingController;
import 'package:flutter/services.dart';
import 'text.dart' as dk;
import '../../core/tokens/typography.dart';
import '../../core/tokens/colors.dart';
import '../../core/tokens/radius.dart';
import '../../core/tokens/spacing.dart';

class TextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final String? Function(String)? validator;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final double? width;
  final double? height;
  final bool showErrorText;

  const TextField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.validator,
    this.maxLength,
    this.inputFormatters,
    this.width,
    this.height,
    this.showErrorText = true,
  });

  @override
  State<TextField> createState() => _TextFieldState();
}

class _TextFieldState extends State<TextField> {
  final m.TextEditingController _controller = m.TextEditingController();
  bool _obscureText = true;
  String? _errorText;
  bool _isHovering = false;

  String? _validatePassword(String value) {
    if (value.isEmpty) return null;

    if (value.length < 8) return "Minimum 8 characters required";
    if (value.length > 16) return "Maximum 16 characters allowed";

    final hasUppercase = value.contains(RegExp(r'[A-Z]'));
    final hasLowercase = value.contains(RegExp(r'[a-z]'));
    final hasDigits = value.contains(RegExp(r'[0-9]'));
    final hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
      return "Use mix of A-Z, a-z, 0-9 & symbols";
    }

    return null;
  }

  void _validate(String value) {
    String? error;

    if (widget.isPassword) {
      error = _validatePassword(value);
    }

    if (error == null && widget.validator != null) {
      error = widget.validator!(value);
    }

    setState(() {
      _errorText = error;
    });
  }

  bool get hasError => _errorText != null;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MouseRegion(
            onEnter: (_) => setState(() => _isHovering = true),
            onExit: (_) => setState(() => _isHovering = false),
            child: SizedBox(
              height: widget.height,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: _isHovering
                      ? const Color.fromARGB(255, 27, 27, 27).withValues(alpha: 0.05)
                      : const Color(0x1FFFFFFF),
                  borderRadius: BorderRadius.circular(AppRadius.circular),
                  border: Border.all(
                    color: (hasError && widget.showErrorText) ? Colors.red : Colors.black.withValues(alpha: 0.1),
                    width: 1.5,
                  ),
                ),
                child: Center(
                  child: m.TextField(
                    controller: _controller,
                    obscureText: widget.isPassword ? _obscureText : false,
                    maxLength: widget.maxLength,
                    inputFormatters: widget.inputFormatters,
                    onChanged: _validate,
                    style: const TextStyle(
                      fontSize: AppTypography.fontLarge,
                      color: AppColors.black,
                      fontWeight: FontWeight.w500,
                      fontFamily: AppTypography.fontFamily,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      counterText: "",
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: AppColors.black.withValues(alpha: 0.3),
                        fontSize: AppTypography.fontLarge,
                        fontFamily: AppTypography.fontFamily,
                      ),
                      contentPadding: const EdgeInsets.only(
                        left: AppSpacing.large,
                        right: AppSpacing.large,
                        top: 0,
                        bottom: 5,
                      ),
                      border: InputBorder.none,
                      suffixIcon: widget.isPassword
                          ? Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: IconButton(
                                icon: Icon(
                                  _obscureText
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: Colors.black87,
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureText = !_obscureText;
                                  });
                                },
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (hasError && widget.showErrorText) ...[
            const SizedBox(height: 8),
             Padding(
               padding: const EdgeInsets.only(left: AppSpacing.large),
               child: dk.Text(
                 text: _errorText!,
                 color: Colors.red,
                 fontSize: AppTypography.fontMedium,
                 fontWeight: FontWeight.w500,
               ),
             ),
          ],
        ],
      ),
    );
  }
}''',

    'Button': r'''import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as m show Text;
import '../../core/tokens/colors.dart';
import '../../core/tokens/radius.dart';
import '../../core/tokens/shadows.dart';
import '../../core/tokens/typography.dart';

class Button extends StatefulWidget {
  final VoidCallback? onTap;
  final double width;
  final double height;
  final String text;
  final bool disabled;
  final Color color;
  final bool showOutline;
  final double blur;
  final double opacity;

  const Button({
    super.key,
    this.onTap,
    this.width = 321,
    this.height = 61,
    this.text = "Know More",
    this.disabled = false,
    this.color = AppColors.accentBlue,
    this.showOutline = true,
    this.blur = 10,
    this.opacity = 0.3,
  });

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (!widget.disabled) {
      _animationController.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (!widget.disabled) {
      _animationController.reverse();
      widget.onTap?.call();
    }
  }

  void _handleTapCancel() {
    _animationController.reverse();
  }

  Color _getTextColor() {
    const Color lightPaletteColor = Color(0xFFE5EDF4);
    const Color darkBlueText = AppColors.darkBlue;

    if (widget.color.value == lightPaletteColor.value) {
      return darkBlueText;
    }
    return AppColors.white;
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widget.disabled ? 0.5 : 1,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.large),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: widget.blur, sigmaY: widget.blur),
              child: Container(
                width: widget.width,
                height: widget.height,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: widget.opacity),
                  borderRadius: BorderRadius.circular(AppRadius.large),
                  border: widget.showOutline
                      ? Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        )
                      : null,
                  boxShadow: AppShadows.soft,
                ),
                alignment: Alignment.center,
                child: m.Text(
                  widget.text,
                  style: TextStyle(
                    color: _getTextColor(),
                    fontSize: AppTypography.fontLargePlus,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}''',

    'Checkbox': r'''import 'package:flutter/material.dart' hide Checkbox;

class Checkbox extends StatefulWidget {
  final bool value;
  final String? label;
  final ValueChanged<bool?>? onChanged;
  final VoidCallback? onPressed;
  final bool disabled;
  final Color activeColor;
  final Color labelColor;
  final double size;
  final Offset offset;

  const Checkbox({
    super.key,
    required this.value,
    this.label,
    this.onChanged,
    this.onPressed,
    this.disabled = false,
    this.activeColor = const Color(0xFF1E1E4C),
    this.labelColor = const Color(0xFF1E1E4C),
    this.size = 1.0,
    this.offset = Offset.zero,
  });

  @override
  State<Checkbox> createState() => _CheckboxState();
}

class _CheckboxState extends State<Checkbox> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late bool _isSelected;

  @override
  void initState() {
    super.initState();
    _isSelected = widget.value;
    _controller = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
    if (_isSelected) {
      _controller.value = 1.0;
    }
  }

  @override
  void didUpdateWidget(Checkbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _isSelected = widget.value;
        if (_isSelected) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      });
    }
  }

  void _handleTap() {
    if (widget.disabled) return;
    setState(() {
      _isSelected = !_isSelected;
      if (_isSelected) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    widget.onChanged?.call(_isSelected);
    widget.onPressed?.call();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color activeColor = widget.disabled 
        ? widget.activeColor.withValues(alpha: 0.3) 
        : widget.activeColor;
        
    return Transform.translate(
      offset: widget.offset,
      child: MouseRegion(
        cursor: widget.disabled ? SystemMouseCursors.forbidden : SystemMouseCursors.click,
        child: GestureDetector(
          onTap: _handleTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Transform.scale(
              scale: widget.size,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isSelected ? activeColor : Colors.grey.shade400,
                            width: 2,
                          ),
                          color: _isSelected ? activeColor : Colors.white,
                        ),
                      ),
                      ScaleTransition(
                        scale: _scaleAnimation,
                        child: const Icon(
                          Icons.check_rounded,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  if (widget.label != null) ...[
                    const SizedBox(width: 14),
                    Text(
                      widget.label!,
                      style: TextStyle(
                        color: widget.disabled ? Colors.grey : widget.labelColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}''',

    'Text Button': r'''import 'package:flutter/material.dart' hide TextButton;
import 'package:flutter/material.dart' as m show Text;

class TextButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double fontSize;
  final bool isClickable;
  final bool enableHover;

  const TextButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.fontSize = 40,
    this.isClickable = true,
    this.enableHover = true,
  });

  @override
  State<TextButton> createState() => _TextButtonState();
}

class _TextButtonState extends State<TextButton> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final Color baseColor = widget.color ?? const Color(0xFF283097);
    final bool effectiveClickable = widget.isClickable;

    return MouseRegion(
      cursor: effectiveClickable ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: (_) {
        if (widget.enableHover && effectiveClickable) {
          setState(() => _isHovering = true);
        }
      },
      onExit: (_) {
        if (widget.enableHover && effectiveClickable) {
          setState(() => _isHovering = false);
        }
      },
      child: GestureDetector(
        onTap: effectiveClickable ? widget.onPressed : null,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: widget.fontSize,
            height: 1.0,
            letterSpacing: 0,
            color: _isHovering ? baseColor.withValues(alpha: 0.8) : baseColor,
            decoration: _isHovering && widget.enableHover
                ? TextDecoration.underline
                : TextDecoration.none,
          ),
          child: m.Text(widget.text),
        ),
      ),
    );
  }
}''',

    'Image': r'''import 'dart:ui';
import 'package:flutter/material.dart';

class dkImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final double offsetX;
  final double offsetY;
  final bool showShadow;
  final BoxFit fit;

  const dkImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.offsetX = 0.0,
    this.offsetY = 0.0,
    this.showShadow = false,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    Widget imageWidget = Image.asset(
      imagePath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.broken_image, color: Colors.grey),
      ),
    );

    return Transform.translate(
      offset: Offset(offsetX, offsetY),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (showShadow)
            Positioned.fill(
              child: Transform.translate(
                offset: const Offset(0, 6),
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: ColorFiltered(
                    colorFilter: ColorFilter.mode(
                      Colors.black.withValues(alpha: 0.2),
                      BlendMode.srcIn,
                    ),
                    child: imageWidget,
                  ),
                ),
              ),
            ),
          imageWidget,
        ],
      ),
    );
  }
}''',

    'Radio Button': r'''import 'package:flutter/material.dart';

class RadioButton extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final String label;
  final Color activeColor;
  final Color labelColor;
  final double fontSize;
  final FontWeight fontWeight;
  final double size;
  final Offset offset;

  const RadioButton({
    super.key,
    required this.value,
    this.onChanged,
    this.label = "Radio Option",
    this.activeColor = const Color(0xFF1E1E4C),
    this.labelColor = Colors.black87,
    this.fontSize = 28.0,
    this.fontWeight = FontWeight.normal,
    this.size = 1.0,
    this.offset = Offset.zero,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value;
    
    return Transform.translate(
      offset: offset,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (onChanged != null) {
              onChanged!(!value);
            }
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
            child: Transform.scale(
              scale: size,
              alignment: Alignment.centerLeft,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? activeColor : Colors.grey,
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: isSelected
                          ? Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: activeColor,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: fontWeight,
                      color: labelColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}''',

    'Toggle Switch': r'''import 'package:flutter/material.dart';

class ToggleSwitch extends StatefulWidget {
  final bool value;
  final ValueChanged<bool>? onChanged;
  final String? label;
  final Color activeColor;
  final Color labelColor;
  final double size;
  final Offset offset;

  const ToggleSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.activeColor = const Color(0xFF1E1E4C),
    this.labelColor = Colors.black87,
    this.size = 1.0,
    this.offset = Offset.zero,
  });

  @override
  State<ToggleSwitch> createState() => _ToggleSwitchState();
}

class _ToggleSwitchState extends State<ToggleSwitch> with SingleTickerProviderStateMixin {
  late bool _internalValue;

  @override
  void initState() {
    super.initState();
    _internalValue = widget.value;
  }

  @override
  void didUpdateWidget(ToggleSwitch oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _internalValue = widget.value;
    }
  }

  void _handleTap() {
    if (widget.onChanged != null) {
      setState(() {
        _internalValue = !_internalValue;
      });
      widget.onChanged!(_internalValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: widget.offset,
      child: Transform.scale(
        scale: widget.size,
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: _handleTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: 50,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: _internalValue ? widget.activeColor : Colors.grey.shade300,
                ),
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      left: _internalValue ? 24 : 4,
                      top: 4,
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.label != null) ...[
                const SizedBox(width: 12),
                Text(
                  widget.label!,
                  style: TextStyle(
                    color: widget.labelColor,
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}''',
  };
}
