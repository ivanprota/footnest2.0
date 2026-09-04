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
          mouseCursor: SystemMouseCursors.click,
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
                  width: 30,
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
                  width: 35,
                  child: Text(
                    "${widget.standing.played}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 35,
                  child: Text(
                    "${widget.standing.wins}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 35,
                  child: Text(
                    "${widget.standing.draws}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 35,
                  child: Text(
                    "${widget.standing.losses}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 40,
                  child: Text(
                    "${widget.standing.goalsFor}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 40,
                  child: Text(
                    "${widget.standing.goalsAgainst}",
                    textAlign: TextAlign.center,
                  ),
                ),

                SizedBox(
                  width: 60,
                  child: Text(
                    "${widget.standing.points}",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(
                  width: 130,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) {
                        final form = widget.standing.form;

                        final result =
                            index < form.length
                                ? form[index]
                                : "?";

                        return Padding(
                          padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
                          child: _FormIndicator(
                            result: result,
                          ),
                        );
                      },
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

class _FormIndicator extends StatelessWidget {

  final String result;

  const _FormIndicator({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {

    late Color color;

    switch (result.toUpperCase()) {
      case "V":
        color = Colors.green;
        break;

      case "S":
        color = Colors.red;
        break;

      case "P":
        color = Colors.amber;
        break;

      default:
        color = Colors.grey;
    }

    return Container(
      width: 22,
      height: 22,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(
        result.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}