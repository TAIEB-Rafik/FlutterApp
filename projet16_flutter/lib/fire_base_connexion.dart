import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CallFireBase {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signIn(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      //Gestions d'erreurs
      if (e.code == 'user-not-found') {
        return Future.error(' l\'email n\'existe pas ');
      } else if (e.code == 'wrong-password') {
        //Si le mot de passe est mauvais
        return Future.error('Mauvais mot de passe');
      } else {
        //Si on arrive pas à se connecter à la bdd
        return Future.error('Erreur de connexion: ${e.message}');
      }
    }
  }


  Future<void> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);


      await userCredential.user!.sendEmailVerification();


    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return Future.error('Le mot de passe est trop faible.');
      } else if (e.code == 'email-already-in-use') {
        return Future.error(' email  déjà utilisé.');
      } else {
        return Future.error('Erreur lors de la création du compte: ${e.message}');
      }
    } catch (e) {
      return Future.error('Erreur inattendue: ${e.toString()}');
    }
  }


  Future<void> connectToLike(String gameId, bool isLiked) async {

    DatabaseReference likesRef = FirebaseDatabase.instance

        .reference()
        .child('liked_games')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(gameId);

    if (isLiked) {

      await likesRef.set(gameId);
    } else {

      await likesRef.remove();
    }
  }

  //permet de voir si un jeu est liké ou non dans la data base
  Future<bool> isLiked(String gameId) async {
    //conecction
    DatabaseReference likesRef = FirebaseDatabase.instance
    // ignore: deprecated_member_use
        .reference()
        .child('liked_games')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(gameId);
    //On va lire s"il existe
    DatabaseEvent snapshot = await likesRef.once();
    return snapshot.snapshot.value != null;
  }


  //Permet de se connecter pour ecrire dans la partie wishlist de la data base. On a besoin de l'ID
  Future<void> connectToWishlist(String gameId, bool isInWishlist) async {
    //connection
    DatabaseReference wishlistRef = FirebaseDatabase.instance
    // ignore: deprecated_member_use
        .reference()
        .child('wish_games')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(gameId);
    //Si il est pas encore wishlisté
    if (isInWishlist) {
      //on l'ajoute
      await wishlistRef.set(gameId);
    } else {
      //sinon on le supprime
      await wishlistRef.remove();
    }
  }

  //permet de voir si un jeu est wishlisté ou non dans la data base
  Future<bool> isInWishlist(String gameId) async {
    //connection
    DatabaseReference wishlistRef = FirebaseDatabase.instance
    // ignore: deprecated_member_use
        .reference()
        .child('wish_games')
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child(gameId);
    //On va lire s"il existe
    DatabaseEvent snapshot = await wishlistRef.once();
    return snapshot.snapshot.value != null;
  }

}
