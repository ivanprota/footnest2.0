import 'package:flutter/material.dart';

import '/widgets/match/match_day_chip.dart';

class MatchTimeline extends StatefulWidget {

  final DateTime selectedDate;
  final Function(DateTime) onDateSelected;

  const MatchTimeline({
    super.key,
    required this.selectedDate,
    required this.onDateSelected,
  });

  @override
  State<MatchTimeline> createState() =>
      _MatchTimelineState();

}

class _MatchTimelineState extends State<MatchTimeline> {

  late ScrollController controller;

  @override
  void initState() {
    super.initState();
    controller = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollToSelected();
    });
  }

  void scrollToSelected() {
    const itemWidth = 76.0;
    final index = 10;
    controller.animateTo(
      index * itemWidth,
      duration:
          const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  List<DateTime> get days {
    return List.generate(
      21,
      (index) {
        return widget.selectedDate.add(
          Duration(
            days: index - 10,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
            vertical: 12,
          ),
      decoration: BoxDecoration(
        color:
            Theme.of(context)
                .colorScheme
                .surface,
        borderRadius:
            BorderRadius.circular(18),
      ),
      child: Column(
        children: [

          // HEADER
          Padding(
            padding:
                const EdgeInsets.symmetric(
                  horizontal:16,
                ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Seleziona giornata",
                  style:
                      Theme.of(context)
                          .textTheme
                          .titleMedium,
                ),

                TextButton.icon(
                  onPressed: () {
                    widget.onDateSelected(
                      DateTime.now(),
                    );
                  },
                  icon:
                      const Icon(
                        Icons.today,
                      ),
                  label:
                      const Text(
                        "Oggi",
                      ),
                )

              ],
            ),
          ),

          const SizedBox(height:8),

          SizedBox(
            height:96,
            child: ListView.builder(
              controller: controller,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              scrollDirection:
                  Axis.horizontal,
              itemCount:
                  days.length,
              itemBuilder:
                  (context,index){
                    final day =
                        days[index];
                    return MatchDayChip(
                      date: day,
                      selected:
                          day.year ==
                              widget.selectedDate.year &&
                          day.month ==
                              widget.selectedDate.month &&
                          day.day ==
                              widget.selectedDate.day,
                      onTap: () {
                        widget.onDateSelected(
                          day,
                        );
                      },
                    );
              },
            ),
          )

        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}