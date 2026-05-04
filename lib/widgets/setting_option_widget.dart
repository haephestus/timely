import 'package:flutter/material.dart';

class SettingOptionWidget extends StatefulWidget {
  final String label;
  final List<Widget> options;
  const SettingOptionWidget({
    required this.label,
    required this.options,
    super.key,
  });

  @override
  State<SettingOptionWidget> createState() => _SettingOptionWidgetState();
}

class _SettingOptionWidgetState extends State<SettingOptionWidget> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Size size = MediaQuery.sizeOf(context);
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusGeometry.circular(18),
        ),
        clipBehavior: Clip.hardEdge,
        width: size.width * 0.95,
        child: ExpansionTile(
          collapsedBackgroundColor: cs.surface, // ← was Colors.white
          backgroundColor: cs.surface, // ← was Colors.white
          title: Text(widget.label),
          children: widget.options,
        ),
      ),
    );
  }
}

class SwitchSettingItem extends StatefulWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const SwitchSettingItem({
    required this.value,
    required this.onChanged,
    required this.label,
    super.key,
  });

  @override
  State<SwitchSettingItem> createState() => _SwitchSettingItemState();
}

class _SwitchSettingItemState extends State<SwitchSettingItem> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return SwitchListTile(
      activeThumbColor: cs.secondary,
      inactiveThumbColor: cs.secondary,
      inactiveTrackColor: cs.primary,
      title: Text(widget.label),
      value: widget.value,
      onChanged: widget.onChanged,
    );
  }
}

class ChoiceSettingItem extends StatefulWidget {
  final dynamic value;
  final String label;
  final List<dynamic> choices;
  final ValueChanged<dynamic> onSelected;
  const ChoiceSettingItem({
    required this.label,
    required this.value,
    required this.onSelected,
    required this.choices,
    super.key,
  });

  @override
  State<ChoiceSettingItem> createState() => _ChoiceSettingItemState();
}

class _ChoiceSettingItemState extends State<ChoiceSettingItem> {
  late dynamic _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 18, right: 20),
      child: Row(
        children: <Widget>[
          Text(widget.label, style: TextStyle(fontSize: 16)),
          Spacer(),
          Wrap(
            children: List<Widget>.generate(widget.choices.length, (int index) {
              return ChoiceChip(
                showCheckmark: false,
                selectedColor: Colors.red,
                disabledColor:
                    cs.surfaceContainerHighest, // ← was Colors.grey.shade400
                label: Text(
                  widget.choices[index].toString(),
                  style: TextStyle(
                    color: _selected == index
                        ? cs
                              .surface // ← text on selected chip
                        : cs.onSurface,
                  ),
                ),
                selected: _selected == index,
                onSelected: (bool selected) {
                  setState(() {
                    _selected = selected ? index : null;
                  });
                  widget.onSelected(index);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class DropDownSettingItem extends StatefulWidget {
  final List<DropdownMenuEntry<dynamic>> dropdownMenuEntries;
  final String label;
  final ValueChanged<dynamic> onSelected;
  final dynamic initialSelection;
  const DropDownSettingItem({
    required this.label,
    required this.onSelected,
    required this.initialSelection,
    required this.dropdownMenuEntries,
    super.key,
  });

  @override
  State<DropDownSettingItem> createState() => _DropDownSettingItemState();
}

class _DropDownSettingItemState extends State<DropDownSettingItem> {
  dynamic _selected;
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return Padding(
      padding: EdgeInsetsGeometry.only(left: 16, right: 16),
      child: Row(
        children: [
          Text(widget.label, style: TextStyle(fontSize: 16)),
          Spacer(),
          DropdownMenu(
            width: size.width * 0.4,
            dropdownMenuEntries: widget.dropdownMenuEntries,
            initialSelection: widget.initialSelection,
            onSelected: (value) => setState(() {
              _selected = value;
              widget.onSelected(value);
            }),
            inputDecorationTheme: InputDecorationTheme(
              isCollapsed: true,
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.transparent),
              ),
            ),
            menuStyle: MenuStyle(
              alignment: AlignmentGeometry.xy(-0.80, 0.5),
              maximumSize: WidgetStatePropertyAll(Size(128, 128)),
            ),
          ),
        ],
      ),
    );
  }
}

class ClickableSettingItem extends StatefulWidget {
  final String label;
  final VoidCallback onTapped;
  const ClickableSettingItem({
    super.key,
    required this.onTapped,
    required this.label,
  });

  @override
  State<ClickableSettingItem> createState() => _ClickableSettingItemState();
}

class _ClickableSettingItemState extends State<ClickableSettingItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTapped,
      child: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Row(
          children: [Text(widget.label, style: TextStyle(fontSize: 16))],
        ),
      ),
    );
  }
}
