import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/house_controller.dart';

class HouseView extends StatelessWidget {
  const HouseView({super.key});

  @override
  Widget build(BuildContext context) {
    final houseController = Get.find<HouseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hari Poah Houses'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Obx(
        () {
          if (houseController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (houseController.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(houseController.error.value),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () => houseController.fetchHouses(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (houseController.houses.isEmpty) {
            return const Center(child: Text('No houses found'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: houseController.houses.length,
            itemBuilder: (context, index) {
              final house = houseController.houses[index];
              final isSelected =
                  houseController.selectedHouse.value?.id == house.id;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                color: isSelected ? Colors.orange.shade50 : null,
                child: ListTile(
                  leading: Text(
                    house.emoji,
                    style: const TextStyle(fontSize: 32),
                  ),
                  title: Text(
                    house.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Founder: ${house.founder}'),
                  trailing: isSelected
                      ? const Icon(Icons.check, color: Colors.green)
                      : null,
                  onTap: () {
                    houseController.selectHouse(house);
                    Get.snackbar(
                      'Selected',
                      '${house.name} selected',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 1),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
