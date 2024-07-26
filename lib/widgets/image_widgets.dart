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
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              // Implement filter functionality
              showModalBottomSheet(
                context: context,
                builder: (context) => FilterOptions(),
              );
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

class CropList extends StatelessWidget {
  final List<Crop> crops;

  CropList({required this.crops});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: crops.length,
      separatorBuilder: (context, index) => Divider(height: 2, color: Colors.grey[400]),
      itemBuilder: (context, index) {
        final crop = crops[index];
        return CropListItem(crop: crop);
      },
    );
  }
}

class CropListItem extends StatelessWidget {
  final Crop crop;

  CropListItem({required this.crop});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CropImage(imageUrl: crop.imageUrl),
      title: Text(crop.name, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(crop.description),
      trailing: Icon(Icons.arrow_forward_ios, size: 16),
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

class CropImage extends StatelessWidget {
  final String imageUrl;

  CropImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
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

class CropDetailScreen extends StatelessWidget {
  final Crop crop;

  CropDetailScreen({required this.crop});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(crop.name),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditCropScreen(crop: crop),
                ),
              );
            },
          ),
        ],
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
            SizedBox(height: 16.0),
            Text(
              'Additional Information:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scientific Name: ${crop.scientificName}',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Harvest Time: ${crop.harvestTime} days',
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Optimal Climate: ${crop.optimalClimate}',
                      style: TextStyle(fontSize: 16),
                    ),
                    // Add more fields as necessary
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

class EditCropScreen extends StatefulWidget {
  final Crop crop;

  EditCropScreen({required this.crop});

  @override
  _EditCropScreenState createState() => _EditCropScreenState();
}

class _EditCropScreenState extends State<EditCropScreen> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _scientificNameController;
  late TextEditingController _harvestTimeController;
  late TextEditingController _optimalClimateController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.crop.name);
    _descriptionController = TextEditingController(text: widget.crop.description);
    _scientificNameController = TextEditingController(text: widget.crop.scientificName);
    _harvestTimeController = TextEditingController(text: widget.crop.harvestTime.toString());
    _optimalClimateController = TextEditingController(text: widget.crop.optimalClimate);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _scientificNameController.dispose();
    _harvestTimeController.dispose();
    _optimalClimateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Crop'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save the edited crop information
              // For example, save it to a database or update the UI
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Crop Information',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _scientificNameController,
              decoration: InputDecoration(labelText: 'Scientific Name'),
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _harvestTimeController,
              decoration: InputDecoration(labelText: 'Harvest Time (days)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 8.0),
            TextField(
              controller: _optimalClimateController,
              decoration: InputDecoration(labelText: 'Optimal Climate'),
            ),
            // Add more fields as necessary
          ],
        ),
      ),
    );
  }
}

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

class FilterOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Filter Options',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          // Example filter options
          CheckboxListTile(
            title: Text('Show only seasonal crops'),
            value: true,
            onChanged: (bool? value) {
              // Implement filter logic
            },
          ),
          CheckboxListTile(
            title: Text('Show organic crops'),
            value: false,
            onChanged: (bool? value) {
              // Implement filter logic
            },
          ),
          // Add more filter options as necessary
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Apply Filters'),
          ),
        ],
      ),
    );
  }
}
