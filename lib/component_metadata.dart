import 'package:flutter/material.dart';

class ComponentMetadata {
  final String name;
  final String category; 
  final Widget Function(Map<String, dynamic>, {bool isFullScreen}) builder;
  final Map<String, dynamic> defaultProps;
  final Map<String, List<String>>? options;

  ComponentMetadata({
    required this.name,
    required this.category,
    required this.builder,
    required this.defaultProps,
    this.options,
  });
}
