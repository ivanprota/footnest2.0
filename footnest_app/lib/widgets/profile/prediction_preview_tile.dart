import 'package:flutter/material.dart';
import 'package:footnest_app/services/prediction_service.dart';
import 'package:footnest_app/services/service_locator.dart';
import '/services/profile_refresh_service.dart';

import '/models/prediction/prediction.dart';
import '/config/api_config.dart';

class PredictionPreviewTile extends StatefulWidget {

  final Prediction prediction;
  final VoidCallback? onTap;
  final VoidCallback? onRefresh;
  final bool readOnly;

  const PredictionPreviewTile({
    super.key,
    required this.prediction,
    this.onTap,
    this.onRefresh,
    this.readOnly = false,
  });

  @override
  State<PredictionPreviewTile> createState() => _PredictionPreviewTileState();

}

class _PredictionPreviewTileState extends State<PredictionPreviewTile> {

  bool hovered = false;

  Color getStatusColor(Prediction prediction) {
    if(!prediction.settled) {
      return Colors.orange;
    }

    return prediction.won
        ? Colors.green
        : Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final prediction = widget.prediction;
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds:180),
        margin: const EdgeInsets.only(bottom:10),
        decoration: BoxDecoration(
          color: hovered
              ? Colors.white.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: GestureDetector(
          onTap: widget.onTap, 
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Row(
                children: [

                  Column(
                    children: [

                      Image.network(
                        "${ApiConfig.baseUrl}/uploads/${prediction.competitionLogo}",
                        width:30,
                        height:30,
                        errorBuilder: (_,__,___)=>
                          const Icon(
                            Icons.emoji_events,
                            size:30,
                          ),
                        ),

                      const SizedBox(height:8),

                      if (!widget.readOnly)
                        PopupMenuButton<String>(
                          tooltip: "Modifica stato",
                          onSelected: (value) async {
                            final service = locator<PredictionService>();

                            if (value == "OPEN") {
                              await service.updateStatus(
                                prediction.id,
                                false,
                                null,
                              );
                            }

                            if (value == "WON") {
                              await service.updateStatus(
                                prediction.id,
                                true,
                                true,
                              );
                            }

                            if (value == "LOST") {
                              await service.updateStatus(
                                prediction.id,
                                true,
                                false,
                              );
                            }

                            widget.onRefresh?.call();
                            locator<ProfileRefreshService>().refresh();
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: "OPEN",
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: const SizedBox(
                                  width: double.infinity,
                                  child: Text("Segna aperto"),
                                ),
                              ),
                            ),

                            PopupMenuItem(
                              value: "WON",
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: const SizedBox(
                                  width: double.infinity,
                                  child: Text("Segna vinto"),
                                ),
                              ),
                            ),

                            PopupMenuItem(
                              value: "LOST",
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: const SizedBox(
                                  width: double.infinity,
                                  child: Text("Segna perso"),
                                ),
                              ),
                            ),
                          ],
                          child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: getStatusColor(prediction).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                prediction.status,
                                style: TextStyle(
                                  color: getStatusColor(prediction),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: getStatusColor(prediction).withOpacity(0.15),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            prediction.status,
                            style: TextStyle(
                              color: getStatusColor(prediction),
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),

                    ],
                  ),

                  // HOME TEAM
                  Expanded(
                    child: Column(
                      children: [

                        _TeamLogo(
                          url:prediction.homeLogo,
                        ),

                        const SizedBox(height:6),

                        Text(
                          prediction.homeTeam,
                          textAlign: TextAlign.center,
                        )

                      ],
                    ),
                  ),

                  SizedBox(
                    width: 450,

                    child: Column(
                      children: [

                        const Text(
                          "VS",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height:8),

                        Container(
                          width: double.infinity,

                          padding: const EdgeInsets.symmetric(
                            horizontal:10,
                            vertical:5,
                          ),

                          decoration: BoxDecoration(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.15),

                            borderRadius:
                                BorderRadius.circular(10),
                          ),

                          child: Text(
                            prediction.prediction,

                            maxLines: 1,

                            overflow: TextOverflow.ellipsis,

                            textAlign: TextAlign.center,

                            style: TextStyle(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        )

                      ],
                    ),
                  ),

                  Expanded(
                    child: Column(
                      children: [

                        _TeamLogo(
                          url: prediction.awayLogo,
                        ),

                        const SizedBox(height:6),

                        Text(
                          prediction.awayTeam,
                          textAlign: TextAlign.center,
                        )

                      ],
                    ),
                  ),

                  const SizedBox(width:20),

                  Column(
                    children: [

                      const Text(
                        "Quota",
                        style: TextStyle(
                          fontSize:12,
                        ),
                      ),

                      Text(
                        prediction.odd.toString(),
                        style: const TextStyle(
                          fontSize:18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height:8),

                      Text(
                        prediction.kickoffText,
                        style: const TextStyle(
                          fontSize:12,
                        ),
                      ),

                    ],
                  )

                ],
              ),
            ),
          ),
        )
      ),
    );
  }

}


class _TeamLogo extends StatelessWidget {

  final String url;

  const _TeamLogo({
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      "${ApiConfig.baseUrl}/uploads/$url",
      width:35,
      height:35,
      errorBuilder: (_,__,___) =>
        const Icon(
          Icons.shield,
          size:35,
        ),
    );
  }

}