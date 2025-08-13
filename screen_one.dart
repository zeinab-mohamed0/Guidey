
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:guidey/sign_up.dart';

import 'login.dart';

class PageOne extends StatelessWidget {
  const PageOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerRight,
              end: Alignment.centerLeft,
              colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
            ),
          ),
        ),
        /*centerTitle: Image.asset(
          'assets/images/logo.png',
          height: 40,
        ), */
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Container(
              margin: EdgeInsets.all(30),
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              padding:EdgeInsets.all(30) ,

              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white, fontSize: 25,fontWeight:FontWeight.bold),
                ),
              ),
            ),
          ),

          SizedBox(height: 50),


          Center(
            child: Container(
              margin: EdgeInsets.all(30),
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                gradient: LinearGradient(
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
                  colors: [Color(0xFF3DAEE9), Color(0xFF8A6FE8)],
                ),
              ),
              padding: EdgeInsets.all(30),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUpScreen()),
                  );
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white, fontSize:25,fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}