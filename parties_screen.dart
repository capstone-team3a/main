


import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:whistlingwoodz/main.dart';
import 'package:whistlingwoodz/models/wedding.dart';
import 'package:uuid/uuid.dart';

import '../widgets/app_bar_widget.dart';
import '../widgets/bottom_navigation_bar_widget.dart';

// This is a party event screen.
class PartyForm extends StatefulWidget {
  const PartyForm({super.key, required this.data});
  final bool data;

  @override
  State<PartyForm> createState() => _PartyState();
}

class _PartyState extends State<PartyForm> {
  // controllers variables for the text form fields
  final venueController = TextEditingController();
  final guestNoController = TextEditingController();
  final budgetController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNoController = TextEditingController();

  // dispose the controllers
  @override
  void dispose() {
    venueController.dispose();
    guestNoController.dispose();
    budgetController.dispose();
    emailController.dispose();
    phoneNoController.dispose();
    super.dispose();
  }

  // generate unique id for the corporates collection
  generateId() {
    const uuid = Uuid();
    return uuid.v4();
  }

  // submit button function to save the data in the firestore
  Future submit() async {
    late final wedding = Wedding(
      id: generateId().toString(),
      type: 'Wedding',
      theme: _selectedTheme,
      function: _selectedFunction,
      venue: _selectedVenue == _venueList[6]
          ? venueController.text.trim()
          : _selectedVenue,
      guestNo: guestNoController.text.trim(),
      budget: _selectedBudget == _budgetList[3]
          ? budgetController.text.trim()
          : _selectedBudget,
      email: emailController.text.toLowerCase().trim(),
      phoneNo: phoneNoController.text.trim(),
      timeStamp: Timestamp.now(),
    );
    // Add the weddings collection to the firestore
    addInquiryDetails(wedding);
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  // This method adds the weddings collection entered by the user to the firestore.
  Future addInquiryDetails(Wedding wedding) async {
    await FirebaseFirestore.instance
        .collection('weddings')
        .add(wedding.toJson());
  }

  // This method is used to navigate to the survey page.
  surveyFunction() {
    runApp(MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Whistlingwoodz',
      theme: ThemeData(
        primarySwatch: Colors.amber,
      ),
      // ignore: prefer_const_constructors
      home: MyApp(selectedIndex: 6),
    ));
  }


  // list variables for drop down menus
  final List<String> _themeList = [
    "Traditional",
    "Modern",
    "Custom"
  ];
  final List<String> _functionList = [
    "Birthday Celebration",
    "Anniversary Celebration",
    "Graduation Ceremony",
    "Personal"
  ];

  final List<String> _venueList = [
    "Australia",
    "India",
    "Other",
  ];
  List<String> _subVenueList = [];
  final List<String> australia = [
    "Hyatt Place Melbounre",
    "Hyatt Place Carribean Park",
    "Grand Hyatt Melbourne",
    "Park Hyatt Melbourne",
    "Hyatt Centric Melbourne",
    "The Langham Melbourne",
  ];
  final List<String> india = [
    "Rajasthan",
    "Missouri",
    "Bangalore",
  ];

  final List<String> _budgetList = [
    r"$20,000 - $29,999",
    r"$30,000 - $39,999",
    r"$40,000 - $60,000",
    "Other"
  ];

  // initial values for drop down menus
  String _selectedTheme = "Traditional";
  String _selectedFunction = "Birthday Celebration";
  String _selectedVenue = "Australia";
  String _selectedSubVenue = "Hyatt Place Melbounre";
  String _selectedBudget = r"$20,000 - $29,999";

  onVenueChanged(value){
    _selectedVenue = value;

    switch(_selectedVenue){
      case 'Australia': /// Australia
        _selectedSubVenue = australia[0];
        _subVenueList = australia;
      case 'India': /// India
        _selectedSubVenue = india[0];
        _subVenueList = india;
      default :
        break;
    }
    setState((){});

  }
  onSubVenueChanged(value){
    _selectedSubVenue = value;
  }

  @override
  void initState() {
    super.initState();
    _subVenueList = australia;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBarPage(data: widget.data),
      bottomNavigationBar: const BottomBar(),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // backgound photo for landing page
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/back2.png"),
            opacity: 1,
            fit: BoxFit.cover,
          ),
        ),
        // The box for the drop down menu section
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.2,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        // tab title
                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'PARTIES',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(25, 30, 25, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Theme drop down menu
                                  _buildTheme(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // Functions drop down menu
                                  _buildFunction(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // Venue drop down menu
                                  _buildVenue(),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  // sub Venue drop down
                                  if (_selectedVenue != _venueList[2])
                                    _buildSubVenue(),
                                  // if other is selected in the venue drop down menu
                                  if (_selectedVenue == _venueList[2])

                                    TextFormField(
                                      controller: venueController,
                                      autofocus: false,
                                      decoration: const InputDecoration(
                                        labelText: "Other Venue*",
                                        prefixIcon: Icon(
                                          Icons.place,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  _buildGuest(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // Budget drop down menu
                                  if (_selectedBudget != _budgetList[3])
                                    _buildBudget(),
                                  if (_selectedBudget == _budgetList[3])
                                    TextFormField(
                                      controller: budgetController,
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        labelText: "Other*",
                                        prefixIcon: Icon(
                                          Icons.attach_money,
                                          color: Colors.deepOrangeAccent,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // email text form field
                                  _buildEmail(),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  // phone text form field
                                  _buildPhone(),
                                  const SizedBox(
                                    height: 30,
                                  ),
                                  // submit button
                                  _buildSubmit(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Theme drop down menu
  Widget _buildTheme() => DropdownButtonFormField(
    value: _selectedTheme,
    items: _themeList
        .map(
          (e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      ),
    )
        .toList(),
    onChanged: (value) {
      setState(() {
        _selectedTheme = value as String;
      });
    },
    icon: const Icon(
      Icons.arrow_drop_down_circle,
      size: 20,
      color: Colors.deepOrangeAccent,
    ),
    dropdownColor: Colors.yellow.shade50,
    decoration: const InputDecoration(
      labelText: "Select Theme*",
      prefixIcon: Icon(
        Icons.subject,
        color: Colors.deepOrangeAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

  // Functions drop down menu
  Widget _buildFunction() => DropdownButtonFormField(
    value: _selectedFunction,
    items: _functionList
        .map(
          (e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      ),
    )
        .toList(),
    onChanged: (value) {
      setState(() {
        _selectedFunction = value as String;
      });
    },
    icon: const Icon(
      Icons.arrow_drop_down_circle,
      size: 20,
      color: Colors.deepOrangeAccent,
    ),
    dropdownColor: Colors.yellow.shade50,
    decoration: const InputDecoration(
      labelText: "Select Functions*",
      prefixIcon: Icon(
        Icons.book_online,
        color: Colors.deepOrangeAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

  // Venue drop down menu
  Widget _buildVenue() => DropdownButtonFormField(
    value: _selectedVenue,
    items: _venueList.map((venue) => DropdownMenuItem(
        value: venue,
        child: Text(venue)
    )).toList(),
    onChanged: onVenueChanged,
    icon: const Icon(
      Icons.arrow_drop_down_circle,
      size: 20,
      color: Colors.deepOrangeAccent,
    ),
    dropdownColor: Colors.yellow.shade50,
    decoration: const InputDecoration(
      labelText: "Select Venue*",
      prefixIcon: Icon(
        Icons.place,
        color: Colors.deepOrangeAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

  // Venue sub drop down menu
  Widget _buildSubVenue() => DropdownButtonFormField(
    value: _selectedSubVenue,
    validator: (value) {
      if(_subVenueList.contains(value)){
        print('xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxExist');
      }
      return 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';
    },
    items: _subVenueList.map((state) => DropdownMenuItem(
        value: state,
        child: Text(state)
    )).toList(),
    onChanged: onSubVenueChanged,
    icon: const Icon(
      Icons.arrow_drop_down_circle,
      size: 20,
      color: Colors.deepOrangeAccent,
    ),
    dropdownColor: Colors.yellow.shade50,
    decoration: const InputDecoration(
      labelText: "Select Venue*",
      prefixIcon: Icon(
        Icons.place,
        color: Colors.deepOrangeAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

  // guest text form field
  Widget _buildGuest() => TextFormField(
    controller: guestNoController,
    autofocus: false,
    keyboardType: TextInputType.number,
    decoration: const InputDecoration(
      labelText: "Number of Guests*",
      prefixIcon: Icon(
        Icons.group,
        color: Colors.deepOrangeAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

  // Budget drop down menu
  Widget _buildBudget() => DropdownButtonFormField(
    value: _selectedBudget,
    items: _budgetList
        .map(
          (e) => DropdownMenuItem(
        value: e,
        child: Text(e),
      ),
    )
        .toList(),
    onChanged: (value) {
      setState(() {
        _selectedBudget = value as String;
      });
    },
    icon: const Icon(
      Icons.arrow_drop_down_circle,
      size: 20,
      color: Colors.deepOrangeAccent,
    ),
    dropdownColor: Colors.yellow.shade50,
    decoration: const InputDecoration(
      labelText: "Select Budget*",
      prefixIcon: Icon(
        Icons.attach_money,
        color: Colors.deepOrangeAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

  // email text form field
  Widget _buildEmail() => TextFormField(
    controller: emailController,
    autofocus: false,
    keyboardType: TextInputType.emailAddress,
    decoration: const InputDecoration(
      labelText: "Email*",
      prefixIcon: Icon(
        Icons.email,
        color: Colors.deepOrangeAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

  // phone text form field
  Widget _buildPhone() => TextFormField(
    controller: phoneNoController,
    autofocus: false,
    keyboardType: TextInputType.phone,
    decoration: const InputDecoration(
      labelText: "Phone*",
      prefixIcon: Icon(
        Icons.phone,
        color: Colors.deepOrangeAccent,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
    ),
  );

// submit button
Widget _buildSubmit() => SizedBox(
  width: double.infinity,
  child: OutlinedButton(
    style: TextButton.styleFrom(
      padding: const EdgeInsets.symmetric(vertical: 26),
      foregroundColor: Colors.yellowAccent,
      backgroundColor: Colors.yellow[900],
      elevation: 15,
      shadowColor: Colors.grey,
      shape: const StadiumBorder(),
    ),
    onPressed: () {
      // call the submit function here
      submit();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Form Submitted"),
          content: const Text("Thank you for your submission!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                // navigate to the survey page
                surveyFunction();
              },
              child: const Text("Close"),
            ),
          ],
        ),
      );
    },
    child: Text(
      "Submit Form".toUpperCase(),
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
        color: Colors.white,
      ),
    ),
  ),
);
}
