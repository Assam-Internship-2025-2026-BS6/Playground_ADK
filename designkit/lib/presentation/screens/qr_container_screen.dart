import 'package:flutter/material.dart';
import '../../components/molecules/qr_container.dart';

class QrContainerScreen extends StatelessWidget {
  const QrContainerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF7289C0),
      body: Center(
        child: QrContainer(
          title: "Click to scan QR and login",
          subtitle: "New HDFC Bank Early Access App Required",
          popupTitle: "Scan to Login",
          qrData: "https://example.com/login",
        ),
      ),
    );
  }
}
