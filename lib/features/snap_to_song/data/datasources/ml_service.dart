// import 'dart:io';
// import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import 'package:image_picker/image_picker.dart';

class ImageLabelingService {
  final ImagePicker _picker = ImagePicker();
  
  // Singleton pattern or just stateless service
  
  Future<List<String>> pickAndAnalyzeImage(ImageSource source) async {
    try {
      // 1. Pick Image
      final XFile? image = await _picker.pickImage(source: source);
      if (image == null) return [];

      // WEB COMPATIBILITY STUB
      // ML Kit does not support Web. Returning dummy data for testing.
      return ["Party", "Summer", "Fun"];

      /* 
      // UNCOMMENT FOR MOBILE (Android/iOS)
      // 2. Prepare Input Image
      final InputImage inputImage = InputImage.fromFilePath(image.path);

      // 3. Labeler Options
      final ImageLabelerOptions options = ImageLabelerOptions(confidenceThreshold: 0.5);
      final ImageLabeler labeler = ImageLabeler(options: options);

      // 4. Process Image
      final List<ImageLabel> labels = await labeler.processImage(inputImage);
      
      // 5. Extract Top 3 Labels
      List<String> results = [];
      for (ImageLabel label in labels) {
        results.add(label.label);
        if (results.length >= 3) break;
      }
      
      // Cleanup
      labeler.close();
      
      return results;
      */
    } catch (e) {
      print('Error in Image Labeling: $e');
      return [];
    }
  }
}
