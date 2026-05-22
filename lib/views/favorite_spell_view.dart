import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/spell_controller.dart';

class FavoriteSpellView extends StatelessWidget {
  const FavoriteSpellView({super.key});

  @override
  Widget build(BuildContext context) {
    final spellController = Get.find<SpellController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Spells'),
        backgroundColor: Colors.indigo,
        elevation: 0,
      ),
      body: Obx(() {
        if (spellController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (spellController.error.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(spellController.error.value),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => spellController.fetchSpells(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        if (spellController.favoriteSpells.isEmpty) {
          return const Center(
            child: Text('No favorite spells yet'),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: spellController.favoriteSpells.length,
          itemBuilder: (context, index) {
            final spell = spellController.favoriteSpells[index];

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  spell.spell?.toString() ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(spell.use?.toString() ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.favorite, color: Colors.red),
                  onPressed: () {
                    spellController.removeFavoriteSpell(spell);
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
