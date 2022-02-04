// import 'package:camera_camera/camera_camera.dart';
// import 'package:flutter/material.dart';

// class BackgroundView extends StatefulWidget {
//   BackgroundView({Key? key}) : super(key: key);

//   @override
//   _BackgroundViewState createState() => _BackgroundViewState();
// }

// class _BackgroundViewState extends State<BackgroundView> {
//   // late CameraController _camera;
//   late bool _cameraInitialized;
//   // late CameraImage _savedImage;

//   @override
//   void initState() {
//     _initializeCamera();
//     super.initState();
//   }

//   void _initializeCamera() async {
//     // Get list of cameras of the device
//     List<CameraDescription> cameras =
//         await availableCameras(); // Create the CameraController
//     _camera = CameraController(cameras[0],
//         ResolutionPreset.veryHigh); // Initialize the CameraController
//     _camera.initialize().then((_) async {
//       // Start ImageStream
//       await _camera
//           .startImageStream((CameraImage image) => _processCameraImage(image));
//       setState(() {
//         _cameraInitialized = true;
//       });
//     });
//   }

//   void _processCameraImage(CameraImage image) async {
//     setState(() {
//       _savedImage = image;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//           child: (_cameraInitialized)
//               ? AspectRatio(
//                   aspectRatio: _camera.value.aspectRatio,
//                   child: CameraPreview(_camera),
//                 )
//               : CircularProgressIndicator()),
//     );
//   }
// }
