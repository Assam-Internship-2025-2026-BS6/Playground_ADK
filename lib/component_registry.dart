import 'component_metadata.dart';
import 'package:flutter/material.dart';
import 'package:designkit/designkit.dart'
    hide
        Text,
        TextField,
        TextButton,
        Checkbox,
        RadioButton,
        ToggleSwitch,
        Dropdown;
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
    defaultProps: {},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return NetBankingLoginPage(
        isFullScreen: isFullScreen,
      );
    },
  ),

  // Organisms
  ComponentMetadata(
    name: 'LoginFormSection',
    category: 'Organisms',
    defaultProps: {
      'width': 500.0,
      'height': 850.0,
      'tintColor': const Color(0x33FFFFFF),
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return LandingFormOrganism(
        width: (props['width'] as num?)?.toDouble() ?? 500.0,
        height: (props['height'] as num?)?.toDouble() ?? 850.0,
        tintColor: props['tintColor'] ?? const Color(0x33FFFFFF),
        onSetResetPassword: () => debugPrint('Set/Reset Password Clicked'),
        onRegisterNow: () => debugPrint('Register Now Clicked'),
      );
    },
  ),
  ComponentMetadata(
    name: 'FraudAwrenessSection',
    category: 'Organisms',
    defaultProps: {
      'width': 500.0,
      'height': 850.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return LeftInfoSection(
        width: (props['width'] as num?)?.toDouble() ?? 500.0,
        height: (props['height'] as num?)?.toDouble() ?? 850.0,
      );
    },
  ),
  ComponentMetadata(
    name: 'NetBankingLoginLayout',
    category: 'Organisms',
    defaultProps: {
      'width': 500.0,
      'height': 850.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return RightLoginContainer(
        width: (props['width'] as num?)?.toDouble() ?? 500.0,
        height: (props['height'] as num?)?.toDouble() ?? 850.0,
      );
    },
  ),

  // Molecules
  ComponentMetadata(
    name: 'QRLoginCard',
    category: 'Molecules',
    defaultProps: {
      'title': 'Click to scan QR and login',
      'subtitle': 'New HDFC Bank Early Access App Required',
      'width': 484.0,
      'height': 120.0,
      'opacity': 0.2,
      'blur': 15.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return QrContainer(
        title: props['title'] ?? 'Click to scan QR and login',
        subtitle:
            props['subtitle'] ?? 'New HDFC Bank Early Access App Required',
        width: (props['width'] as num?)?.toDouble() ?? 484.0,
        height: (props['height'] as num?)?.toDouble() ?? 120.0,
        blur: (props['blur'] as num?)?.toDouble() ?? 15.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.2,
      );
    },
  ),
  ComponentMetadata(
    name: 'SecureInfoCard',
    category: 'Molecules',
    defaultProps: {
      'title': 'Goodbye, Secure Text & Image',
      'subtitle': 'Hello, Digicert Security',
      'imagePath': 'assets/lock.png',
      'width': 484.0,
      'height': 120.0,
      'opacity': 0.2,
      'blur': 15.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return DigicartSecurity(
        title: props['title'] ?? 'Goodbye, Secure Text & Image',
        subtitle: props['subtitle'] ?? 'Hello, Digicert Security',
        imagePath: props['imagePath'] ?? 'assets/lock.png',
        width: (props['width'] as num?)?.toDouble() ?? 484.0,
        height: (props['height'] as num?)?.toDouble() ?? 120.0,
        blur: (props['blur'] as num?)?.toDouble() ?? 15.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.2,
        onTap: () => debugPrint('Security Card Tapped'),
      );
    },
  ),
  ComponentMetadata(
    name: 'LabeledInputField',
    category: 'Molecules',
    defaultProps: {
      'label': 'Customer ID/ User ID',
      'hintText': 'Enter your ID',
      'width': 700.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return LabeledInputField(
        label: props['label'] ?? 'Customer ID/ User ID',
        hintText: props['hintText'] ?? 'Enter your ID',
        width: (props['width'] as num?)?.toDouble() ?? 700.0,
      );
    },
  ),
  ComponentMetadata(
    name: 'PasswordField',
    category: 'Molecules',
    defaultProps: {
      'label': 'Password/ PIN',
      'hintText': 'Enter password',
      'width': 700.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
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
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
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
              (props['yOffset'] as num?)?.toDouble() ?? 0.0,
            ),
            onChanged: (val) {
              setState(() {
                props['value'] = val;
              });
            },
          );
        },
      );
    },
  ),

  // Atoms
  ComponentMetadata(
    name: 'GlassCard',
    category: 'Atoms',
    defaultProps: {
      'width': 550.0,
      'height': 300.0,
      'opacity': 0.12,
      'blur': 15.0,
      'showShadow': true,
      'borderRadius': 20.0,
      'tintColor': Colors.white,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return GlassCard(
        width: (props['width'] as num?)?.toDouble() ?? 550.0,
        height: (props['height'] as num?)?.toDouble() ?? 300.0,
        blur: (props['blur'] as num?)?.toDouble() ?? 15.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.12,
        showShadow: props['showShadow'] ?? true,
        borderRadius: (props['borderRadius'] as num?)?.toDouble() ?? 20.0,
        tintColor: props['tintColor'] ?? Colors.white,
        child: const Center(
          child:
              dk.Text(text: 'Glass Card', fontSize: 24.0, color: Colors.black),
        ),
      );
    },
  ),
  ComponentMetadata(
    name: 'Text',
    category: 'Atoms',
    defaultProps: {
      'text': 'Hello World',
      'fontSize': 20.0,
      'color': Colors.black,
      'fontWeight': FontWeight.normal,
      'textAlign': 'left',
    },
    options: {
      'textAlign': ['left', 'center', 'right'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      TextAlign align = TextAlign.left;
      if (props['textAlign'] == 'center') align = TextAlign.center;
      if (props['textAlign'] == 'right') align = TextAlign.right;

      return dk.Text(
        text: props['text'] ?? 'Hello World',
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 20.0,
        color: props['color'],
        fontWeight: props['fontWeight'],
        textAlign: align,
      );
    },
  ),
  ComponentMetadata(
    name: 'TextField',
    category: 'Atoms',
    defaultProps: {
      'hintText': 'Enter text',
      'isPassword': false,
      'height': 60.0,
      'width': 700.0,
      'showErrorText': false,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return dk.TextField(
        hintText: props['hintText'] ?? 'Enter text',
        isPassword: props['isPassword'] ?? false,
        height: (props['height'] as num?)?.toDouble() ?? 60.0,
        width: (props['width'] as num?)?.toDouble() ?? 700.0,
        showErrorText: props['showErrorText'] ?? false,
      );
    },
  ),
  ComponentMetadata(
    name: 'Button',
    category: 'Atoms',
    defaultProps: {
      'text': 'Know More',
      'width': 321.0,
      'height': 61.0,
      'disabled': false,
      'color': const Color.fromARGB(255, 41, 84, 255),
      'showOutline': true,
      'blur': 10.0,
      'opacity': 0.8,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return Button(
        text: props['text'] ?? 'Know More',
        width: (props['width'] as num?)?.toDouble() ?? 321.0,
        height: (props['height'] as num?)?.toDouble() ?? 61.0,
        disabled: props['disabled'] ?? false,
        color: props['color'] ?? const Color(0xFF5371F9),
        showOutline: props['showOutline'] ?? true,
        blur: (props['blur'] as num?)?.toDouble() ?? 10.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.8,
        onTap: () => debugPrint('Button Pressed'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Checkbox',
    category: 'Atoms',
    defaultProps: {
      'label': 'Keep me logged in',
      'disabled': false,
      'activeColor': const Color(0xFF1E1E4C),
      'labelColor': const Color(0xFF1E1E4C),
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return dk.Checkbox(
        value: false, // Internal state will take over after first render
        label: props['label'],
        disabled: props['disabled'] ?? false,
        activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
        labelColor: props['labelColor'] ?? const Color(0xFF1E1E4C),
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          (props['yOffset'] as num?)?.toDouble() ?? 0.0,
        ),
        onChanged: (val) => debugPrint('Checkbox onChanged: $val'),
        onPressed: () => debugPrint('Checkbox onPressed triggered'),
      );
    },
  ),
  ComponentMetadata(
    name: 'TextButton',
    category: 'Atoms',
    defaultProps: {
      'text': 'Click Me',
      'fontSize': 24.0,
      'isClickable': true,
      'enableHover': true,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return dk.TextButton(
        text: props['text'] ?? 'Click Me',
        fontSize: (props['fontSize'] as num?)?.toDouble() ?? 24.0,
        isClickable: props['isClickable'] ?? true,
        enableHover: props['enableHover'] ?? true,
        onPressed: () => debugPrint('Button Pressed'),
      );
    },
  ),
  ComponentMetadata(
    name: 'Logo',
    category: 'Atoms',
    defaultProps: {
      'width': 240.0,
      'height': 31.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return Logo(
        width: (props['width'] as num?)?.toDouble() ?? 240.0,
        height: (props['height'] as num?)?.toDouble() ?? 31.0,
      );
    },
  ),
  ComponentMetadata(
    name: 'RadioButton',
    category: 'Atoms',
    defaultProps: {
      'label': 'Radio Option',
      'value': true,
      'fontSize': 18.0,
      'activeColor': const Color(0xFF1E1E4C),
      'labelColor': Colors.black87,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return StatefulBuilder(
        builder: (context, setState) {
          return dk.RadioButton(
            label: props['label'] ?? 'Radio Option',
            value: props['value'] ?? false,
            fontSize: (props['fontSize'] as num?)?.toDouble() ?? 18.0,
            activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
            labelColor: props['labelColor'] ?? Colors.black87,
            offset: Offset(
              (props['xOffset'] as num?)?.toDouble() ?? 0.0,
              (props['yOffset'] as num?)?.toDouble() ?? 0.0,
            ),
            onChanged: (val) {
              setState(() {
                props['value'] = val;
              });
              debugPrint('Radio Button Toggled: $val');
            },
          );
        },
      );
    },
  ),
  ComponentMetadata(
    name: 'ToggleSwitch',
    category: 'Atoms',
    defaultProps: {
      'label': 'Enable Notifications',
      'value': false,
      'activeColor': const Color(0xFF1E1E4C),
      'labelColor': Colors.black87,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) {
      return StatefulBuilder(
        builder: (context, setState) {
          return dk.ToggleSwitch(
            label: props['label'],
            value: props['value'] ?? false,
            activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
            labelColor: props['labelColor'] ?? Colors.black87,
            offset: Offset(
              (props['xOffset'] as num?)?.toDouble() ?? 0.0,
              (props['yOffset'] as num?)?.toDouble() ?? 0.0,
            ),
            onChanged: (val) {
              setState(() {
                props['value'] = val;
              });
            },
          );
        },
      );
    },
  ),
  // Assets
  ComponentMetadata(
    name: 'HDFC Logo',
    category: 'Assets',
    defaultProps: {'width': 200.0},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) =>
        Image.asset('assets/hdfc_logo.png',
            width: (props['width'] as num?)?.toDouble() ?? 200.0),
  ),
  ComponentMetadata(
    name: 'Left Image',
    category: 'Assets',
    defaultProps: {'width': 400.0},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) =>
        Image.asset('assets/left_image.png',
            width: (props['width'] as num?)?.toDouble() ?? 400.0),
  ),
  ComponentMetadata(
    name: 'Lock Icon',
    category: 'Assets',
    defaultProps: {'width': 100.0},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) =>
        Image.asset('assets/lock.png',
            width: (props['width'] as num?)?.toDouble() ?? 100.0),
  ),
  ComponentMetadata(
    name: 'Now Logo',
    category: 'Assets',
    defaultProps: {'width': 100.0},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) =>
        Image.asset('assets/now_logo.png',
            width: (props['width'] as num?)?.toDouble() ?? 100.0),
  ),
  ComponentMetadata(
    name: 'Right Background',
    category: 'Assets',
    defaultProps: {'width': 400.0},
    builder: (Map<String, dynamic> props, {bool isFullScreen = false}) =>
        Image.asset('assets/right_back.png',
            width: (props['width'] as num?)?.toDouble() ?? 400.0),
  ),
];
