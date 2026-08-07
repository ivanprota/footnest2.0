import 'package:flutter/material.dart';

import '/services/service_locator.dart';
import '/services/profile_service.dart';

import '/models/bet/bet.dart';

import '/widgets/profile/bet_preview_tile.dart';



class MyBetsScreen extends StatefulWidget {


  const MyBetsScreen({
    super.key,
  });



  @override
  State<MyBetsScreen> createState() =>
      _MyBetsScreenState();

}




class _MyBetsScreenState
    extends State<MyBetsScreen> {


  List<Bet> bets = [];


  bool loading = true;


  int currentPage = 0;


  int totalPages = 0;



  @override
  void initState() {

    super.initState();

    loadBets();

  }





  Future loadBets() async {


    setState(() {

      loading = true;

    });



    final service =
        locator<ProfileService>();


    final response =
        await service.getBets(

          page: currentPage,

          size:10,

        );



    setState(() {


      bets =
          response.content;


      totalPages =
          response.totalPages;


      loading = false;


    });


  }





  void nextPage(){

    if(currentPage < totalPages - 1){

      currentPage++;

      loadBets();

    }

  }




  void previousPage(){

    if(currentPage > 0){

      currentPage--;

      loadBets();

    }

  }





  @override
  Widget build(BuildContext context) {


    return Scaffold(


      appBar: AppBar(

        title:
            const Text(
              "Le mie schedine",
            ),

      ),




      body: loading


          ? const Center(

              child:
                  CircularProgressIndicator(),

            )



          :

          Padding(

            padding:
                const EdgeInsets.all(25),


            child: Column(

              children: [



                Expanded(

                  child: ListView.builder(

                    itemCount:
                        bets.length,


                    itemBuilder:
                        (_,index){


                      return BetPreviewTile(

                        bet:
                            bets[index],

                      );


                    },

                  ),

                ),





                Row(

                  mainAxisAlignment:
                      MainAxisAlignment.center,


                  children: [



                    IconButton(

                      onPressed:
                          currentPage > 0

                          ? previousPage

                          : null,


                      icon:
                          const Icon(
                            Icons.chevron_left,
                          ),

                    ),




                    Text(

                      "${currentPage + 1}"
                      " / "
                      "$totalPages",

                    ),




                    IconButton(

                      onPressed:
                          currentPage <
                              totalPages - 1

                          ? nextPage

                          : null,


                      icon:
                          const Icon(
                            Icons.chevron_right,
                          ),

                    ),


                  ],

                )


              ],

            ),

          ),

    );


  }


}