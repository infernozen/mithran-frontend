import 'dart:core';
import "package:flutter/material.dart";
import 'package:intl/intl.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import '../../widgets/charts/constructbarchart.dart';
import '../expense-section/expensetrackerpage.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Home Page
        break;
      case 1:
        // Navigate to Expense Tracker
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ExpenseTracker()),
        );
        break;
      case 2:
        // Navigate to Add Page
        // Navigator.pushNamed(context, '/add');
        break;
      case 3:
        // Navigate to Message Page
        // Navigator.pushNamed(context, '/message');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    int hour = now.hour;
    int minute = now.minute;
    String day = DateFormat('EEEE').format(now);
    String date = DateFormat('dd').format(now);
    String month = DateFormat('MMMM').format(now);
    List<String> timeArr = [
      "11:03",
      "11:03",
      "11:04",
      "11:04",
      "11:04",
      "11:04",
      "11:04"
    ];
    List<double> temperatureArr = [18, 21, 4, 26, 26, 19, 10];
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xffEBF5FF),
      bottomNavigationBar: StyleProvider(
        style: Style(),
        child: ConvexAppBar(
          backgroundColor: Colors.white,
          color: Colors.blue,
          activeColor: const Color(0xff0158DB),
          items: const [
            TabItem(icon: Icons.home, title: "Home"),
            TabItem(icon: Icons.map, title: 'Expense'),
            TabItem(icon: Icons.add, title: 'Add'),
            TabItem(icon: Icons.message, title: "Message"),
          ],
          onTap: _onItemTapped,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 37, 185, 0).withOpacity(0.6), // Green color
              Color(0xffF5F6FB), // Blue color
            ],
            stops: [0.4, 0.4], // 40% green, 60% blue
          ),
        ),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 40.0, bottom: 10.0),
                  child: Text(
                    "Vanakkam Rohith 🙏",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 29.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, bottom: 10.0),
                child: Text(
                  '${day}, ${date} ${month}',
                  style: const TextStyle(
                    fontFamily: "Poppins",
                    fontSize: 25.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 25.0, bottom: 10.0),
                  child: Text(
                    "Updated 2 minutes(s) ago",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      fontSize: 16.0,
                      color: Colors.white,
                    ),
                  )),
              Container(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 15.0),
                child: Stack(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/homepage/weather.png',
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFF313131), // #313131
                            const Color(0xFF616161).withOpacity(
                                0.51), // rgba(97, 97, 97, 0.511667)
                            const Color(0xFF838383)
                                .withOpacity(0.0), // rgba(131, 131, 131, 0)
                          ],
                          stops: const [0.0, 0.4883, 1.0],
                        ),
                      ),
                    ),
                  ),
                  const Positioned(
                    left: 20,
                    top: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Next 6 hours",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 22.0,
                                color: Color(0xffFFFFFF),
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 6.0),
                        Text(
                          "23.5 C",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 30.0,
                            color: Color(0xffFFFFFF),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 12.0),
                        Text(
                          "Raing ending around 11:45",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xffFFFFFF),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 25.0, right: 25.0, bottom: 15.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: const Color(0xffFFFFFF),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 20.0),
                          child: Text(
                            "Hows the Weather",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 18.0),
                          )),
                      const Padding(
                          padding: EdgeInsets.only(left: 20.0, bottom: 20.0),
                          child: Text("looking?🤔",
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0))),
                      Row(
                        children: [
                          const Spacer(),
                          Row(children: [
                            Image.asset('assets/homepage/rain.png',
                                height: 40, width: 40),
                            const SizedBox(width: 15.0),
                            const SizedBox(
                              width: 100.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("53% chance",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0)),
                                  Text("0.6mm rain",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0xff848484),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0)),
                                ],
                              ),
                            ),
                          ]),
                          const Spacer(),
                          Row(children: [
                            Image.asset('assets/homepage/humidity.png',
                                height: 40, width: 40),
                            const SizedBox(width: 15.0),
                            const SizedBox(
                              width: 100.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("88%",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0)),
                                  Text("Humidity",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0xff848484),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0)),
                                ],
                              ),
                            ),
                          ]),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          const Spacer(),
                          Row(children: [
                            Image.asset('assets/homepage/temp.png',
                                height: 40, width: 40),
                            const SizedBox(width: 15.0),
                            const SizedBox(
                              width: 100.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("22-24",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0)),
                                  Text("Min 20",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0xff848484),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0)),
                                ],
                              ),
                            ),
                          ]),
                          const Spacer(),
                          Row(children: [
                            Image.asset('assets/homepage/wind.png',
                                height: 40, width: 40),
                            const SizedBox(width: 15.0),
                            const SizedBox(
                              width: 100.0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("25 km/h",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14.0)),
                                  Text("Wind",
                                      style: TextStyle(
                                          fontFamily: "Poppins",
                                          color: Color(0xff848484),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12.0)),
                                ],
                              ),
                            ),
                          ]),
                          const Spacer(),
                        ],
                      ),
                      const Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 40.0, bottom: 10.0),
                          child: Text(
                            "Hourly Forecast",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 20.0),
                          )),
                      Container(
                        height: 130.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 10,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.only(
                                  top: 5.0, left: 8.0, right: 8.0),
                              decoration: const BoxDecoration(
                                border: Border(
                                  right: BorderSide(
                                      color: Color(0xff39C0FF), width: 0.5),
                                ),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Color(0xFFE3F3FF), // #E3F3FF
                                    Color(0xFF90CFFF), // #90CFFF
                                  ],
                                  stops: [
                                    0.0,
                                    1.0
                                  ], // Corresponding to 0% and 100%
                                ),
                              ),
                              child: Column(
                                children: [
                                  Text("${hour}:${(minute + index) % 60}",
                                      style: const TextStyle(
                                          fontFamily: "Poppins",
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff6B6B6B))),
                                  const SizedBox(height: 40.0),
                                  Container(
                                    child: Image.asset(
                                        'assets/homepage/cloudy.png',
                                        height: 40,
                                        width: 40),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 10.0),
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0, bottom: 15.0),
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: '11:03', // Time part
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xffFF7979),
                                    fontWeight: FontWeight.w700),
                              ),
                              TextSpan(
                                text: ' Mostly rainy', // Rest of the text
                                style: TextStyle(
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: Colors
                                        .black), // Change this if you want a different color
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 25.0, bottom: 10.0),
                        child: Text("Temperature",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w700,
                                fontSize: 16.0)),
                      ),
                      ConstructBarChart(
                          timeArr: timeArr, temperatureArr: temperatureArr),
                      const SizedBox(height: 14.0),
                      const Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 10.0, bottom: 12.0),
                          child: Text(
                              '''Showers early with some clearing overnight.Hazy.Low 21 C. Winds W at 15 to 30 km/h. Chance of rain 60%''',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                fontSize: 14.0,
                                color: Color(0xff616161),
                              ))),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25.0),
                child: Container(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: Colors.white,
                  ),
                  child: Row(children: [
                    const SizedBox(width: 10.0),
                    Image.asset('assets/homepage/calendar.png',
                        height: 60.0, width: 60.0),
                    const Spacer(),
                    const SizedBox(
                        width: 200.0,
                        child: Text(
                          "Compare past 14 days and next 14 days weather",
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w600,
                            fontSize: 14.0,
                          ),
                        )),
                    const Spacer(),
                    const Icon(Icons.keyboard_arrow_right,
                        color: Color(0xff4F9EFF), size: 30.0),
                    const SizedBox(width: 10.0)
                  ]),
                ),
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        )),
      ),
    );
  }
}

class Style extends StyleHook {
  @override
  double get activeIconSize => 25;

  @override
  double get activeIconMargin => 10;

  @override
  double get iconSize => 20;

  @override
  TextStyle textStyle(Color color, String? fontFamily) {
    return TextStyle(color: color, fontFamily: fontFamily);
  }
}
