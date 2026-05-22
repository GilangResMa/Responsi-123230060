import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/spell_controller.dart';
import '../../app/routes/app_pages.dart';

class SpellView extends StatelessWidget {
  const SpellView({super.key});

  @override
  Widget build(BuildContext context) {
    final spellController = Get.find<SpellController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hari Poah Spells'),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Get.toNamed(Routes.favoriteSpells),
          ),
        ],
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

        if (spellController.spells.isEmpty) {
          return const Center(child: Text('No spells found'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: spellController.spells.length,
          itemBuilder: (context, index) {
            final spell = spellController.spells[index];
            final isFavorited = spellController.favoriteSpells
                .any((fav) => fav.index == spell.index);

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  spell.spell?.toString() ?? '',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(spell.use?.toString() ?? ''),
                trailing: IconButton(
                  icon: Icon(
                    isFavorited ? Icons.favorite : Icons.favorite_border,
                    color: isFavorited ? Colors.red : null,
                  ),
                  onPressed: () {
                    spellController.toggleFavoriteSpell(spell);
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
