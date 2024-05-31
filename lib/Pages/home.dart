import 'package:app_project/Pages/LoginPage.dart';
import 'package:app_project/Pages/SignUp.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          children: [
            ListTile(
              title: Text(
                'Safe Road',
                style: GoogleFonts.akayaTelivigala(
                  fontSize: 32,
                  foreground: Paint()
                    ..shader = const LinearGradient(
                      colors: <Color>[
                        Color.fromARGB(255, 16, 28, 38),
                        Colors.blueAccent
                      ],
                    ).createShader(const Rect.fromLTWH(0.0, 70.0, 200.0, 0.0)),
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(
                      "images/Free Photo _ Road landscape with blue sky.jfif"),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.6),
                    BlendMode.darken,
                  ),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    radius: 40,
                    child: ClipOval(
                      child: Image.asset(
                        "images/profile.png",
                        fit: BoxFit.cover,
                        width: 160,
                        height: 160,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: Text(
                      ' $firstName' + ' $lastName',
                      style: GoogleFonts.workSans(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      ' $email',
                      style: GoogleFonts.workSans(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.account_circle,
                          color: Color.fromARGB(255, 10, 92, 159),
                          size: 30,
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "ProfilePage");
                          },
                          child: const Text(
                            "Account",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 10, 92, 159),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_right,
                              color: Color.fromARGB(255, 10, 92, 159),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.payment,
                          color: Color.fromARGB(255, 10, 92, 159),
                          size: 30,
                        ),
                        const SizedBox(
                          width: 70,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "ProfilePage");
                          },
                          child: const Text(
                            "Payment",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 10, 92, 159),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 45,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_right,
                              color: Color.fromARGB(255, 10, 92, 159),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.privacy_tip,
                          color: Color.fromARGB(255, 10, 92, 159),
                          size: 30,
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "ProfilePage");
                          },
                          child: const Text(
                            "Privacy Policy",
                            style: TextStyle(
                                fontSize: 20,
                                color: Color.fromARGB(255, 10, 92, 159)),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_right,
                              color: Color.fromARGB(255, 10, 92, 159),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.notifications,
                          color: Color.fromARGB(255, 10, 92, 159),
                          size: 30,
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "ProfilePage");
                          },
                          child: const Text(
                            "Notifcation",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 10, 92, 159),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_right,
                              color: Color.fromARGB(255, 10, 92, 159),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.help,
                          color: Color.fromARGB(255, 10, 92, 159),
                          size: 30,
                        ),
                        const SizedBox(
                          width: 60,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "ProfilePage");
                          },
                          child: const Text(
                            "Terms and\n Conditions",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 10, 92, 159),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 35,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_right,
                              color: Color.fromARGB(255, 10, 92, 159),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.switch_account,
                          color: Color.fromARGB(255, 10, 92, 159),
                          size: 30,
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "ProfilePage");
                          },
                          child: const Text(
                            "Service Provider",
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 10, 92, 159),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.arrow_right,
                              color: Color.fromARGB(255, 10, 92, 159),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 30),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "LoginPage");
                          },
                          child: const Text(
                            "Sign Out",
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.red,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(
                          width: 40,
                        ),
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, "LoginPage");
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: Colors.red,
                            size: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // CustomButton(
            //   onTap: () {
            //     Navigator.pushNamed(context, 'FormPage');
            //   },
            //   text: '$firstName',
            // ),
          ],
        ),
      ),
      appBar: AppBar(
        // leading: IconButton(onPressed: (){},icon: Icon(Icons.menu),),
        title: Text(
          'Safe Road',
          style: GoogleFonts.akayaTelivigala(
            fontSize: 32,
            foreground: Paint()
              ..shader = const LinearGradient(
                colors: <Color>[
                  Color.fromARGB(255, 16, 28, 38),
                  Colors.blueAccent
                ],
              ).createShader(const Rect.fromLTWH(0.0, 70.0, 200.0, 0.0)),
          ),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.notifications)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Row(
            children: [
              const SizedBox(
                width: 7,
              ),
              Text(
                'Hi,$firstName',
                style: GoogleFonts.amethysta(
                  fontSize: 35,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              GestureDetector(
                onTap: () {},
                child: Card(
                  child: Container(
                    width: 150,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 16, 28, 38),
                          Colors.blueAccent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.car_repair,
                          size: 70,
                          color: Colors.white,
                        ), // Icon added here
                        const SizedBox(height: 10),
                        Text(
                          'Services',
                          style: GoogleFonts.allerta(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              GestureDetector(
                onTap: () {},
                child: Card(
                  child: Container(
                    width: 150,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 16, 28, 38),
                          Colors.blueAccent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 70,
                          color: Colors.white,
                        ), // Icon added here
                        const SizedBox(height: 10),
                        Text(
                          'Places',
                          style: GoogleFonts.allerta(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            children: [
              const Spacer(
                flex: 2,
              ),
              GestureDetector(
                onTap: () {},
                child: Card(
                  child: Container(
                    width: 150,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 16, 28, 38),
                          Colors.blueAccent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.question_answer,
                          size: 70,
                          color: Colors.white,
                        ), // Icon added here
                        const SizedBox(height: 10),
                        Text(
                          'Chatbot',
                          style: GoogleFonts.allerta(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
              GestureDetector(
                onTap: () {},
                child: Card(
                  child: Container(
                    width: 150,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 16, 28, 38),
                          Colors.blueAccent
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.local_shipping,
                          size: 70,
                          color: Colors.white,
                        ), // Icon added here
                        const SizedBox(height: 10),
                        Text(
                          'Tow Trunk',
                          style: GoogleFonts.allerta(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
