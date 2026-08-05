import 'package:flutter/material.dart';

import '/models/bet/bet.dart';
import '/services/bet_service.dart';
import '/services/service_locator.dart';

import '/widgets/bet/bet_card.dart';

class BetsScreen extends StatefulWidget {

  const BetsScreen({
    super.key,
  });

  @override
  State createState() => _BetsScreenState();
}

class _BetsScreenState extends State<BetsScreen>{

  final BetService betService = locator<BetService>();

  List<Bet> bets = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadBets();
  }

  Future loadBets() async {
    try{
      final result = await betService.getMyBets();

      if(!mounted)return;

      setState((){
        bets=result;
      });
    }
    finally {
      if(mounted) {
        setState(() {
          loading=false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Schedine"),
      ),
      body: loading 
        ?
        const Center(
          child: CircularProgressIndicator(),
        )
        :
        ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: bets.length,
          itemBuilder: (context,index) {
            return BetCard(
              bet: bets[index],
              onRefresh: loadBets,
            );
          },
        ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
      // nuova schedina
        },
        icon: const Icon(Icons.add),
        label: const Text("Nuova"),
      ),
    );
  }
}