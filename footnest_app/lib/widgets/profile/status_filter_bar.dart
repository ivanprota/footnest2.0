import 'package:flutter/material.dart';

class StatusFilterBar extends StatelessWidget {

  final String selected;
  final ValueChanged<String> onChanged;

  const StatusFilterBar({
  super.key,
  required this.selected,
  required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {

    final filters = [
      ("ALL", "Tutti", Colors.blue),
      ("OPEN", "Aperti", Colors.orange),
      ("WON", "Vinti", Colors.green),
      ("LOST", "Persi", Colors.red),
    ];

    return Row(
      children: filters.map((filter) {
        final active = selected == filter.$1;

      return Padding(
        padding: const EdgeInsets.only(right:10),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () {
              onChanged(filter.$1);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds:200),
              padding: const EdgeInsets.symmetric(
                horizontal:16,
                vertical:8,
              ),
              decoration: BoxDecoration(
                color: active
                    ? filter.$3.withOpacity(0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? filter.$3
                      : Colors.grey.withOpacity(0.3),
                  width: active ? 2 : 1,
                ),
              ),
              child: Text(
                filter.$2,
                style: TextStyle(
                  color:
                      active
                          ? filter.$3
                          : Colors.grey,
                  fontWeight:
                      active
                          ? FontWeight.bold
                          : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
      }).toList(),
    );
  }

}