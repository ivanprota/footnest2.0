import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MatchDayChip extends StatefulWidget {
  final DateTime date;
  final bool selected;
  final VoidCallback onTap;

  const MatchDayChip({
    super.key,
    required this.date,
    required this.selected,
    required this.onTap,
  });

  @override
  State<MatchDayChip> createState() => _MatchDayChipState();
}

class _MatchDayChipState extends State<MatchDayChip> {

  bool hovering = false;

  String get monthShort {
    const months = [
      "GEN",
      "FEB",
      "MAR",
      "APR",
      "MAG",
      "GIU",
      "LUG",
      "AGO",
      "SET",
      "OTT",
      "NOV",
      "DIC",
    ];
    return months[widget.date.month - 1];
  }

  bool get isToday {
    final now = DateTime.now();
    return widget.date.year == now.year &&
           widget.date.month == now.month &&
           widget.date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {

    final weekday =
        DateFormat("EEE", "it_IT")
            .format(widget.date);

    final day =
        widget.date.day.toString();

    return MouseRegion(

      onEnter: (_) {
        setState(() {
          hovering = true;
        });
      },

      onExit: (_) {
        setState(() {
          hovering = false;
        });
      },

      child: GestureDetector(

        onTap: widget.onTap,

        child: AnimatedContainer(

          duration:
              const Duration(milliseconds: 180),

          width: 68,
          height: 82,

          margin:
              const EdgeInsets.symmetric(
                horizontal: 4,
                vertical: 6,
              ),

          decoration: BoxDecoration(

            color: widget.selected
                ? Theme.of(context).colorScheme.primary
                : hovering
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : Colors.transparent,

            borderRadius:
                BorderRadius.circular(14),

            border: Border.all(
              color: widget.selected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.outline
            ),

            boxShadow: widget.selected
                ? [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : [],

          ),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              Text(
                monthShort,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: widget.selected
                      ? Colors.white70
                      : Colors.grey,
                ),
              ),

              const SizedBox(height: 2),

              Text(
                weekday.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: widget.selected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface
                ),
              ),

              const SizedBox(height: 2),

              if(isToday)
                Container(
                  margin:
                      const EdgeInsets.only(
                        bottom: 2,
                      ),
                  width: 5,
                  height: 5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        Theme.of(context)
                            .colorScheme
                            .primary,
                  ),
                ),

              Text(
                day,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: widget.selected
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.onSurface
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}