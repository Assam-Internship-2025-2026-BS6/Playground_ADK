import 'package:flutter/material.dart';
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
                      SizedBox(width: _sidebarWidth, child: _sidebar()),
                      // Resize Handle (Left)
                      _verticalResizeHandle(
                        isHovering: _isHoveringLeftHandle,
                        onHoverChanged: (val) =>
                            setState(() => _isHoveringLeftHandle = val),
                        onDrag: (delta) {
                          setState(() {
                            double newWidth = (_sidebarWidth + delta).clamp(
                              _minPanelWidth,
                              _maxPanelWidth,
                            );
                            // Ensure preview doesn't shrink below 400
                            if (totalWidth - newWidth - _propertiesWidth >=
                                minPreviewWidth) {
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
                              left: BorderSide(
                                color: Colors.black.withValues(alpha: 0.05),
                                width: 1,
                              ),
                              right: BorderSide(
                                color: Colors.black.withValues(alpha: 0.05),
                                width: 1,
                              ),
                            ),
                          ),
                          child: _preview(),
                        ),
                      ),
                      // Resize Handle (Right)
                      _verticalResizeHandle(
                        isHovering: _isHoveringRightHandle,
                        onHoverChanged: (val) =>
                            setState(() => _isHoveringRightHandle = val),
                        onDrag: (delta) {
                          setState(() {
                            double newWidth = (_propertiesWidth - delta).clamp(
                              _minPanelWidth,
                              _maxPanelWidth,
                            );
                            // Ensure preview doesn't shrink below 400
                            if (totalWidth - _sidebarWidth - newWidth >=
                                minPreviewWidth) {
                              _propertiesWidth = newWidth;
                            }
                          });
                        },
                      ),
                      // Properties
                      SizedBox(width: _propertiesWidth, child: _properties()),
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

  // ================= UTILS & HELPERS =================

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
                ? const Color(0xFF1E1E4C).withValues(alpha: 0.1)
                : Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Visual Line
              Container(
                width: 1,
                color: isHovering
                    ? const Color(0xFF1E1E4C).withValues(alpha: 0.3)
                    : Colors.black.withValues(alpha: 0.05),
              ),
              // Drag Icon (Dots)
              if (isHovering)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      width: 3,
                      height: 3,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1E1E4C),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
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
          Image.asset('assets/hdfc_logo.png', height: 36), // Scaled up slightly
          const SizedBox(width: 40),
          const VerticalDivider(
            color: Colors.white24,
            indent: 18,
            endIndent: 18,
          ),
          const SizedBox(width: 40),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Design System Playground  ",
                  style: TextStyle(
                    color: Color(0xFF00FFC2),
                    fontSize: 22, // Increased from 20
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // TextSpan(
                //   text: "NETBANKING - GLASS - ATOMIC",
                //   style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 14),
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
      color: const Color.fromARGB(
        255,
        208,
        236,
        255,
      ), // Deeper bluish tint for sidebar
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
              child: Text(
                "COMPONENTS",
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Search Bar
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
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
                  hintStyle: const TextStyle(
                    color: Colors.black26,
                    fontSize: 14,
                  ),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Color(0xFF1E1E4C),
                    size: 20,
                  ),
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

            // Inline Search Suggestions
            if (_searchQuery.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
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
                          .where(
                            (c) => c.name.toLowerCase().contains(_searchQuery),
                          )
                          .map(
                            (c) => ListTile(
                              dense: true,
                              title: Text(
                                c.name,
                                style: const TextStyle(
                                  color: Color(0xFF1E1E4C),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              subtitle: Text(
                                c.category,
                                style: const TextStyle(fontSize: 12),
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
                            ),
                          )
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
        .where(
          (c) =>
              c.category == category &&
              c.name.toLowerCase().contains(_searchQuery),
        )
        .toList();

    // Auto-expand if searching and there are matches
    final bool isSearching = _searchQuery.isNotEmpty;
    final bool isExpanded = isSearching
        ? items.isNotEmpty
        : (_expandedCategories[category] ?? false);

    if (isSearching && items.isEmpty) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: const Color.fromARGB(
          255,
          182,
          205,
          225,
        ), // Distinct shade for categories
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () =>
                setState(() => _expandedCategories[category] = !isExpanded),
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
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
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
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Text(
                      "No components",
                      style: TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                  )
                else
                  ...items.map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 0,
                        ),
                        dense: true,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        title: Text(
                          c.name,
                          style: TextStyle(
                            color: selectedComponent?.name == c.name
                                ? const Color(0xFF1E1E4C)
                                : Colors.black87,
                            fontSize: 16,
                            fontWeight: selectedComponent?.name == c.name
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        selected: selectedComponent?.name == c.name,
                        selectedTileColor: const Color(
                          0xFFBAE6FD,
                        ), // Distinct blue for selected
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
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 250),
          ),
        ],
      ),
    );
  }

  // ================= PREVIEW =================

  Widget _preview() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Component Name and Category
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedComponent?.name ?? "Select Component",
                    style: const TextStyle(
                      color: Color(0xFF1E1E4C),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    selectedComponent?.category ?? "",
                    style: const TextStyle(
                      color: Colors.black45,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Desktop/Mobile Toggle in Styled Container
              Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 178, 230, 254),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(6),
                child: Row(
                  children: [
                    _deviceIcon(
                      Icons.desktop_windows,
                      !isMobile,
                      () => setState(() => isMobile = false),
                    ),
                    _deviceIcon(
                      Icons.phone_iphone,
                      isMobile,
                      () => setState(() => isMobile = true),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // Component Preview
          Expanded(
            child: GlassContainer(
              padding: EdgeInsets.zero,
              opacity: 0.05,
              borderRadius: BorderRadius.circular(24),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Center(
                  child: selectedComponent == null
                      ? const Text(
                          "Select Component to Preview",
                          style: TextStyle(color: Colors.black38),
                        )
                      : LayoutBuilder(
                          builder: (context, constraints) {
                            final isPage =
                                selectedComponent?.category == 'Pages';
                            final double targetWidth = isPage || !isMobile
                                ? constraints.maxWidth
                                : 375.0;
                            final double targetHeight = isPage || !isMobile
                                ? constraints.maxHeight
                                : 812.0;

                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeInOutCubic,
                              width: targetWidth,
                              height: targetHeight,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(
                                  255,
                                  193,
                                  230,
                                  255,
                                ), // Bluish tint for preview
                                borderRadius: isMobile && !isPage
                                    ? BorderRadius.circular(40)
                                    : BorderRadius.circular(24),
                                border: Border.all(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  width: isMobile && !isPage ? 2 : 1,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: isMobile && !isPage
                                    ? BorderRadius.circular(32)
                                    : BorderRadius.circular(16),
                                child: Center(
                                  child: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      maxWidth: targetWidth,
                                      maxHeight: targetHeight,
                                    ),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            maxWidth: isMobile
                                                ? targetWidth
                                                : (selectedComponent
                                                              ?.category ==
                                                          'Pages'
                                                      ? 1300
                                                      : (selectedComponent
                                                                    ?.category ==
                                                                'Organisms'
                                                            ? 800
                                                            : 600)),
                                            maxHeight: isMobile
                                                ? targetHeight
                                                : (selectedComponent
                                                              ?.category ==
                                                          'Pages'
                                                      ? 800
                                                      : (selectedComponent
                                                                    ?.category ==
                                                                'Organisms'
                                                            ? 800
                                                            : 500)),
                                            minHeight: 0,
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: isPage
                                                  ? EdgeInsets.zero
                                                  : (isMobile
                                                        ? const EdgeInsets.symmetric(
                                                            horizontal: 20,
                                                            vertical: 40,
                                                          )
                                                        : const EdgeInsets.all(
                                                            40,
                                                          )),
                                              child: Center(
                                                key: ValueKey(_refreshCounter),
                                                child: selectedComponent!
                                                    .builder(currentProps),
                                              ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _deviceIcon(IconData icon, bool isActive, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? Colors.white.withValues(alpha: 0.3)
              : Colors.transparent,
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
                const Text(
                  "PROPERTIES",
                  style: TextStyle(
                    color: Colors.black, // Changed from black54
                    fontWeight: FontWeight.bold, // More emphasis
                    fontSize: 16,
                    letterSpacing: 1.2,
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.code_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                      onPressed: () => _showCodePreview(),
                      tooltip: "View Component Code",
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.refresh_rounded,
                        color: Colors.black,
                        size: 22,
                      ),
                      onPressed: () {
                        setState(() {
                          currentProps = Map.from(
                            selectedComponent!.defaultProps,
                          );
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

  String _capitalize(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);

  Widget _propertyGroup({
    required String title,
    required List<Widget> children,
  }) {
    return GlassContainer(
      padding: const EdgeInsets.all(16),
      opacity: 0.05,
      borderRadius: BorderRadius.circular(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ), // Changed from white70
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
      title: Text(
        label,
        style: const TextStyle(color: Colors.black, fontSize: 18),
      ), // Changed from black87
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
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 12)),
        const SizedBox(height: 8),
        TextField(
          enabled: !disabled,
          style: TextStyle(
            color: disabled ? Colors.black26 : Colors.black87,
            fontSize: 18,
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
      if (lowerKey.contains("height") &&
          selectedComponent?.category == 'Atoms') {
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
            Expanded(
              child: Text(
                label,
                style: const TextStyle(color: Colors.black, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(
              width: 60,
              height: 24,
              child: TextField(
                enabled: !disabled,
                controller: controller,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
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
            onChanged: disabled
                ? null
                : (val) {
                    setState(() {
                      currentProps[key] = val;
                      if (controller != null) {
                        controller.text = decimals > 0
                            ? val.toStringAsFixed(decimals)
                            : val.toInt().toString();
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
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              '#${currentColor.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontFamily: 'monospace',
              ),
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
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.black, fontSize: 15),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ), // Changed from black87
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

  Widget _propertyFontWeightInput(String label, String key) {
    final FontWeight currentWeight = currentProps[key] ?? FontWeight.normal;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.black, fontSize: 15)),
        const SizedBox(height: 8),
        Row(
          children: [
            _weightOption(
              "Normal",
              FontWeight.normal,
              currentWeight == FontWeight.normal,
              key,
            ),
            const SizedBox(width: 8),
            _weightOption(
              "Bold",
              FontWeight.bold,
              currentWeight == FontWeight.bold,
              key,
            ),
          ],
        ),
      ],
    );
  }

  Widget _weightOption(
    String label,
    FontWeight weight,
    bool isSelected,
    String key,
  ) {
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => currentProps[key] = weight),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF1E1E4C) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? const Color(0xFF1E1E4C) : Colors.black12,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
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
              style: const TextStyle(
                color: Color(0xFF1E1E4C),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Container(
          width: 600,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
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
                const Text(
                  "Copy and use this code in your Flutter app:",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
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
                      fontFamily: 'monospace',
                      fontSize: 14,
                      color: Color(0xFF1E1E4C),
                      height: 1.5,
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
            child: const Text(
              "Close",
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
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
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
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
        String colorHex = value.toARGB32()
            .toRadixString(16)
            .toUpperCase()
            .padLeft(8, '0');
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
                final Offset localOffset = box.globalToLocal(
                  details.globalPosition,
                );
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
                              boxShadow: const [
                                BoxShadow(blurRadius: 4, color: Colors.black26),
                              ],
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
              thumbShape: const RoundSliderThumbShape(
                enabledThumbRadius: 8,
                elevation: 2,
              ),
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
                  const Text(
                    "HEX",
                    style: TextStyle(fontSize: 10, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  TextField(
                    key: ValueKey('hex_${widget.color.toARGB32()}'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'monospace',
                    ),
                    controller: TextEditingController(
                      text: widget.color.toARGB32()
                          .toRadixString(16)
                          .substring(2)
                          .toUpperCase(),
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      prefixText: '#',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 8,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onSubmitted: (val) {
                      String hex = val.replaceFirst('#', '');
                      if (hex.length == 6) {
                        final parsed = int.tryParse(hex, radix: 16);
                        if (parsed != null) {
                          widget.onChanged(
                            Color(parsed).withValues(alpha: 1.0),
                          );
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
                  _colorComponentInput("R", (widget.color.r * 255.0).round().clamp(0, 255), (val) {
                    widget.onChanged(widget.color.withRed(val));
                  }),
                  const SizedBox(width: 6),
                  _colorComponentInput("G", (widget.color.g * 255.0).round().clamp(0, 255), (val) {
                    widget.onChanged(widget.color.withGreen(val));
                  }),
                  const SizedBox(width: 6),
                  _colorComponentInput("B", (widget.color.b * 255.0).round().clamp(0, 255), (val) {
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

  Widget _colorComponentInput(
    String label,
    int value,
    ValueChanged<int> onChanged,
  ) {
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.black54),
          ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
              ),
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
