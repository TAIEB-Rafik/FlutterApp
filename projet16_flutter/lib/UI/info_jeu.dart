import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet16_flutter/api/api_steam.dart' as steamAPI;
import 'package:projet16_flutter/fire_base_connexion.dart';


class GameInfo extends StatefulWidget {
  final String gameId;

  const GameInfo({super.key, required this.gameId});

  @override
  _GameInfoState createState() => _GameInfoState();
}

class _GameInfoState extends State<GameInfo> {
  late Future<Map<String, dynamic>> _gameDetailsFromApi;
  late Future<List<Map<String, dynamic>>> _gameCommentFromApi;

  bool _showingReviews = false;

  @override
  void initState() {
    super.initState();
    _gameDetailsFromApi = steamAPI.getGameDetails(widget.gameId);
    _gameCommentFromApi = steamAPI.getGameReviews(widget.gameId);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarDetail(gameId: widget.gameId),
      backgroundColor: const Color(0xFF1A2025),
      body : FutureBuilder<Map<String, dynamic>>(
        future: _gameDetailsFromApi,
        builder: (BuildContext context, AsyncSnapshot<Map<String, dynamic>> snapshot) {

          if (snapshot.hasData) {
            final data = snapshot.data!;
            return SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: 400,
                    child: Image.network(
                      data['imageSecondaire'],
                      fit: BoxFit.cover,
                    ),
                  ),
                   Padding(
                    padding: const EdgeInsets.only(top: 325.0),
                    child: MyGameCard(data: data),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 500, 16, 0),
                    child: Column(
                      children: [
                        ButtonCustomisedRevDes(
                          onDescription: () {
                            setState(() {
                              _showingReviews = false;
                            });
                          },
                          onReviews: () {
                            setState(() {
                              _showingReviews = true;
                            });
                          },
                          showingReviews: _showingReviews,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: _showingReviews
                              ? FutureBuilder<List<Map<String, dynamic>>>(
                            future: _gameCommentFromApi,
                            builder: (BuildContext context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                              if (snapshot.hasData) {
                                return ReviewsListWidget(reviews: snapshot.data!);
                              } else if (snapshot.hasError) {
                                return Center(child: Text('${snapshot.error}'));
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          )
                              : Text(
                            data['description'],
                            style: const TextStyle(fontSize: 16, color: Colors.white),
                          ),
                        ),
                      ],

                    ),
                  ),
                ],
              ),
            );
            } else if (snapshot.hasError) {
            return Center(child: Text('${snapshot.error}'));
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}


// ignore: must_be_immutable
class AppBarDetail extends StatefulWidget implements PreferredSizeWidget {
  final String gameId;


  const AppBarDetail({super.key, required this.gameId});

  @override
  _AppBarDetailState createState() => _AppBarDetailState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}


class _AppBarDetailState extends State<AppBarDetail> {

  bool _isLiked = false;
  bool _isInWishlist = false;


  final CallFireBase _auth = CallFireBase();

  @override
  void initState() {
    super.initState();
    _initLikeAndWishlistState();
  }

  Future<void> _initLikeAndWishlistState() async {
    bool isLiked = await _auth.isLiked(widget.gameId);
    bool isInWishlist = await _auth.isInWishlist(widget.gameId);
    setState(() {
      _isLiked = isLiked;
      _isInWishlist = isInWishlist;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1A2025),
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: Colors.white,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      title: Row(
        children: [
          const Expanded(
            child: Text(
              "Détails du jeu",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ),

          IconButton(
            onPressed: () async {
              setState(() {
                _isLiked = !_isLiked;
              });
             await _auth.connectToLike(widget.gameId, _isLiked);

            },
            icon: SvgPicture.asset(
              _isLiked ? 'assets/icons/like_full.svg' : 'assets/icons/like.svg',
              height: 20,
              width: 20,
            ),
          ),


          const SizedBox(width: 40),

          IconButton(
            onPressed: () async {
              setState(() {
                _isInWishlist = !_isInWishlist;
              });
              await _auth.connectToWishlist(widget.gameId, _isInWishlist);

            },
            icon: SvgPicture.asset(
              _isInWishlist ? 'assets/icons/whishlist_full.svg' : 'assets/icons/whishlist.svg',
              height: 20,
              width: 20,
            ),
          ),
        ],
      ),
    );
  }
}



class MyGameCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const MyGameCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          color: const Color(0xFF293136),
          child: Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: Image.network(
                  data['imageTersiaire'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
              Row(
                children: [

                  SizedBox(
                    width: 100,
                    child: AspectRatio(
                      aspectRatio: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Image.network(
                          data['imagePrincipale'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data['titre'],
                          style: const TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${data['editeur']}',
                          style: const TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}




class ButtonCustomisedRevDes extends StatelessWidget {

  final VoidCallback onDescription;
  final VoidCallback onReviews;
  final bool showingReviews;

  const ButtonCustomisedRevDes({super.key, required this.onDescription, required this.onReviews, required this.showingReviews});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: ElevatedButton(
            onPressed: onDescription,
            style: ElevatedButton.styleFrom(
              backgroundColor: showingReviews ? const Color(0xFF1A2025) : const Color(0xff626af6),
              side: const BorderSide(
                color: Color(0xff626af6),
                width: 1,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5),
                  bottomLeft: Radius.circular(5),
                  topRight: Radius.circular(0),
                  bottomRight: Radius.circular(0),
                ),
              ),
              minimumSize: const Size(double.infinity, 40),
            ),
            child: Text(
              'DESCRIPTION',
              style: TextStyle(
                fontSize: 16,
                color: showingReviews ? Colors.white : Colors.white,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          //Notre bouton Avis
          child: ElevatedButton(
            onPressed: onReviews,
            style: ElevatedButton.styleFrom(
              backgroundColor: showingReviews ? const Color(0xff626af6) : const Color(0xFF1A2025),
              side: const BorderSide(
                color: Color(0xff626af6) ,
                width: 1,
              ),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  bottomLeft: Radius.circular(0),
                  topRight: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              //On augmente sa height
              minimumSize: const Size(double.infinity, 40),
            ),
            child: Text(
              'AVIS',
              style: TextStyle(
                fontSize: 16,
                color: showingReviews ? Colors.white : Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}



class ReviewsListWidget extends StatelessWidget {
  final List<Map<String, dynamic>> reviews;
  //On veut que l'appel envoie les reviews en List<Map<String, dynamic>>.
  const ReviewsListWidget({super.key, required this.reviews});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 4),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              color: const Color(0xFF232B31),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        FutureBuilder<String>(
                          future: steamAPI.getSteamUsername(review['idSteam']),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.done) {
                              if (snapshot.hasData) {
                                return Text(
                                  snapshot.data!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                );
                              } else if (snapshot.hasError) {
                                return const Text(
                                  "Echec de chargement de l'utilisateur",
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                );
                              }
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                        /*
                        Image.asset(
                          'assets/images/etoile_${review['etoileVote'] ? '5' : '0'}.png',
                          height: 80,
                          width: 80,
                        ),
              */
                      ],
                    ),
                    Text(
                      review['commentaireClient'],
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
