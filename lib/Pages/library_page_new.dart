import 'package:flutter/material.dart';
import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/Services/disease_service.dart';
import 'package:arbtilant/core/design_system/index.dart';
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
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        centerTitle: true,
        title: Text('Disease Library', style: AppTypography.headline()),
        leading: const SizedBox(),
        actions: [
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(color: AppColors.brightGreen),
            )
          : Column(
              children: [
                _buildSearchBar(),
                _buildCategoryFilter(),
                Expanded(
                  child: _filteredDiseases.isEmpty
                      ? _buildEmptyState()
                      : SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                  vertical: AppSpacing.lg,
                                ),
                                child: Text(
                                  'POPULAR DIAGNOSES',
                                  style: AppTypography.bodySmall(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                              GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.lg,
                                ),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: AppSpacing.md,
                                      mainAxisSpacing: AppSpacing.md,
                                      childAspectRatio: 0.85,
                                    ),
                                itemCount: _filteredDiseases.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  final disease = _filteredDiseases[index];
                                  return _buildDiseaseCard(disease);
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.lg,
                                ),
                                child: Center(
                                  child: Text(
                                    'LOAD MORE DISEASES',
                                    style: AppTypography.bodySmall(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _filterDiseases(),
              style: AppTypography.bodyLarge(),
              decoration: InputDecoration(
                hintText: 'Search diseases, symptoms...',
                hintStyle: AppTypography.bodyMedium(
                  color: AppColors.textTertiary,
                ),
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    AppSpacing.cardBorderRadius,
                  ),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            decoration: BoxDecoration(
              color: AppColors.brightGreen,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.tune, color: AppColors.darkBackground),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = _selectedCategory == category;

          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: FilterChip(
              label: Text(
                category,
                style: AppTypography.label(
                  color: isSelected
                      ? AppColors.darkBackground
                      : AppColors.textSecondary,
                ),
              ),
              backgroundColor: isSelected
                  ? AppColors.brightGreen
                  : AppColors.lightSurface,
              selectedColor: AppColors.brightGreen,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                });
                _filterDiseases();
              },
              side: BorderSide.none,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppSpacing.chipBorderRadius,
                ),
              ),
            ),
          );
        },
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
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.cardBorderRadius),
          border: Border.all(color: AppColors.lightSurface, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(AppSpacing.cardBorderRadius),
                  topRight: Radius.circular(AppSpacing.cardBorderRadius),
                ),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(color: AppColors.lightSurface),
                  child:
                      disease.imageUrl != null && disease.imageUrl!.isNotEmpty
                      ? Image.asset(
                          disease.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.image_not_supported,
                              color: AppColors.textTertiary,
                            );
                          },
                        )
                      : Icon(
                          Icons.image_not_supported,
                          color: AppColors.textTertiary,
                        ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    disease.name,
                    style: AppTypography.label(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: _getSeverityColor(
                        disease.severity,
                      ).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      disease.severity,
                      style: AppTypography.bodySmall(
                        color: _getSeverityColor(disease.severity),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: AppSpacing.iconXLarge,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No diseases found',
            style: AppTypography.bodyLarge(color: AppColors.textTertiary),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return AppColors.error;
      case 'medium':
        return AppColors.warning;
      case 'low':
        return AppColors.success;
      default:
        return AppColors.info;
    }
  }
}
