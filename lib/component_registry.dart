import 'component_metadata.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      'title': 'Welcome to NetBanking',
      'subtitle': 'MADE DIGITAL BY',
      'customerIdLabel': 'Customer ID/User ID',
      'customerIdHint': 'Customer ID/ User ID',
      'passwordLabel': 'Password',
      'buttonText': 'Login',
      'qrText': 'Click to scan QR and login',
      'qrSubtitle': 'New HDFC Bank Early Access App Required',
      'leftImagePath': 'assets/left_image.png',
      'titleSize': 'Medium',
      'titleColor': const Color(0xFF1E1E4C),
      'subtitleSize': 'Medium',
      'subtitleColor': const Color(0xFF1E1E4C),
      'customerIdSize': 'Medium',
      'customerIdColor': const Color(0xFF1E1E4C),
      'passwordSize': 'Medium',
      'passwordColor': const Color(0xFF1E1E4C),
      'buttonSize': 'Medium',
      'buttonColor': const Color(0xFF004C8F),
      'qrTextSize': 'Medium',
      'qrTextColor': const Color(0xFF1E1E4C),
      'qrSubtitleSize': 'Medium',
      'qrSubtitleColor': const Color(0xFF1E1E4C),
      'checkboxSize': 'Medium',
      'checkboxColor': const Color(0xFF1E1E4C),
    },
    options: {
      'titleSize': ['Small', 'Medium', 'Large'],
      'subtitleSize': ['Small', 'Medium', 'Large'],
      'customerIdSize': ['Small', 'Medium', 'Large'],
      'passwordSize': ['Small', 'Medium', 'Large'],
      'buttonSize': ['Small', 'Medium', 'Large'],
      'qrTextSize': ['Small', 'Medium', 'Large'],
      'qrSubtitleSize': ['Small', 'Medium', 'Large'],
      'checkboxSize': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return NetBankingLoginPage(
        isFullScreen: isFullScreen,
        title: props['title'] ?? 'Welcome to NetBanking',
        subtitle: props['subtitle'] ?? 'MADE DIGITAL BY',
        customerIdLabel: props['customerIdLabel'] ?? 'Customer ID/User ID',
        customerIdHint: props['customerIdHint'] ?? 'Customer ID/ User ID',
        passwordLabel: props['passwordLabel'] ?? 'Password',
        buttonText: props['buttonText'] ?? 'Login',
        qrText: props['qrText'] ?? 'Click to scan QR and login',
        qrSubtitle: props['qrSubtitle'] ?? 'New HDFC Bank Early Access App Required',
        leftImagePath: props['leftImagePath'] ?? 'assets/left_image.png',
        titleSize: props['titleSize'] ?? 'Medium',
        titleColor: props['titleColor'] ?? const Color(0xFF1E1E4C),
        subtitleSize: props['subtitleSize'] ?? 'Medium',
        subtitleColor: props['subtitleColor'] ?? const Color(0xFF1E1E4C),
        customerIdSize: props['customerIdSize'] ?? 'Medium',
        customerIdColor: props['customerIdColor'] ?? const Color(0xFF1E1E4C),
        passwordSize: props['passwordSize'] ?? 'Medium',
        passwordColor: props['passwordColor'] ?? const Color(0xFF1E1E4C),
        buttonSize: props['buttonSize'] ?? 'Medium',
        buttonColor: props['buttonColor'] ?? const Color(0xFF004C8F),
        qrTextSize: props['qrTextSize'] ?? 'Medium',
        qrTextColor: props['qrTextColor'] ?? const Color(0xFF1E1E4C),
        qrSubtitleSize: props['qrSubtitleSize'] ?? 'Medium',
        qrSubtitleColor: props['qrSubtitleColor'] ?? const Color(0xFF1E1E4C),
        checkboxSize: props['checkboxSize'] ?? 'Medium',
        checkboxColor: props['checkboxColor'] ?? const Color(0xFF1E1E4C),
      );
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
      'xOffset': 0.0,
      'yOffset': 0.0,
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
      'xOffset': 0.0,
      'yOffset': 0.0,
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
      'labelColor': const Color(0xFF1E1E4C),
      'labelSize': 'Medium',
      'labelWeight': FontWeight.normal,
      'inputHint': 'Enter your ID',
      'inputColor': Colors.black87,
      'inputSize': 'Medium',
      'inputWeight': FontWeight.normal,
      'width': 700.0,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'labelSize': ['Small', 'Medium', 'Large'],
      'inputSize': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final labelSize = props['labelSize'] ?? 'Medium';
      double labelFontSize = 32.0;
      if (labelSize == 'Small') labelFontSize = 24.0;
      if (labelSize == 'Large') labelFontSize = 40.0;

      final inputSize = props['inputSize'] ?? 'Medium';
      double inputFontSize = 36.0;
      if (inputSize == 'Small') inputFontSize = 24.0;
      if (inputSize == 'Large') inputFontSize = 50.0;

      return LabeledInputField(
        label: props['label'] ?? 'Customer ID/ User ID',
        hintText: props['inputHint'] ?? 'Enter your ID',
        width: (props['width'] as num?)?.toDouble() ?? 700.0,
        labelColor: props['labelColor'] ?? const Color(0xFF1E1E4C),
        labelFontSize: labelFontSize,
        labelWeight: props['labelWeight'] ?? FontWeight.normal,
        inputColor: props['inputColor'] ?? Colors.black87,
        inputFontSize: inputFontSize,
        inputWeight: props['inputWeight'] ?? FontWeight.normal,
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),
  ComponentMetadata(
    name: 'Password Field',
    category: 'Molecules',
    defaultProps: {
      'label': 'Password/ PIN',
      'labelColor': const Color(0xFF1E1E4C),
      'labelSize': 'Medium',
      'labelWeight': FontWeight.normal,
      'inputHint': 'Enter password',
      'inputColor': Colors.black87,
      'inputSize': 'Medium',
      'inputWeight': FontWeight.normal,
      'width': 700.0,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'labelSize': ['Small', 'Medium', 'Large'],
      'inputSize': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final labelSize = props['labelSize'] ?? 'Medium';
      double labelFontSize = 32.0;
      if (labelSize == 'Small') labelFontSize = 24.0;
      if (labelSize == 'Large') labelFontSize = 40.0;

      final inputSize = props['inputSize'] ?? 'Medium';
      double inputFontSize = 36.0;
      if (inputSize == 'Small') inputFontSize = 24.0;
      if (inputSize == 'Large') inputFontSize = 50.0;

      return PasswordField(
        label: props['label'] ?? 'Password/ PIN',
        hintText: props['inputHint'] ?? 'Enter password',
        width: (props['width'] as num?)?.toDouble() ?? 700.0,
        labelColor: props['labelColor'] ?? const Color(0xFF1E1E4C),
        labelFontSize: labelFontSize,
        labelWeight: props['labelWeight'] ?? FontWeight.normal,
        inputColor: props['inputColor'] ?? Colors.black87,
        inputFontSize: inputFontSize,
        inputWeight: props['inputWeight'] ?? FontWeight.normal,
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
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
        'Salary Account - 3456',
        'Business Account - 7890',
        'NRI Account - 1122',
      ],
      'width': 300.0,
      'activeColor': AppColors.hdfcBlue,
      'disabled': false,
      'xOffset': 0.0,
      'yOffset': 0.0,
    },
    options: {
      'value': [
        'Savings Account - 1234',
        'Current Account - 5678',
        'Fixed Deposit - 9012',
        'Salary Account - 3456',
        'Business Account - 7890',
        'NRI Account - 1122',
      ],
    },
    builder: (Map<String, dynamic> props,
        {bool isFullScreen = false, VoidCallback? onUpdate}) {
      return StatefulBuilder(
        builder: (context, setState) {
          return dk.Dropdown(
            label: props['label'],
            value: props['value'],
            items: List<String>.from(props['items'] ?? []),
            width: (props['width'] as num?)?.toDouble() ?? 300.0,
            activeColor: props['activeColor'] ?? AppColors.hdfcBlue,
            enabled: !(props['disabled'] ?? false),
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
      'tintColor': const Color(0xFF3B82F6),
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final bool showTitle = props['showTitle'] ?? true;
      return GlassCard(
        width: (props['width'] as num?)?.toDouble() ?? 550.0,
        height: (props['height'] as num?)?.toDouble() ?? 300.0,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.12,
        showShadow: props['showShadow'] ?? true,
        borderRadius: (props['borderRadius'] as num?)?.toDouble() ?? 20.0,
        tintColor: props['tintColor'] ?? const Color(0xFF3B82F6),
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
      'fontWeight': FontWeight.normal,
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
      'fontWeight': FontWeight.normal,
      'size': 'Medium',
      'disabled': false,
      'restrictNumbers': false,
      'restrictAlphabets': false,
      'restrictSpecialCharacters': false,
      'restrictCopyPaste': false,
      'xOffset': 0.0,
      'yOffset': 0.0,
},
    options: {
      'size': ['Small', 'Medium', 'Large'],
    },
    builder: (Map<String, dynamic> props, {bool isFullScreen = false, VoidCallback? onUpdate}) {
      final size = props['size'] ?? 'Medium';
      double fontSize = 28.0;
      if (size == 'Small') {
        fontSize = 20.0;
      } else if (size == 'Medium') {
        fontSize = 28.0;
      } else if (size == 'Large') {
        fontSize = 36.0;
      }

      final List<FilteringTextInputFormatter> formatters = [];
      if (props['restrictNumbers'] ?? false) {
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'[0-9]')));
      }
      if (props['restrictAlphabets'] ?? false) {
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'[a-zA-Z]')));
      }
      if (props['restrictSpecialCharacters'] ?? false) {
        formatters.add(FilteringTextInputFormatter.deny(RegExp(r'[^a-zA-Z0-9\s]')));
      }

      return dk.TextField(
        hintText: props['hintText'] ?? 'Enter text',
        isPassword: props['isPassword'] ?? false,
        height: (props['height'] as num?)?.toDouble() ?? 80.0,
        width: (props['width'] as num?)?.toDouble() ?? 400.0,
        showErrorText: props['showErrorText'] ?? false,
        textColor: props['color'] ?? Colors.black,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
        fontSize: fontSize,
        enabled: !(props['disabled'] ?? false),
        keyboardType: (props['restrictAlphabets'] ?? false) && !(props['restrictNumbers'] ?? false)
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: formatters.isEmpty ? null : formatters,
        enableInteractiveSelection: !(props['restrictCopyPaste'] ?? false),
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
      'color': const Color(0xFF004C8F),
      'opacity': 0.8,
      'fontWeight': FontWeight.normal,
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
        color: props['color'] ?? const Color(0xFF004C8F),
        opacity: (props['opacity'] as num?)?.toDouble() ?? 0.8,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
        onTap: () => debugPrint('Button Pressed'),
        offset: Offset(
          (props['xOffset'] as num?)?.toDouble() ?? 0.0,
          -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
        ),
      );
    },
  ),
  ComponentMetadata(
    name: 'Check Box',
    category: 'Atoms',
    defaultProps: {
      'label': 'Keep me logged in',
      'size': 'Medium',
      'disabled': false,
      'activeColor': const Color(0xFF1E1E4C),
      'labelColor': const Color(0xFF1E1E4C),
      'fontWeight': FontWeight.normal,
      'opacity': 1.0,
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
        value: props['value'] ?? false, 
        label: props['label'],
        size: componentSize,
        disabled: props['disabled'] ?? false,
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
        opacity: (props['opacity'] as num?)?.toDouble() ?? 1.0,
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
      'fontWeight': FontWeight.normal,
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
        fontWeight: props['fontWeight'] ?? FontWeight.normal,
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
      'fontWeight': FontWeight.normal,
      'disabled': false,
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
            fontWeight: props['fontWeight'] ?? FontWeight.normal,
            activeColor: props['activeColor'] ?? const Color(0xFF1E1E4C),
            labelColor: props['labelColor'] ?? Colors.black87,
            offset: Offset(
              (props['xOffset'] as num?)?.toDouble() ?? 0.0,
              -((props['yOffset'] as num?)?.toDouble() ?? 0.0),
            ),
            disabled: props['disabled'] ?? false,
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
      'labelColor': Colors.black87,
      'fontWeight': FontWeight.normal,
      'disabled': false,
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
            fontWeight: props['fontWeight'] ?? FontWeight.normal,
            disabled: props['disabled'] ?? false,
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
