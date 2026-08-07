import 'package:flutter/material.dart';


class ProfileStatItem {

  final String label;

  final int value;


  const ProfileStatItem({

    required this.label,

    required this.value,

  });

}





class ProfileStatCard extends StatefulWidget {


  final String title;

  final IconData icon;

  final List<ProfileStatItem> items;



  const ProfileStatCard({

    super.key,

    required this.title,

    required this.icon,

    required this.items,

  });



  @override
  State<ProfileStatCard> createState() =>
      _ProfileStatCardState();


}





class _ProfileStatCardState
    extends State<ProfileStatCard> {


  bool hovered = false;



  Color getColor(String label) {


    switch(label.toLowerCase()) {

      case "vinte":

      case "vinti":

        return Colors.green;


      case "perse":

      case "persi":

        return Colors.red;


      case "aperte":

      case "aperti":

        return Colors.orange;


      default:

        return Theme.of(context)
            .colorScheme
            .primary;

    }


  }




  @override
  Widget build(BuildContext context) {


    final total =
        widget.items.first.value;



    return MouseRegion(

      cursor:
          SystemMouseCursors.click,


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

        duration:
            const Duration(milliseconds:180),


        transform:
            hovered

            ? Matrix4.translationValues(
                0,
                -4,
                0,
              )

            : Matrix4.identity(),



        child: Card(


          child: Padding(

            padding:
                const EdgeInsets.all(20),


            child: Column(


              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [



                Row(

                  children: [


                    Icon(

                      widget.icon,

                      color:
                          Theme.of(context)
                          .colorScheme
                          .primary,

                    ),



                    const SizedBox(width:10),



                    Text(

                      widget.title,

                      style:
                          const TextStyle(

                            fontWeight:
                                FontWeight.bold,

                            fontSize:18,

                          ),

                    )

                  ],

                ),




                const SizedBox(height:20),




                Text(

                  total.toString(),

                  style:
                      Theme.of(context)
                      .textTheme
                      .displaySmall
                      ?.copyWith(

                        fontWeight:
                            FontWeight.bold,

                      ),

                ),




                const Text(

                  "Totali",

                ),




                const SizedBox(height:20),




                ...widget.items.skip(1).map((item){


                  return Padding(

                    padding:
                        const EdgeInsets
                        .only(

                          bottom:8,

                        ),


                    child: Row(

                      mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,


                      children: [


                        Row(

                          children: [


                            Container(

                              width:10,

                              height:10,


                              decoration:
                                  BoxDecoration(

                                    color:
                                        getColor(
                                          item.label,
                                        ),

                                    shape:
                                        BoxShape.circle,

                                  ),

                            ),



                            const SizedBox(width:8),



                            Text(

                              item.label,

                            ),

                          ],

                        ),




                        Text(

                          item.value.toString(),


                          style:
                              const TextStyle(

                                fontWeight:
                                    FontWeight.bold,

                              ),

                        )


                      ],

                    ),

                  );


                }),


              ],


            ),

          ),

        ),

      ),

    );


  }


}