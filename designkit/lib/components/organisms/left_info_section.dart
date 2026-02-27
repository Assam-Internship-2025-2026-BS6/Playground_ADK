import 'package:flutter/material.dart';
import '../atoms/button.dart' as dk;

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
    return Container(
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
              vertical: 0.0,
              horizontal: isSmall ? 20.0 : 40.0,
            ),
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top Writing Part
                    Column(
                      children: [
                        SizedBox(height: isSmall ? 30 : 60),
                        Text(
                          "Digital Arrest is Fake!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmall ? 32 : 44,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Genuine officers will never detain you\nor ask for money",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmall ? 20 : 28,
                            color: Colors.white70,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
      
                    // Bottom Writing Part & Know More Button
                    Column(
                      children: [
                        Text(
                          "When in doubt reach out to your bank.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmall ? 20 : 28,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Click here to know more about Investment and APK Fraud",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isSmall ? 16 : 21,
                            color: Colors.white60,
                          ),
                        ),
                        const SizedBox(height: 30),
                        
                        // Know More Button
                        dk.Button(
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Loading detailed fraud prevention guide..."),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          text: "Know More",
                          width: isSmall ? 250 : 350,
                          height: 55,
                          color: const Color(0xFF2938AD),
                          opacity: 0.8,
                        ),
                        SizedBox(height: isSmall ? 30 : 60),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

