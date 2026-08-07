import 'package:flutter/material.dart';

import '/models/user/user_profile.dart';


class ProfileHeader extends StatelessWidget {


  final UserProfile profile;



  const ProfileHeader({

    super.key,

    required this.profile,

  });



  String get createdText {


    final date =
        profile.createdAt;


    return "${date.day}/"
        "${date.month}/"
        "${date.year}";

  }




  @override
  Widget build(BuildContext context) {


    return Card(


      child: Padding(

        padding:
            const EdgeInsets.all(25),


        child: Row(

          children: [


            CircleAvatar(

              radius:40,


              backgroundColor:
                  Theme.of(context)
                  .colorScheme
                  .primary
                  .withOpacity(0.15),


              child:

              Icon(

                Icons.person,

                size:45,

                color:
                    Theme.of(context)
                    .colorScheme
                    .primary,

              ),

            ),



            const SizedBox(width:25),




            Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,


              children: [


                Row(

                  children: [


                    Text(

                      profile.username,

                      style:
                          Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(

                            fontWeight:
                                FontWeight.bold,

                          ),

                    ),



                    if(profile.admin)

                      Padding(

                        padding:
                            const EdgeInsets
                            .only(left:10),


                        child: Container(

                          padding:
                              const EdgeInsets
                              .symmetric(

                                horizontal:10,

                                vertical:4,

                              ),


                          decoration:
                              BoxDecoration(

                                color:
                                    Colors.amber
                                    .withOpacity(0.15),

                                borderRadius:
                                    BorderRadius
                                    .circular(20),

                              ),


                          child: const Row(

                            children: [


                              Icon(

                                Icons.admin_panel_settings,

                                size:16,

                                color:
                                    Colors.amber,

                              ),


                              SizedBox(width:5),


                              Text(

                                "Admin",

                                style:
                                    TextStyle(

                                      color:
                                          Colors.amber,

                                      fontWeight:
                                          FontWeight.bold,

                                    ),

                              )


                            ],

                          ),

                        ),

                      )

                  ],

                ),




                const SizedBox(height:8),




                Text(

                  "Iscritto dal $createdText",

                  style:
                      Theme.of(context)
                      .textTheme
                      .bodyMedium,

                )

              ],

            )


          ],

        ),

      ),

    );


  }


}