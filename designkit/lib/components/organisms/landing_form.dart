import 'package:flutter/material.dart';
import '../atoms/text_field.dart' as dk;
import '../atoms/glass_card.dart' as dk;
import '../atoms/login_button.dart' as dk;
import '../molecules/qr_container.dart';
import '../molecules/digicart_security.dart';

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

        return dk.GlassCard(
          width: width.clamp(0.0, constraints.maxWidth),
          height: height.clamp(0.0, constraints.maxHeight),
          tintColor: tintColor,
          borderRadius: 30,
          padding: EdgeInsets.symmetric(
            horizontal: isSmall ? 18 : 28,
            vertical: isVeryShort ? 20 : 30,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// WELCOME HEADER
                Text(
                  "Welcome to NetBanking",
                  style: TextStyle(
                    fontSize: isSmall ? 25 : 32,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2938AD),
                  ),
                ),
                
                SizedBox(height: isSmall ? 3 : 5),

                /// LOGO SECTION
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "MADE DIGITAL BY",
                      style: TextStyle(
                        fontSize: isSmall ? 14 : 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2938AD),
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Image.asset('assets/hdfc_logo.png', height: isSmall ? 15 : 18, fit: BoxFit.contain),
                        const SizedBox(width: 15),
                        Image.asset('assets/now_logo.png', height: isSmall ? 11 : 14, fit: BoxFit.contain),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: isSmall ? 10 : 15),

                /// QR SCANNER BOX
                QrContainer(
                  title: "Click to scan QR and login",
                  subtitle: "New HDFC Bank Early Access App Required",
                  width: double.infinity,
                  height: isSmall ? 90 : 110,
                  opacity: 0.3,
                ),


                SizedBox(height: isSmall ? 10 : 15),

                /// INPUT FIELDS
                Text(
                  "Customer ID",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: isSmall ? 16 : 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                const dk.TextField(
                  hintText: "Customer ID",
                ),

                const SizedBox(height: 8),

                Text(
                  "Password",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: isSmall ? 16 : 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                const dk.TextField(
                  hintText: "Password",
                  isPassword: true,
                ),
                
                const SizedBox(height: 8),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: onSetResetPassword ?? () => debugPrint("Set/Reset Password Pressed"),
                    child: Text(
                      "Set/Reset Password",
                      style: TextStyle(
                        color: const Color(0xFF5371F9),
                        fontSize: isSmall ? 18 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isSmall ? 8 : 10),

                /// SECURITY BANNER
                DigicartSecurity(
                  title: "Goodbye, Secure Text & Image",
                  subtitle: "Hello, Digicert Security",
                  imagePath: 'assets/lock.png',
                  width: double.infinity,
                  height: isSmall ? 90 : 100, 
                  opacity: 0.3,
                ),


                SizedBox(height: isSmall ? 8 : 10),

                /// LOGIN BUTTON
                dk.LoginButton(
                  onTap: () => debugPrint("Login Pressed"),
                  width: double.infinity,
                  height: isSmall ? 50 : 55,
                ),

                const SizedBox(height: 10),

                /// FOOTER
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Not registered for NetBanking? ",
                        style: TextStyle(fontSize: isSmall ? 15 : 17, color: Colors.black54),
                      ),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: onRegisterNow ?? () => debugPrint("Register Now Pressed"),
                          child: Text(
                            "Register Now",
                            style: TextStyle(
                              fontSize: isSmall ? 15 : 17,
                              color: const Color(0xFF2938AD),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
