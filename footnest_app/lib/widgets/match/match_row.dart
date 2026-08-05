import 'package:flutter/material.dart';

import '/models/match/match_summary.dart';
import '/config/api_config.dart';
import '/screens/matches/match_detail_screen.dart';

class MatchRow extends StatefulWidget {

  final MatchSummary match;
  final VoidCallback onRefresh;

  const MatchRow({
    super.key,
    required this.match,
    required this.onRefresh,
  });

  @override
  State<MatchRow> createState() => _MatchRowState();

}

class _MatchRowState extends State<MatchRow> {

  bool hovering = false;

  String logoUrl(String path) {
    if (path.startsWith("http")) return path;

    return "${ApiConfig.baseUrl}/uploads/$path";
  }

  bool get finished =>
      widget.match.homeGoals != -1 &&
      widget.match.awayGoals != -1;


  @override
  Widget build(BuildContext context) {
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
      child: InkWell(
        mouseCursor: SystemMouseCursors.click,
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => MatchDetailScreen(
                matchId: widget.match.id,
              ),
            ),
          );

          if(result == true) {
            widget.onRefresh();
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds:150),
          padding:
              const EdgeInsets.symmetric(
                horizontal:20,
                vertical:12,
              ),
          decoration: BoxDecoration(
            color: hovering
                ? Colors.grey.withOpacity(0.08)
                : Colors.transparent,
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.withOpacity(0.15),
              ),
            ),
          ),
          child: Row(
            children: [

              // CASA
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [

                    Flexible(
                      child: Text(
                        widget.match.homeTeam,
                        textAlign:
                            TextAlign.right,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                            ),
                      ),
                    ),

                    const SizedBox(width:10),

                    Image.network(
                      logoUrl(
                        widget.match.homeLogo,
                      ),
                      width:34,
                      height:34,
                      errorBuilder:
                      (_,__,___) =>
                          const Icon(
                            Icons.shield,
                            size:34,
                          ),
                    )

                  ],
                ),
              ),

              const SizedBox(width:20),

              // ORARIO / RISULTATO
              SizedBox(
                width:80,
                child: Column(
                  children: [

                    Text(
                      finished
                      ? "${widget.match.homeGoals} - ${widget.match.awayGoals}"
                      : widget.match.kickoffText,
                      style:
                      const TextStyle(
                        fontWeight:
                            FontWeight.bold,
                        fontSize:16,
                      ),
                    ),

                    if(!finished)
                      Text(
                        widget.match.status == "SCHEDULED"
                            ? "Programmato"
                            : widget.match.status,
                        style:
                        TextStyle(
                          fontSize:11,
                          color:
                          Colors.grey[600],
                        ),

                      )

                  ],
                ),
              ),

              const SizedBox(width:20),

              // TRASFERTA
              Expanded(
                child: Row(
                  children: [

                    Image.network(
                      logoUrl(
                        widget.match.awayLogo,
                      ),
                      width:34,
                      height:34,
                      errorBuilder:
                      (_,__,___)=>
                          const Icon(
                            Icons.shield,
                            size:34,
                          ),
                    ),

                    const SizedBox(width:10),

                    Flexible(
                      child: Text(
                        widget.match.awayTeam,
                        overflow:
                            TextOverflow.ellipsis,
                        style:
                            const TextStyle(
                              fontWeight:
                                  FontWeight.w500,
                            ),
                      ),
                    )

                  ],
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

}