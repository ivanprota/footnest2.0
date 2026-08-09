import 'package:flutter/material.dart';

class AppSidebar extends StatelessWidget {

  final int selectedIndex;
  final Function(int) onItemSelected;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    final items = const [

      (
        Icons.groups,
        "Squadre",
      ),

      (
        Icons.sports_soccer,
        "Partite",
      ),

      (
        Icons.emoji_events,
        "Competizioni",
      ),

      (
        Icons.tips_and_updates,
        "Pronostici",
      ),

      (
        Icons.people,
        "Utenti"
      ),

      (
        Icons.person,
        "Profilo",
      ),

    ];

    return Container(
      width: 220,
      color: const Color(0xff181B22),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 35,
          left: 12,
          right: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

          Center(
            child: Image.asset(
              "assets/logo.png",
              width: 380,
              fit: BoxFit.contain,
            ),
          ),

            const SizedBox(height: 45),

            ...items.asMap().entries.map((entry){
              final index = entry.key;
              final item = entry.value;

              return _SidebarItem(
                icon: item.$1,
                title: item.$2,
                selected: selectedIndex == index,
                onTap: () => onItemSelected(index),
              );
            }),

          ],
        ),
      ),
    );

  }

}




class _SidebarItem extends StatefulWidget {

  final IconData icon;
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  State createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {

  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },

      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },

      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,

        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),

          margin: const EdgeInsets.only(
            bottom: 8,
          ),

          decoration: BoxDecoration(
            color: widget.selected
                ? Theme.of(context)
                    .colorScheme
                    .primary
                    .withOpacity(0.18)
                : hovered
                    ? Colors.white.withOpacity(0.08)
                    : Colors.transparent,

            borderRadius:
                BorderRadius.circular(12),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),

            child: Row(
              children: [

                Icon(
                  widget.icon,
                  size: 23,
                  color: widget.selected
                      ? Theme.of(context)
                          .colorScheme
                          .primary
                      : Colors.white70,
                ),

                const SizedBox(width: 14),

                Text(
                  widget.title,
                  style: TextStyle(
                    color: widget.selected
                        ? Theme.of(context)
                            .colorScheme
                            .primary
                        : Colors.white70,

                    fontWeight: widget.selected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

}