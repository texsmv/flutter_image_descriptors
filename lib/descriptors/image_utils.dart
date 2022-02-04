import 'dart:math';

import 'package:image_descriptors/descriptors/list_shape_extension.dart';

double euclideanDistance(List<double> vector1, List<double> vector2) {
  assert(vector1.length == vector2.length);
  double sum = 0;
  for (var i = 0; i < vector1.length; i++) {
    sum += pow(vector1[i] - vector2[i], 2);
  }
  return sqrt(sum);
}

double chi2Distance(List<double> vector1, List<double> vector2) {
  assert(vector1.length == vector2.length);
  double sum = 0;
  for (var i = 0; i < vector1.length; i++) {
    sum +=
        pow(vector1[i] - vector2[i], 2) / (vector1[i] + vector2[i] + 0.00001);
  }

  return 0.5 * sum;
}
