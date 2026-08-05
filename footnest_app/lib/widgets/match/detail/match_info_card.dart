import 'package:flutter/material.dart';

import '/models/match/match_detail.dart';

class MatchInfoCard extends StatelessWidget {

  final MatchDetail match;
  final bool editing;
  final String? selectedStatus;

  final VoidCallback onPickDate;
  final VoidCallback onPickTime;
  final Function(String?) onStatusChanged;

  const MatchInfoCard({
    super.key,
    required this.match,
    required this.editing,
    required this.selectedStatus,
    required this.onPickDate,
    required this.onPickTime,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Informazioni partita",
            style: TextStyle(
                fontSize:20,
                fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height:20),

          _infoRow(
            context,
            icon: Icons.calendar_today,
            title: "Data",
            value:
              "${match.date.day.toString().padLeft(2,'0')}/"
              "${match.date.month.toString().padLeft(2,'0')}/"
              "${match.date.year}",
            editable: editing,
            onTap: onPickDate,
          ),

          const SizedBox(height:12),

          _infoRow(
            context,
            icon: Icons.access_time,
            title: "Orario",
            value: match.kickoffTime ?? "Non impostato",
            editable: editing,
            onTap: onPickTime,
          ),

          const SizedBox(height:12),

          if(editing)
            DropdownButtonFormField<String>(
              value: selectedStatus,
              mouseCursor: SystemMouseCursors.click,
              decoration: const InputDecoration(
                  labelText: "Stato partita",
                  prefixIcon: Icon(Icons.flag),
              ),
              items: const [
                "SCHEDULED",
                "PLAYED",
                "POSTPONED",
                "CANCELLED",
              ].map(
                (status) =>
                  DropdownMenuItem(
                    value: status,
                    child: Text(status),
                  ),
              ).toList(),
              onChanged:onStatusChanged,
            )
          else
            _infoRow(
              context,
              icon: Icons.flag,
              title: "Stato",
              value: _statusLabel(match.status),
              editable: false,
            ),

        ],

      ),
    );
  }

  Widget _infoRow(BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    bool editable = false,
    VoidCallback? onTap,
  }) 
  {
    return _HoverInfoRow(
      icon: icon,
      title: title,
      value: value,
      editable: editable,
      onTap: onTap,
    );
  }

  String _statusLabel(String status) {
    switch(status) {

      case "PLAYED":
        return "Terminata";

      case "SCHEDULED":
        return "Programmato";

      case "POSTPONED":
        return "Rinviata";

      case "CANCELLED":
        return "Annullata";

      default:
        return status;

    }
  }
}

class _HoverInfoRow extends StatefulWidget {

  final IconData icon;
  final String title;
  final String value;
  final bool editable;
  final VoidCallback? onTap;

  const _HoverInfoRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.editable,
    required this.onTap,
  });

  @override
  State<_HoverInfoRow> createState() => _HoverInfoRowState();

}

class _HoverInfoRowState extends State<_HoverInfoRow> {

  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: widget.editable
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onEnter: widget.editable
          ? (_) {
              setState(() {
                hovering = true;
              });
            }
          : null,
      onExit: widget.editable
          ? (_) {
              setState(() {
                hovering = false;
              });
            }
          : null,
      child: GestureDetector(
        onTap: widget.editable
            ? widget.onTap
            : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds:180),
          transform: hovering
              ? Matrix4.translationValues(0, -3, 0)
              : Matrix4.identity(),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: hovering
                ? Colors.black.withOpacity(0.12)
                : Colors.black.withOpacity(0.08),
            borderRadius: BorderRadius.circular(16),
            boxShadow: hovering
                ? [
                    BoxShadow(
                      color:
                          Colors.black.withOpacity(0.18),
                      blurRadius:10,
                      offset:
                          const Offset(0,3),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [

              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size:20,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),

              const SizedBox(width:15),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      widget.title,
                      style: TextStyle(
                        fontSize:12,
                        color: Colors.grey[400],
                      ),
                    ),

                    const SizedBox(height:3),

                    Text(
                      widget.value,
                      style: const TextStyle(
                        fontSize:16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  ],

                ),
              ),

              if(widget.editable)
                const Icon(
                  Icons.edit,
                  size:18,
                ),

            ],

          ),
        ),
      ),
    );
  }
}