import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/Services/disease_service.dart';
import 'package:arbtilant/core/constants/colors.dart';
import 'package:arbtilant/Pages/disease_detail_page.dart';
import 'package:arbtilant/Widgets/custom_bottom_nav.dart';
import 'package:arbtilant/Pages/home_page.dart';
import 'package:arbtilant/Pages/scan_page.dart';
import 'package:arbtilant/Pages/history_page.dart';

class LibraryPageNew extends StatefulWidget {
  const LibraryPageNew({super.key});

  @override
  State<LibraryPageNew> createState() => _LibraryPageNewState();
}

class _LibraryPageNewState extends State<LibraryPageNew> {
  final DiseaseService _diseaseService = DiseaseService();
  final TextEditingController _searchController = TextEditingController();

  List<DiseaseModel> _diseases = [];
  List<DiseaseModel> _filteredDiseases = [];
  bool _isLoading = true;
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];
  int _selectedIndex = 2;

  @override
  void initState() {
    super.initState();
    _loadDiseases();
  }

  Future<void> _loadDiseases() async {
    try {
      setState(() => _isLoading = true);

      final diseases = await _diseaseService.getAllDiseases();
      final categories = await _diseaseService.getAllCategories();

      setState(() {
        _diseases = diseases;
        _filteredDiseases = diseases;
        _categories = ['All', ...categories];
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  void _filterDiseases() {
    String query = _searchController.text.toLowerCase();

    setState(() {
      _filteredDiseases = _diseases.where((disease) {
        bool matchesSearch =
            disease.name.toLowerCase().contains(query) ||
            disease.englishName.toLowerCase().contains(query);

        bool matchesCategory =
            _selectedCategory == 'All' || disease.category == _selectedCategory;

        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ScanPage()),
      );
    } else if (index == 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HistoryPage()),
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBgSecondary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Disease library',
          style: GoogleFonts.poppins(
            color: AppColors.textWhite,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.brightGreen),
            )
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => _filterDiseases(),
                          style: GoogleFonts.poppins(
                            color: AppColors.textWhite,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Arbtilant',
                            hintStyle: GoogleFonts.poppins(
                              color: AppColors.textGray,
                            ),
                            prefixIcon: Icon(
                              Icons.search,
                              color: AppColors.textGray,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(24),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.brightGreen,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.tune, color: Colors.black),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),

                // Category Filter
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      final isSelected = _selectedCategory == category;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: FilterChip(
                          label: Text(
                            category,
                            style: GoogleFonts.poppins(
                              color: isSelected
                                  ? Colors.black
                                  : AppColors.textGray,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          backgroundColor: isSelected
                              ? AppColors.brightGreen
                              : AppColors.darkBgSecondary,
                          onSelected: (selected) {
                            setState(() {
                              _selectedCategory = category;
                            });
                            _filterDiseases();
                          },
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 16),

                // Disease Grid
                Expanded(
                  child: _filteredDiseases.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.search_off,
                                size: 64,
                                color: AppColors.textGray,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No diseases found',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textGray,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 0.85,
                              ),
                          itemCount: _filteredDiseases.length,
                          itemBuilder: (context, index) {
                            final disease = _filteredDiseases[index];
                            return _buildDiseaseCard(disease);
                          },
                        ),
                ),
              ],
            ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildDiseaseCard(DiseaseModel disease) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiseaseDetailPage(disease: disease),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkBgSecondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColors.darkBgTertiary,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: disease.imageUrl != null && disease.imageUrl!.isNotEmpty
                    ? Image.asset(
                        disease.imageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.image_not_supported,
                            color: AppColors.textGray,
                            size: 32,
                          );
                        },
                      )
                    : Icon(
                        Icons.image_not_supported,
                        color: AppColors.textGray,
                        size: 32,
                      ),
              ),
            ),

            // Info
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(
                        Icons.check_circle,
                        size: 12,
                        color: AppColors.brightGreen,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        disease.severity,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: AppColors.textGray,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
