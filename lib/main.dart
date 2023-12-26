import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

void main() => runApp(ImageDetectorApp());

class ImageDetectorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ImageDetectorScreen(),
    );
  }
}

class ImageDetectorScreen extends StatefulWidget {
  @override
  _ImageDetectorScreenState createState() => _ImageDetectorScreenState();
}

class _ImageDetectorScreenState extends State<ImageDetectorScreen> {
//   PickedFile? _pickedImage;
//   late File _fileImage;
//   late List<dynamic> _output;

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

//   classifyImage(PickedFile image) async {
//     setState(() {});

//     _fileImage = File(image.path);

//     var output = await Tflite.runModelOnImage(
//       path: _fileImage.path,
//       numResults: 2,
//       threshold: 0.5,
//       imageMean: 127.5,
//       imageStd: 127.5,
//     );

//     setState(() {
//       _output = output!;
//     });
//   }

//   Future<void> pickImage() async {
//     // ignore: deprecated_member_use
//     final image = await ImagePicker().getImage(source: ImageSource.gallery);

//     if (image == null) return;
//     setState(() {
//       _pickedImage = image; // Initialize the _pickedImage variable
//     });

//     classifyImage(image); // Classify the picked image
//   }

//   Future<void> takeImage() async {
//     // ignore: deprecated_member_use
//     final image = await ImagePicker().getImage(source: ImageSource.camera);

//     if (image == null) return;
//     setState(() {
//       _pickedImage = image; // Initialize the _pickedImage variable
//     });

//     classifyImage(image); // Classify the captured image
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
//         title: Text('Image Detector App'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             _pickedImage == null
//                 ? Text('No image selected.')
//                 : Image.file(_fileImage),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: pickImage,
//               child: Text('Choose an Image'),
//             ),
//             SizedBox(height: 20.0),
//             ElevatedButton(
//               onPressed: takeImage,
//               child: Text('Click an Image'),
//             ),
//             SizedBox(height: 20.0),
//             _output.isNotEmpty
//                 ? Text(
//                     'Prediction: ${_output[0]['label']}\nConfidence: ${(_output[0]['confidence'] * 100).toStringAsFixed(2)}%',
//                     style: TextStyle(fontSize: 18),
//                   )
//                 : Text('Waiting for image classification...'),
//           ],
//         ),
//       ),
//     );
//   }
// }
  late File _image;
  late List result;
  bool imageSelect = false;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  Future loadModel() async {
    Tflite.close();
    String? res;

    res = await Tflite.loadModel(
      model: "assets/model_unquant.tflite",
      labels: "assets/labels.txt",
      numThreads: 1,
    );
    print("model loaded : $res");
  }

  Future imageClassification(File image) async {
    var classification = await Tflite.runModelOnImage(
      path: image.path,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 1,
      threshold: 0.1,
      asynch: true,
    );
    setState(() {
      result = classification!;
      _image = image;

      imageSelect = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    //SizeConfig().init(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'IMAGE DETECTOR',
          style: TextStyle(color: Colors.black), // Set the text color to white
        ),
        centerTitle: true, // Center align the title
        backgroundColor: Colors.blue, // Set the background color of the app bar
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10, //getProportionateScreenHeight(200),
          ),
          Center(
            child: imageSelect == false
                ? Container(
                    height: 100, //getProportionateScreenHeight(170),
                    width: 100, //getProportionateScreenWidth(170),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromARGB(255, 128, 157, 172),
                      ),
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Color.fromARGB(255, 128, 157, 172),
                    ),
                  )
                : Container(
                    height: 100, //getProportionateScreenHeight(190),
                    width: 100, //getProportionateScreenWidth(190),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        style: BorderStyle.solid,
                        width: 2,
                      ),
                    ),
                    child: Image.file(_image),
                  ),
          ),
          SizedBox(
            height: 10, //getProportionateScreenHeight(10),
          ),
          Column(
            children: imageSelect
                ? result.map((e) {
                    return Text(
                        '${e['label']} - ${e['confidence'].toStringAsFixed(2)}');
                  }).toList()
                : [],
          ),
          SizedBox(
            height: 10, //getProportionateScreenHeight(20),
          ),
          ElevatedButton(
            onPressed: pickImage,
            child: const Text('Choose an image'),
          ),
          SizedBox(
            height: 10, //getProportionateScreenHeight(20),
          ),
          ElevatedButton(
            onPressed: pickImage,
            child: const Text('Click an image'),
          ),
        ],
      ),
    );
  }

  Future pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    File image = File(pickedFile!.path);
    imageClassification(image);
  }
}
