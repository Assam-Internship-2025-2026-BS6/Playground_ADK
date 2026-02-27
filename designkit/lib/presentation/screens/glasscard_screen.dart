import 'package:flutter/material.dart';
import '../../components/atoms/glass_card.dart';

class GlasscardScreen extends StatefulWidget {
  const GlasscardScreen({super.key});

  @override
  State<GlasscardScreen> createState() => _GlasscardScreenState();
}

class _GlasscardScreenState extends State<GlasscardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey.shade900,
      body: Center(
        child: GlassCard(
          width: 587,
          height: 932,
          child: Column(mainAxisAlignment: MainAxisAlignment.center),
        ),
      ),
    );
  }
}
