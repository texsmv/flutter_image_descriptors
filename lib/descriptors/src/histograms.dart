import 'package:image_descriptors/descriptors/list_shape_extension.dart';

List<double> image1dHistogram(
  List<dynamic> image,
  channel, {
  int nBins = 16,
}) {
  final int width = image.shape[0];
  final int height = image.shape[1];
  final double binSize = 256.0 / nBins;

  List<dynamic> bins = List.filled(nBins, 0.0);

  late int kBin;
  for (int i = 0; i < width; i++) {
    for (int j = 0; j < height; j++) {
      kBin = (image[i][j][channel] / binSize).floor();
      bins[kBin] += 1;
    }
  }

  // Normalize histogram
  bins = List.generate(nBins, (index) => bins[index] / (width * height));

  return List<double>.from(bins);
}

List<double> textureHistogram(
  List<dynamic> gray,
) {
  final int width = gray.shape[0];
  final int height = gray.shape[1];
  List<double> histogram = List.filled(256, 0.0);
  int pixelCount = 0;
  for (var i = 0; i < width; i++) {
    for (var j = 0; j < height; j++) {
      histogram[gray[i][j]] += 1;
      pixelCount += 1;
    }
  }

  histogram = List.generate(256, (index) => histogram[index] / pixelCount);
  return histogram;
}
