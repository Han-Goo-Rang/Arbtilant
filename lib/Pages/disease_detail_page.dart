import 'package:flutter/material.dart';
import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/core/design_system/index.dart';
import 'package:arbtilant/core/widgets/index.dart';
import 'package:arbtilant/Pages/scan_page.dart';

class DiseaseDetailPage extends StatefulWidget {
  final DiseaseModel disease;

  const DiseaseDetailPage({super.key, required this.disease});

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text('Disease Details', style: AppTypography.headline()),
        actions: [IconButton(icon: const Icon(Icons.share), onPressed: () {})],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Image
            _buildHeroImage(),

            // Disease Info
            _buildDiseaseInfo(),

            // Symptoms Section
            _buildSymptoms(),

            // Causes Section
            _buildCauses(),

            // Treatment Section
            _buildTreatment(),

            // Prevention Section
            _buildPrevention(),

            // Affected Plants Section
            if (widget.disease.affectedPlants.isNotEmpty)
              _buildAffectedPlants(),

            // Action Buttons
            _buildActionButtons(),

            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  /// Build hero image section
  Widget _buildHeroImage() {
    return Container(
      width: double.infinity,
      height: 280,
      color: AppColors.lightSurface,
      child:
          widget.disease.imageUrl != null && widget.disease.imageUrl!.isNotEmpty
          ? Image.asset(
              widget.disease.imageUrl!,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  size: AppSpacing.iconXLarge,
                  color: AppColors.textTertiary,
                );
              },
            )
          : Icon(
              Icons.image_not_supported,
              size: AppSpacing.iconXLarge,
              color: AppColors.textTertiary,
            ),
    );
  }

  /// Build disease info section
  Widget _buildDiseaseInfo() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text(widget.disease.name, style: AppTypography.displayMedium()),

          const SizedBox(height: AppSpacing.xs),

          // English Name
          Text(widget.disease.englishName, style: AppTypography.bodyMedium()),

          const SizedBox(height: AppSpacing.md),

          // Severity Badge
          AppSeverityChip(severity: widget.disease.severity),

          const SizedBox(height: AppSpacing.md),

          // Description
          Text(widget.disease.description, style: AppTypography.bodyLarge()),

          if (widget.disease.scientificNames.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text('Scientific Names', style: AppTypography.label()),
            const SizedBox(height: AppSpacing.sm),
            Text(
              widget.disease.scientificNames.join(', '),
              style: AppTypography.bodyMedium(),
            ),
          ],
        ],
      ),
    );
  }

  /// Build symptoms section
  Widget _buildSymptoms() {
    if (widget.disease.symptoms.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Symptoms', style: AppTypography.headline()),
          const SizedBox(height: AppSpacing.md),
          ...widget.disease.symptoms.map(
            (symptom) => _buildBulletItem(symptom),
          ),
        ],
      ),
    );
  }

  /// Build causes section
  Widget _buildCauses() {
    if (widget.disease.causes.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Causes', style: AppTypography.headline()),
          const SizedBox(height: AppSpacing.md),
          ...widget.disease.causes.map((cause) => _buildBulletItem(cause)),
        ],
      ),
    );
  }

  /// Build treatment section
  Widget _buildTreatment() {
    if (widget.disease.treatment.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Treatment', style: AppTypography.headline()),
          const SizedBox(height: AppSpacing.md),
          ...widget.disease.treatment.asMap().entries.map((entry) {
            return _buildNumberedItem(entry.value, entry.key + 1);
          }),
        ],
      ),
    );
  }

  /// Build prevention section
  Widget _buildPrevention() {
    if (widget.disease.prevention.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Prevention', style: AppTypography.headline()),
          const SizedBox(height: AppSpacing.md),
          ...widget.disease.prevention.map(
            (prevention) => _buildBulletItem(prevention),
          ),
        ],
      ),
    );
  }

  /// Build affected plants section
  Widget _buildAffectedPlants() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Affected Plants', style: AppTypography.headline()),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: widget.disease.affectedPlants
                .map((plant) => AppChip(label: plant, isSelected: false))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Build bullet item
  Widget _buildBulletItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brightGreen,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: AppTypography.bodyLarge())),
        ],
      ),
    );
  }

  /// Build numbered item
  Widget _buildNumberedItem(String text, int number) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.brightGreen,
            ),
            child: Center(
              child: Text(
                '$number',
                style: AppTypography.label(color: AppColors.darkBackground),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(text, style: AppTypography.bodyLarge()),
            ),
          ),
        ],
      ),
    );
  }

  /// Build action buttons
  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Column(
        children: [
          // Scan Similar Button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Scan Similar Plant',
              icon: Icons.camera_alt,
              size: AppButtonSize.large,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ScanPage()),
                );
              },
            ),
          ),

          const SizedBox(height: AppSpacing.md),

          // Share Button
          SizedBox(
            width: double.infinity,
            child: AppButton(
              label: 'Share',
              icon: Icons.share,
              size: AppButtonSize.medium,
              variant: AppButtonVariant.outlined,
              onPressed: () {},
            ),
          ),

          const SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}
