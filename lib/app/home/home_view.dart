import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_descriptors/app/utils.dart';
import 'package:image_descriptors/descriptors/image_extension.dart';
import 'package:image_descriptors/descriptors/image_utils.dart';
import 'package:image_descriptors/descriptors/list_shape_extension.dart';
import 'package:image_descriptors/descriptors/src/color_descriptor.dart';
import 'package:image_descriptors/descriptors/src/texture_descriptor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  File? _fileA;
  List<double>? _featureVectorA;
  img.Image? _imageA;

  File? _fileB;
  List<double>? _featureVectorB;
  img.Image? _imageB;

  // double? _colorDistance;
  // double? _textureDistance;
  double? _distance;
  bool _useTexture = false;

  TextureDescriptor textureDescriptor = TextureDescriptor();
  ColorDescriptor colorDescriptor = ColorDescriptor(bins: [4, 4, 4]);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Use texture'),
                Switch(
                  value: _useTexture,
                  onChanged: (value) {
                    setState(() {
                      _useTexture = value;
                      _featureVectorA =
                          textureDescriptor.describe(_imageA!.toList());
                      _featureVectorB =
                          textureDescriptor.describe(_imageB!.toList());
                      _computeDistance();
                    });
                  },
                ),
              ],
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey,
              child: (_fileA != null) ? Image.file(_fileA!) : null,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: () {
                    _selectImage(_useTexture).then((value) {
                      if (value == null) return;
                      _fileA = value[0];
                      _featureVectorA = value[1];
                      _imageA = value[2];
                      _computeDistance();
                      setState(() {});
                    });
                  },
                  child: const Text(
                    'Pick image A',
                  ),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: () {
                    _selectImage(_useTexture).then((value) {
                      if (value == null) return;
                      _fileB = value[0];
                      _featureVectorB = value[1];
                      _imageB = value[2];
                      _computeDistance();
                      setState(() {});
                    });
                  },
                  child: const Text(
                    'Pick image B',
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Distance'),
                Text((_distance ?? 0).toStringAsFixed(2))
              ],
            ),
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey,
              child: (_fileB != null) ? Image.file(_fileB!) : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<List?> _selectImage(bool useTexture) async {
    File? file = await utilPickImage(ImageSource.camera, true);
    if (file == null) return null;

    List<dynamic>? featureVector;

    img.Image? image = img.decodeImage(file.readAsBytesSync());
    image = img.copyResize(image!, width: 128, height: 128);

    if (useTexture) {
      featureVector = textureDescriptor.describe(image.toList());
    } else {
      featureVector = colorDescriptor.describe(image.toList());
    }

    return [file, featureVector, image];
  }

  void _computeDistance() {
    if (_featureVectorA == null || _featureVectorB == null) return;

    _distance = chi2Distance(_featureVectorA!, _featureVectorB!);
  }
}
