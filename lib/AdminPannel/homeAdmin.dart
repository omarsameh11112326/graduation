import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:photo_view/photo_view.dart';

// Main screen for the admin panel
class AdminPanelScreen extends StatefulWidget {
  @override
  State<AdminPanelScreen> createState() => _AdminPanelScreenState();
}

class _AdminPanelScreenState extends State<AdminPanelScreen> {
  int _selectedIndex = 0;  // Current tab index

  // Function to handle tab selection
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Safe Road',
          style: TextStyle(
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
      body: _buildBody(),  // Display the appropriate body content based on the selected tab
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.request_page),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.approval),
            label: 'Approved',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.cancel),
            label: 'Rejected',
          ),
          
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
        ],
        currentIndex: _selectedIndex,  // Highlight the selected tab
        selectedItemColor: Colors.blue.shade900,  // Color for selected tab
        unselectedItemColor: Colors.grey,  // Color for unselected tabs
        onTap: _onItemTapped,  // Handle tab selection
      ),
    );
  }

  // Function to build the body content based on the selected tab
  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
      case 1:
      case 2:
        return _buildServiceProvidersList();  // Show service providers list for requests, approved, and rejected tabs
      case 3:
        return _buildUsersList();  // Show dashboard for the dashboard tab
      case 4:
        return Dashboard();  // Show users list for the users tab
      default:
        return _buildServiceProvidersList();
    }
  }

  // Function to build the list of service providers
  Widget _buildServiceProvidersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('form').snapshots(),  // Fetch data from Firestore
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());  // Show loading indicator if data is not yet available
        }

        var docs = snapshot.data!.docs;

        // Separate the documents based on their status
        var pendingProviders =
            docs.where((doc) => doc['status'] == 'pending').toList();
        var acceptedProviders =
            docs.where((doc) => doc['status'] == 'accepted').toList();
        var rejectedProviders =
            docs.where((doc) => doc['status'] == 'rejected').toList();

        // Function to build the list view for providers
        Widget buildProviderList(List<DocumentSnapshot> providers) {
          return ListView.builder(
            itemCount: providers.length,
            itemBuilder: (context, index) {
              var data = providers[index].data() as Map<String, dynamic>;
              data['docId'] = providers[index].id;  // Add document ID to the data map
              return ServiceProviderDetails(data: data);  // Show provider details
            },
          );
        }

        // Show the appropriate list based on the selected tab
        switch (_selectedIndex) {
          case 0:
            return buildProviderList(pendingProviders);
          case 1:
            return buildProviderList(acceptedProviders);
          case 2:
            return buildProviderList(rejectedProviders);
          default:
            return buildProviderList(pendingProviders);
        }
      },
    );
  }

  // Function to build the list of users with type 'normal'
  Widget _buildUsersList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('userType', isEqualTo: 'Normal user').snapshots(),  // Fetch users with type 'normal' from Firestore
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());  // Show loading indicator if data is not yet available
        }

        var docs = snapshot.data!.docs;

        // Function to build the list view for users
        Widget buildUserList(List<DocumentSnapshot> users) {
          return ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              var data = users[index].data() as Map<String, dynamic>;
              data['docId'] = users[index].id;  // Add document ID to the data map
              return UserDetail(data: data);  // Show user details
            },
          );
        }

        // Show the list of users
        return buildUserList(docs);
      },
    );
  }
}

// Widget to display details of a service provider
class ServiceProviderDetails extends StatelessWidget {
  final Map<String, dynamic> data;

  ServiceProviderDetails({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Business Name: ${data['businessName']}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Phone: ${data['phone']}'),
            SizedBox(height: 8),
            Text('National ID Image:'),
            data['nationalID'] != null
                ? GestureDetector(
                    onTap: () {
                      _showLargeImage(context, data['nationalID']);
                    },
                    child: Image.network(data['nationalID'], height: 100),
                  )
                : Text('No image available'),
            SizedBox(height: 8),
            Text('Location: ${data['location']}'),
            SizedBox(height: 8),
            Text('Place Image:'),
            data['place'] != null
                ? GestureDetector(
                    onTap: () {
                      _showLargeImage(context, data['place']);
                    },
                    child: Image.network(data['place'], height: 100),
                  )
                : Text('No image available'),
            SizedBox(height: 8),
            Text('Service Type: ${data['selectedValue']}'),
            SizedBox(height: 8),
            Text('Status: ${data['status']}'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.check, color: Colors.green),
                  onPressed: () => _approveServiceProvider(context, data),
                ),
                IconButton(
                  icon: Icon(Icons.close, color: Colors.red),
                  onPressed: () =>
                      _rejectServiceProvider(context, data['docId']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to show a large image in a dialog
  void _showLargeImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: PhotoView(
                  imageProvider: NetworkImage(imageUrl),
                  backgroundDecoration:
                      BoxDecoration(color: Colors.transparent),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to approve a service provider
  Future<void> _approveServiceProvider(
      BuildContext context, Map<String, dynamic> data) async {
    try {
      data['status'] = 'accepted';
      await FirebaseFirestore.instance
          .collection('service_providers')
          .add(data);  // Add data to the service_providers collection
      await FirebaseFirestore.instance
          .collection('form')
          .doc(data['docId'])
          .update({'status': 'accepted'});  // Update the status in the form collection
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Service provider approved')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error approving service provider: $e')));
    }
  }

  // Function to reject a service provider
  Future<void> _rejectServiceProvider(
      BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('form')
          .doc(docId)
          .update({'status': 'rejected'});  // Update the status in the form collection
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Service provider rejected')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error rejecting service provider: $e')));
    }
  }
}

// Widget to display details of a user
class UserDetail extends StatelessWidget {
  final Map<String, dynamic> data;

  UserDetail({required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('User Name: ${data['firstName']} ${data['lastName']}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Email: ${data['email']}'),
            SizedBox(height: 8),
            Text('User Type: ${data['userType']}'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteUser(context, data['docId']),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Function to delete a user
  Future<void> _deleteUser(BuildContext context, String docId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).delete();  // Delete the user document from the collection
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('User deleted')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting user: $e')));
    }
  }
}

// Dashboard widget displaying charts and statistics
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('form').snapshots(),  // Fetch data from Firestore
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());  // Show loading indicator if data is not yet available
        }

        var docs = snapshot.data!.docs;
        var pendingProviders =
            docs.where((doc) => doc['status'] == 'pending').length;
        var acceptedProviders =
            docs.where((doc) => doc['status'] == 'accepted').length;
        var rejectedProviders =
            docs.where((doc) => doc['status'] == 'rejected').length;

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Service Providers',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Expanded(
                child: _buildPieChart([
                  _ChartData('Pending', pendingProviders),
                  _ChartData('Accepted', acceptedProviders),
                  _ChartData('Rejected', rejectedProviders),
                ]),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Pending', pendingProviders, Colors.orange),
                  _buildStatCard('Accepted', acceptedProviders, Colors.blue),
                  _buildStatCard('Rejected', rejectedProviders, Colors.pink),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Function to build a pie chart with given data
  Widget _buildPieChart(List<_ChartData> data) {
    var series = [
      charts.Series<_ChartData, String>(
        id: 'Service Providers',
        domainFn: (datum, _) => datum.status,
        measureFn: (datum, _) => datum.count,
        data: data,
        labelAccessorFn: (datum, _) => '${datum.count}',
        colorFn: (datum, _) {
          switch (datum.status) {
            case 'Pending':
              return charts.MaterialPalette.red.shadeDefault;
            case 'Accepted':
              return charts.MaterialPalette.blue.shadeDefault;
            case 'Rejected':
              return charts.MaterialPalette.pink.shadeDefault;
            default:
              return charts.MaterialPalette.gray.shadeDefault;
          }
        },
      ),
    ];

    return charts.PieChart<String>(
      series,
      animate: true,
      behaviors: [
        charts.DatumLegend(
          position: charts.BehaviorPosition.bottom,
          outsideJustification: charts.OutsideJustification.middleDrawArea,
          horizontalFirst: false,
          desiredMaxRows: 2,
          cellPadding: const EdgeInsets.only(right: 4.0, bottom: 4.0),
        ),
      ],
      defaultRenderer: charts.ArcRendererConfig<String>(
        arcWidth: 60,
        arcRendererDecorators: [
          charts.ArcLabelDecorator(
            labelPosition: charts.ArcLabelPosition.inside,
          ),
        ],
      ),
    );
  }

  // Function to build a card showing the count of providers in each status
  Widget _buildStatCard(String title, int count, Color color) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: color),
            ),
            SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// Class to hold chart data
class _ChartData {
  final String status;
  final int count;

  _ChartData(this.status, this.count);
}