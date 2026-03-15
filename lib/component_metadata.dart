import 'package:flutter/material.dart';

class ComponentMetadata {
  final String name;
  final String category; 
  final Widget Function(Map<String, dynamic>, {bool isFullScreen, VoidCallback? onUpdate}) builder;
  final Map<String, dynamic> defaultProps;
  final Map<String, List<String>>? options;
  final String? implementationCode;

  ComponentMetadata({
    required this.name,
    required this.category,
    required this.builder,
    required this.defaultProps,
    this.options,
    this.implementationCode,
  });
}
