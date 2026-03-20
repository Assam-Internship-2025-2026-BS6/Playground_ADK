import 'component_metadata.dart';
import 'package:flutter/material.dart';
import 'package:designkit/designkit.dart'
    hide
        Text,
        TextField,
        TextButton,
        Checkbox,
        RadioButton,
        ToggleSwitch;
import 'package:designkit/designkit.dart' as dk
    show
        Text,
        TextField,
        TextButton,
        Checkbox,
        RadioButton,
        ToggleSwitch,
        Dropdown;

final List<ComponentMetadata> componentRegistry = [
  ComponentMetadata(
    name: 'NetBankingLoginPage',
    category: 'Pages',
    defaultProps: {
      '_width': 1440.0,
      '_height': 900.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return NetBankingLoginPage(isFullScreen: isFullScreen);
    },
  ),

  // Organisms
  ComponentMetadata(
    name: 'Landing Form Organism',
    category: 'Organisms',
    defaultProps: {
      'width': 500.0,
      'height': 720.0,
      'tintColor': const Color(0x33FFFFFF),
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return LandingFormOrganism(
        width: (props['width'] as num?)?.toDouble() ?? 500.0,
        height: (props['height'] as num?)?.toDouble() ?? 720.0,
        tintColor: props['tintColor'] ?? const Color(0x33FFFFFF),
        onSetResetPassword: () => debugPrint('Set/Reset Password Clicked'),
        onRegisterNow: () => debugPrint('Register Now Clicked'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Left Info Section',
    category: 'Organisms',
    defaultProps: {
      'width': 550.0,
      'height': 780.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return LeftInfoSection(
        width: (props['width'] as num?)?.toDouble() ?? 550.0,
        height: (props['height'] as num?)?.toDouble() ?? 780.0,
      );
    },
  ),
  ComponentMetadata(
    name: 'Right Login Container',
    category: 'Organisms',
    defaultProps: {
      'width': 500.0,
      'height': 780.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return RightLoginContainer(
        width: (props['width'] as num?)?.toDouble() ?? 500.0,
        height: (props['height'] as num?)?.toDouble() ?? 780.0,
      );
    },
  ),

  // Molecules
  ComponentMetadata(
    name: 'QR Login',
    category: 'Molecules',
    defaultProps: {
      'title': 'Click to scan QR and login',
      'subtitle': 'New HDFC Bank Early Access App Required',
      'width': 484.0,
      'height': 120.0,
      'opacity': 0.2,
},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return QrLogin(
        title: props['title'] ?? 'Click to scan QR and login',
        subtitle:
            props['subtitle'] ?? 'New HDFC Bank Early Access App Required',
        imagePath: 'assets/qr_login.png',
        width: (props['width'] as num?)?.toDouble() ?? 484.0,
        height: (props['height'] as num?)?.toDouble() ?? 120.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.2,
      );
    },
  ),
  ComponentMetadata(
    name: 'Digicart Security',
    category: 'Molecules',
    defaultProps: {
      'title': 'Goodbye, Secure Text & Image',
      'subtitle': 'Hello, Digicert Security',
      'imagePath': 'assets/lock.png',
      'width': 484.0,
      'height': 120.0,
      'opacity': 0.2,
},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return DigicartSecurity(
        title: props['title'] ?? 'Goodbye, Secure Text & Image',
        subtitle: props['subtitle'] ?? 'Hello, Digicert Security',
        imagePath: props['imagePath'] ?? 'assets/lock.png',
        width: (props['width'] as num?)?.toDouble() ?? 484.0,
        height: (props['height'] as num?)?.toDouble() ?? 120.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.2,
        onTap: () => debugPrint('Security Card Tapped'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Labeled Input Field',
    category: 'Molecules',
    defaultProps: {
      'label': 'Customer ID/ User ID',
      'hintText': 'Enter your ID',
      'width': 700.0,
},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return LabeledInputField(
        label: props['label'] ?? 'Customer ID/ User ID',
        hintText: props['hintText'] ?? 'Enter your ID',
        width: (props['width'] as num?)?.toDouble() ?? 700.0,
      );
    },
  ),
  ComponentMetadata(
    name: 'Password Field',
    category: 'Molecules',
    defaultProps: {
      'label': 'Password/ PIN',
      'hintText': 'Enter password',
      'width': 700.0,
},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return PasswordField(
        label: props['label'] ?? 'Password/ PIN',
        hintText: props['hintText'] ?? 'Enter password',
        width: (props['width'] as num?)?.toDouble() ?? 700.0,
      );
    },
  ),
  ComponentMetadata(
    name: 'Dropdown',
    category: 'Molecules',
    defaultProps: {
      'label': 'Select Account',
      'value': 'Savings Account - 1234',
      'items': [
        'Savings Account - 1234',
        'Current Account - 5678',
        'Fixed Deposit - 9012',
      ],
      'width': 300.0,
      'activeColor': const Color(0xFF1E1E4C),
},
    options: {
      'value': [
        'Savings Account - 1234',
        'Current Account - 5678',
        'Fixed Deposit - 9012',
      ],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return StatefulBuilder(
        builder: (context, setState) {
          return dk.Dropdown(
            label: props['label'],
            value: props['value'],
            items: List<String>.from(props['items'] ?? []),
            width: (props['width'] as num?)?.toDouble() ?? 300.0,
            activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
            offset: Offset(
              (props['xOffset'] as num?)?.toDouble() ?? 0.0,
              -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
            ),
            onChanged: (val) {
              setState(() {
                props['value'] = val;
              });
              onUpdate?.call();
            },
          );
        },
      );
    },
  ),

  // Atoms
  ComponentMetadata(
    name: 'Glass Card',
    category: 'Atoms',
    defaultProps: {
      'width': 550.0,
      'height': 300.0,
      'opacity': 0.12,
      'showShadow': true,
      'showTitle': true,
      'borderRadius': 20.0,
      'tintColor': Colors.white,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final bool showTitle = props['showTitle'] ?? true;
      return GlassCard(
        width: (props['width'] as num?)?.toDouble() ?? 550.0,
        height: (props['height'] as num?)?.toDouble() ?? 300.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.12,
        showShadow: props['showShadow'] ?? true,
        borderRadius: (props['borderRadius'] as num?)?.toDouble() ?? 20.0,
        tintColor: props['tintColor'] ?? Colors.white,
        child: showTitle
            ? const Center(
                child: dk.Text(
                    text: 'Glass Card', fontSize: 20.0, color: Colors.black),
              )
            : const SizedBox(),
      );
    },
  ),
  ComponentMetadata(
    name: 'Text',
    category: 'Atoms',
    defaultProps: {
      'text': 'Hello World',
      'size': 'Medium',
      'color': Colors.black,
      'fontWeight': FontWeight.w700,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'size': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final size = props['size'] ?? 'Medium';
      double fontSize = 40.0;
      if (size == 'Small') {
        fontSize = 24.0; // H1 token mapping (Small)
      } else if (size == 'Medium') {
        fontSize = 40.0; // H2 token mapping (Medium)
      } else if (size == 'Large') {
        fontSize = 64.0; // H3 token mapping (Large)
      }

      return dk.Text(
        text: props['text'] ?? 'Hello World',
        fontSize: fontSize,
        color: props['color'],
        fontWeight: props['fontWeight'],
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),
  ComponentMetadata(
    name: 'Text Field',
    category: 'Atoms',
    defaultProps: {
      'hintText': 'Enter text',
      'isPassword': false,
      'height': 80.0,
      'width': 400.0,
      'showErrorText': false,
      'color': Colors.black,
      'fontWeight': FontWeight.w700,
      'disabled': false,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return dk.TextField(
        hintText: props['hintText'] ?? 'Enter text',
        isPassword: props['isPassword'] ?? false,
        height: (props['height'] as num?)?.toDouble() ?? 80.0,
        width: (props['width'] as num?)?.toDouble() ?? 400.0,
        showErrorText: props['showErrorText'] ?? false,
        textColor: props['color'] ?? Colors.black,
        fontWeight: props['fontWeight'] ?? FontWeight.w700,
        enabled: !(props['disabled'] ?? false),
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),
  ComponentMetadata(
    name: 'Button',
    category: 'Atoms',
    defaultProps: {
      'text': 'Know More',
      'size': 'Medium',
      'disabled': false,
      'color': const Color.fromARGB(255, 41, 84, 255),
      'opacity': 0.8,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'size': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final size = props['size'] ?? 'Medium';
      double width = 321.0;
      double height = 80.0;

      if (size == 'Small') {
        width = 200.0;
        height = 60.0;
      } else if (size == 'Medium') {
        width = 321.0;
        height = 80.0;
      } else if (size == 'Large') {
        width = 450.0;
        height = 100.0;
      }

      return Button(
        text: props['text'] ?? 'Know More',
        width: width,
        height: height,
        disabled: props['disabled'] ?? false,
        color: props['color'] ?? const Color(0xFF5371F9),
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.8,
        onTap: () => debugPrint('Button Pressed'),
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),
  ComponentMetadata(
    name: 'Checkbox',
    category: 'Atoms',
    defaultProps: {
      'label': 'Keep me logged in',
      'size': 'Medium',
      'disabled': false,
      'activeColor': const Color(0xFF1E1E4C),
      'labelColor': const Color(0xFF1E1E4C),
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'size': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final sizeOpt = props['size'] ?? 'Medium';
      double componentSize = 1.0;
      if (sizeOpt == 'Small') {
        componentSize = 0.8;
      } else if (sizeOpt == 'Large') {
        componentSize = 1.2;
      }

      return dk.Checkbox(
        value: false, // Internal state will take over after first render
        label: props['label'],
        size: componentSize,
        disabled: props['disabled'] ?? false,
        activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
        labelColor: props['labelColor'] ?? const Color(0xFF1E1E4C),
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
        onChanged: (val) => debugPrint('Checkbox onChanged: $val'),
        onPressed: () => debugPrint('Checkbox onPressed triggered'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Text Button',
    category: 'Atoms',
    defaultProps: {
      'text': 'Click Me',
      'size': 'Medium',
      'isClickable': true,
      'enableHover': true,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'size': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final size = props['size'] ?? 'Medium';
      double fontSize = 40.0;
      if (size == 'Small') {
        fontSize = 24.0;
      } else if (size == 'Medium') {
        fontSize = 40.0;
      } else if (size == 'Large') {
        fontSize = 64.0;
      }

      return dk.TextButton(
        text: props['text'] ?? 'Click Me',
        fontSize: fontSize,
        isClickable: props['isClickable'] ?? true,
        enableHover: props['enableHover'] ?? true,
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
        onPressed: () => debugPrint('Button Pressed'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Image',
    category: 'Atoms',
    defaultProps: {
      'imagePath': 'assets/hdfc_logo.png',
      'size': 'Medium',
      'showShadow': false,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {
      'size': ['Small', 'Medium', 'Large'],
      'imagePath': [
        'assets/hdfc_logo.png',
        'assets/lock.png',
        'assets/now_logo.png',
        'assets/left_image.png',
        'assets/right_back.png',
        'assets/qr_login.png',
      ],
    },
       builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final String path = props['imagePath'] ?? 'assets/hdfc_logo.png';
      final String size = props['size'] ?? 'Medium';
      
      // Base sizes for assets
      final Map<String, Size> imageSizes = {
        'assets/hdfc_logo.png': const Size(400.0, 400.0),
        'assets/lock.png': const Size(100.0, 100.0),
        'assets/left_image.png': const Size(700.0, 700.0),
        'assets/now_logo.png': const Size(120.0, 120.0),
        'assets/right_back.png': const Size(700.0, 700.0),
        'assets/qr_login.png': const Size(400.0, 400.0),
      };

      Size currentSize = imageSizes[path] ?? const Size(300.0, 300.0);

      // Apply size multiplier
      double multiplier = 1.0;
      if (size == 'Small') multiplier = 0.5;
      if (size == 'Large') multiplier = 1.5;

      return dkImage(
        imagePath: path,
        width: currentSize.width * multiplier,
        height: currentSize.height * multiplier,
        offsetX: (props['xOffset'] as num?)?.toDouble() ?? 0.0,
        offsetY: -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        showShadow: props['showShadow'] ?? false,
      );
    },
  ),
  ComponentMetadata(
    name: 'Radio Button',
    category: 'Atoms',
    defaultProps: {
      'label': 'Radio Option',
      'value': true,
      'size': 'Medium',
      'activeColor': const Color(0xFF1E1E4C),
      'labelColor': Colors.black87,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'size': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final sizeOpt = props['size'] ?? 'Medium';
      double fontSize = 40.0;
      if (sizeOpt == 'Small') {
        fontSize = 28.0;
      } else if (sizeOpt == 'Large') {
        fontSize = 50.0;
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return dk.RadioButton(
            label: props['label'] ?? 'Radio Option',
            value: props['value'] ?? false,
            fontSize: fontSize,
            activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
            labelColor: props['labelColor'] ?? Colors.black87,
            offset: Offset(
              (props['xOffset'] as num?)?.toDouble() ?? 0.0,
              -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
            ),
            onChanged: (val) {
              setState(() {
                props['value'] = val;
              });
              onUpdate?.call();
              debugPrint('Radio Button Toggled: $val');
            },
          );
        },
      );
    },
  ),
  ComponentMetadata(
    name: 'Toggle Switch',
    category: 'Atoms',
    defaultProps: {
      'label': 'Enable Notifications',
      'value': false,
      'size': 'Medium',
      'activeColor': const Color(0xFF1E1E4C),
      'labelColor': Colors.black87,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'size': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final sizeOpt = props['size'] ?? 'Medium';
      double componentSize = 1.0;
      if (sizeOpt == 'Small') {
        componentSize = 0.7;
      } else if (sizeOpt == 'Large') {
        componentSize = 1.4;
      }

      return StatefulBuilder(
        builder: (context, setState) {
          return dk.ToggleSwitch(
            label: props['label'],
            value: props['value'] ?? false,
            size: componentSize,
            fontSize: 30.0,
            activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
            labelColor: props['labelColor'] ?? Colors.black87,
            offset: Offset(
              (props['xOffset'] as num?)?.toDouble() ?? 0.0,
              -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
            ),
            onChanged: (val) {
              setState(() {
                props['value'] = val;
              });
              onUpdate?.call();
            },
          );
        },
      );
    },
  ),
];
