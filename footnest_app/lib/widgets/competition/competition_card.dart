import 'package:flutter/material.dart';
import '/models/competition/competition.dart';

class CompetitionCard extends StatefulWidget {

  final Competition competition;
  final VoidCallback? onTap;

    const CompetitionCard({
    super.key,
    required this.competition,
    this.onTap
  });

  @override
  State<CompetitionCard> createState() => _CompetitionCardState();

}

class _CompetitionCardState extends State<CompetitionCard> {

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
          elevation: hovered ? 8 : 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: hovered
                  ? Theme.of(context).colorScheme.primary
                  : Colors.transparent,
              width: 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: widget.competition.logoPath != null
                      ? Image.network(
                          widget.competition.logoPath!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(
                              Icons.emoji_events,
                              size: 35,
                            );
                          },
                        )
                      : const Icon(
                          Icons.emoji_events,
                          size: 35,
                        ),
                ),
              ),
              title: Text(
                widget.competition.name,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium,

              ),
              subtitle: Text(
                widget.competition.type,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium,
              ),

              trailing: Icon(
                Icons.chevron_right,
                color: Theme.of(context)
                    .colorScheme
                    .primary,
              ),
              hoverColor: Colors.transparent,
              onTap: widget.onTap,
            ),
          ),
        )
      )
    );
  }

}