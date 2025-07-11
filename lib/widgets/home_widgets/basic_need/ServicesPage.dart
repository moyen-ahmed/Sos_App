import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({Key? key}) : super(key: key);

  // Function to make a phone call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      await launchUrl(launchUri);
    } catch (e) {
      debugPrint('Could not launch $launchUri: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency Services'),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Container(
              color: Colors.blue.shade700,
              child: TabBar(
                indicatorColor: Colors.white,
                tabs: [
                  Tab(
                    icon: Icon(Icons.local_police),
                    text: 'Police',
                  ),
                  Tab(
                    icon: Icon(Icons.local_hospital),
                    text: 'Hospitals',
                  ),
                  Tab(
                    icon: Icon(Icons.fire_truck),
                    text: 'Fire Service',
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildPoliceContacts(),
                  _buildHospitalContacts(),
                  _buildFireServiceContacts(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPoliceContacts() {
    final policeContacts = [
      {
        'designation': 'Police Commissioner (Addl. IGP)',
        'name': 'Police Headquarters',
        'number': '01320037000',
        'email': 'pc@dmp.gov.bd',
      },
      {
        'designation': 'Addl. Police Commissioner (DIG) Admin',
        'name': 'DMP Admin',
        'number': '01320037005',
        'email': 'addlcomadmin@dmp.gov.bd',
      },
      {
        'designation': 'Addl. Police Commissioner (DIG) Crime & Ops',
        'name': 'Crime Operations',
        'number': '01320037006',
        'email': 'addlcomc&o@dmp.gov.bd',
      },
      {
        'designation': 'Addl. Police Commissioner (DIG) DB',
        'name': 'Detective Branch',
        'number': '01320037007',
        'email': 'addlcomdb@dmp.gov.bd',
      },
      {
        'designation': 'Addl. Police Commissioner (DIG) Traffic',
        'name': 'Traffic Division',
        'number': '01320037009',
        'email': 'addlcomtraffic@dmp.gov.bd',
      },
      {
        'designation': 'DC Ramna Division',
        'name': 'Ramna Division',
        'number': '01320039440',
        'email': 'dcramna@dmp.gov.bd',
      },
      {
        'designation': 'DC Traffic-Ramna',
        'name': 'Traffic South',
        'number': '01320042260',
        'email': 'dctsouth@dmp.gov.bd',
      },
    ];

    return _buildContactList(policeContacts, Colors.blue.shade100);
  }

  Widget _buildHospitalContacts() {
    final hospitalContacts = [
      {
        'designation': 'Emergency',
        'name': 'Dhaka Medical College Hospital',
        'number': '01712581981',
        'email': 'info@dmch.gov.bd',
      },
      {
        'designation': 'Emergency',
        'name': 'National Institute of Cardiovascular Diseases',
        'number': '01911063364',
        'email': 'info@nicvd.gov.bd',
      },
      {
        'designation': 'Emergency',
        'name': 'Bangabandhu Sheikh Mujib Medical University',
        'number': '01711956075',
        'email': 'info@bsmmu.edu.bd',
      },
      {
        'designation': 'Emergency',
        'name': 'Square Hospital',
        'number': '01713377774',
        'email': 'info@squarehospital.com',
      },
      {
        'designation': 'Emergency',
        'name': 'Apollo Hospital',
        'number': '01919276556',
        'email': 'info@apollodhaka.com',
      },
    ];

    return _buildContactList(hospitalContacts, Colors.red.shade100);
  }

  Widget _buildFireServiceContacts() {
    final fireServiceContacts = [
      {
        'designation': 'Deputy Director',
        'name': 'Dhaka Division',
        'number': '01901020100',
        'email': '',
      },
      {
        'designation': 'Assistant Director',
        'name': 'Dhaka District',
        'number': '01901020102',
        'email': '',
      },
      {
        'designation': 'Assistant Director',
        'name': 'Zone-1',
        'number': '01901020708',
        'email': '',
      },
      {
        'designation': 'Assistant Director',
        'name': 'Zone-2',
        'number': '01901020705',
        'email': '',
      },
      {
        'designation': 'Assistant Director',
        'name': 'Zone-3',
        'number': '01901020706',
        'email': '',
      },
      {
        'designation': 'Assistant Director',
        'name': 'Zone-4',
        'number': '01901020707',
        'email': '',
      },
      {
        'designation': 'Fire Station',
        'name': 'Siddique Bazar',
        'number': '01901020748',
        'email': '',
      },
      {
        'designation': 'Fire Station',
        'name': 'Sadarghat',
        'number': '01901020750',
        'email': '',
      },
      {
        'designation': 'Fire Station',
        'name': 'Lalbagh',
        'number': '01901020790',
        'email': '',
      },
      {
        'designation': 'Deputy Director',
        'name': 'Barisal Division',
        'number': '01901020160',
        'email': '',
      },
    ];

    return _buildContactList(fireServiceContacts, Colors.orange.shade100);
  }

  Widget _buildContactList(List<Map<String, String>> contacts, Color backgroundColor) {
    return Container(
      color: backgroundColor.withOpacity(0.3),
      child: ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          final contact = contacts[index];
          return Card(
            elevation: 3,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              title: Text(
                contact['name']!,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 4),
                  Text(contact['designation']!),
                  if (contact['email']!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Icon(Icons.email, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              contact['email']!,
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 13,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
              trailing: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                  icon: Icon(Icons.call, color: Colors.white),
                  onPressed: () => _makePhoneCall(contact['number']!),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}