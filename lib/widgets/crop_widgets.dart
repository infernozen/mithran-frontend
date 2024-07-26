import 'package:flutter/material.dart';
import '../models/crop_model.dart';

class CropListWidget extends StatelessWidget {
  final List<Crop> crops;

  CropListWidget({required this.crops});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crop List'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: CropSearchDelegate(crops));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CropList(crops: crops),
      ),
    );
  }
}

// A widget that displays a list of crops with additional features
class CropList extends StatelessWidget {
  final List<Crop> crops;

  CropList({required this.crops});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: crops.length,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        final crop = crops[index];
        return CropListItem(crop: crop);
      },
    );
  }
}

// A widget that represents a single crop item in the list
class CropListItem extends StatelessWidget {
  final Crop crop;

  CropListItem({required this.crop});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CropImage(imageUrl: crop.imageUrl),
      title: Text(crop.name),
      subtitle: Text(crop.description),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CropDetailScreen(crop: crop),
          ),
        );
      },
    );
  }
}

// A widget to display the crop image with custom styling
class CropImage extends StatelessWidget {
  final String imageUrl;

  CropImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(color: Colors.grey),
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

// A screen to display detailed information about a crop
class CropDetailScreen extends StatelessWidget {
  final Crop crop;

  CropDetailScreen({required this.crop});

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
            CropImage(imageUrl: crop.imageUrl),
            SizedBox(height: 16.0),
            Text(
              crop.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              crop.description,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

// A search delegate to allow users to search for crops
class CropSearchDelegate extends SearchDelegate<String> {
  final List<Crop> crops;

  CropSearchDelegate(this.crops);

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = crops.where((crop) {
      return crop.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final crop = suggestions[index];
        return ListTile(
          leading: CropImage(imageUrl: crop.imageUrl),
          title: Text(crop.name),
          subtitle: Text(crop.description),
          onTap: () {
            close(context, crop.name);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = crops.where((crop) {
      return crop.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final crop = results[index];
        return ListTile(
          leading: CropImage(imageUrl: crop.imageUrl),
          title: Text(crop.name),
          subtitle: Text(crop.description),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CropDetailScreen(crop: crop),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget buildBottomSheet(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        'Search results for: $query',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}
