import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PackageImageScreen extends StatefulWidget {
  final List<String> imageUrls;
  final List<String> packageNames;

  const PackageImageScreen({
    Key? key,
    required this.imageUrls,
    required this.packageNames,
  }) : super(key: key);

  @override
  _PackageImageScreenState createState() => _PackageImageScreenState();
}

class _PackageImageScreenState extends State<PackageImageScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _pageController.addListener(() {
      setState(() {
        _currentIndex = _pageController.page!.round();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        title: const Text(
          'Package Images',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black54,
      ),
      backgroundColor: Colors.black54,
      body: widget.imageUrls.isEmpty
          ? const Center(
              child: Text(
                'This Order\'s Packages Have No Image',
                style: TextStyle(color: Colors.white),
              ),
            )
          : Stack(
              children: [
                Container(
                  color: Colors.black54,
                  child: PageView.builder(
                    itemCount: widget.imageUrls.length,
                    controller: _pageController,
                    itemBuilder: (context, index) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            widget.packageNames[index],
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 64.0),
                              child: CachedNetworkImage(
                                imageUrl: widget.imageUrls[index],
                                fit: BoxFit.contain,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                if (_currentIndex > 0)
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2,
                    left: 0,
                    child: IconButton(
                      onPressed: () {
                        _pageController.previousPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.arrow_back),
                    ),
                  ),
                if (_currentIndex < widget.imageUrls.length - 1)
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2,
                    right: 0,
                    child: IconButton(
                      onPressed: () {
                        _pageController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
              ],
            ),
    );
  }
}
