import 'package:flutter/material.dart';
import '/models/standing/standing.dart';

class StandingRow extends StatefulWidget {

  final Standing standing;
  final VoidCallback? onTap;

  const StandingRow({
    super.key,
    required this.standing,
    this.onTap,
  });

  @override
  State<StandingRow> createState() =>
      _StandingRowState();

}

class _StandingRowState extends State<StandingRow> {

  bool hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        transform: hovered
            ? Matrix4.translationValues(4, 0, 0)
            : Matrix4.identity(),
        decoration: BoxDecoration(
          color: hovered
              ? Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.08)
              : Colors.transparent,
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(8),
          onTap: widget.onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 6,
                ),
            child: Row(
              children: [

                SizedBox(
                  width: 35,
                  child: Text(
                    "${widget.standing.position}",
                  ),
                ),

                Expanded(
                  child: Row(
                    children: [

                      if(widget.standing.team.logoPath != null)
                        Image.network(
                          widget.standing.team.logoPath!,
                          width: 28,
                          height: 28,
                          fit: BoxFit.contain,
                        )
                      else
                        const Icon(
                          Icons.sports_soccer,
                          size: 28,
                        ),

                      const SizedBox(width: 10),

                      Text(
                        widget.standing.team.name,
                      ),

                    ],
                  ),
                ),

                SizedBox(
                  width: 40,
                  child: Text(
                    "${widget.standing.played}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 40,
                  child: Text(
                    "${widget.standing.wins}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 40,
                  child: Text(
                    "${widget.standing.draws}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 40,
                  child: Text(
                    "${widget.standing.losses}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 45,
                  child: Text(
                    "${widget.standing.goalsFor}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 45,
                  child: Text(
                    "${widget.standing.goalsAgainst}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 45,
                  child: Text(
                    "${widget.standing.points}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
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