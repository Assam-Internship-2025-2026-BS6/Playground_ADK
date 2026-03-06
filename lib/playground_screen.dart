import 'package:flutter/material.dart';
import 'package:designkit/components/atoms/text.dart' as dk;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'component_registry.dart';
import 'component_metadata.dart';
import 'package:designkit/components/atoms/glass_container.dart';

class PlaygroundScreen extends StatefulWidget {
  const PlaygroundScreen({super.key});

  @override
  State<PlaygroundScreen> createState() => _PlaygroundScreenState();
}

class _PlaygroundScreenState extends State<PlaygroundScreen> {
  ComponentMetadata? selectedComponent;
  Map<String, dynamic> currentProps = {};
  bool isMobile = false;
  bool _isFullScreen = false;
  final Map<String, TextEditingController> _controllers = {};
  int _refreshCounter = 0;
  String _searchQuery = "";
  late TextEditingController _searchController;
  
  double _sidebarWidth = 320.0;
  double _propertiesWidth = 320.0;
  final double _minPanelWidth = 300.0;
  final double _maxPanelWidth = 800.0;
  
  bool _isHoveringLeftHandle = false;
  bool _isHoveringRightHandle = false;
  
  // Track expansion state for categories
  final Map<String, bool> _expandedCategories = {
    "Atoms": false,
    "Molecules": false,
    "Organisms": false,
    "Pages": false,
    "Assets": false,
  };

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (componentRegistry.isNotEmpty) {
      selectedComponent = componentRegistry.first;
      currentProps = Map.from(selectedComponent!.defaultProps);
      _updateControllers();
    }

    if (kIsWeb) {
      html.document.onFullscreenChange.listen((event) {
        if (html.document.fullscreenElement == null && mounted) {
          setState(() {
            _isFullScreen = false;
          });
        }
      });
    }
  }

  void _toggleFullScreen(bool value) {
    setState(() {
      _isFullScreen = value;
      isMobile = false; // Always desktop for true fullscreen
    });

    if (kIsWeb) {
      if (value) {
        html.document.documentElement?.requestFullscreen();
      } else {
        if (html.document.fullscreenElement != null) {
          html.document.exitFullscreen();
        }
      }
    }
  }

  void _updateControllers() {
    // Clear existing if needed, or just update
    _controllers.forEach((key, controller) => controller.dispose());
    _controllers.clear();
    
    currentProps.forEach((key, value) {
      if (value is String) {
        _controllers[key] = TextEditingController(text: value);
      } else if (value is double || value is int) {
        _controllers[key] = TextEditingController(
          text: value is double ? value.toStringAsFixed(2) : value.toString(),
        );
      }
    });
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isFullScreen) {
      return Scaffold(
        backgroundColor: const Color(0xFFF0F9FF),
        body: Stack(
          children: [
            _preview(),
            Positioned(
              top: 20,
              right: 20,
              child: Opacity(
                opacity: 0.2, // Subtle so it doesn't distract
                child: MouseRegion(
                  onEnter: (_) => setState(() {}), // Trigger hover if needed
                  child: IconButton(
                    icon: const Icon(Icons.close_fullscreen, color: Color(0xFF1E1E4C), size: 30),
                    onPressed: () => _toggleFullScreen(false),
                    tooltip: "Exit Full Screen",
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: Container(
        color: const Color(0xFFF0F9FF), // Modern subtle sky blue background
        child: Column(
          children: [
            _header(),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double totalWidth = constraints.maxWidth;
                  const double minPreviewWidth = 400.0;
                  
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Sidebar
                      if (!_isFullScreen)
                        SizedBox(
                          width: _sidebarWidth,
                          child: _sidebar(),
                        ),
                      // Resize Handle (Left)
                      if (!_isFullScreen)
                        _verticalResizeHandle(
                          isHovering: _isHoveringLeftHandle,
                          onHoverChanged: (val) => setState(() => _isHoveringLeftHandle = val),
                          onDrag: (delta) {
                            setState(() {
                              double newWidth = (_sidebarWidth + delta).clamp(_minPanelWidth, _maxPanelWidth);
                              // Ensure preview doesn't shrink below 400
                              if (totalWidth - newWidth - _propertiesWidth >= minPreviewWidth) {
                                _sidebarWidth = newWidth;
                              }
                            });
                          },
                        ),
                      // Preview
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border(
                              left: BorderSide(color: Colors.black.withOpacity(0.05), width: _isFullScreen ? 0 : 1),
                              right: BorderSide(color: Colors.black.withOpacity(0.05), width: _isFullScreen ? 0 : 1),
                            ),
                          ),
                          child: _preview(),
                        ),
                      ),
                      // Resize Handle (Right)
                      if (!_isFullScreen)
                        _verticalResizeHandle(
                          isHovering: _isHoveringRightHandle,
                          onHoverChanged: (val) => setState(() => _isHoveringRightHandle = val),
                          onDrag: (delta) {
                            setState(() {
                              double newWidth = (_propertiesWidth - delta).clamp(_minPanelWidth, _maxPanelWidth);
                              // Ensure preview doesn't shrink below 400
                              if (totalWidth - _sidebarWidth - newWidth >= minPreviewWidth) {
                                _propertiesWidth = newWidth;
                              }
                            });
                          },
                        ),
                      // Properties
                      if (!_isFullScreen)
                        SizedBox(
                          width: _propertiesWidth,
                          child: _properties(),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================= UTILS & HELPERS ================= (resizeable sidebar handle)
  
  Widget _verticalResizeHandle({
    required bool isHovering,
    required ValueChanged<bool> onHoverChanged,
    required ValueChanged<double> onDrag,
  }) {
    return MouseRegion(
      cursor: SystemMouseCursors.resizeLeftRight,
      onEnter: (_) => onHoverChanged(true),
      onExit: (_) => onHoverChanged(false),
      child: GestureDetector(
        onHorizontalDragUpdate: (details) => onDrag(details.delta.dx),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isHovering ? 12 : 6,
          decoration: BoxDecoration(
            color: isHovering 
                ? const Color(0xFF1E1E4C).withOpacity(0.1) 
                : Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Visual Line
              Container(
                width: 2,
                color: isHovering 
                    ? const Color(0xFF1E1E4C).withOpacity(0.3) 
                    : Colors.black.withOpacity(0.05),
              ),
              // Drag Icon (Dots)
              if (isHovering)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) => Container(
                    width: 3,
                    height: 3,
                    margin: const EdgeInsets.symmetric(vertical: 2),
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 30, 43, 76),
                      shape: BoxShape.circle,
                    ),
                  )),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // ================= HEADER =================

  Widget _header() {
    return Container(
      height: 70, // Increased back to 70 for better proportion with larger bars
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF1E1E4C), // Dark HDFC Blue
      ),
      child: Row(
        children: [
          Image.asset('assets/hdfc_logo.png', height: 36,), // Scaled up slightly
          const SizedBox(width: 40),
          const VerticalDivider(color: Colors.white24, indent: 18, endIndent: 18),
          const SizedBox(width: 40),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Design System Playground  ",
                  style: const TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TextSpan(
                //   text: "NETBANKING - GLASS - ATOMIC",
                //   style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 14),
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ================= SIDEBAR =================

  Widget _sidebar() {
    return Container(
      color: const Color.fromARGB(255, 208, 236, 255), //color for sidebar
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                "COMPONENTS",
                style: const TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                onChanged: (val) {
                  setState(() {
                    _searchQuery = val.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  hintText: "Search components...",
                  hintStyle: const TextStyle(color: Colors.black26, fontSize: 14),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF1E1E4C), size: 20),
                  suffixIcon: _searchQuery.isNotEmpty 
                      ? IconButton(
                          icon: const Icon(Icons.close, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {
                              _searchQuery = "";
                            });
                          },
                        ) 
                      : null,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            
            // Inline or after Search Suggestions dialogue
            if (_searchQuery.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxHeight: 300),
                    child: ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      children: componentRegistry
                          .where((c) => c.name.toLowerCase().contains(_searchQuery))
                          .map((c) => ListTile(
                                dense: true,
                                title: Text(
                                  c.name,
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 33, 179),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  c.category,
                                  style: const TextStyle(fontSize: 11, color: Colors.black45),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedComponent = c;
                                    currentProps = Map.from(c.defaultProps);
                                    _updateControllers();
                                    _refreshCounter++;
                                    _searchQuery = "";
                                    _searchController.clear();
                                    _expandedCategories[c.category] = true;
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _categoryGlassContainer("Pages"),
            _categoryGlassContainer("Atoms"),
            _categoryGlassContainer("Molecules"),
            _categoryGlassContainer("Organisms"),
            _categoryGlassContainer("Assets"),
          ],
        ),
      ),
    );
  }

  Widget _categoryGlassContainer(String category) {
    return _category(category);
  }

  Widget _category(String category) {
    final items = componentRegistry
        .where((c) => c.category == category && c.name.toLowerCase().contains(_searchQuery))
        .toList();
    
    // Auto-expand if searching and there are matches
    final bool isSearching = _searchQuery.isNotEmpty;
    final bool isExpanded = isSearching ? items.isNotEmpty : (_expandedCategories[category] ?? false);

    if (isSearching && items.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 182, 205, 225), // Distinct shade for categories
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _expandedCategories[category] = !isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text(
                      category,
                      style: const TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: Colors.black45,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Column(
              children: [
                if (items.isEmpty && !isSearching)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      "No components",
                      style: const TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                  )
                else
                  ...items.map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        dense: true,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          c.name,
                          style: TextStyle(
                            color: selectedComponent?.name == c.name ? const Color.fromARGB(255, 0, 33, 179) : Colors.black87, //selected items in the sidebar
                            fontSize: 14,
                            fontWeight: selectedComponent?.name == c.name ? FontWeight.w600 : FontWeight.normal,
                          ),
                        ),
                        selected: selectedComponent?.name == c.name,
                        selectedTileColor: const Color(0xFFBAE6FD), // Distinct blue for selected
                        onTap: () {
                          setState(() {
                            selectedComponent = c;
                            currentProps = Map.from(c.defaultProps);
                            _updateControllers();
                            _refreshCounter++;
                          });
                        },
                      ),
                    ),
                  ),
                const SizedBox(height: 12),
              ],
            ),
            crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  // ================= PREVIEW ================= (canvas)

  Widget _preview() {
    return Padding(
      padding: _isFullScreen ? EdgeInsets.zero : const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Component Name and Category (Hidden in full screen)
          if (!_isFullScreen)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        selectedComponent?.name ?? "Select Component",
                        style: const TextStyle(
                          color: Color(0xFF1E1E4C),
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        selectedComponent?.category ?? "",
                        style: const TextStyle(
                          color: Colors.black45,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                // Desktop/Mobile/Full Screen Toggle Row
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 178, 230, 254),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Row(
                    children: [
                      _deviceIcon(Icons.desktop_windows, !_isFullScreen, () {
                        _toggleFullScreen(false);
                      }),
                      _deviceIcon(Icons.fullscreen, _isFullScreen, () {
                        _toggleFullScreen(true);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          if (!_isFullScreen) const SizedBox(height: 32),
          Expanded(
            child: selectedComponent == null
                ? const Center(child: Text("Select Component to Preview"))
                : _isFullScreen
                    ? Container(
                        color: const Color.fromARGB(255, 193, 230, 255),
                        child: selectedComponent!.name == 'NetBankingLoginPage'
                            ? selectedComponent!.builder(currentProps, isFullScreen: true)
                            : Center(
                                child: Transform.scale(
                                  scale: _getComponentScale(),
                                  child: selectedComponent!.builder(currentProps, isFullScreen: false),
                                ),
                              ),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          // Constant "Common Screen" size (7:5 aspect ratio)
                          const double designWidth = 1440.0;
                          const double designHeight = 900.0;
                          
                          return Center(
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 193, 230, 255),
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 30,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: designWidth,
                                    height: designHeight,
                                    child: Center(
                                      key: ValueKey(_refreshCounter),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20), // Standard padding for components on the common screen
                                        child: Center(
                                          child: Transform.scale(
                                            scale: _getComponentScale(),
                                            child: selectedComponent!.builder(currentProps, isFullScreen: false),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  double _getComponentScale() {
    if (selectedComponent == null) return 1.0;
    final name = selectedComponent!.name;
    if (name == 'NetBankingLoginPage') return 1.0;

    final lowerName = name.toLowerCase();
    if (lowerName.contains('text') ||
        lowerName.contains('checkbox') ||
        lowerName.contains('toggle') ||
        lowerName.contains('switch') ||
        lowerName.contains('field')) {
      return 1.5;
    }

    return 1.2;
  }

  Widget _deviceIcon(IconData icon, bool isActive, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white.withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isActive ? const Color(0xFF1E1E4C) : Colors.black38,
          size: 26,
        ),
      ),
    );
  }

  // ================= PROPERTIES =================

  Widget _properties() {
    if (selectedComponent == null) return const SizedBox();

    return Container(
      color: const Color(0xFFE0F2FE), // Deeper bluish tint for properties
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "PROPERTIES",
                  style: const TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                    letterSpacing: 1.5,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.code_rounded, color: Colors.black, size: 22),
                      onPressed: () => _showCodePreview(),
                      tooltip: "View Component Code",
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.black, size: 22),
                      onPressed: () {
                        setState(() {
                          currentProps = Map.from(selectedComponent!.defaultProps);
                          _updateControllers();
                          _refreshCounter++;
                        });
                      },
                      tooltip: "Reset Properties",
                    ),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Render all properties dynamically
          ...currentProps.entries.map((entry) {
            final key = entry.key;
            final value = entry.value;

            if (value is bool) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyBoolInput(_capitalize(key), key),
              );
            } else if (value is double || value is int) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyNumericInput(_capitalize(key), key),
              );
            } else if (value is Color) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyColorInput(_capitalize(key), key),
              );
            } else if (value is String) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyTextInput(_capitalize(key), key),
              );
            } else if (value is FontWeight) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyFontWeightInput(_capitalize(key), key),
              );
            } else if (key.toLowerCase().contains("variant") || 
                       key.toLowerCase().contains("size") || 
                       key.toLowerCase().contains("style") ||
                       key.toLowerCase().contains("align")) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _propertyEnumInput(_capitalize(key), key),
              );
            }
            return const SizedBox();
          }),

          const SizedBox(height: 16),
          _propertyGroup(
            title: "Component Info",
            children: [
              _infoRow("Name", selectedComponent?.name ?? ""),
              _infoRow("Category", selectedComponent?.category ?? ""),
              _infoRow("Props", currentProps.length.toString()),
            ],
          ),
        ],
      ),
    ),
  );
}

  String _capitalize(String s) => s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Widget _propertyGroup({required String title, required List<Widget> children}) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      opacity: 0.05,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _propertyBoolInput(String label, String key) {
    return SwitchListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label, style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
      value: currentProps[key] ?? false,
      onChanged: (val) => setState(() => currentProps[key] = val),
      activeThumbColor: const Color(0xFF1E1E4C),
    );
  }

  Widget _propertyTextInput(String label, String key) {
    bool disabled = currentProps["disabled"] ?? false;
    final controller = _controllers[key];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        TextField(
          enabled: !disabled,
          style: TextStyle(
            color: disabled ? Colors.black26 : Colors.black87,
            fontSize: 16,
          ),
          controller: controller,
          onChanged: (val) => setState(() => currentProps[key] = val),
          decoration: _inputDecoration(),
        ),
      ],
    );
  }

  Widget _propertyNumericInput(String label, String key) {
    bool disabled = currentProps["disabled"] ?? false;
    final value = (currentProps[key] ?? 0.0).toDouble();
    final controller = _controllers[key];
    
    // Determine bounds and properties based on key name
    double min = 0;
    double max = 1000;
    int decimals = 0;
    
    final lowerKey = key.toLowerCase();
    if (lowerKey.contains("opacity")) {
      max = 1.0;
      decimals = 2;
    } else if (lowerKey.contains("blur")) {
      max = 50.0;
      decimals = 1;
    } else if (lowerKey.contains("radius")) {
      max = 100.0;
    } else if (lowerKey.contains("fontsize")) {
      min = 8.0;
      max = 120.0;
    } else if (lowerKey.contains("width") || lowerKey.contains("height")) {
      max = 1200.0;
      // Atoms usually don't need 1200px height, 400px is plenty and prevents UI breakage
      if (lowerKey.contains("height") && selectedComponent?.category == 'Atoms') {
        max = 400.0;
      }
    } else if (lowerKey.contains("length")) {
      min = 1.0;
      max = 100.0;
      decimals = 0;
    } else if (lowerKey.contains("offset")) {
      min = -1200.0;
      max = 1200.0;
    } else if (lowerKey.contains("scale") || lowerKey.contains("size")) {
      min = 0.0;
      max = 10.0;
      decimals = 2;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
            SizedBox(
              width: 60,
              height: 24,
              child: TextField(
                enabled: !disabled,
                controller: controller,
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: (val) {
                  final parsedValue = double.tryParse(val);
                  if (parsedValue != null) {
                    setState(() {
                      currentProps[key] = parsedValue.clamp(min, max);
                    });
                  }
                },
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 2,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: disabled ? null : (val) {
              setState(() {
                currentProps[key] = val;
                if (controller != null) {
                  controller.text = decimals > 0 ? val.toStringAsFixed(decimals) : val.toInt().toString();
                }
              });
            },
            activeColor: const Color(0xFF1E1E4C),
            inactiveColor: Colors.black12,
          ),
        ),
      ],
    );
  }

  Widget _propertyColorInput(String label, String key) {
    final Color currentColor = currentProps[key] ?? Colors.white;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
            Text(
              '#${currentColor.value.toRadixString(16).substring(2).toUpperCase()}',
              style: const TextStyle(color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _AdvancedColorPicker(
          color: currentColor,
          onChanged: (newColor) {
            setState(() {
              currentProps[key] = newColor;
            });
          },
        ),
      ],
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: const TextStyle(color: Colors.black, fontSize: 14))),
          Text(value, style: const TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration() {
    return InputDecoration(
      isDense: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.black38),
      ),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }


  void _showCodePreview() {
    if (selectedComponent == null) return;

    final String code = _generateCodeString();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFFF0F9FF),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            const Icon(Icons.code_rounded, color: Color(0xFF1E1E4C)),
            const SizedBox(width: 12),
            Text(
              "${selectedComponent!.name} Code",
              style: const TextStyle(color: Color(0xFF1E1E4C), fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
        content: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withOpacity(0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Copy and use this code in your Flutter app:",
                  style: const TextStyle(color: Colors.black54, fontSize: 13, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SelectableText(
                    code,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF1E1E4C),
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close", style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold)),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: code));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Code copied to clipboard!"),
                  behavior: SnackBarBehavior.floating,
                  width: 300,
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.copy_rounded, size: 18),
            label: const Text("Copy Code"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E1E4C),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  String _generateCodeString() {
    final name = selectedComponent!.name;
    final buffer = StringBuffer();
    
    // Class name formatting
    String className = name.replaceAll(' ', '');
    
    buffer.writeln('$className(');
    
    currentProps.forEach((key, value) {
      buffer.write('  $key: ');
      if (value is String) {
        buffer.writeln("'$value',");
      } else if (value is Color) {
        String colorHex = value.value.toRadixString(16).toUpperCase().padLeft(8, '0');
        buffer.writeln('Color(0x$colorHex),');
      } else if (value is FontWeight) {
        buffer.writeln('$value,');
      } else if (value is Offset) {
        buffer.writeln('Offset(${value.dx}, ${value.dy}),');
      } else {
        buffer.writeln('$value,');
      }
    });
    
    buffer.write(')');
    return buffer.toString();
  }

  Widget _propertyEnumInput(String label, String key) {
    List<String> options = selectedComponent?.options?[key] ?? [];
    
    if (options.isEmpty) {
      final lowerKey = key.toLowerCase();
      if (lowerKey.contains("variant")) {
        options = ["Default", "H1", "H2", "Body"];
      } else if (lowerKey.contains("size")) {
        options = ["Small", "Medium", "Large"];
      } else if (lowerKey.contains("style")) {
        options = ["Glass", "Primary"];
      } else if (lowerKey.contains("align")) {
        options = ["left", "center", "right"];
      }
    }
    
    if (options.isEmpty) return const SizedBox();

    final String currentValue = currentProps[key]?.toString() ?? options.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: options.contains(currentValue) ? currentValue : options.first,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54, size: 20),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              items: options.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: const TextStyle()),
                );
              }).toList(),
              onChanged: (val) {
                if (val != null) {
                  setState(() {
                    currentProps[key] = val;
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _propertyFontWeightInput(String label, String key) {
    final FontWeight currentWeight = currentProps[key] ?? FontWeight.normal;
    final List<FontWeight> weights = [
      FontWeight.w100, FontWeight.w200, FontWeight.w300, FontWeight.w400,
      FontWeight.w500, FontWeight.w600, FontWeight.w700, FontWeight.w800, FontWeight.w900,
    ];
    
    String weightName(FontWeight w) {
      if (w == FontWeight.w100) return "Thin (100)";
      if (w == FontWeight.w200) return "ExtraLight (200)";
      if (w == FontWeight.w300) return "Light (300)";
      if (w == FontWeight.w400) return "Regular (400)";
      if (w == FontWeight.w500) return "Medium (500)";
      if (w == FontWeight.w600) return "SemiBold (600)";
      if (w == FontWeight.w700) return "Bold (700)";
      if (w == FontWeight.w800) return "ExtraBold (800)";
      if (w == FontWeight.w900) return "Black (900)";
      return "Weight";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<FontWeight>(
              value: currentWeight,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.black54, size: 20),
              style: const TextStyle(color: Colors.black, fontSize: 14),
              items: weights.map((w) => DropdownMenuItem(
                value: w,
                child: Text(weightName(w), style: const TextStyle()),
              )).toList(),
              onChanged: (val) {
                if (val != null) setState(() => currentProps[key] = val);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _AdvancedColorPicker extends StatefulWidget {
  final Color color;
  final ValueChanged<Color> onChanged;

  const _AdvancedColorPicker({required this.color, required this.onChanged});

  @override
  State<_AdvancedColorPicker> createState() => _AdvancedColorPickerState();
}

class _AdvancedColorPickerState extends State<_AdvancedColorPicker> {
  late double h, s, v;

  @override
  void initState() {
    super.initState();
    _updateHSV();
  }

  @override
  void didUpdateWidget(_AdvancedColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.color != widget.color) {
      _updateHSV();
    }
  }

  void _updateHSV() {
    final hsv = HSVColor.fromColor(widget.color);
    h = hsv.hue;
    s = hsv.saturation;
    v = hsv.value;
  }

  void _onHSVChanged() {
    final newColor = HSVColor.fromAHSV(1.0, h, s, v).toColor();
    widget.onChanged(newColor);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // SV Selection Area
        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            const height = 150.0;
            
            return GestureDetector(
              onPanUpdate: (details) {
                final RenderBox box = context.findRenderObject() as RenderBox;
                final Offset localOffset = box.globalToLocal(details.globalPosition);
                setState(() {
                  s = (localOffset.dx / width).clamp(0.0, 1.0);
                  v = (1.0 - (localOffset.dy / height)).clamp(0.0, 1.0);
                  _onHSVChanged();
                });
              },
              child: Container(
                height: height,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: HSVColor.fromAHSV(1.0, h, 1.0, 1.0).toColor(),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [Colors.white, Colors.transparent],
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black, Colors.transparent],
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          left: s * width - 8,
                          top: (1.0 - v) * height - 8,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black26)],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        // Hue Slider
        Container(
          height: 12,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFFF0000),
                Color(0xFFFFFF00),
                Color(0xFF00FF00),
                Color(0xFF00FFFF),
                Color(0xFF0000FF),
                Color(0xFFFF00FF),
                Color(0xFFFF0000),
              ],
            ),
          ),
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 12,
              activeTrackColor: Colors.transparent,
              inactiveTrackColor: Colors.transparent,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8, elevation: 2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
            ),
            child: Slider(
              value: h,
              min: 0,
              max: 360,
              onChanged: (val) {
                setState(() {
                  h = val;
                  _onHSVChanged();
                });
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Hex and RGB Inputs
        Row(
          children: [
            // Hex Input
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("HEX", style: TextStyle(fontSize: 10, color: Colors.black54)),
                  const SizedBox(height: 4),
                  TextField(
                    key: ValueKey('hex_${widget.color.value}'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    controller: TextEditingController(
                      text: widget.color.value.toRadixString(16).substring(2).toUpperCase(),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      prefixText: '#',
                      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    onSubmitted: (val) {
                      String hex = val.replaceFirst('#', '');
                      if (hex.length == 6) {
                        final parsed = int.tryParse(hex, radix: 16);
                        if (parsed != null) {
                          widget.onChanged(Color(parsed).withOpacity(1.0));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // RGB Inputs
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  _colorComponentInput("R", widget.color.red, (val) {
                    widget.onChanged(widget.color.withRed(val));
                  }),
                  const SizedBox(width: 6),
                  _colorComponentInput("G", widget.color.green, (val) {
                    widget.onChanged(widget.color.withGreen(val));
                  }),
                  const SizedBox(width: 6),
                  _colorComponentInput("B", widget.color.blue, (val) {
                    widget.onChanged(widget.color.withBlue(val));
                  }),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _colorComponentInput(String label, int value, ValueChanged<int> onChanged) {
    return Expanded(
      child: Column(
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.black54)),
          const SizedBox(height: 4),
          TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            key: ValueKey('${label}_$value'),
            controller: TextEditingController(text: value.toString()),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
            ),
            onSubmitted: (val) {
              final parsed = int.tryParse(val);
              if (parsed != null) {
                onChanged(parsed.clamp(0, 255));
              }
            },
          ),
        ],
      ),
    );
  }
}



