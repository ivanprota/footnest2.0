import 'package:flutter/material.dart';

import '/models/match/match_detail.dart';


class MatchScoreCard extends StatelessWidget {

  final MatchDetail match;

  final bool editing;

  final TextEditingController homeGoalsController;
  final TextEditingController awayGoalsController;


  const MatchScoreCard({
    super.key,
    required this.match,
    required this.editing,
    required this.homeGoalsController,
    required this.awayGoalsController,
  });


  bool get finished =>
      match.homeGoals != -1 &&
      match.awayGoals != -1;



  @override
  Widget build(BuildContext context) {

    final theme = Theme.of(context);


    return Container(

      width: double.infinity,

      padding:
        const EdgeInsets.symmetric(
          vertical:20,
          horizontal:30,
        ),


      decoration: BoxDecoration(

        color:
          finished
            ? Colors.green.withOpacity(0.12)
            : theme.colorScheme.primary
                .withOpacity(0.10),


        borderRadius:
          BorderRadius.circular(24),


        border: Border.all(

          color:
            finished
              ? Colors.green.withOpacity(0.4)
              : theme.colorScheme.outline
                  .withOpacity(0.5),

        ),

      ),



      child: Column(

        children: [


          Text(

            finished
              ? "RISULTATO FINALE"
              : "CALCIO D'INIZIO",

            style:
              TextStyle(

                fontSize:12,

                letterSpacing:1.2,

                fontWeight:
                  FontWeight.bold,

                color:
                  Colors.grey[400],

              ),

          ),



          const SizedBox(height:12),



          editing

            ? Row(

                mainAxisAlignment:
                  MainAxisAlignment.center,

                children: [


                  _goalField(
                    homeGoalsController,
                  ),


                  const Padding(

                    padding:
                      EdgeInsets.symmetric(
                        horizontal:15,
                      ),

                    child: Text(

                      "-",

                      style:
                        TextStyle(

                          fontSize:38,

                          fontWeight:
                            FontWeight.w900,

                        ),

                    ),

                  ),



                  _goalField(
                    awayGoalsController,
                  ),


                ],

              )


            : Text(

                finished

                  ? "${match.homeGoals} - ${match.awayGoals}"

                  : "-- : --",


                style:
                  const TextStyle(

                    fontSize:46,

                    fontWeight:
                      FontWeight.w900,

                  ),

              ),





          const SizedBox(height:12),




          Container(

            padding:
              const EdgeInsets.symmetric(
                horizontal:14,
                vertical:6,
              ),


            decoration:
              BoxDecoration(

                color:
                  finished

                    ? Colors.green
                        .withOpacity(0.2)

                    : Colors.orange
                        .withOpacity(0.2),


                borderRadius:
                  BorderRadius.circular(20),

              ),


            child: Text(

              finished
                ? "Terminata"
                : "Programmata",


              style:
                TextStyle(

                  fontWeight:
                    FontWeight.bold,

                  color:
                    finished
                      ? Colors.green
                      : Colors.orange,

                ),

            ),

          ),


        ],

      ),

    );

  }



  Widget _goalField(
      TextEditingController controller
  ){

    return Container(

      width:70,

      height:60,


      decoration:
        BoxDecoration(

          color:
            Colors.black.withOpacity(0.15),

          borderRadius:
            BorderRadius.circular(16),

        ),


      child: TextField(

        controller: controller,

        keyboardType:
          TextInputType.number,


        textAlign:
          TextAlign.center,


        style:
          const TextStyle(

            fontSize:32,

            fontWeight:
              FontWeight.bold,

          ),


        decoration:
          const InputDecoration(

            border:
              InputBorder.none,

          ),

      ),

    );

  }

}