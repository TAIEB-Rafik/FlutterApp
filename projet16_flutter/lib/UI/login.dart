import 'package:flutter/material.dart';
import 'package:projet16_flutter/UI/sign_up.dart';
import 'package:projet16_flutter/fire_base_connexion.dart';
class LoginUi extends StatefulWidget {
  const LoginUi({Key? key}) : super(key: key);

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {

 final _keyForm = GlobalKey<FormState>();
 final _emailController = TextEditingController();
 final _passwordController = TextEditingController();
    String _emailError="" ;
 String _passwordError="";

 final CallFireBase _auth = CallFireBase();


 Future<void> _signIn() async {
   final email = _emailController.text.trim();
   final password = _passwordController.text.trim();

   if (email.isEmpty || password.isEmpty) {
     setState(() {
       _emailError = email.isEmpty ? 'Veuillez entrer un email' : "";
       _passwordError =
       password.isEmpty ? 'Veuillez entrer le mot de passe' : "";
     });
     return;
   }

   try {
     await _auth.signIn(email, password);
     Navigator.pushReplacementNamed(context, '/home');
   } catch (error) {
     setState(() {
       _emailError = error.toString();
     });
   }
 }





  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: const Color(0xFF1a2025),
      body: Container(
        padding: const EdgeInsets.only(top: 30),
        decoration:  const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/bg.jpg')
            )
        ),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,

        child: SingleChildScrollView(
          child: Padding(
            padding: const  EdgeInsets.all(40),// espace entre elements collumn
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Bienvenue !",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontFamily: 'GoogleSans-Bold',
                    fontSize: 39,
                    color: Colors.white
                  ),

                ),//1st child collumn
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top:5, bottom:15),
                    child: const SizedBox(
                      width: 180,
                        child: Text(
                          "Veuillez vous connecter ou créer un nouveau compte pour utiliser l'application.",
                          textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'ProximaNova-Regular',
                              fontWeight: FontWeight.w300,
                              fontSize: 16,
                            )
                        ),
                    )
                ),//2nd child

                Form(
                  key:_keyForm ,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,

                    children: [
                      TextField(
                        cursorColor: Colors.white,
                        controller:_emailController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          //errorText: _emailError,
                          errorStyle: const TextStyle(color: Colors.red),
                          contentPadding: EdgeInsets.symmetric(vertical: 18),
                          focusedBorder: UnderlineInputBorder(
                            //borderSide: BorderSide(color: Color(0xFF636AF6))
                          ),
                          hintText: 'E-mail',
                          filled: true,
                          fillColor: Color(0xFF1e262c),
                          hintStyle: TextStyle(
                            color: Colors.white70,
                            fontFamily: 'ProximaNova-Regular',
                            fontSize: 20
                          )

                        ),
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'ProximaNova-Regular',
                          fontSize: 15,
                        ),
                      ),//1st child second column

                      const SizedBox(height: 16.0),//2nd child column2

                      TextField(
                        cursorColor: Colors.white,
                        controller:_passwordController,
                        obscureText: true,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          //errorText: _passwordError,
                            errorStyle: const TextStyle(color: Colors.red),
                            contentPadding: EdgeInsets.symmetric(vertical: 18),
                            focusedBorder: UnderlineInputBorder(
                              //borderSide: BorderSide(color: Color(0xFF636AF6))
                            ),
                            hintText: 'Mot de passe',
                            filled: true,
                            fillColor: Color(0xFF1e262c),
                            hintStyle: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'ProximaNova-Regular',
                                fontSize: 20
                            )

                        ),

                      ),//3child column2
                      const SizedBox(height: 100.0),//4eme child column2
                      ElevatedButton(
                          onPressed:(){
                            // _signIn,
                          },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(1.0, 20.0, 1.0, 20.0), backgroundColor: const Color(0xFF636AF6),
                        ),
                        child: const Text(
                          'Se Connecter',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily:'ProximaNova-Regular',
                            fontSize: 20
                          ),
                        ),


                      ),//5eme column2
                      const SizedBox(height: 20),//6eme colum2
                      ElevatedButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpUi()));
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFF1a2025),
                          padding: EdgeInsets.only(top: 20,bottom: 20,left: 1,right: 1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            side: const BorderSide(color: Color(0xFF636AF6), width: 2.0),
                          ),
                        ),
                        child: const Text(
                          "Créer un nouveau compte",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Google Sans',
                            fontSize: 17
                          )
                        ),
                      ),//7eme
                      Align(
                        child: Container(
                          margin: const EdgeInsets.only(top:120),
                          child: SizedBox(
                            height: 20.0,
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/passforget');
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF1a2025)),
                              ),
                              child: const Text(
                                'Mot de passe oublié',
                                style: TextStyle(
                                  color: Colors.white,
                                  decoration: TextDecoration.underline,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w300,
                                  fontSize: 12.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ),//3red child column1


              ],
            ),
          ),
        ),
      ) ,
    );
  }
}
