import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class ModelController {
  Interpreter? _interpreter;
  List<String>? _labels;

  Future<void> loadModel() async {
    _interpreter = await Interpreter.fromAsset("assets/model/model.tflite");
    _labels = await _loadLabels("assets/model/labels.txt");
  }

  Future<List<String>> _loadLabels(String path) async {
    final labelsData = await rootBundle.loadString(path);
    return labelsData.split('\n').where((label) => label.isNotEmpty).toList();
  }

  Future<List<Map<String, dynamic>>> runModelOnImage(String imagePath) async {
    if (_interpreter == null) throw Exception("Model not loaded");

    
    final image = await _loadImage(imagePath);
    final input = _preprocessImage(image);

   
    final output = List.filled(
      1 * _labels!.length,
      0.0,
    ).reshape([1, _labels!.length]);
    _interpreter!.run(input, output);

    
    final results = <Map<String, dynamic>>[];
    final probabilities = output[0] as List<double>;
    final sortedIndices = List.generate(probabilities.length, (i) => i)
      ..sort((a, b) => probabilities[b].compareTo(probabilities[a]));

    for (int i = 0; i < 3 && i < sortedIndices.length; i++) {
      final index = sortedIndices[i];
      results.add({
        'index': index,
        'label': _labels![index],
        'confidence': probabilities[index],
      });
    }

    return results;
  }

  Future<Uint8List> _loadImage(String path) async {
    final file = File(path);
    return await file.readAsBytes();
  }

  List<List<List<List<double>>>> _preprocessImage(Uint8List imageBytes) {
    // Decode image dan risize ukuran input model nya asumsi ke 224 x 224 
    final image = img.decodeImage(imageBytes)!;
    final resized = img.copyResize(image, width: 224, height: 224);

    
    final input = List.generate(
      1,
      (i) => List.generate(
        224,
        (y) => List.generate(
          224,
          (x) => List.generate(3, (c) {
            final pixel = resized.getPixel(x, y);
            final channel = c == 0
                ? pixel.r.toDouble()
                : c == 1
                ? pixel.g.toDouble()
                : pixel.b.toDouble();
            return (channel - 127.5) / 127.5;
          }),
        ),
      ),
    );

    return input;
  }
}
