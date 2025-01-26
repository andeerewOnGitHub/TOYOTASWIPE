import 'package:flutter/material.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PageController _pageController;
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _imageUrls = [
    'images/carrosel_1.avif',
    'images/carrosel_2.webp',
    'images/carrosel_3.png',
    'images/carrosel_4.webp',
  ];

  // List of VR tour links
  final List<Map<String, String>> _vrLinks = [
    {
      'title': 'Explore 2021 Toyota Tacoma',
      'url': 'https://my.matterport.com/show/?m=yP7fi6xESzJ',
    },
    {
      'title': 'Explore 2021 Toyota Corolla Hybrid',
      'url': 'https://my.matterport.com/show/?m=f4wCqxduHK4',
    },

    {
      'title': 'Explore 2021 Toyota Avalon XLE',
      'url': 'https://my.matterport.com/show/?m=Zh4h8DYax15',
    },
    {
      'title': 'Explore 2021 Toyota Supra',
      'url': 'https://my.matterport.com/show/?m=yXBJA368Wyv',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _timer = Timer.periodic(Duration(seconds: 5), (timer) {
      if (_currentPage < _imageUrls.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: Duration(seconds: 1),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOYOTA SWIPE"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'images/toyotaLogo.png',
              height: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView
        child: Column(
          children: [
            // Carousel Section
            SizedBox(
              height: 350,
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemCount: _imageUrls.length,
                itemBuilder: (context, index) {
                  return Image.asset(
                    _imageUrls[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_imageUrls.length, (index) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 4),
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Colors.red : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),
            SizedBox(height: 40),
            Text('Welcome To', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 10),
            Text('TOYOTA SWIPE', style: TextStyle(fontSize: 58, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 10),
            Text('Seamlessly Find the Best Car for YOU, Quickly, Easily,', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 10),
            Text('Survey-Less', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
            SizedBox(height: 40),
            
            // "Explore Toyota VR Tours" Section with black background
            Container(
              color: Colors.black, // Black background
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  Text(
                    'Explore Toyota VR Tours',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  Column(
                    children: _vrLinks.map((vrLink) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            if (await canLaunch(vrLink['url']!)) {
                              await launch(vrLink['url']!);
                            } else {
                              throw 'Could not launch ${vrLink['url']}';
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8), // Smaller padding for buttons
                            textStyle: TextStyle(fontSize: 14), // Smaller text size
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)), // Smaller radius
                          ),
                          child: Text(vrLink['title']!),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            
            // Larger "Start Searching for Cars" button with extra white space at the bottom
            Padding(
              padding: const EdgeInsets.only(bottom: 20), // Add extra bottom space
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SwipeCardsDemo()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 25), // Larger button
                  textStyle: TextStyle(fontSize: 20), // Larger text size
                  elevation: 5,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Larger radius
                ),
                child: Text('Start Searching for Cars'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class SwipeCardsDemo extends StatefulWidget {
  const SwipeCardsDemo({super.key});

  @override
  _SwipeCardsDemoState createState() => _SwipeCardsDemoState();
}

class _SwipeCardsDemoState extends State<SwipeCardsDemo> {
  final List<Map<String, String>> carList = [
    {'name': 'Toyota Camry', 'image': 'images/toyota_camry.avif', 'price': '25000', 'mpg': '28 City / 39 Hwy', 'type': 'Sedan', 'description': 'Toyota Camry\nStarting Price: \$25,000\nMPG: 28 City / 39 Hwy', 'url': 'https://www.toyota.com/camry/'},
    {'name': 'Toyota Corolla', 'image': 'images/Toyota_Corolla.avif', 'price': '20000', 'mpg': '30 City / 38 Hwy', 'type': 'Sedan', 'description': 'Toyota Corolla\nStarting Price: \$20,000\nMPG: 30 City / 38 Hwy', 'url': 'https://www.toyota.com/corolla/'},
    {'name': 'Toyota RAV4', 'image': 'images/Toyota_RAV4.avif', 'price': '28000', 'mpg': '27 City / 35 Hwy', 'type': 'SUV', 'description': 'Toyota RAV4\nStarting Price: \$28,000\nMPG: 27 City / 35 Hwy', 'url': 'https://www.toyota.com/rav4/'},
    {'name': 'Toyota Highlander', 'image': 'images/Toyota_Highlander.jpg', 'price': '40000', 'mpg': '21 City / 29 Hwy', 'type': 'SUV', 'description': 'Toyota Highlander\nStarting Price: \$40,000\nMPG: 21 City / 29 Hwy', 'url': 'https://www.toyota.com/highlander/'},
    {'name': 'Toyota Tacoma', 'image': 'images/Toyota_Tacoma.avif', 'price': '35000', 'mpg': '20 City / 24 Hwy', 'type': 'Truck', 'description': 'Toyota Tacoma\nStarting Price: \$35,000\nMPG: 20 City / 24 Hwy', 'url': 'https://www.toyota.com/tacoma/'},
    {'name': 'Toyota Tundra', 'image': 'images/Toyota_Tundra.avif', 'price': '45000', 'mpg': '17 City / 22 Hwy', 'type': 'Truck', 'description': 'Toyota Tundra\nStarting Price: \$45,000\nMPG: 17 City / 22 Hwy', 'url': 'https://www.toyota.com/tundra/'},
    {'name': 'Toyota Prius', 'image': 'images/Toyota_Prius.avif', 'price': '28000', 'mpg': '54 City / 50 Hwy', 'type': 'Sedan', 'description': 'Toyota Prius\nStarting Price: \$28,000\nMPG: 54 City / 50 Hwy', 'url': 'https://www.toyota.com/prius/'},
    {'name': 'Toyota 4Runner', 'image': 'images/Toyota_4Runner.avif', 'price': '42000', 'mpg': '16 City / 19 Hwy', 'type': 'SUV', 'description': 'Toyota 4Runner\nStarting Price: \$42,000\nMPG: 16 City / 19 Hwy', 'url': 'https://www.toyota.com/4runner/'},
    {'name': 'Toyota Sienna', 'image': 'images/Toyota_Sienna.avif', 'price': '38000', 'mpg': '19 City / 26 Hwy', 'type': 'Minivan', 'description': 'Toyota Sienna\nStarting Price: \$38,000\nMPG: 19 City / 26 Hwy', 'url': 'https://www.toyota.com/sienna/'},
    {'name': 'Toyota Avalon', 'image': 'images/Toyota_Avalon.webp', 'price': '36000', 'mpg': '22 City / 32 Hwy', 'type': 'Sedan', 'description': 'Toyota Avalon\nStarting Price: \$36,000\nMPG: 22 City / 32 Hwy', 'url': 'https://www.toyota.com/avalon/'},
    {'name': 'Toyota Supra', 'image': 'images/Toyota_Supra.jpg', 'price': '50000', 'mpg': '24 City / 31 Hwy', 'type': 'Sports Car', 'description': 'Toyota Supra\nStarting Price: \$50,000\nMPG: 24 City / 31 Hwy', 'url': 'https://www.toyota.com/supra/'},
    {'name': 'Toyota C-HR', 'image': 'images/Toyota_C-HR.jpg', 'price': '25000', 'mpg': '27 City / 31 Hwy', 'type': 'SUV', 'description': 'Toyota C-HR\nStarting Price: \$25,000\nMPG: 27 City / 31 Hwy', 'url': 'https://www.toyota.com/c-hr/'},
    {'name': 'Toyota Land Cruiser', 'image': 'images/Toyota_Land_Cruiser.avif', 'price': '85000', 'mpg': '13 City / 17 Hwy', 'type': 'SUV', 'description': 'Toyota Land Cruiser\nStarting Price: \$85,000\nMPG: 13 City / 17 Hwy', 'url': 'https://www.toyota.com/landcruiser/'},
    {'name': 'Toyota Sequoia', 'image': 'images/Toyota_Sequoia.jpg', 'price': '60000', 'mpg': '15 City / 19 Hwy', 'type': 'SUV', 'description': 'Toyota Sequoia\nStarting Price: \$60,000\nMPG: 15 City / 19 Hwy', 'url': 'https://www.toyota.com/sequoia/'},
    {'name': 'Toyota Venza', 'image': 'images/Toyota_Venza.avif', 'price': '35000', 'mpg': '40 City / 37 Hwy', 'type': 'SUV', 'description': 'Toyota Venza\nStarting Price: \$35,000\nMPG: 40 City / 37 Hwy', 'url': 'https://www.toyota.com/venza/'},
  ];

  List<Map<String, String>> rightSwipedCars = [];

  double getAveragePrice() {
    double total = 0;
    for (var car in rightSwipedCars) {
      total += double.parse(car['price']!);
    }
    return rightSwipedCars.isEmpty ? 0 : total / rightSwipedCars.length;
  }

  String getPreferredCarType() {
    Map<String, int> typeCount = {};
    for (var car in rightSwipedCars) {
      typeCount[car['type']!] = (typeCount[car['type']!] ?? 0) + 1;
    }
    var sortedTypes = typeCount.entries.toList()..sort((a, b) => b.value.compareTo(a.value));
    return "Preferred Car Type: ${sortedTypes[0].key}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOYOTA SWIPE"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Lets Find What You Like first', style: TextStyle(fontSize: 38, fontWeight: FontWeight.w600, color: Colors.black), textAlign: TextAlign.center),
          Text('Swipe 👉 If Interested,  Swipe 👈 If Uninterested', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black), textAlign: TextAlign.center),
          SizedBox(height: 20),
          Expanded(
            child: Stack(
              children: carList.map((car) {
                return Dismissible(
                  key: Key(car['name']!),
                  direction: DismissDirection.horizontal,
                  onDismissed: (direction) {
                    setState(() {
                      if (direction == DismissDirection.startToEnd) {
                        rightSwipedCars.add(car);
                      }
                      carList.remove(car);
                      if (carList.isEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SwipedRightPage(cars: rightSwipedCars, averagePrice: getAveragePrice(), preferredCarType: getPreferredCarType()),
                          ),
                        );
                      }
                    });
                  },
                  child: Center(
                    child: Card(
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: SizedBox(
                        width: 350,
                        height: 500,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.asset(
                                car['image']!,
                                fit: BoxFit.cover,
                                height: 250.0,
                                width: double.infinity,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                car['description']!,
                                style: TextStyle(fontSize: 30.0, fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class SwipedRightPage extends StatefulWidget {
  final List<Map<String, String>> cars;
  final double averagePrice;
  final String preferredCarType;

  const SwipedRightPage({super.key, required this.cars, required this.averagePrice, required this.preferredCarType});

  @override
  _SwipedRightPageState createState() => _SwipedRightPageState();
}

class _SwipedRightPageState extends State<SwipedRightPage> {
  late List<Map<String, String>> rightSwipedCars;

  @override
  void initState() {
    super.initState();
    rightSwipedCars = widget.cars;
  }

  void _removeCar(int index) {
    setState(() {
      if (rightSwipedCars.length > 1) {
        if (index == 0) {
          rightSwipedCars[0] = rightSwipedCars[1];
        } else {
          if (rightSwipedCars.length > 2) {
            rightSwipedCars[1] = rightSwipedCars[2];
          }
        }
        rightSwipedCars.removeAt(1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("TOYOTA SWIPE"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text('Time to Narrow Down Your Perfect Car!',
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.black),
              textAlign: TextAlign.center),
          SizedBox(height: 20),
          Text('Compare the options and select the one you would like to keep',
              style: TextStyle(fontSize: 26, color: Colors.black), textAlign: TextAlign.center),
          SizedBox(height: 20),
          if (rightSwipedCars.length > 1)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _removeCar(1),
                  child: Card(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(rightSwipedCars[0]['image']!, fit: BoxFit.cover, height: 150.0, width: 150.0),
                        ),
                        Text(rightSwipedCars[0]['name']!),
                        Text(rightSwipedCars[0]['mpg']!),
                        Text('Starting Price: \$${rightSwipedCars[0]['price']}'),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () => _removeCar(0),
                  child: Card(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(rightSwipedCars[1]['image']!, fit: BoxFit.cover, height: 150.0, width: 150.0),
                        ),
                        Text(rightSwipedCars[1]['name']!),
                        Text(rightSwipedCars[1]['mpg']!),
                        Text('Starting Price: \$${rightSwipedCars[1]['price']}'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          SizedBox(height: 20),
          if (rightSwipedCars.length == 1)
            Column(
              children: [
                Text('Your Preferred Car Is:', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: Colors.black)),
                SizedBox(height: 20),
                Card(
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(rightSwipedCars[0]['image']!, fit: BoxFit.cover, height: 150.0, width: 150.0),
                      ),
                      Text(rightSwipedCars[0]['name']!),
                      Text(rightSwipedCars[0]['mpg']!),
                      Text('Starting Price: \$${rightSwipedCars[0]['price']}'),
                      SizedBox(height: 10),
                      Text('For more details, visit:'),
                      GestureDetector(
                        onTap: () => _launchURL(rightSwipedCars[0]['url']!),
                        child: Text(
                          'I want this car',
                          style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Future<void> _launchURL(String url) async {
  final Uri uri = Uri.parse(url);  // Convert the string URL to Uri object
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);  // Open URL in external browser
  } else {
    throw 'Could not launch $url';
  }
}
}