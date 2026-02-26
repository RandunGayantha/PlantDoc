import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

class Classifier {
  Interpreter? _interpreter;
  List<String> _labels = [];

  Future<void> loadModel() async {
    try {
      _interpreter = await Interpreter.fromAsset(
        'assets/models/diseaseDetection.tflite',
      );
      final labelData = await rootBundle.loadString(
        'assets/models/labels.txt',
      );
      _labels = labelData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
      print('✅ Model loaded successfully');
      print('✅ Labels: $_labels');
    } catch (e) {
      print('❌ Error loading model: $e');
    }
  }

  Future<Map<String, dynamic>> predict(File imageFile) async {
    if (_interpreter == null) {
      await loadModel();
    }
    try {
      final imageBytes = await imageFile.readAsBytes();
      img.Image? originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        return {'label': 'Unknown', 'confidence': 0.0};
      }
      img.Image resizedImage = img.copyResize(originalImage, width: 224, height: 224);
      var input = _imageToByteListFloat32(resizedImage, 224);
      var output = List.filled(1 * _labels.length, 0.0).reshape([1, _labels.length]);
      _interpreter!.run(input, output);
      List<double> scores = List<double>.from(output[0]);
      double maxScore = 0.0;
      int maxIndex = 0;
      for (int i = 0; i < scores.length; i++) {
        if (scores[i] > maxScore) {
          maxScore = scores[i];
          maxIndex = i;
        }
      }
      String predictedLabel = maxIndex < _labels.length ? _labels[maxIndex] : 'Unknown';
      print('✅ Prediction: $predictedLabel ($maxScore)');
      return {
        'label': predictedLabel,
        'confidence': maxScore,
        'allScores': Map.fromIterables(_labels, scores),
      };
    } catch (e) {
      print('❌ Prediction error: $e');
      return {'label': 'Unknown', 'confidence': 0.0};
    }
  }

  Uint8List _imageToByteListFloat32(img.Image image, int inputSize) {
    var convertedBytes = Float32List(1 * inputSize * inputSize * 3);
    var buffer = Float32List.view(convertedBytes.buffer);
    int pixelIndex = 0;
    for (int y = 0; y < inputSize; y++) {
      for (int x = 0; x < inputSize; x++) {
        var pixel = image.getPixel(x, y);
        // ✅ Fixed: use pixel.r / .g / .b instead of deprecated img.getRed/getGreen/getBlue
        buffer[pixelIndex++] = pixel.r / 255.0;
        buffer[pixelIndex++] = pixel.g / 255.0;
        buffer[pixelIndex++] = pixel.b / 255.0;
      }
    }
    return convertedBytes.buffer.asUint8List();
  }

  void dispose() {
    _interpreter?.close();
  }
}