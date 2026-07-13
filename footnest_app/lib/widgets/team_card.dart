import 'package:flutter/material.dart';
import '../models/team/team.dart';

class TeamCard extends StatefulWidget {

  final Team team;
  final VoidCallback? onTap;

  const TeamCard({
    super.key,
    required this.team,
    this.onTap,
  });

  @override
  State<TeamCard> createState() => _TeamCardState();

}

class _TeamCardState extends State<TeamCard> {

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
        duration: const Duration(milliseconds: 200),
        transform: hovered
          ? Matrix4.translationValues(0, -4, 0)
          : Matrix4.identity(),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: hovered
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
              width: 1
            )
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              leading: widget.team.logoPath != null
                  ? Image.network(
                      widget.team.logoPath!,
                      width: 60,
                      height: 60,
                      fit: BoxFit.contain,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return const Icon(
                          Icons.sports_soccer,
                          size: 40,
                        );
                      },
                    )
                  : const Icon(
                      Icons.sports_soccer,
                    ),
              title: Text(
                widget.team.name,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context).colorScheme.primary
              ),
              tileColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onTap: widget.onTap
            ),
          )
        )
      )
    );
  }

}