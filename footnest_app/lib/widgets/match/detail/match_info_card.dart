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

      padding:
        const EdgeInsets.all(20),


      decoration: BoxDecoration(

        color:
          theme.colorScheme.surface,


        borderRadius:
          BorderRadius.circular(24),


        border: Border.all(

          color:
            theme.colorScheme.outline
                .withOpacity(0.5),

        ),

      ),


      child: Column(

        crossAxisAlignment:
          CrossAxisAlignment.start,


        children: [


          const Text(

            "Informazioni partita",

            style:
              TextStyle(

                fontSize:20,

                fontWeight:
                  FontWeight.bold,

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


            editable:
              editing,

            onTap:
              onPickDate,

          ),




          const SizedBox(height:12),




          _infoRow(

            context,

            icon: Icons.access_time,

            title: "Orario",

            value:
              match.kickoffTime ??
              "Non impostato",


            editable:
              editing,

            onTap:
              onPickTime,

          ),



          const SizedBox(height:12),




          if(editing)

            DropdownButtonFormField<String>(

              value: selectedStatus,


              decoration:
                const InputDecoration(

                  labelText:
                    "Stato partita",

                  prefixIcon:
                    Icon(
                      Icons.flag,
                    ),

                ),


              items:

              const [

                "SCHEDULED",

                "PLAYED",

                "POSTPONED",

                "CANCELLED",

              ]

              .map(

                (status) =>

                  DropdownMenuItem(

                    value:
                      status,

                    child:
                      Text(status),

                  ),

              )

              .toList(),


              onChanged:
                onStatusChanged,

            )

          else

            _infoRow(

              context,

              icon:
                Icons.flag,


              title:
                "Stato",


              value:
                _statusLabel(match.status),


              editable:
                false,

            ),



        ],

      ),

    );

  }



  Widget _infoRow(
    BuildContext context, {

    required IconData icon,

    required String title,

    required String value,

    bool editable = false,

    VoidCallback? onTap,

  }) {


    return InkWell(

      borderRadius:
        BorderRadius.circular(16),


      onTap:
        editable
          ? onTap
          : null,


      child: Container(

        padding:
          const EdgeInsets.all(14),


        decoration:
          BoxDecoration(

            color:
              Colors.black.withOpacity(0.08),

            borderRadius:
              BorderRadius.circular(16),

          ),


        child: Row(

          children: [


            Container(

              padding:
                const EdgeInsets.all(10),


              decoration:
                BoxDecoration(

                  color:
                    Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.15),


                  shape:
                    BoxShape.circle,

                ),


              child:
                Icon(

                  icon,

                  size:20,

                  color:
                    Theme.of(context)
                      .colorScheme
                      .primary,

                ),

            ),



            const SizedBox(width:15),



            Expanded(

              child: Column(

                crossAxisAlignment:
                  CrossAxisAlignment.start,


                children: [


                  Text(

                    title,

                    style:
                      TextStyle(

                        fontSize:12,

                        color:
                          Colors.grey[400],

                      ),

                  ),



                  const SizedBox(height:3),



                  Text(

                    value,

                    style:
                      const TextStyle(

                        fontSize:16,

                        fontWeight:
                          FontWeight.bold,

                      ),

                  ),

                ],

              ),

            ),



            if(editable)

              const Icon(

                Icons.edit,

                size:18,

              ),


          ],

        ),

      ),

    );

  }



  String _statusLabel(String status){

    switch(status){

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