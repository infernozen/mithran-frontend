import 'package:flutter/material.dart';
import '../controllers/crop_controller.dart';
import '../widgets/crop_widgets.dart';

class CropListPage extends StatelessWidget {
  final CropController cropController;

  CropListPage({Key? key, required this.cropController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CropSearchDelegate(cropController: cropController),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: cropController.fetchCrops(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List crops = snapshot.data as List;
            return CropListWidget(crops: crops);
          } else {
            return Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}

class CropSearchDelegate extends SearchDelegate<String> {
  final CropController cropController;

  CropSearchDelegate({required this.cropController});

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: cropController.fetchCrops(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final crops = snapshot.data as List;
          final suggestions = crops.where((crop) {
            return crop.name.toLowerCase().contains(query.toLowerCase());
          }).toList();

          return ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) {
              final crop = suggestions[index];
              return ListTile(
                leading: Image.asset(crop.imageUrl),
                title: Text(crop.name),
                subtitle: Text(crop.description),
                onTap: () {
                  close(context, crop.name);
                },
              );
            },
          );
        } else {
          return Center(child: Text('No data available'));
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = cropController.fetchCrops().then((crops) {
      return crops.where((crop) {
        return crop.name.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });

    return FutureBuilder(
      future: results,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          final results = snapshot.data as List;
          return ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final crop = results[index];
              return ListTile(
                leading: Image.asset(crop.imageUrl),
                title: Text(crop.name),
                subtitle: Text(crop.description),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CropDetailPage(crop: crop),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return Center(child: Text('No results found'));
        }
      },
    );
  }
}

class CropDetailPage extends StatelessWidget {
  final Crop crop;

  CropDetailPage({Key? key, required this.crop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(crop.imageUrl),
            SizedBox(height: 16),
            Text(
              crop.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              crop.description,
              style: TextStyle(fontSize: 16),
            ),
            // Additional crop details can be added here
          ],
        ),
      ),
    );
  }
}
