
import 'package:flutter/material.dart';
import 'package:projet16_flutter/game.dart';
import '../api/api_steam.dart'as steamApi;
import 'package:flutter_svg/flutter_svg.dart';
import 'info_jeu.dart';


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
            Expanded(
              child: FutureBuilder<List<Game>>(
                future: _futureGames,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final games = snapshot.data!;
                    return ListView.builder(
                      itemCount: games.length +1,
                      itemBuilder: (context, index) {
                        if (index == 0) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 15, bottom: 30.0),
                                child: _backgroundImg(context),
                              ),
                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 13.0),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Text(
                                      "Les meilleures ventes",
                                      style: TextStyle(fontSize: 16, color: Colors.white, decoration : TextDecoration.underline),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        }else {
                          final game = games[index -1];

                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),

                            margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 13),
                            child: Container(
                              height: 115,
                              decoration: BoxDecoration(
                                color: const Color(0xFF212B33),
                                borderRadius: BorderRadius.circular(5),
                                image: DecorationImage(
                                  image: NetworkImage(game.imgTer),
                                  fit: BoxFit.cover,
                                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.75), BlendMode.srcOver),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10.0 ,vertical: 12),
                                    child : Expanded(
                                      child: AspectRatio(
                                        aspectRatio: 1,
                                        child: Image.network(
                                          game.imgUrl,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),


                                  Expanded(
                                    flex: 2,
                                    child: Padding(
                                      padding: const EdgeInsets.all(17),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(game.name, style: const TextStyle(fontSize: 15, color: Colors.white,)),
                                          const SizedBox(height: 2),
                                          Text(game.publisher.first, style: const TextStyle(fontSize: 13, color: Colors.white,)),
                                          const SizedBox(height: 9),

                                          Row(
                                            children: [
                                              if (game.price != "Gratuit") const Text("Prix: ", style: TextStyle(fontSize: 13, color: Colors.white, decoration : TextDecoration.underline),),
                                              Text(game.price, style:const TextStyle(fontSize: 12, color: Colors.white,)),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  GestureDetector(

                                      onTap: () {

                                        Navigator.push(
                                          context,
                                          PageRouteBuilder(pageBuilder: (_, __, ___) => GameInfo(gameId: game.id.toString(),),),);
                                      },
                                      child: Container(
                                        height: double.infinity,
                                        width: 115,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF626AF6),
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(5),
                                            bottomRight: Radius.circular(5),
                                          ),
                                        ),
                                        //On le centre
                                        child: const Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 10),
                                            child: Text(
                                              "En savoir plus",
                                              style: TextStyle(color: Colors.white, fontSize: 18,),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      )
                                  )
                                ],
                              ),
                            ),
                          );
                        }
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          ]
      ),
    );
  }






  Widget _backgroundImg(context) {
    return  Card(
      child: Stack(
        children: [
          Image.asset(
            'assets/images/imageacceuil.png',
            width: double.infinity,
            height: 200,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 10.0, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text(
                  'Titan Fall 2\n Ultimate Edition',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Vous suivrez l\'histoire \n d\'un militaire qui souhaite \n devenir pilote d\'élite à la Frontière?',
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF636AF6),
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 9, vertical: 5)
                    ),
                    child: const Text('En savoir plus'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const GameInfo(gameId: '570',)),
                      );
                    }
                ),
              ],
            ),
          ),
        ],
      ),
    );

  }


}
