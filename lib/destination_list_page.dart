import 'package:flutter/material.dart';
import 'add_destination_page.dart';
import 'update_destination_page.dart';
import 'destination_service.dart';
import 'destination_model.dart';

class DestinationListPage extends StatelessWidget {
  const DestinationListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Destinations")),
      body: StreamBuilder<List<Destination>>(
        stream: destinationService.getDestinations(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final destinations = snapshot.data!;
          if (destinations.isEmpty) return const Center(child: Text("No destinations found"));
          return ListView.builder(
            itemCount: destinations.length,
            itemBuilder: (context, index) {
              final destination = destinations[index];
              return ListTile(
                leading: Image.network(destination.imageUrl, width: 60, height: 60, fit: BoxFit.cover),
                title: Text(destination.name),
                subtitle: Text(destination.location),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => UpdateDestinationPage(destination: destination),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => destinationService.deleteDestination(destination.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const AddDestinationPage()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
