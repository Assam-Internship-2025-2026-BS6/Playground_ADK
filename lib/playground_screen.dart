import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'utils/web_utils.dart';
import 'component_registry.dart';
import 'component_metadata.dart';
import 'generated_sources.dart';

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

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Track expansion state for categories
  final Map<String, bool> _expandedCategories = {
    "Atoms": false,
    "Molecules": false,
    "Organisms": false,
    "Pages": false,
  };

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    if (componentRegistry.isNotEmpty) {
      selectedComponent = componentRegistry.first;
      currentProps = Map.from(selectedComponent!.defaultProps);
      _ensureOffsetProps();
      _updateControllers();
    }

    if (kIsWeb) {
      WebUtils.onFullscreenChange.listen((event) {
        if (!WebUtils.isFullscreen && mounted) {
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
        WebUtils.requestFullscreen();
      } else {
        if (WebUtils.isFullscreen) {
          WebUtils.exitFullscreen();
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

  void _ensureOffsetProps() {
    if (selectedComponent == null) return;
    
    final targetAtoms = [
      'Text', 
      'Text Field', 
      'Button', 
      'Checkbox', 
      'Text Button', 
      'Image', 
      'Radio Button', 
      'Toggle Switch'
    ];
    
    if (targetAtoms.contains(selectedComponent!.name) ||
        selectedComponent!.category == 'Molecules') {
      if (!currentProps.containsKey('xOffset')) currentProps['xOffset'] = 0.0;
      if (!currentProps.containsKey('yOffset')) currentProps['yOffset'] = 0.0;
    }
  }

  @override
  void dispose() {
    _controllers.forEach((key, controller) => controller.dispose());
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildDesktopLayout(double totalWidth) {
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
            onHoverChanged: (val) =>
                setState(() => _isHoveringLeftHandle = val),
            onDrag: (delta) {
              setState(() {
                double newWidth = (_sidebarWidth + delta)
                    .clamp(_minPanelWidth, _maxPanelWidth);
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
                    width: _isFullScreen ? 0 : 1),
                right: BorderSide(
                    color: Colors.black.withValues(alpha: 0.05),
                    width: _isFullScreen ? 0 : 1),
              ),
            ),
            child: _preview(),
          ),
        ),
        // Resize Handle (Right)
        if (!_isFullScreen)
          _verticalResizeHandle(
            isHovering: _isHoveringRightHandle,
            onHoverChanged: (val) =>
                setState(() => _isHoveringRightHandle = val),
            onDrag: (delta) {
              setState(() {
                double newWidth = (_propertiesWidth - delta)
                    .clamp(_minPanelWidth, _maxPanelWidth);
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
                    icon: const Icon(Icons.close_fullscreen,
                        color: Color(0xFF1E1E4C), size: 30),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final isMobileLayout = screenWidth <= 1024;

        // 1. Mobile/Tablet Layout (Drawers for sidebar & properties)
        if (isMobileLayout) {
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: const Color(0xFF1E1E4C),
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                tooltip: 'Components',
              ),
              title: const Text(
                "Playground",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: const Icon(Icons.settings, color: Colors.white),
                  onPressed: () => _scaffoldKey.currentState?.openEndDrawer(),
                  tooltip: 'Properties',
                ),
              ],
            ),
            drawer: Drawer(child: _sidebar()),
            endDrawer: Drawer(child: _properties()),
            body: Container(
              color: const Color(0xFFF0F9FF),
              child: _preview(),
            ),
          );
        }

        // 2 & 3. Desktop Layout
        return Scaffold(
          body: Container(
            color: const Color(0xFFF0F9FF),
            child: Column(
              children: [
                _header(),
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, desktopConstraints) {
                      return _buildDesktopLayout(desktopConstraints.maxWidth);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

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
                width: 2,
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
      height: 60, // Increased back to 70 for better proportion with larger bars
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFF0F326A), // Dark HDFC Blue
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/hdfc_logo.png',
            height: 40,
          ), // Scaled up slightly
          const SizedBox(width: 40),
          const VerticalDivider(
              color: Colors.white24, indent: 18, endIndent: 18),
          const SizedBox(width: 40),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: "Design System Playground  ",
                  style: TextStyle(
                    color: Color.fromARGB(255, 255, 255, 255),
                    fontSize: 22,
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
      color: const Color.fromARGB(255, 208, 236, 255), //color for sidebar
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
                  hintStyle:
                      const TextStyle(color: Colors.black26, fontSize: 14),
                  prefixIcon: const Icon(Icons.search,
                      color: Color(0xFF1E1E4C), size: 20),
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
                          .where((c) =>
                              c.name.toLowerCase().contains(_searchQuery))
                          .map((c) => ListTile(
                                dense: true,
                                title: Text(
                                  _formatName(c.name),
                                  style: const TextStyle(
                                    color: Color.fromARGB(255, 0, 33, 179),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                subtitle: Text(
                                  c.category,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.black45),
                                ),
                                onTap: () {
                                  setState(() {
                                    selectedComponent = c;
                                    currentProps = Map.from(c.defaultProps);
                                    _ensureOffsetProps();
                                    _updateControllers();
                                    _refreshCounter++;
                                    _searchQuery = "";
                                    _searchController.clear();
                                    _expandedCategories[c.category] = true;
                                    if (_scaffoldKey.currentState?.isDrawerOpen == true) {
                                      _scaffoldKey.currentState?.closeDrawer();
                                    }
                                  });
                                },
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 24),
            _categoryGlassContainer("Atoms"),
            _categoryGlassContainer("Molecules"),
            _categoryGlassContainer("Organisms"),
            _categoryGlassContainer("Pages"),
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
        .where((c) =>
            c.category == category &&
            c.name.toLowerCase().contains(_searchQuery))
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
            255, 182, 205, 225), // Distinct shade for categories
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
                      style:
                          TextStyle(color: Colors.black38, fontSize: 12),
                    ),
                  )
                else
                  ...items.map(
                    (c) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 0),
                        dense: true,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        title: Text(
                          _formatName(c.name),
                          style: TextStyle(
                            color: selectedComponent?.name == c.name
                                ? const Color.fromARGB(255, 0, 33, 179)
                                : Colors
                                    .black87, //selected items in the sidebar
                            fontSize: 14,
                            fontWeight: selectedComponent?.name == c.name
                                ? FontWeight.w600
                                : FontWeight.normal,
                          ),
                        ),
                        selected: selectedComponent?.name == c.name,
                        selectedTileColor: const Color(
                            0xFFBAE6FD), // Distinct blue for selected
                        onTap: () {
                          setState(() {
                            selectedComponent = c;
                            currentProps = Map.from(c.defaultProps);
                            _ensureOffsetProps();
                            _updateControllers();
                            _refreshCounter++;
                            if (_scaffoldKey.currentState?.isDrawerOpen == true) {
                              _scaffoldKey.currentState?.closeDrawer();
                            }
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
                        selectedComponent != null ? _formatName(selectedComponent!.name) : "Select Component",
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
                    color: const Color.fromARGB(255, 233, 236, 237),
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
                : _isFullScreen && selectedComponent!.category == 'Pages'
                    ? _renderComponent(isFullScreen: true)
                    : Center(
                        child: FittedBox(
                          fit: BoxFit.contain,
                          child: _isFullScreen
                              ? Container(
                                  width: 1440,
                                  height: 1024,
                                  color:
                                      const Color.fromARGB(255, 247, 247, 251),
                                  child: selectedComponent!.name ==
                                          'NetBankingLoginPage'
                                      ? selectedComponent!.builder(currentProps,
                                          isFullScreen: true,
                                          onUpdate: () => setState(() {}))
                                      : Center(
                                          child: Transform.scale(
                                            scale: _getComponentScale(),
                                            child: _renderComponent(isFullScreen: false),
                                          ),
                                        ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 246, 247, 248),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.1),
                                        blurRadius: 30,
                                        offset: const Offset(0, 15),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: SizedBox(
                                      width: 1440,
                                      height: 1024,
                                      child: Center(
                                        key: ValueKey(_refreshCounter),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20),
                                          child: Center(
                                            child: Transform.scale(
                                              scale: _getComponentScale(),
                                              child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth: 1400 / _getComponentScale(),
                                                ),
                                                child: _renderComponent(isFullScreen: false),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _renderComponent({required bool isFullScreen}) {
    if (selectedComponent == null) return const SizedBox();

    Widget component = selectedComponent!.builder(
      currentProps,
      isFullScreen: isFullScreen,
      onUpdate: () => setState(() {}),
    );

    // Apply conditional offset for Molecules (except Dropdown)
    if (selectedComponent!.category == 'Molecules' &&
        selectedComponent!.name != 'Dropdown') {
      final x = (currentProps['xOffset'] as num?)?.toDouble() ?? 0.0;
      final y = (currentProps['yOffset'] as num?)?.toDouble() ?? 0.0;
      if (x != 0 || y != 0) {
        component = Transform.translate(
          offset: Offset(x, -y), // Negative y for up
          child: component,
        );
      }
    }

    return component;
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
          color: isActive ? Colors.white.withValues(alpha: 0.3) : Colors.transparent,
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
                      icon: const Icon(Icons.code_rounded,
                          color: Colors.black, size: 22),
                      onPressed: () => _showCodePreview(),
                      tooltip: "View Component Code",
                    ),
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded,
                          color: Colors.black, size: 22),
                      onPressed: () {
                        setState(() {
                          currentProps =
                              Map.from(selectedComponent!.defaultProps);
                          _ensureOffsetProps();
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

            // Render all properties dynamically, grouped by category
            ...() {
              final Map<String, List<Widget>> groups = {
                "Label Style": [],
                "Input Style": [],
                "Input Restrictions": [],
                "Text Customization": [],
                "Checkbox Customization": [],
                "Image & Appearance": [],
                "General Options": [],
              };
              final Set<String> processedKeys = {};

              Widget renderPropertyInput(String key, dynamic value) {
                final hasOptions =
                    selectedComponent?.options?.containsKey(key) ?? false;
                final isKnownEnum = key.toLowerCase().contains("variant") ||
                    key.toLowerCase().contains("style") ||
                    key.toLowerCase().contains("align");

                if ((hasOptions || isKnownEnum) &&
                    value is! double &&
                    value is! int) {
                  if (key.toLowerCase() == "size" ||
                      key.toLowerCase().contains("size")) {
                    final String displayLabel =
                        (selectedComponent?.name == 'Text' && key == 'size')
                            ? "Font Size"
                            : _formatName(key);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _propertySegmentedInput(displayLabel, key),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _propertyEnumInput(_formatName(key), key),
                  );
                }

                if (value is bool) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _propertyBoolInput(_formatName(key), key),
                  );
                } else if (value is List<String>) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _propertyListInput(_formatName(key), key),
                  );
                } else if (value is double || value is int) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _propertyNumericInput(_formatName(key), key),
                  );
                } else if (value is Color) {
                  return _presetBox(_formatName(key), key, null);
                } else if (value is String) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _propertyTextInput(_formatName(key), key),
                  );
                } else if (value is FontWeight) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _propertyFontWeightInput(_formatName(key), key),
                  );
                }
                return const SizedBox();
              }

              // 1. Group color and size presets into boxes
              final Map<String, Map<String, String>> unifiedGroups = {};
              for (var key in currentProps.keys) {
                if (key.startsWith('_')) continue;
                String prefix = key;
                String type = 'other';
                if (key.endsWith('Color') && currentProps[key] is Color) {
                  prefix = key.substring(0, key.length - 5);
                  type = 'color';
                } else if (key.endsWith('Size') &&
                    (currentProps[key] == 'Small' ||
                        currentProps[key] == 'Medium' ||
                        currentProps[key] == 'Large' ||
                        selectedComponent?.options?.containsKey(key) == true)) {
                  prefix = key.substring(0, key.length - 4);
                  type = 'size';
                } else if (key == 'color' && currentProps[key] is Color) {
                  prefix = 'component';
                  type = 'color';
                } else if (key == 'size' && currentProps[key] is String) {
                  prefix = 'component';
                  type = 'size';
                } else if (key.endsWith('Weight') && currentProps[key] is FontWeight) {
                  prefix = key.substring(0, key.length - 6);
                  type = 'weight';
                } else if (key.endsWith('Weight') && currentProps[key] is FontWeight) {
                  prefix = key.substring(0, key.length - 6);
                  type = 'weight';
                } else if (key.endsWith('Hint') && currentProps[key] is String) {
                  prefix = key.substring(0, key.length - 4);
                  type = 'hint';
                } else if (currentProps[key] is String &&
                    !key.endsWith('Size') &&
                    !key.endsWith('Weight') &&
                    !key.endsWith('Hint') &&
                    !key.endsWith('Color') &&
                    selectedComponent?.options?.containsKey(key) != true) {
                  if (key == 'buttonText') { prefix = 'button'; type = 'text'; }
                  else if (key == 'customerIdLabel') { prefix = 'customerId'; type = 'text'; }
                  else if (key == 'customerIdHint') { prefix = 'customerId'; type = 'hint'; }
                  else if (key == 'passwordLabel') { prefix = 'password'; type = 'text'; }
                  else if (key == 'qrText') { prefix = 'qrText'; type = 'text'; }
                  else if (key == 'qrSubtitle') { prefix = 'qrSubtitle'; type = 'text'; }
                  else if (key == 'title') { prefix = 'title'; type = 'text'; }
                  else if (key == 'subtitle') { prefix = 'subtitle'; type = 'text'; }
                  else if (key == 'label' && currentProps.containsKey('checkboxSize')) { prefix = 'checkbox'; type = 'text'; }
                  else if (key == 'text' && currentProps.containsKey('size')) { prefix = 'component'; type = 'text'; }
                }

                if (type != 'other') {
                  unifiedGroups.putIfAbsent(prefix, () => {});
                  unifiedGroups[prefix]![type] = key;
                }
              }

              // 2. Render preset boxes
              final Set<String> renderedPrefixes = {};
              unifiedGroups.forEach((prefix, types) {
                if (renderedPrefixes.contains(prefix)) return;

                // SPECIAL case for merging qrText and qrSubtitle
                if (prefix == 'qrText' || prefix == 'qrSubtitle') {
                  final qrTextTypes = unifiedGroups['qrText'];
                  final qrSubTypes = unifiedGroups['qrSubtitle'];
                  
                  if (qrTextTypes != null || qrSubTypes != null) {
                    renderedPrefixes.add('qrText');
                    renderedPrefixes.add('qrSubtitle');

                    final List<Widget> innerWidgets = [];

                    void addFields(Map<String, String>? t, String defaultTitle) {
                      if (t == null) return;
                      final cK = t['color'];
                      final sK = t['size'];
                      final txtK = t['text'];
                      final hK = t['hint'];
                      if (cK != null) processedKeys.add(cK);
                      if (sK != null) processedKeys.add(sK);
                      if (txtK != null) processedKeys.add(txtK);
                      if (hK != null) processedKeys.add(hK);

                      if (txtK == null && hK == null) {
                        innerWidgets.add(Text(defaultTitle, style: const TextStyle(color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold)));
                        innerWidgets.add(const SizedBox(height: 12));
                      }
                      if (txtK != null) {
                        innerWidgets.add(_propertyTextInput(_formatName(txtK), txtK));
                        if (cK != null || sK != null) innerWidgets.add(const SizedBox(height: 12));
                      }
                      if (hK != null) {
                        innerWidgets.add(_propertyTextInput(_formatName(hK), hK));
                        if (cK != null || sK != null) innerWidgets.add(const SizedBox(height: 12));
                      }
                      if (cK != null || sK != null) {
                        innerWidgets.add(Row(
                          children: [
                            if (cK != null) _colorPresetIconDropdown(cK),
                            if (cK != null && sK != null) const SizedBox(width: 12),
                            if (sK != null) _sizePresetIconDropdown(sK),
                          ]
                        ));
                      }
                    }

                    addFields(qrTextTypes, "QR Text");
                    if (qrTextTypes != null && qrSubTypes != null) {
                      innerWidgets.add(const SizedBox(height: 24));
                    }
                    addFields(qrSubTypes, "QR Subtitle");

                    groups["Text Customization"]!.add(
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black12, width: 1.5),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: innerWidgets,
                        ),
                      )
                    );
                  }
                  return;
                }

                final colorKey = types['color'];
                final sizeKey = types['size'];
                final textKey = types['text'];
                final hintKey = types['hint'];
                final weightKey = types['weight'];

                if (colorKey != null || sizeKey != null || textKey != null || hintKey != null || weightKey != null) {
                  if (colorKey != null) processedKeys.add(colorKey);
                  if (sizeKey != null) processedKeys.add(sizeKey);
                  if (textKey != null) processedKeys.add(textKey);
                  if (hintKey != null) processedKeys.add(hintKey);
                  if (weightKey != null) processedKeys.add(weightKey);

                  String title = prefix == 'component'
                      ? _formatName(selectedComponent!.name)
                      : _formatName(prefix);
                  if (title.isEmpty) title = "Customization";
                  if (!title.toLowerCase().contains("customization") &&
                      !title.toLowerCase().contains("text") &&
                      !title.toLowerCase().contains("checkbox") &&
                      textKey == null) {
                    title = "$title Customization";
                  }

                  // Determine group
                  String groupName = "General Options";
                  if (prefix.toLowerCase().contains('checkbox')) {
                    groupName = "Checkbox Customization";
                  } else if (prefix.toLowerCase().contains('title') ||
                      prefix.toLowerCase().contains('label') ||
                      prefix.toLowerCase().contains('text') ||
                      prefix.toLowerCase().contains('password') ||
                      prefix.toLowerCase().contains('customer') ||
                      prefix.toLowerCase().contains('button') ||
                      prefix == 'component' || prefix.toLowerCase().contains('qr')) {
                    if (selectedComponent?.name == 'Image' || selectedComponent?.name == 'Glass Card') {
                      groupName = "Image & Appearance";
                    } else {
                      groupName = "Text Customization";
                    }
                  }

                  groups[groupName]!
                      .add(_presetBox(title, colorKey, sizeKey, textKey: textKey, hintKey: hintKey, weightKey: weightKey));
                }
              });

              // 3. Render everything else
              for (var entry in currentProps.entries) {
                final key = entry.key;
                if (processedKeys.contains(key)) continue;

                if (key.startsWith('_')) {
                  continue; // Skip rendering dimensions in the UI
                }

                final lower = key.toLowerCase();
                String groupName = "General Options";
                if (lower.contains('checkbox')) {
                  groupName = "Checkbox Customization";
                } else if (lower.contains('restrict')) {
                  groupName = "Input Restrictions";
                } else if (lower.contains('label')) {
                  groupName = "Label Style";
                } else if (lower.contains('input') || lower.contains('hint')) {
                  groupName = "Input Style";
                } else if (lower.contains('text') ||
                    lower.contains('title') ||
                    lower.contains('subtitle') ||
                    lower.contains('font') ||
                    lower.contains('password')) {
                  groupName = "Text Customization";
                } else if (lower.contains('image') ||
                    lower.contains('qr') ||
                    lower.contains('path') ||
                    lower.contains('radius') ||
                    lower.contains('opacity')) {
                  groupName = "Image & Appearance";
                }

                groups[groupName]!.add(renderPropertyInput(key, entry.value));
              }

              List<Widget> finalWidgets = [];

              // Render ordered groups
              for (String groupName in [
                "Label Style",
                "Input Style",
                "Input Restrictions",
                "Text Customization",
                "Checkbox Customization",
                "Image & Appearance",
                "General Options"
              ]) {
                final entries = groups[groupName]!;
                if (entries.isNotEmpty) {
                  finalWidgets.add(Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _propertyGroup(
                      title: groupName,
                      children: entries,
                    ),
                  ));
                }
              }

              return finalWidgets;
            }(),

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

  String _formatName(String s) {
    if (s.isEmpty) return s;
    if (s == 'CustomerIDUserID') return 'Customer ID / User ID';
    final formatted = s.replaceAllMapped(RegExp(r'([a-z])([A-Z])'), (m) => '${m.group(1)} ${m.group(2)}');
    return formatted[0].toUpperCase() + formatted.substring(1);
  }

  Widget _propertyGroup(
      {required String title, required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
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
      title: Text(label,
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600)),
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
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.w600)),
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
    double max = 850;
    int decimals = 0;

    final lowerKey = key.toLowerCase();
    if (lowerKey.contains("opacity")) {
      max = 1.0;
      decimals = 2;
    } else if (lowerKey.contains("radius")) {
      max = 100.0;
    } else if (lowerKey.contains("fontsize")) {
      min = 8.0;
      max = 120.0;
    } else if (lowerKey.contains("width")) {
      final isOrganism = selectedComponent?.category == 'Organisms';

      min = isOrganism ? 434.0 : 191.0;

      if (selectedComponent?.name == 'Glass Card') {
        max = 1440.0;
      } else {
        max = selectedComponent?.name == 'TextField' ? 850.0 : 850.0;
      }
    } else if (lowerKey.contains("height")) {
      final isOrganism = selectedComponent?.category == 'Organisms';

      min = isOrganism ? 680.0 : 70.0;
      max = 830.0;
      if (selectedComponent?.name == 'Glass Card') {
        max = 830.0;
      } else if (selectedComponent?.category == 'Atoms') {
        max = 400.0;
      }
    } else if (lowerKey.contains("length")) {
      min = 1.0;
      max = 100.0;
      decimals = 0;
    } else if (lowerKey.contains("offset")) {
      final isImage = selectedComponent?.name == 'Image';
      final isText = selectedComponent?.name == 'Text';
      final isButton = selectedComponent?.name == 'Button';
      final isCheckbox = selectedComponent?.name == 'Checkbox';
      final isTextButton = selectedComponent?.name == 'Text Button';
      final isRadioButton = selectedComponent?.name == 'Radio Button';
      final isToggleSwitch = selectedComponent?.name == 'Toggle Switch';
      if (isImage) {
        if (lowerKey.contains("xoffset")) {
          min = -280.0;
          max = 280.0;
        } else if (lowerKey.contains("yoffset")) {
          min = -350.0;
          max = 350.0;
        }
      } else if (isText) {
        if (lowerKey.contains("xoffset")) {
          min = -600.0;
          max = 600.0;
        } else if (lowerKey.contains("yoffset")) {
          min = -600.0;
          max = 600.0;
        }
      } else if (isButton) {
        if (lowerKey.contains("xoffset")) {
          min = -750.0;
          max = 750.0;
        } else if (lowerKey.contains("yoffset")) {
          min = -650.0;
          max = 650.0;
        }
      } else if (isCheckbox) {
        if (lowerKey.contains("xoffset")) {
          min = -500.0;
          max = 500.0;
        } else if (lowerKey.contains("yoffset")) {
          min = -620.0;
          max = 620.0;
        }
      } else if (isTextButton) {
        if (lowerKey.contains("xoffset")) {
          min = -650.0;
          max = 650.0;
        } else if (lowerKey.contains("yoffset")) {
          min = -590.0;
          max = 590.0;
        }
      } else if (isRadioButton) {
        if (lowerKey.contains("xoffset")) {
          min = -770.0;
          max = 770.0;
        } else if (lowerKey.contains("yoffset")) {
          min = -770.0;
          max = 770.0;
        }
      } else if (isToggleSwitch) {
        if (lowerKey.contains("xoffset")) {
          min = -550.0;
          max = 450.0;
        } else if (lowerKey.contains("yoffset")) {
          min = -620.0;
          max = 620.0;
        }
      } else if (selectedComponent?.category == 'Molecules') {
        final name = selectedComponent?.name;
        final isQRorDigi = name == 'QR Login' || name == 'Digicart Security';
        final isInputField = name == 'Labeled Input Field' || name == 'Password Field';
        final isDropdown = name == 'Dropdown';
        
        if (lowerKey.contains("xoffset")) {
          if (isQRorDigi) {
            min = -346.0; max = 346.0;
          } else if (isInputField) {
            min = -120.0; max = 120.0;
          } else if (isDropdown) {
            min = -435.0; max = 435.0;
          } else {
            min = -750.0; max = 750.0;
          }
        } else if (lowerKey.contains("yoffset")) {
          if (isQRorDigi) {
            min = -355.0; max = 355.0;
          } else if (isInputField) {
            min = -285.0; max = 285.0;
          } else if (isDropdown) {
            min = -380.0; max = 380.0;
          } else {
            min = -650.0; max = 650.0;
          }
        }
      } else {
        min = -500.0;
        max = 500.0;
      }
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
                child: Text(label,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    overflow: TextOverflow.ellipsis)),
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
                    fontWeight: FontWeight.bold),
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

  Widget _presetBox(String title, String? colorKey, String? sizeKey, {String? textKey, String? hintKey, String? weightKey}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (textKey == null && hintKey == null) ...[
            Text(title,
                style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
          ],
          if (textKey != null) ...[
            _propertyTextInput(_formatName(textKey), textKey),
            if (colorKey != null || sizeKey != null || hintKey != null) const SizedBox(height: 12),
          ],
          if (hintKey != null) ...[
            _propertyTextInput(_formatName(hintKey), hintKey),
            if (colorKey != null || sizeKey != null) const SizedBox(height: 12),
          ],
          if (colorKey != null) ...[
            _colorPresetIconDropdown(colorKey),
            if (sizeKey != null) const SizedBox(height: 16),
          ],
          if (sizeKey != null) 
            _propertySegmentedInput("", sizeKey),
          if (weightKey != null) ...[
            const SizedBox(height: 12),
            _propertyFontWeightInput("Font Weight", weightKey),
          ],
        ],
      ),
    );
  }

  Widget _colorPresetIconDropdown(String key) {
    final currentColor = currentProps[key] as Color? ?? Colors.black;
    final palette = [
      const Color(0xFF1E1E4C), // Default HDFC Blue
      const Color(0xFF004C8F), // Added New Blue
      const Color(0xFF0B1F5E), // Darker Navy
      const Color(0xFF1E40AF), // Deep Blue
      const Color(0xFF3B82F6), // Bright primary Blue
      const Color(0xFFE5EDF4), // Light blue tint
      Colors.black,
      Colors.black87,
      Colors.grey.shade800,
      Colors.grey.shade500,
      Colors.grey.shade200,
      Colors.white,
      const Color(0xFFE11D48), // Rose Red / Danger
      const Color(0xFF16A34A), // Emerald Green / Success
      const Color(0xFFEA580C), // Orange / Warning
    ];
    return PopupMenuButton<Color>(
      tooltip: "Color preset",
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 40),
      onSelected: (color) => setState(() => currentProps[key] = color),
      itemBuilder: (context) => palette
          .map((color) => PopupMenuItem(
                value: color,
                child: Row(
                  children: [
                    Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.black12))),
                    const SizedBox(width: 12),
                    Text(
                        '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}',
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ))
          .toList(),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: currentColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black26, width: 1.5),
        ),
      ),
    );
  }

  Widget _sizePresetIconDropdown(String key) {
    final currentSize = currentProps[key] as String? ?? 'Medium';
    String displayObj = "H2"; // Default Medium
    if (currentSize == 'Small') displayObj = "H3";
    if (currentSize == 'Large') displayObj = "H1";

    const sizes = ["Small", "Medium", "Large"];
    return PopupMenuButton<String>(
      tooltip: "Font size preset",
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      offset: const Offset(0, 40),
      onSelected: (size) => setState(() => currentProps[key] = size),
      itemBuilder: (context) => sizes
          .map((size) => PopupMenuItem(
                value: size,
                child: Text(size,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
              ))
          .toList(),
      child: Container(
        width: 36,
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.black87, width: 1.5),
        ),
        child: Text(displayObj,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Text(label,
                  style: const TextStyle(color: Colors.black, fontSize: 14))),
          Text(value,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold)),
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

    final String usageCode = _generateCodeString();
    String implementationCode =
        GeneratedSources.implementationCode[selectedComponent!.name] ??
            "Implementation code not available for this component.";
            
    if (implementationCode == "Implementation code not available for this component.") {
      debugPrint('Source code mismatch: Could not find code for component "${selectedComponent!.name}"');
    }
    // Live sync properties into the source code view
    currentProps.forEach((key, value) {
      if (!key.startsWith('_')) {
        String valStr = value.toString();
        if (value is String) {
          valStr = "'$value'";
        } else if (value is Color) {
          valStr = "const Color(0x${value.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()})";
        } else if (value is Offset) {
          valStr = "const Offset(${value.dx}, ${value.dy})";
        }
        // Attempt to replace constructor defaults: this.property = defaultValue,
        implementationCode = implementationCode.replaceAllMapped(
            RegExp('this.$key' r'\s*=\s*[^,)]+([,)])'),
            (match) => 'this.$key = $valStr${match.group(1)}');
      }
    });

    showDialog(
      context: context,
      builder: (context) => DefaultTabController(
        length: 2,
        child: StatefulBuilder(builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: const Color(0xFFF0F9FF),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.code_rounded, color: Color(0xFF1E1E4C)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "${_formatName(selectedComponent!.name)} Code",
                        style: const TextStyle(
                            color: Color(0xFF1E1E4C),
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const TabBar(
                  labelColor: Color(0xFF1E1E4C),
                  unselectedLabelColor: Colors.black38,
                  indicatorColor: Color(0xFF1E1E4C),
                  indicatorWeight: 3,
                  tabs: [
                    Tab(text: "USAGE"),
                    Tab(text: "SOURCE CODE"),
                  ],
                ),
              ],
            ),
            content: Container(
              width: 800,
              height: 500,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
              ),
              child: TabBarView(
                children: [
                  // Tab 1: Usage
                  _codeContainer(usageCode, "Copy and use this code in your Flutter app:"),
                  // Tab 2: Implementation
                  _codeContainer(implementationCode, "The implementation code for this component:"),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Close",
                    style: TextStyle(
                        color: Colors.black54, fontWeight: FontWeight.bold)),
              ),
              Builder(builder: (context) {
                return ElevatedButton.icon(
                  onPressed: () {
                    final tabIndex = DefaultTabController.of(context).index;
                    final codeToCopy =
                        tabIndex == 0 ? usageCode : implementationCode;

                    Clipboard.setData(ClipboardData(text: codeToCopy));
                    ScaffoldMessenger.of(this.context).showSnackBar(
                      SnackBar(
                        content: Text(tabIndex == 0
                            ? "Usage code copied!"
                            : "Source code copied!"),
                        behavior: SnackBarBehavior.floating,
                        width: 300,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.copy_rounded, size: 18),
                  label: const Text("Copy Active Code"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF004C8F),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                );
              }),
            ],
          );
        }),
      ),
    );
  }

  Widget _codeContainer(String code, String description) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  code,
                  style: const TextStyle(
                    fontSize: 13,
                    fontFamily: 'monospace',
                    color: Color(0xFF1E1E4C),
                    height: 1.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _generateCodeString() {
    if (selectedComponent == null) return "No component selected";
    
    final name = selectedComponent!.name;
    final buffer = StringBuffer();

    // 1. Format class name (remove spaces)
    String className = name.replaceAll(' ', '');

    buffer.writeln('$className(');

    // 2. Prep properties (combine x/y offsets, filter internal)
    final Map<String, dynamic> props = Map.from(currentProps);
    
    // Combine xOffset/yOffset or offsetX/offsetY into 'offset'
    if (props.containsKey('xOffset') && props.containsKey('yOffset')) {
      final x = props.remove('xOffset') ?? 0.0;
      final y = props.remove('yOffset') ?? 0.0;
      props['offset'] = Offset(x.toDouble(), y.toDouble());
    } else if (props.containsKey('offsetX') && props.containsKey('offsetY')) {
      final x = props.remove('offsetX') ?? 0.0;
      final y = props.remove('offsetY') ?? 0.0;
      props['offset'] = Offset(x.toDouble(), y.toDouble());
    }

    // 3. Generate properties code
    props.forEach((key, value) {
      // Skip internal props starting with '_'
      if (key.startsWith('_')) return;

      buffer.write('  $key: ');

      final options = selectedComponent!.options?[key];
      final lowerKey = key.toLowerCase();

      // Handle Enum-like string options
      if (options != null && value is String && (lowerKey.contains('variant') || lowerKey.contains('style') || lowerKey.contains('size') || lowerKey.contains('type'))) {
        // Heuristic: ComponentName + CapitalizedKey + Variant
        // For CustomButton -> ButtonSizeVariant.medium
        String enumPrefix = className;
        if (enumPrefix.startsWith('Custom') && enumPrefix.length > 6) {
          enumPrefix = enumPrefix.substring(6);
        }
        String enumType = '$enumPrefix${_formatName(key)}Variant';
        buffer.writeln('$enumType.${value.toLowerCase()},');
      } 
      else if (value is String) {
        buffer.writeln("'$value',");
      } 
      else if (value is Color) {
        String colorHex = value.toARGB32().toRadixString(16).toUpperCase().padLeft(8, '0');
        buffer.writeln('const Color(0x$colorHex),');
      } 
      else if (value is FontWeight) {
        buffer.writeln('$value,');
      } 
      else if (value is Offset) {
        buffer.writeln('const Offset(${value.dx}, ${value.dy}),');
      }
      else if (value is List) {
        buffer.write('[ ');
        buffer.write(value.map((e) => e is String ? "'$e'" : e.toString()).join(', '));
        buffer.writeln(' ],');
      }
      else {
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
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
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
              value:
                  options.contains(currentValue) ? currentValue : options.first,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.black54, size: 20),
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

  Widget _propertySegmentedInput(String label, String key) {
    List<String> options = selectedComponent?.options?[key] ?? [];
    if (options.isEmpty) {
      options = ["Small", "Medium", "Large"];
    }

    final String currentValue = currentProps[key]?.toString() ?? options.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label.isNotEmpty) ...[
          Text(label,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
        ],
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.black12),
          ),
          child: Row(
            children: options.map((option) {
              final isSelected = currentValue == option;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() {
                    currentProps[key] = option;
                    _refreshCounter++;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? const Color(0xFF1E1E4C) : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      option,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _propertyFontWeightInput(String label, String key) {
    final FontWeight currentWeight = currentProps[key] ?? FontWeight.normal;
    final bool isBold = currentWeight == FontWeight.bold || currentWeight == FontWeight.w700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Row(
          children: [
            GestureDetector(
              onTap: () => setState(() {
                currentProps[key] = isBold ? FontWeight.normal : FontWeight.bold;
              }),
              child: Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isBold ? const Color(0xFF1E1E4C) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isBold ? const Color(0xFF1E1E4C) : Colors.black12,
                    width: 1.5,
                  ),
                  boxShadow: [
                    if (isBold)
                      BoxShadow(
                        color: const Color(0xFF1E1E4C).withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Text(
                  "B",
                  style: TextStyle(
                    color: isBold ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              isBold ? "Bold" : "Normal",
              style: const TextStyle(
                color: Colors.black54,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _propertyListInput(String label, String key) {
    final List<String> items = List<String>.from(currentProps[key] ?? []);
    final controller =
        _controllers[key] ?? TextEditingController(text: items.join(', '));
    if (!_controllers.containsKey(key)) _controllers[key] = controller;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: const TextStyle(fontSize: 14),
          decoration: _inputDecoration().copyWith(
            hintText: "Item 1, Item 2, Item 3",
            helperText: "Separate items with commas",
            helperStyle: const TextStyle(fontSize: 10),
          ),
          onChanged: (val) {
            setState(() {
              currentProps[key] = val
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList();
            });
          },
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
  bool _isInteracting = false;

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

  void _updateColorFromPosition(Offset localPosition, double width, double height) {
    setState(() {
      s = (localPosition.dx / width).clamp(0.0, 1.0);
      v = (1.0 - (localPosition.dy / height)).clamp(0.0, 1.0);
      _onHSVChanged();
    });
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

            return MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onPanStart: (details) {
                  setState(() => _isInteracting = true);
                  _updateColorFromPosition(details.localPosition, width, height);
                },
                onPanUpdate: (details) {
                  _updateColorFromPosition(details.localPosition, width, height);
                },
                onPanEnd: (_) => setState(() => _isInteracting = false),
                onPanCancel: () => setState(() => _isInteracting = false),
                onTapDown: (details) {
                  setState(() => _isInteracting = true);
                  _updateColorFromPosition(details.localPosition, width, height);
                },
                onTapUp: (_) => setState(() => _isInteracting = false),
                onTapCancel: () => setState(() => _isInteracting = false),
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
                          if (_isInteracting)
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
                                  BoxShadow(blurRadius: 4, color: Colors.black26)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
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
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 12,
                activeTrackColor: Colors.transparent,
                inactiveTrackColor: Colors.transparent,
                thumbShape: const RoundSliderThumbShape(
                    enabledThumbRadius: 8, elevation: 2),
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
                  const Text("HEX",
                      style: TextStyle(fontSize: 10, color: Colors.black54)),
                  const SizedBox(height: 4),
                  TextField(
                    key: ValueKey('hex_${widget.color.toARGB32()}'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.bold),
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
                          vertical: 8, horizontal: 8),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    onSubmitted: (val) {
                      String hex = val.replaceFirst('#', '');
                      if (hex.length == 6) {
                        final parsed = int.tryParse(hex, radix: 16);
                        if (parsed != null) {
                          widget.onChanged(Color(parsed).withValues(alpha: 1.0));
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
                  _colorComponentInput("R", (widget.color.r * 255).round().clamp(0, 255), (val) {
                    widget.onChanged(widget.color.withRed(val));
                  }),
                  const SizedBox(width: 6),
                  _colorComponentInput("G", (widget.color.g * 255).round().clamp(0, 255), (val) {
                    widget.onChanged(widget.color.withGreen(val));
                  }),
                  const SizedBox(width: 6),
                  _colorComponentInput("B", (widget.color.b * 255).round().clamp(0, 255), (val) {
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
      String label, int value, ValueChanged<int> onChanged) {
    return Expanded(
      child: Column(
        children: [
          Text(label,
              style: const TextStyle(fontSize: 10, color: Colors.black54)),
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(6)),
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
