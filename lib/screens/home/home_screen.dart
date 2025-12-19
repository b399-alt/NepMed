import 'package:flutter/material.dart';
import '../../utils/responsive.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const List<Map<String, dynamic>> _categories = [
    {'name': 'Lungs', 'icon': Icons.air, 'color': Color(0xFFFF6B6B)},
    {'name': 'Kidney', 'icon': Icons.water_drop, 'color': Color(0xFF4ECDC4)},
    {'name': 'Eye', 'icon': Icons.visibility, 'color': Color(0xFFFFD93D)},
    {'name': 'Heart', 'icon': Icons.favorite, 'color': Color(0xFFFF6B6B)},
    {'name': 'Infection', 'icon': Icons.coronavirus, 'color': Color(0xFF6C5CE7)},
    {'name': 'Bone', 'icon': Icons.accessibility_new, 'color': Color(0xFFA29BFE)},
  ];

  static List<Map<String, String>> _medicinesFor(String category) {
    final data = {
      'Heart': [
        {'name': 'Paracetamol', 'price': '99', 'image': 'paracetamol'},
        {'name': 'Cardichek', 'price': '399', 'image': 'cardichek'},
      ],
      'Lungs': [
        {'name': 'Lungs Cleaner', 'price': '799', 'image': 'lungs_cleaner'},
        {'name': 'OPL Original', 'price': '899', 'image': 'opl'},
      ],
      'Kidney': [
        {'name': 'MyoCoft', 'price': '899', 'image': 'myocoft'},
        {'name': 'Kanopas', 'price': '599', 'image': 'kanopas'},
      ],
      'Infection': [
        {'name': 'Azithromycin', 'price': '565', 'image': 'azithro'},
        {'name': 'Flagyl', 'price': '399', 'image': 'flagyl'},
      ],
    };
    return data[category] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final isTab = Responsive.isTablet(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFF),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "WELCOME USER, HOME",
          style: TextStyle(
            color: Colors.black87,
            fontSize: Responsive.scale(context, 16),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isTab ? 28 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: Responsive.scale(context, 120),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
                itemBuilder: (context, i) {
                  final cat = _categories[i];

                  return Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: Responsive.scale(context, 32),
                          backgroundColor: (cat['color'] as Color).withOpacity(0.2),
                          child: Icon(
                            cat['icon'] as IconData,
                            size: Responsive.scale(context, 36),
                            color: cat['color'] as Color,
                          ),
                        ),
                        SizedBox(height: Responsive.scale(context, 8)),
                        Text(
                          cat['name'] as String,
                          style: TextStyle(
                            fontSize: Responsive.scale(context, 12),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: Responsive.scale(context, 30)),

            TextField(
              decoration: InputDecoration(
                hintText: "Search for medicine",
                prefixIcon: Icon(Icons.search, size: Responsive.scale(context, 24), color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                    vertical: Responsive.scale(context, 16)),
              ),
            ),

            SizedBox(height: Responsive.scale(context, 30)),

            ..._categories.map((cat) {
              final categoryName = cat['name'] as String;
              final items = _medicinesFor(categoryName);

              if (items.isEmpty) return const SizedBox.shrink();

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categoryName,
                    style: TextStyle(
                      fontSize: Responsive.scale(context, 18),
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: Responsive.scale(context, 12)),
                  SizedBox(
                    height: Responsive.scale(context, 180),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, i) {
                        final med = items[i];

                        return Container(
                          width: Responsive.scale(context, 140),
                          margin: const EdgeInsets.only(right: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                height: Responsive.scale(context, 90),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F4FF),
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                                  image: DecorationImage(
                                    image: AssetImage('assets/medicines/${med['image']}.png'),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.medication,
                                    size: Responsive.scale(context, 50),
                                    color: Colors.blue[300],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(Responsive.scale(context, 10)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      med['name']!,
                                      style: TextStyle(
                                        fontSize: Responsive.scale(context, 14),
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    SizedBox(height: Responsive.scale(context, 4)),
                                    Text(
                                      "Starting at ₹${med['price']}",
                                      style: TextStyle(
                                        fontSize: Responsive.scale(context, 12),
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: Responsive.scale(context, 8)),
                                    Row(
                                      children: [
                                        Text(
                                          "Shop Now",
                                          style: TextStyle(
                                            fontSize: Responsive.scale(context, 12),
                                            color: Colors.blue,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Icon(Icons.arrow_forward,
                                            size: Responsive.scale(context, 16),
                                            color: Colors.blue),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: Responsive.scale(context, 30)),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}