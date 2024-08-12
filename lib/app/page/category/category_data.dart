import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/api.dart';
import '../../model/category.dart';
import 'category_add.dart';

class CategoryBuilder extends StatefulWidget {
  const CategoryBuilder({Key? key}) : super(key: key);

  @override
  State<CategoryBuilder> createState() => _CategoryBuilderState();
}

class _CategoryBuilderState extends State<CategoryBuilder> {
  Future<List<CategoryModel>> _getCategorys() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return await APIRepository().getCategory(
        prefs.getString('accountID').toString(),
        prefs.getString('token').toString());
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CategoryModel>>(
      future: _getCategorys(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("Không tìm thấy danh mục nào", style: TextStyle(color: Colors.black, fontSize: 24)),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final itemCat = snapshot.data![index];
              return _buildCategory(itemCat, context);
            },
          ),
        );
      },
    );
  }

  Widget _buildCategory(CategoryModel breed, BuildContext context) {
    return Dismissible(
      key: ValueKey<int>(breed.id), // Use ValueKey with int id
      direction: DismissDirection.endToStart, // Swipe from right to left
      onDismissed: (direction) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        await APIRepository().removeCategory(
            breed.id,
            pref.getString('accountID').toString(),
            pref.getString('token').toString());

        // Remove the item from the list
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${breed.name} đã được xóa'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        color: const Color.fromARGB(
            255, 44, 119, 210), // Background color for swipe action
        child: const Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Icon(
              Icons.delete,
              color: Colors.black, // Icon color
            ),
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 4.0), // Spacing between cards
        elevation: 2.0, // Card elevation
        shape: RoundedRectangleBorder( // Card border radius
          borderRadius: BorderRadius.circular(8.0),
        ),
        color: Colors.white, // Card background color
        child: InkWell( // Ripple effect on tap
          onTap: () {
            // Handle card tap (e.g., show details)
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white70, width: 2),
                    ),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: breed.imageUrl == null ||
                          breed.imageUrl == '' ||
                          breed.imageUrl == 'Null'
                          ? Image.asset('assets/images/placeholder.png')
                          : Image.network(breed.imageUrl),
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to the start for better layout
                    children: [
                      Text(
                        breed.name,
                        style: GoogleFonts.rowdies(
                          fontSize: 25.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black, // Text color
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        breed.desc,
                        style: GoogleFonts.rowdies(
                          fontWeight: FontWeight.w300,
                          color: Colors.black, // Description text color
                        ),
                        maxLines: 1, // Limit the description to one line
                        overflow: TextOverflow.ellipsis, // Show ellipsis if description is too long
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (_) => CategoryAdd(
                          isUpdate: true,
                          categoryModel: breed,
                        ),
                        fullscreenDialog: true,
                      ),
                    )
                        .then((_) => setState(() {}));
                  },
                  icon: const Icon(
                    Icons.edit,
                    color: Color.fromARGB(
                        255, 44, 119, 210), // Edit icon color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
