import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/one.png'), fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomRight,
                colors: [
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(0.25),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(
                    width: 250.0,
                    child: TyperAnimatedTextKit(
                        speed: Duration(milliseconds: 80),
                        onTap: () {},
                        text: [
                          "Welcome to SSC",
                          'More to come.. Till then',
                          "Enjoy the Tour..",
                        ],
                        textStyle:
                            TextStyle(fontSize: 30.0, fontFamily: "Agne"),
                        textAlign: TextAlign.center,
                        alignment: AlignmentDirectional
                            .topStart // or Alignment.topLeft
                        ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  InkWell(
                    child: Container(
                      height: 60,
                      decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.black.withOpacity(0.3),
                      ),
                      child: Center(
                        child: Text(
                          'Discover',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 23,
                              color: Color(0xffF9F5EC)),
                        ),
                      ),
                    ),
                    onTap: () => Navigator.pushNamed(context, '/product'),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
