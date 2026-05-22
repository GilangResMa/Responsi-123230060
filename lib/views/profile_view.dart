import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/house_controller.dart';
import '../../app/routes/app_pages.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TextEditingController feedbackController;

  @override
  void initState() {
    super.initState();
    feedbackController = TextEditingController(
      text: 'Jujurr sebenernya materinya menarik dan menyenangkan untuk dipelajari. '
          'Kalau dari cara mengajar si udah mantul yaa (mantap betul).'
          'Tapi.. cukup pusing ketika lagi ngerjain tugas atau buat projectnya. ',
    );
  }

  @override
  void dispose() {
    feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final houseController = Get.find<HouseController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.indigo,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authController.logout();
              Get.offAllNamed(Routes.login);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Picture
            Obx(
              () => Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.teal.shade100,
                ),
                child: Center(
                  child: Text(
                    authController.username.value.isNotEmpty
                        ? authController.username.value[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Username
            Obx(
              () => Text(
                authController.username.value,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 30),

            // House Section
            Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selected House',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    if (houseController.selectedHouse.value == null) {
                      return const Text('No house selected yet');
                    }

                    final house = houseController.selectedHouse.value!;
                    return Row(
                      children: [
                        Text(house.emoji, style: const TextStyle(fontSize: 32)),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              house.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('Founder: ${house.founder}'),
                          ],
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Feedback Section
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Kesan & Pesan Praktikum TPM',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Tulis kesan dan pesan Anda di sini...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(15),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
