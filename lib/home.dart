// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:tflite/tflite.dart';

// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   //late PickedFile _image;
//   late File _image;
//   late List<dynamic> _output;
//   bool _loading = false;

//   @override
//   void initState() {
//     super.initState();
//     loadModel();
//   }

//   loadModel() async {
//     await Tflite.loadModel(
//       model: 'assets/model_unquant.tflite',
//       labels: 'assets/labels.txt',
//     );
//   }

//   classifyImage() async {
//     var output = await Tflite.runModelOnImage(
//       path: _image.path,
//       numResults: 2,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );

//     setState(() {
//       _output = output!;
//       _loading = false;
//     });
//   }

//   pickImage() async {
//     // ignore: deprecated_member_use
//     final image = await ImagePicker().getImage(source: ImageSource.gallery);

//     if (image == null) return;

//     setState(() {
//       _loading = true;
//       _image = File(image.path);
//     });

//     classifyImage();
//   }

//   @override
//   void dispose() {
//     Tflite.close();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Teachable Machine Classification'),
//       ),
//       body: Center(
//         child: Column(
//           children: <Widget>[
//             _image == null ? Text('No image selected.') : Image.file(_image),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: Text('Choose an Image'),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: _loading ? null : classifyImage,
//               child: Text('Classify Image'),
//             ),
//             SizedBox(height: 20.0),
//             _output != null
//                 ? Text(
//                     'Prediction: ${_output[0]['label']}\nConfidence: ${_output[0]['confidence'].toStringAsFixed(2)}')
//                 : Text('Waiting for image classification...'),
//           ],
//         ),
//       ),
//     );
//   }
// }
