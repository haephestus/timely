import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final List<NavItem> items;
  final VoidCallback? onAddChunk;
  final int? selectedIndex;
  final ValueChanged<int>? onItemSelected;
  final VoidCallback? onAddActivity;

  const Navbar({
    required this.items,
    this.onAddChunk,
    this.onAddActivity,
    this.onItemSelected,
    this.selectedIndex,
    super.key,
  });

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final containerWidth = size.width * 0.65 - 12;
    final selectedWidth = containerWidth * 0.55;
    final unselectedWidth =
        (containerWidth - selectedWidth) / (widget.items.length - 1);
    final buttonSize = size.height * 0.07;
    final expandedButtonHeight = buttonSize * 3.2;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      height: expandedButtonHeight + 16,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 10,
            right: 10,
            bottom: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: size.width * 0.65,
                  height: buttonSize,
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(96),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: widget.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      final isSelected = widget.selectedIndex == index;
                      return GestureDetector(
                        onTap: () => widget.onItemSelected?.call(index),
                        child: SizedBox(
                          width: isSelected
                              ? selectedWidth
                              : unselectedWidth, // WARN: width issue
                          height: size.height * 0.055,
                          child: NavItem(
                            icon: item.icon,
                            name: item.name,
                            selected: isSelected,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  width: buttonSize,
                  height: expandedButtonHeight,
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: AddButton(
                      onAddChunk: widget.onAddChunk,
                      onAddActivity: widget.onAddActivity,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class NavItem extends StatelessWidget {
  final IconData icon;
  final String? name;
  final bool selected;

  const NavItem({
    super.key,
    required this.icon,
    this.name,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      padding: EdgeInsets.symmetric(horizontal: selected ? 32 : 8, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(256),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: selected ? Colors.black : Colors.white,
            size: selected ? size.height * 0.04 : size.height * 0.03,
          ),
          if (selected && name != null) ...[
            const SizedBox(width: 2),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  name!,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? Colors.black : Colors.white,
                    fontSize: size.height * 0.0175,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class AddButton extends StatefulWidget {
  final VoidCallback? onAddChunk;
  final VoidCallback? onAddActivity;

  const AddButton({super.key, this.onAddChunk, this.onAddActivity});

  @override
  State<AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<AddButton>
    with SingleTickerProviderStateMixin {
  bool _isOpened = false;
  late final AnimationController _controller;
  late final Animation<double> _expand;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _expand = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpened) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    setState(() => _isOpened = !_isOpened);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final buttonSize = size.height * 0.065;
    final expandedHeight = buttonSize * 3.2;

    return AnimatedBuilder(
      animation: _expand,
      builder: (context, child) {
        final height =
            buttonSize + (expandedHeight - buttonSize) * _expand.value;
        final optionsHeight = expandedHeight - buttonSize;

        return SizedBox(
          width: buttonSize,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(buttonSize / 2),
            child: Container(
              color: Colors.black,
              child: Stack(
                children: [
                  // ── Options revealed as pill grows ──
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: optionsHeight,
                    child: Opacity(
                      opacity: _expand.value.clamp(0.0, 1.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _PillOption(
                            icon: Icons.view_day_rounded,
                            label: 'New Chunk',
                            opacity: ((_expand.value - 0.3) / 0.7).clamp(
                              0.0,
                              1.0,
                            ),
                            onTap: () {
                              _toggle();
                              widget.onAddChunk?.call();
                            },
                          ),
                          _PillOption(
                            icon: Icons.add_task_rounded,
                            label: 'New Activity',
                            opacity: ((_expand.value - 0.5) / 0.5).clamp(
                              0.0,
                              1.0,
                            ),
                            onTap: () {
                              _toggle();
                              widget.onAddActivity?.call();
                            },
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── FAB at bottom ──
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: buttonSize,
                    child: GestureDetector(
                      onTap: _toggle,
                      child: Center(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, anim) =>
                              RotationTransition(
                                turns: anim,
                                child: FadeTransition(
                                  opacity: anim,
                                  child: child,
                                ),
                              ),
                          child: Icon(
                            _isOpened ? Icons.close : Icons.add,
                            key: ValueKey(_isOpened),
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PillOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final double opacity;
  final VoidCallback? onTap;

  const _PillOption({
    required this.icon,
    required this.label,
    required this.opacity,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 32),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 6,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
