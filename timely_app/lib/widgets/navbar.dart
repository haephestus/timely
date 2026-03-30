import 'package:flutter/material.dart';

class Navbar extends StatefulWidget {
  final List<NavItem> items;
  const Navbar({required this.items, super.key});

  @override
  State<Navbar> createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Positioned(
      left: 10,
      right: 10,
      bottom: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: size.width * 0.65,
            height: size.height * 0.09,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:
                  widget.items.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    final isSelected = _selectedIndex == index;
                    return Flexible(
                      flex: isSelected ? 2 : 1,
                      child: NavItem(
                        icon: item.icon,
                        name: item.name,
                        selected: isSelected,
                        onTap: () {
                          setState(() => _selectedIndex = index);
                          item.onTap?.call();
                        },
                      ),
                    );
                  }).toList(),
            ),
          ),
          SizedBox(
            width: size.height * 0.09,
            height: size.height * 0.09,
            child: FloatingActionButton(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              onPressed: () {},
              shape: const CircleBorder(),
              child: const Icon(Icons.add),
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
  final VoidCallback? onTap;

  const NavItem({
    super.key,
    required this.icon,
    this.name,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // width: size.width * 0.5,
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(
          horizontal: selected ? 32 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Padding(
          padding: EdgeInsetsGeometry.only(right: 8, left: 8),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected ? Colors.black : Colors.white,
                size: selected ? size.height * 0.05 : size.height * 0.04,
              ),
              if (selected && name != null) ...[
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    name!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: selected ? Colors.black : Colors.white,
                      fontSize: size.height * 0.02,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
