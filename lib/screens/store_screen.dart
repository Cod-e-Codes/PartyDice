import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        title: Text(
          'PartyDice Store',
          style: TextStyle(
            fontFamily: 'Bungee',
            fontSize: 28.sp, // Use ScreenUtil for font size
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [
              Shadow(
                blurRadius: 3.0.sp, // Use ScreenUtil for blur radius
                color: Colors.black54,
                offset: Offset(2.sp, 2.sp), // Use ScreenUtil for offset
              ),
            ],
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
            WidgetsBinding.instance.focusManager.primaryFocus?.unfocus();
          },
        ),
      ),
      body: SafeArea(
        child: CustomPaint(
          painter: StoreBackgroundPainter(),
          child: Padding(
            padding: EdgeInsets.all(8.0.w), // Use ScreenUtil for padding
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('storeItems').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final items = snapshot.data?.docs ?? [];

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index].data() as Map<String, dynamic>;
                    return GameContentCard(
                      itemId: items[index].id,
                      title: item['title'] ?? 'No title',
                      price: item['price'] ?? 'No price',
                      description: item['description'] ?? 'No description',
                      imagePath: item['imagePath'] ?? 'assets/images/placeholder.png',
                      features: List<String>.from(item['features'] ?? []),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class GameContentCard extends StatefulWidget {
  final String itemId;
  final String title;
  final String price;
  final String description;
  final String imagePath;
  final List<String> features;

  const GameContentCard({
    super.key,
    required this.itemId,
    required this.title,
    required this.price,
    required this.description,
    required this.imagePath,
    required this.features,
  });

  @override
  GameContentCardState createState() => GameContentCardState();
}

class GameContentCardState extends State<GameContentCard> {
  bool _isPurchased = false;

  @override
  void initState() {
    super.initState();
    _checkIfPurchased();
  }

  Future<void> _checkIfPurchased() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final purchaseSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('purchases')
          .doc(widget.itemId)
          .get();

      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        _isPurchased = purchaseSnapshot.exists;
      });
    } catch (e) {
      if (!mounted) return;
      // Handle error here
      debugPrint('Error checking purchase: $e');
    }
  }

  Future<void> _handlePurchase() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await userDocRef.collection('purchases').doc(widget.itemId).set({
        'itemId': widget.itemId,
        'purchasedAt': Timestamp.now(),
      });

      if (!mounted) return; // Check if the widget is still mounted

      setState(() {
        _isPurchased = true;
      });

      _showPurchaseSnackbar();
    } catch (e) {
      // Handle error here
      debugPrint('Error handling purchase: $e');
    }
  }

  void _showPurchaseSnackbar() {
    final snackBar = SnackBar(
      content: Text(
        'Purchased ${widget.title} for ${widget.price}!',
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 16.sp,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurpleAccent,
        ),
      ),
      backgroundColor: Colors.white,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0.r),
        side: BorderSide(color: Colors.black, width: 3.0.w),
      ),
      margin: EdgeInsets.all(16.0.w),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showDetailsDialog();
      },
      child: Card(
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0.r),
                topRight: Radius.circular(16.0.r),
              ),
              child: Image.asset(
                widget.imagePath,
                height: 120.h, // Limit the image height
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(4.0.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'RobotoCondensed',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.0.h),
                    Expanded(
                      child: Text(
                        widget.description,
                        style: TextStyle(
                          fontFamily: 'RobotoCondensed',
                          fontSize: 14.sp,
                          color: Colors.black54,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(height: 8.0.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.price,
                          style: TextStyle(
                            fontFamily: 'Bungee',
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.teal.shade300,
                          ),
                        ),
                        Flexible(
                          child: ElevatedButton(
                            onPressed: _isPurchased ? null : _handlePurchase,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepPurpleAccent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0.r),
                              ),
                            ),
                            child: Text(
                              _isPurchased ? 'Owned' : 'Buy Now',
                              style: TextStyle(
                                fontFamily: 'Bungee',
                                fontSize: 14.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            widget.title,
            style: TextStyle(
              fontFamily: 'Bungee',
              fontSize: 22.sp,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 180.h, // Restrict the height of the image
                  width: double.infinity,
                  child: Image.asset(
                    widget.imagePath,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  widget.description,
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Features:',
                  style: TextStyle(
                    fontFamily: 'RobotoCondensed',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                ...widget.features.map((feature) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  child: Text(
                    '- $feature',
                    style: TextStyle(
                      fontFamily: 'RobotoCondensed',
                      fontSize: 14.sp,
                    ),
                  ),
                )),
                SizedBox(height: 8.h),
                Text(
                  widget.price,
                  style: TextStyle(
                    fontFamily: 'Bungee',
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal.shade300,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            // Buttons in the same row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // "Close" and "Owned" buttons if the item is purchased
                if (_isPurchased) ...[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontFamily: 'Bungee',
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: null, // Disable since it's already purchased
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green, // Owned button color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0.r),
                      ),
                    ),
                    child: Text(
                      'Owned',
                      style: TextStyle(
                        fontFamily: 'Bungee',
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                // "Maybe Later" and "Buy Now" buttons if the item is not purchased
                if (!_isPurchased) ...[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      // Handle "Maybe Later" action here
                    },
                    child: Text(
                      'Maybe Later',
                      style: TextStyle(
                        fontFamily: 'Bungee',
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _handlePurchase, // Handle purchase
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0.r),
                      ),
                    ),
                    child: Text(
                      'Buy Now',
                      style: TextStyle(
                        fontFamily: 'Bungee',
                        fontSize: 14.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class StoreBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blueGrey.shade100
      ..style = PaintingStyle.fill;

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
