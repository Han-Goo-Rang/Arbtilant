import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:arbtilant/core/constants/colors.dart';
import 'package:arbtilant/Models/disease_model.dart';
import 'package:arbtilant/Services/disease_service.dart';

class FeedbackDialog extends StatefulWidget {
  final String predictedLabel;
  final double confidence;
  final Function(
    bool isCorrect,
    String? correctedDiseaseId,
    String? feedbackText,
    int? rating,
  )
  onSubmit;

  const FeedbackDialog({
    super.key,
    required this.predictedLabel,
    required this.confidence,
    required this.onSubmit,
  });

  @override
  State<FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<FeedbackDialog> {
  bool? _isCorrect;
  String? _selectedDiseaseId;
  final TextEditingController _feedbackController = TextEditingController();
  int _rating = 3;
  List<DiseaseModel> _diseases = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDiseases();
  }

  Future<void> _loadDiseases() async {
    try {
      final diseases = await DiseaseService().getAllDiseases();
      if (mounted) {
        setState(() {
          _diseases = diseases;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Icon(
                    Icons.feedback_outlined,
                    color: AppColors.mediumGreen,
                    size: 28,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Berikan Feedback',
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Prediction Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.eco, color: AppColors.mediumGreen),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hasil Deteksi:',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            widget.predictedLabel,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Confidence: ${(widget.confidence * 100).toStringAsFixed(1)}%',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Question
              Text(
                'Apakah hasil deteksi ini benar?',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 12),

              // Yes/No Buttons
              Row(
                children: [
                  Expanded(
                    child: _buildOptionButton(
                      label: 'Ya, Benar',
                      icon: Icons.check_circle,
                      isSelected: _isCorrect == true,
                      color: Colors.green,
                      onTap: () => setState(() => _isCorrect = true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildOptionButton(
                      label: 'Tidak',
                      icon: Icons.cancel,
                      isSelected: _isCorrect == false,
                      color: Colors.red,
                      onTap: () => setState(() => _isCorrect = false),
                    ),
                  ),
                ],
              ),

              // If incorrect, show disease selection
              if (_isCorrect == false) ...[
                const SizedBox(height: 16),
                Text(
                  'Pilih penyakit yang benar:',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : DropdownButtonFormField<String>(
                        initialValue: _selectedDiseaseId,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        hint: Text(
                          'Pilih penyakit',
                          style: GoogleFonts.poppins(fontSize: 14),
                        ),
                        items: _diseases
                            .map(
                              (disease) => DropdownMenuItem(
                                value: disease.id,
                                child: Text(
                                  disease.name,
                                  style: GoogleFonts.poppins(fontSize: 14),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() => _selectedDiseaseId = value);
                        },
                      ),
              ],

              const SizedBox(height: 16),

              // Rating
              Text(
                'Rating kepercayaan Anda:',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _rating ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () => setState(() => _rating = index + 1),
                  );
                }),
              ),

              const SizedBox(height: 16),

              // Feedback Text
              Text(
                'Komentar (opsional):',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _feedbackController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Tulis komentar Anda...',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isCorrect == null
                      ? null
                      : () {
                          widget.onSubmit(
                            _isCorrect!,
                            _selectedDiseaseId,
                            _feedbackController.text.isEmpty
                                ? null
                                : _feedbackController.text,
                            _rating,
                          );
                          Navigator.pop(context);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mediumGreen,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Kirim Feedback',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required String label,
    required IconData icon,
    required bool isSelected,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: 0.1)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isSelected ? color : Colors.grey, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isSelected ? color : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
