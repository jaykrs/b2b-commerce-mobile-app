import 'package:flutter/material.dart';
import 'package:grocery/core/constants/apiCall.dart';
import 'package:grocery/core/models/userModel.dart';

import '../../core/constants/constants.dart';
import '../../core/routes/app_routes.dart';
import 'components/category_tile.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<Category> categories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    try {
      final data = await getCategories(); // fetch from API or local
      setState(() {
        categories = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      debugPrint('Error fetching categories: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        //Navigator.pushAndRemoveUntil(context, AppRoutes.entryPoint, (route)=> false)
         Navigator.pushNamed(context, AppRoutes.entryPoint);
        return false;
      },
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              'Choose a category',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : categories.isEmpty
                      ? const Center(child: Text('No categories found'))
                      : GridView.builder(
                          padding: const EdgeInsets.all(AppDefaults.padding),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio:
                                0.8, // makes tile taller if needed
                          ),
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return CategoryTile(
                              imageLink: "", // add category.image if available
                              label: category.name,
                              backgroundColor: AppColors.primary,
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.categoryDetails,
                                  arguments: {
                                    'categoryId': category.id,
                                    'categoryName': category.name,
                                  },
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
