import 'package:flutter/material.dart';

class ComponentMetadata {
  final String name;
  final String category; 
  final Widget Function(Map<String, dynamic>) builder;
  final Map<String, dynamic> defaultProps;

  ComponentMetadata({
    required this.name,
    required this.category,
    required this.builder,
    required this.defaultProps,
  });
}
