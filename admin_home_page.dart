import 'package:flutter/material.dart';

import 'destination_list_page.dart'; // Existing destination page

import 'trip_plans_page.dart'; // New trip plans page

import 'manage_comments_page.dart'; // New comments management page

import 'feedback_page.dart'; // New feedback page



// Mock data to simulate fetching from a database

const int totalUsers = 554;

const int totalTrips = 77;

const int totalDestinations = 120;



class AdminHomePage extends StatelessWidget {

  const AdminHomePage({super.key});



  @override

  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text('Admin Home Page'),

        backgroundColor: Colors.white,

        elevation: 0,

      ),

      body: Container(

// General background color (subtle light gray)

        color: const Color(0xFFF4F5F8),

        padding: const EdgeInsets.all(12.0), // Reduced main padding

        child: Column(

          crossAxisAlignment: CrossAxisAlignment.start,

          children: <Widget>[

// Title for the dashboard section

            const Padding(

              padding: EdgeInsets.only(bottom: 10.0), // Reduced padding

              child: Text(

                'Dashboard Overview',

                style: TextStyle(

                  fontSize: 16, // Reduced font size

                  fontWeight: FontWeight.w600,

                  color: Color(0xFF333333),

                ),

              ),

            ),



// ------------------------------------

// 1. Statistics Cards Section

// ------------------------------------

            _StatCard(

              title: 'Users',

              count: totalUsers,

              icon: Icons.group_rounded,

              iconColor: Colors.orange.shade700,

            ),

            const SizedBox(height: 10), // Reduced space

            _StatCard(

              title: 'Trips',

              count: totalTrips,

              icon: Icons.checklist_rtl_rounded,

              iconColor: Colors.red.shade400,

            ),

            const SizedBox(height: 10), // Reduced space

            _StatCard(

              title: 'Destinations',

              count: totalDestinations,

              icon: Icons.location_on_sharp,

              iconColor: Colors.green.shade500,

            ),



            const SizedBox(height: 20), // Reduced space



// ------------------------------------

// 2. Admin Control Section

// ------------------------------------

            const Padding(

              padding: EdgeInsets.only(bottom: 10.0), // Reduced padding

              child: Text(

                'Admin control',

                style: TextStyle(

                  fontSize: 16, // Reduced font size

                  fontWeight: FontWeight.w600,

                  color: Color(0xFF333333),

                ),

              ),

            ),



            Expanded(

              child: Container(

                padding: const EdgeInsets.all(12.0), // Reduced padding

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius: BorderRadius.circular(16),

                  boxShadow: [

                    BoxShadow(

                      color: Colors.grey.withOpacity(0.1),

                      spreadRadius: 2,

                      blurRadius: 5,

                      offset: const Offset(0, 3),

                    ),

                  ],

                ),

                child: Column(

                  mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Distributes buttons vertically

                  children: [

                    _AdminButton(

                      title: 'View & Update Destination',

                      onPressed: () {

                        Navigator.of(context).push(MaterialPageRoute(

                          builder: (context) => const DestinationListPage(),

                        ));

                      },

                    ),

                    const SizedBox(height: 8), // Reduced space

                    _AdminButton(

                      title: 'View trip plans',

                      onPressed: () {

                        Navigator.of(context).push(MaterialPageRoute(

                          builder: (context) => const TripPlansPage(),

                        ));

                      },

                    ),

                    const SizedBox(height: 8), // Reduced space

                    // _AdminButton(
                    //
                    //   title: 'View comments',
                    //
                    //   onPressed: () {
                    //
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //
                    //       builder: (context) => const ManageCommentsPage(),
                    //
                    //     ));
                    //
                    //   },
                    //
                    // ),

                    const SizedBox(height: 8), // Reduced space

                    _AdminButton(

                      title: 'Show feedback',

                      onPressed: () {

                        Navigator.of(context).push(MaterialPageRoute(

                          builder: (context) => const FeedbackPage(),

                        ));

                      },

                    ),

                  ],

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}





/// Reusable widget for displaying a single statistic card.

class _StatCard extends StatelessWidget {

  final String title;

  final int count;

  final IconData icon;

  final Color iconColor;



  const _StatCard({

    required this.title,

    required this.count,

    required this.icon,

    required this.iconColor,

  });



  @override

  Widget build(BuildContext context) {

    return Card(

      elevation: 3, // Soft shadow for the card

      shape: RoundedRectangleBorder(

        borderRadius: BorderRadius.circular(16),

      ),

      child: Padding(

        padding: const EdgeInsets.all(12.0), // Reduced padding

        child: Row(

          mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: <Widget>[

// Icon and Title

            Row(

              children: [

// Icon placeholder

                Container(

                  padding: const EdgeInsets.all(6), // Reduced padding

                  decoration: BoxDecoration(

                    color: iconColor.withOpacity(0.1),

                    borderRadius: BorderRadius.circular(10),

                  ),

                  child: Icon(

                    icon,

                    size: 32, // Reduced icon size

                    color: iconColor,

                  ),

                ),

                const SizedBox(width: 16), // Reduced space

// Title

                Text(

                  title,

                  style: TextStyle(

                    fontSize: 16, // Reduced font size

                    fontWeight: FontWeight.bold,

                    color: iconColor,

                  ),

                ),

              ],

            ),



// Count

            Text(

              count.toString(),

              style: TextStyle(

                fontSize: 20, // Reduced font size

                fontWeight: FontWeight.bold,

                color: Colors.grey.shade700, // Count is a neutral color

              ),

            ),

          ],

        ),

      ),

    );

  }

}



/// Reusable widget for the admin control buttons.

class _AdminButton extends StatelessWidget {

  final String title;

  final VoidCallback onPressed;



  const _AdminButton({

    required this.title,

    required this.onPressed,

  });



  @override

  Widget build(BuildContext context) {

    return SizedBox(

      width: double.infinity, // Full width button

      height: 40, // Reduced height

      child: ElevatedButton(

        onPressed: onPressed,

        style: ElevatedButton.styleFrom(

          backgroundColor: const Color(0xFFF0F0F0), // Very light gray background

          foregroundColor: const Color(0xFF333333), // Dark text color

          elevation: 0, // No shadow for a flat, modern look

          shape: RoundedRectangleBorder(

            borderRadius: BorderRadius.circular(12), // Rounded corners

          ),

          textStyle: const TextStyle(

            fontSize: 15, // Reduced font size

            fontWeight: FontWeight.w500,

          ),

        ),

        child: Text(title),

      ),

    );

  }

}