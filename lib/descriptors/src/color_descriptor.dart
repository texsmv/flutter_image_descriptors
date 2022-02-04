import 'package:image/image.dart' as img;
import 'package:image_descriptors/descriptors/image_extension.dart';
import 'package:image_descriptors/descriptors/image_utils.dart';
import 'package:image_descriptors/descriptors/list_shape_extension.dart';
import 'package:image_descriptors/descriptors/src/histograms.dart';

enum ColorSpace {
  rgb,
  o1o2o3,
}

class ColorDescriptor {
  ColorSpace colorSpace;
  List<int> bins;
  ColorDescriptor({
    this.colorSpace = ColorSpace.rgb,
    this.bins = const [4, 4, 4],
  });

  static List<dynamic> rgb2o1o2o3(List<dynamic> rgbImage) {
    final int width = rgbImage.shape[0];
    final int height = rgbImage.shape[1];
    final List<dynamic> o1o2o3Image =
        List.filled(height * width * 3, 0).reshape([width, height, 3]);
    int r, g, b;
    for (var i = 0; i < width; i++) {
      for (var j = 0; j < height; j++) {
        r = rgbImage[i][j][0];
        g = rgbImage[i][j][1];
        b = rgbImage[i][j][2];
        o1o2o3Image[i][j][0] = (255.0 + g - r) ~/ 2;
        o1o2o3Image[i][j][1] = ((510.0 + r + g - (2 * b)) ~/ 4.0);
        o1o2o3Image[i][j][2] = (r + g + b) ~/ 3.0;
      }
    }
    return o1o2o3Image;
  }

  List<double> describe(List<dynamic> input) {
    late List<dynamic> pixels;
    if (colorSpace == ColorSpace.o1o2o3) {
      pixels = rgb2o1o2o3(input);
    } else {
      pixels = input;
    }

    List<double> descriptors = [];

    for (var i = 0; i < bins.length; i++) {
      if (bins[i] != 0) {
        descriptors += image1dHistogram(pixels, i, nBins: bins[i]);
      }
    }

    return descriptors;
  }
}
