import 'dart:developer';
import 'package:flutter/material.dart';
import '../../components/molecules/digicart_security.dart';

class DigicartSecurityScreen extends StatefulWidget {
  const DigicartSecurityScreen({super.key});

  @override
  State<DigicartSecurityScreen> createState() => _DigicartSecurityScreenState();
}

class _DigicartSecurityScreenState extends State<DigicartSecurityScreen> {
  void handleCardClick() {
    log("Security card clicked!");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 114, 137, 192),
      body: Center(
        child: DigicartSecurity(
          title: "Goodbye, Secure Text & Image",
          subtitle: "Hello, Digicert Security",
          imagePath: "assets/lock.png",
          width: MediaQuery.of(context).size.width * 0.9,
          onTap: handleCardClick,
        ),
      ),
    );
  }
}
