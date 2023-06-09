import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet16_flutter/fire_base_connexion.dart';
class SignUpUi extends StatefulWidget {
  const SignUpUi({Key? key}) : super(key: key);

  @override
  State<SignUpUi> createState() => _SignUpUiState();
}

class _SignUpUiState extends State<SignUpUi> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CallFireBase _newUser = CallFireBase();
  //controls  Form
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _pseudoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final logger = Logger();
  bool isAlreadyExist = false;

  //erreur Control
  bool _passwordError = false;
  bool _confirmPasswordError = false;
  bool _pseudoError = false;
  bool _emailError = false;


  bool _showPasswordErrorIcon = false;
  bool _showConfirmPasswordErrorIcon = false;
  bool _showPseudoErrorIcon = false;
  bool _showEmailErrorIcon = false;


  //  pour les valeurs des TextFields
  late String _email, _password, _tempPassword='';

  @override
  void initState() {
    super.initState();

    _passwordController.addListener(_updatePasswordError);
    _confirmPasswordController.addListener(_updateConfirmPasswordError);
    _pseudoController.addListener(_updatePseudoError);
    _emailController.addListener(_updateEmailError);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _pseudoController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateEmailError() {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      if (!_emailError) {
        setState(() {
          _emailError = true;
        });
      }
    } else if (_emailError) {
      setState(() {
        _emailError = false;
      });
    }
  }

  void _updatePasswordError() {
    if (_passwordController.text.isEmpty || _passwordController.text.length < 6) {
      if (!_passwordError) {
        setState(() {
          _passwordError = true;
        });
      }
    } else if (_passwordError) {
      setState(() {
        _passwordError = false;
      });
    }
  }

  void _updateConfirmPasswordError() {
    if (_confirmPasswordController.text.isEmpty ||
        _confirmPasswordController.text != _passwordController.text) {
      if (!_confirmPasswordError) {
        setState(() {
          _confirmPasswordError = true;
        });
      }
    } else if (_confirmPasswordError) {
      setState(() {
        _confirmPasswordError = false;
      });
    }
  }

  void _updatePseudoError() {
    if (_pseudoController.text.isEmpty) {
      if (!_pseudoError) {
        setState(() {
          _pseudoError = true;
        });
      }
    } else if (_pseudoError) {
      setState(() {
        _pseudoError = false;
      });
    }
  }

  void _submit() async {
    //Si le form est valide
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        // Appeler signUp() depuis l'instance de Backend
        await _newUser.signUp(_email, _password);

        //On connecte l'utilisateur
        await _auth.signInWithEmailAndPassword(email: _email, password: _password);

        // Redirection vers la page de connexion
        // ignore: use_build_context_synchronously
        Navigator.pushReplacementNamed(context, '/login');
      } catch (error) {
        if (error.toString().contains('Le mot de passe faible.')) {
          // Gérer l'erreur 'Le mot de passe faible.'
          logger.e('Le mot de passe faible.');
        } else if (error.toString().contains('email déjà utilisé.')) {
          // Gérer l'erreur 'Cet email est déjà utilisé.'
          isAlreadyExist = true;
          logger.e('email déjà utilisé.');
        } else {
          // Gérer les autres erreurs
          logger.e(error.toString());
        }
      }
    } else {
      // On met à jour l'état des icônes d'avertissement si on ne remplit pas les conditions nécessaires à leur apparition.
      setState(() {
        _showPseudoErrorIcon = _pseudoController.text.isEmpty;
        _showEmailErrorIcon = _emailController.text.isEmpty || !_emailController.text.contains('@');
        _showPasswordErrorIcon = _passwordController.text.isEmpty || _passwordController.text.length < 6;
        _showConfirmPasswordErrorIcon = _confirmPasswordController.text.isEmpty || _confirmPasswordController.text != _passwordController.text;
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        backgroundColor: const Color(0xFF1a2025),
        body: ListView(

          children:[ Padding(
            padding: EdgeInsets.only(top: 70.0, left: 20, right: 20),
            child: Stack(
              children: [
                const Image(image: AssetImage('assets/images/bg.jpg')),//image: AssetImage('assets/images/bg.jpg')

                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container
                        (
                        padding: const EdgeInsets.symmetric(vertical: 1.0),
                        child: const Text
                          (
                          'Inscription',
                          style: TextStyle
                            (
                            color: Colors.white,
                            fontSize: 40.0,
                            fontFamily: 'Google Sans',
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),//1st

                      Container
                        (
                        padding: const EdgeInsets.only( top: 20.0,bottom: 40.0, left: 20.0, right: 20.0),
                        alignment: Alignment.center,
                        child: const Text
                          (
                          'Veuillez saisir ces différentes informations, afin que vos listes soient sauvegardées.',
                          style: TextStyle
                            (
                            color: Colors.white,
                            fontSize: 17.0,
                            fontFamily: 'Google Sans',
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),//2nd
                      SizedBox(height: 30),

                      TextFormField(
                        controller: _pseudoController,
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration
                          (
                          labelText: "Nom d'utilisateur",
                          labelStyle: const TextStyle
                            (
                            //Pour le label 'Email'
                            fontFamily: 'Google Sans',
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1e262c),
                          border: const OutlineInputBorder(
                          ),
                          focusedBorder: const OutlineInputBorder
                            (
                            borderSide: BorderSide
                              (
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          enabledBorder: OutlineInputBorder
                            (
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(
                              color: const Color(0xFF1e262c),
                            ),
                          ),
                          suffixIcon: _showPseudoErrorIcon
                              ? SizedBox(
                            width: 18,
                            height: 18,
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset('assets/icons/warning.svg', width: 24, height: 24),
                            ),
                          )
                              : null,
                        ),
                        style: const TextStyle
                          (
                          color: Colors.white,
                        ),
                        validator: (input) {
                          if (input==null || input.isEmpty){
                            return "Veuillez entrer  un nom d'utilisateur";
                          }
                          return null;
                        },

                      ),//3rd
                      const SizedBox(height: 16.0),//4th

                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration
                          (
                          labelText: "E-Mail",
                          labelStyle: const TextStyle
                            (
                            //Pour le label 'Email'
                            fontFamily: 'Google Sans',
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1e262c),
                          border: const OutlineInputBorder(
                          ),
                          focusedBorder: const OutlineInputBorder
                            (
                            borderSide: BorderSide
                              (
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          enabledBorder: OutlineInputBorder
                            (
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(
                              color: const Color(0xFF1e262c),
                            ),
                          ),
                          suffixIcon: _showEmailErrorIcon
                              ? SizedBox(
                            width: 18,
                            height: 18,
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset('assets/icons/warning.svg', width: 24, height: 24),
                            ),
                          )
                              : null,
                        ),
                        style: const TextStyle
                          (
                          color: Colors.white,
                        ),

                        validator: (input) {
                          if (input==null || input.isEmpty){
                            return 'Veuillez renseigner une adresse e-mail';
                          }
                          else if (!input.contains('@')) {
                            return 'Entrez une adresse email valide';
                          } else if (isAlreadyExist) {
                            isAlreadyExist = false;
                            return 'Adresse email déjà existant';
                          } else {
                            return null;
                          }
                        },
                        //Quand on va save, on va sauvegarder l'email
                        onSaved: (input) => _email = input!,
                      ),//5th

                      const SizedBox(height: 16.0),//6th

                      //TextField pour le Mot de passe de l'utilisateur
                      TextFormField(
                        controller: _passwordController,
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(
                          labelText: "Mot de passe",
                          labelStyle: const TextStyle(
                            //Pour le label Password
                            fontFamily: 'Google Sans',
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1e262c),
                          border: const OutlineInputBorder(
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          enabledBorder: OutlineInputBorder(
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(
                              color: const Color(0xFF1e262c),
                            ),
                          ),
                          suffixIcon: _showPasswordErrorIcon
                              ? SizedBox(
                            width: 18,
                            height: 18,
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset('assets/icons/warning.svg', width: 24, height: 24),
                            ),
                          )
                              : null,
                        ),
                        obscureText: true,
                        style: const TextStyle
                          (

                          color: Colors.white,
                        ),

                        validator: (value) {
                          if (value==null || value.isEmpty){
                            return 'Veuillez renseigner un mot de passe';
                          }
                          else if (value.length < 6) {
                            return 'Le mot de passe doit contenir au moins 6 caractères';
                          }
                          else {
                            _tempPassword= value;
                            return null;
                          }
                        },
                        onSaved: (value) => _password = value!,
                      ),//7th

                      const SizedBox(height: 16.0),//8th

                      TextFormField(
                        controller: _confirmPasswordController,
                        // ignore: prefer_const_constructors
                        decoration: InputDecoration(

                          labelText: "verification du mot de passe",
                          labelStyle: const TextStyle(
                            fontFamily: 'Google Sans',
                            color: Colors.white70,
                          ),
                          filled: true,
                          fillColor: const Color(0xFF1e262c),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                          // ignore: prefer_const_constructors
                          enabledBorder: OutlineInputBorder(
                            // ignore: prefer_const_constructors
                            borderSide: BorderSide(
                              color: const Color(0xFF1e262c),
                            ),
                          ),
                          suffixIcon: _showConfirmPasswordErrorIcon
                              ? SizedBox(
                            width: 18,
                            height: 18,
                            child: Align(
                              alignment: Alignment.center,
                              child: SvgPicture.asset('assets/icons/warning.svg', width: 24, height: 24),
                            ),
                          )
                              : null,
                        ),
                        obscureText: true,
                        style: const TextStyle
                          (
                          //Couleur du texte tapé par l'utilisateur
                          color: Colors.white,
                        ),
                        //On va vérifier si les deux mots de passes sont les mêmes. Si NON, on bloque la création
                        validator: (input) {
                          if (input==null || input.isEmpty) {
                            return "Veuillez  confirmer votre mot de passe";
                          } else if (input != _tempPassword ) {
                            return "Les mots de passe sont differents ";
                          }
                          return null;
                        },

                      ),//9th
                      const SizedBox(height: 130.0),//10

                      ElevatedButton
                        (
                        onPressed: _submit,
                        style: ElevatedButton.styleFrom
                          (
                          padding: const EdgeInsets.fromLTRB(145.5, 20.0, 145.5, 20.0), backgroundColor: const Color(0xFF636AF6),
                          shape: RoundedRectangleBorder
                            (
                            borderRadius: BorderRadius.circular(5.0),
                          ),
                        ),
                        child: const Text (
                          "S'inscrire",
                          style: TextStyle(
                            fontFamily: 'Google Sans',
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),//12

                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        style: ElevatedButton.styleFrom
                          (
                          foregroundColor: Colors.white, backgroundColor: const Color(0xFF1a2025), padding: const EdgeInsets.fromLTRB(130, 20.0, 130, 20.0),
                          shape: RoundedRectangleBorder
                            (
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(color: Color(0xFF636AF6), width: 2.0),
                          ),
                        ),
                        child: const Text(
                          "Se Connecter",
                          style: TextStyle(
                            fontFamily: 'Google Sans',
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),


                    ],
                  ),
                )

              ],
            ),
          ),
    ]
        )
    );
  }
}


