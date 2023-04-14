import 'dart:convert';
import 'package:http/http.dart' as http;
import '../game.dart';

String cleanTags(String description) {
  description = description.replaceAll('<br>', '\n');
  description = description.replaceAll('<br />', '\n');
  description = description.replaceAll('<br/>', '\n');

  description = description.replaceAll('&quot;', '"');

  description = description.replaceAll('<li>', '-');
  description = description.replaceAll('</li>', '\n');

  description = description.replaceAll(RegExp(r'<\/?p>|<\/?h1>|<\/?h2>|<\/?h3>|<\/?h4>|<\/?h5>|<\/?i>|<\/?h6>|<\/?ol>|<\/?ul>|<ul.*?>|<\/?u>|<u.*?>|<\/?strong>|<img.*?>|<a.*?>|<\/?a>|<h1.*?>|<h2.*?>|<h3.*?>|<h4.*?>|<h5.*?>|<h6.*?>'), '');
  return description;
}

//geters
Future<List<int>> getGameIdsWithoutParameter() async {
  final response = await http.get(Uri.parse('https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/?supportedlang=french'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> body = json.decode(response.body);
    final List<dynamic> gameRanks = body['response']['ranks'];
     List<int> gameIds = gameRanks.map((rank) => rank['appid'] as int).toList();
    return gameIds;
  } else {

    throw Exception('Echec de la recuperation des identifiant des Jeux steam');
  }
}

Future<List<int>> getGameIds(List<int> gameIds) async {
  final response = await http.get(Uri.parse('https://api.steampowered.com/ISteamChartsService/GetMostPlayedGames/v1/?supportedlang=french'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> body = json.decode(response.body);
    final List<dynamic> gameRanks = body['response']['ranks'];
    //On récupère les ids, et on les mets dans un tableau d'Id
    final List<int> gameIds = gameRanks.map((rank) => rank['appid'] as int).toList();
    return gameIds;
  } else {
    throw Exception('Echec du Fetch les Ids des Jeux');
  }
}

Future<List<Game>> getGamesInformation(List<int> gameIds) async {//fetchGames
  final List<Game> gamesList = [];

  for (int id in gameIds) {
    final response = await http.get(Uri.parse('https://store.steampowered.com/api/appdetails?appids=$id&supportedlang=french'));
    if (response.statusCode == 200) {
      final String body = response.body;
      if (body.isNotEmpty) {
        final Map<String, dynamic> data = json.decode(body);
        final Map<String, dynamic>? readyInfo = data[id.toString()]['data'];
        if (readyInfo != null) {
          String name = readyInfo['name'];
          if (name.length > 25) {//==> vois dossier c> rafik >projet>mobile>bug> grandMot
            List<String> motsName = name.split(' ');
            // Concatène les mots jusqu'à ce que la longueur maximale soit atteinte.
            String newStringName = '';
            for (int i = 0; i < motsName.length; i++) {
              if ((newStringName + motsName[i]).length > 25) {
                break;
              }
              newStringName += '${motsName[i]} ';
            }
            name = newStringName.substring(0, newStringName.length - 1);
          }
          final String imageUrl = readyInfo['header_image'];
          final List<dynamic> screenshotsList = readyInfo['screenshots'];
          final String imgTer = screenshotsList.isNotEmpty ? screenshotsList.last['path_thumbnail'] : '';
          final List<dynamic> publisher = readyInfo['publishers'];
          if (publisher.first.length > 20) {
            List<String> mots = publisher.first.split(' ');
            String newString = '';
            for (int i = 0; i < mots.length; i++) {
              if ((newString + mots[i]).length > 20) {
                break;
              }
              newString += '${mots[i]} ';
            }
            publisher.first = newString.substring(0, newString.length - 1);
          }

          final Map<String, dynamic>? gamePrice = data[id.toString()]['data']['price_overview'];
          String price;
          // price_overview existe lorsque le jeux est payant
          if (gamePrice != null) {
            if(gamePrice['initial_formatted']!= "") {
              price = gamePrice['initial_formatted'];
            } else {
              price = gamePrice['final_formatted'];
            }
          } else {
            price = "Gratuit";
          }

          final Game gameInstance = Game(id: id, name: name, publisher: publisher, price : price,imgUrl: imageUrl, imgTer: imgTer);
          gamesList.add(gameInstance);
        }
      }
    } else {
      throw Exception('Echec de la tentative de recuperation d\'informations des Jeux');
    }
  }
  return gamesList;
}

Future<List<int>> searchGameIds(String searchQuery) async {
  final response = await http.get(Uri.parse('https://steamcommunity.com/actions/SearchApps/$searchQuery'));
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body);
    final gamesList = body as List<dynamic>;
    final gamesIds = gamesList.map<int>((gamesList) => int.parse(gamesList['appid'].toString())).toList();
    return gamesIds;
  } else {
    throw Exception('Echec de tentative de recherche');
  }
}

Future<Map<String, dynamic>> getGameDetails(String gameId) async {
  final url = 'https://store.steampowered.com/api/appdetails?appids=$gameId&supportedlang=french';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body)[gameId];
    final gameDetails = body['data'];

    final String title = gameDetails['name'];
    final List<dynamic> editorList = gameDetails['publishers'];
    final String firstEditor = editorList.isNotEmpty ? editorList.first : '';
    final String imgHeader = gameDetails['header_image'];
    final List<dynamic> screenshotsList = gameDetails['screenshots'];
    final String imgSecondry = screenshotsList.isNotEmpty ? screenshotsList.first['path_thumbnail'] : '';
    final String imgTer = screenshotsList.isNotEmpty ? screenshotsList.last['path_thumbnail'] : '';

    final String description = gameDetails['detailed_description'];
    final String cleanedDescription = cleanTags(description);

    return  {
      'titre': title,
      'editeur': firstEditor,
      'imagePrincipale': imgHeader,
      'imageSecondaire': imgSecondry,
      'imageTersiaire' : imgTer,
      'description': cleanedDescription,
    };

  } else {
    throw Exception('Echec du chargement des informations');
  }
}

Future<List<Map<String, dynamic>>> getGameReviews(String gameId) async {

  final url = 'https://store.steampowered.com/appreviews/$gameId?json=1';
  final response = await http.get(Uri.parse(url));
  if (response.statusCode == 200) {
    final body = jsonDecode(response.body)['reviews'];
    final List<Map<String, dynamic>> reviews = [];
    if (body != null) {
      for (var review in body) {
        final idSteam = review['author']['steamid'];
        final etoileVote = review['voted_up'];
        final gamerComment = review['review'];

        if (gamerComment.length > 1500) {
          continue;
        }
        reviews.add({
          'idSteam': idSteam,
          'etoileVote': etoileVote,
          'gamerComment': gamerComment,
        });
      }
    }
    return reviews;
  } else {
    throw Exception('Echec du chargement des Commentaires');
  }
}





