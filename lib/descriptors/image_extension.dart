import 'package:image/image.dart' as img;
import 'package:image_descriptors/descriptors/list_shape_extension.dart';

extension ImageUtils on img.Image {
  List<dynamic> toList() {
    final List<dynamic> rgbList =
        List.filled(height * width * 3, 0).reshape([width, height, 3]);
    late int r, g, b;
    for (var i = 0; i < width; i++) {
      for (var j = 0; j < height; j++) {
        // if (getPixelSafe(i, j) != 4278255360) {
          r = getPixelSafe(i, j) >> 0 & 0x000000FF;
          g = getPixelSafe(i, j) >> 8 & 0x000000FF;
          b = getPixelSafe(i, j) >> 16 & 0x000000FF;
        // }
        rgbList[i][j] = [r, g, b];
      }
    }
    return rgbList;
  }
}