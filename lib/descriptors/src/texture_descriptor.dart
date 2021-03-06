import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:image_descriptors/descriptors/list_shape_extension.dart';
import 'package:image_descriptors/descriptors/src/histograms.dart';

class TextureDescriptor {
  List<dynamic> rgbToGray(
    List<dynamic> rgb,
  ) {
    final int width = rgb.shape[0];
    final int height = rgb.shape[1];
    final List<dynamic> gray =
        List<int>.filled(height * width, 0).reshape([width, height]);
    int r, g, b;
    for (var i = 0; i < width; i++) {
      for (var j = 0; j < height; j++) {
        r = rgb[i][j][0];
        g = rgb[i][j][1];
        b = rgb[i][j][2];
        gray[i][j] = img.getLuminanceRgb(r, g, b);
      }
    }
    return gray;
  }

  List<dynamic> lbpImage(List<dynamic> gray) {
    final int m = gray.shape[0];
    final int n = gray.shape[1];
    final List<dynamic> z = List.filled(8, 0);
    final List<dynamic> b = List.filled(m * n, 0).reshape([m, n]);

    for (int i = 1; i < m - 1; i++) {
      for (int j = 1; j < n - 1; j++) {
        int t = 0;
        for (int k = -1; k < 2; k++) {
          for (int l = -1; l < 2; l++) {
            if ((k != 0) || (l != 0)) {
              if (gray[i + k][j + l] - gray[i][j] < 0) {
                z[t] = 0;
              } else {
                z[t] = 1;
              }
              t = t + 1;
            }
          }
        }

        for (int t = 0; t < 8; t++) {
          b[i][j] += pow(2, t) * z[t];
        }
      }
    }
    return b;
  }

  List<dynamic> loopImage(List<dynamic> gray) {
    final int m = gray.shape[0];
    final int n = gray.shape[1];
    final List<dynamic> x = List.filled(8, 0);
    final List<dynamic> y = List.filled(8, 0);
    final List<dynamic> b = List.filled(m * n, 0).reshape([m, n]);

    List<dynamic> msk = [
      -3,
      -3,
      5,
      5,
      5,
      -3,
      -3,
      -3,
      -3,
      5,
      5,
      5,
      -3,
      -3,
      -3,
      -3,
      5,
      5,
      5,
      -3,
      -3,
      -3,
      -3,
      -3,
      -3,
      -3,
      -3,
      5,
      5,
      5,
      -3,
      -3,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      5,
      5,
      -3,
      -3,
      -3,
      -3,
      -3,
      5,
      -3,
      -3,
      -3,
      -3,
      5,
      5,
      5,
      -3,
      -3,
      -3,
      -3,
      -3,
      -3,
      5,
      5,
      5,
      5,
      -3,
      -3,
      -3,
      -3,
      -3,
      5,
      5
    ].reshape([3, 3, 8]);

    for (int i = 1; i < m - 1; i++) {
      for (int j = 1; j < n - 1; j++) {
        int t = 0;
        for (int k = -1; k < 2; k++) {
          for (int l = -1; l < 2; l++) {
            if ((k != 0) || (l != 0)) {
              if (gray[i + k][j + l] - gray[i][j] < 0) {
                x[t] = 0;
              } else {
                x[t] = 1;
              }
              y[t] = gray[i + k][j + l] * msk[1 + k][1 + l][t];
              t = t + 1;
            }
          }
        }
        final List<dynamic> temp = List.from(y);
        temp.sort();
        final List<dynamic> q = List.generate(y.length,
            (index) => y.indexWhere((element) => element == temp[index]));

        for (int t = 0; t < 8; t++) {
          b[i][j] += (pow(2, q[t]) * x[t]);
        }
      }
    }
    return b;
  }

  List<double> describe(List<dynamic> input) {
    final List<dynamic> gray = rgbToGray(input);
    final List<dynamic> lbp = lbpImage(gray);
    return textureHistogram(lbp);
  }
}
