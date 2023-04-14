import 'dart:js';

import 'package:flutter/material.dart';
import 'package:projet16_flutter/game.dart';
import '../api/api_steam.dart'as steamApi;
import 'package:flutter_svg/flutter_svg.dart';


class HomeUi extends StatefulWidget {
  const HomeUi({Key? key}) : super(key: key);

  @override
  State<HomeUi> createState() => _HomeUiState();
}

class _HomeUiState extends State<HomeUi> {


  TextEditingController searchController = TextEditingController();
  late Future<List<Game>> _futureGames;

  Future<List<Game>> _loadGames() async {
    final gameIds = await steamApi.getGameIdsWithoutParameter();
    final gamesInformation = await steamApi.getGamesInformation(gameIds);
    return gamesInformation;
  }

  @override
  void initState() {
    super.initState();
    _futureGames = _loadGames();
  }




  @override
  Widget build(BuildContext context) {
    return   Scaffold(
      backgroundColor:const Color(0xFF1e262c),
      appBar: AppBar(
        title: const Text("Accueil",style: TextStyle(fontWeight: FontWeight.w700,)),
        backgroundColor: const Color(0xFF1A2025),
        automaticallyImplyLeading: false,
        titleSpacing: 20,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 30.0),
            child: GestureDetector(
                onTap: (){
                 // Navigator.push(context,MaterialPageRoute(builder:(context)=>  WishlistPage())),
                },
                child:  SvgPicture.asset(
                    "assets/icons/whishlist.svg",
                  height: 30,
                  width: 30,
                ),
              ),
          ),
          Container(
            margin: EdgeInsets.only(right: 22.0),
            child: GestureDetector(
                onTap: (){
                 // Navigator.push(context,MaterialPageRoute(builder:(context)=>  WishlistPage())),
                },
                child:  SvgPicture.asset(
                    "assets/icons/like.svg",
                  height: 30,
                  width: 30,
                ),
              ),
          ),

        ],
      ),

      body: Column(
          children: [

            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7),
                    borderSide: BorderSide(
                      color: Colors.blueGrey.shade900,
                    ),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  filled: true,
                  fillColor: Colors.blueGrey.shade900,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: const OutlineInputBorder(),
                  hintText: 'Rechercher un jeu...',
                  hintStyle: const TextStyle(color: Colors.white),
                  suffixIcon: GestureDetector(
                    onTap: () {
                     // Navigator.push(context,MaterialPageRoute(builder: (context) => Recherche(query: recherche.text)),);
                    },
                    child:  SvgPicture.asset(
                      "assets/icons/Search.svg",
                      height: 30,
                      width: 30,
                    ),
                  ),
                ),
              ),
            ),
          ]
      ),
    );
  }


}
