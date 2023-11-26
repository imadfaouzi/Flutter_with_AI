import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AjoutScreen extends StatefulWidget {
  @override
  _AjoutScreenState createState() => _AjoutScreenState();
}

class _AjoutScreenState extends State<AjoutScreen> {
  TextEditingController _selectedCategory = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _placeController = TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField(_titleController, 'Titre'),
            _buildTextField(_locationController, 'Lieu'),
            _buildNumberTextField(_priceController, 'Prix'),
            _buildNumberTextField(_placeController, 'Nombre de places'),
            IgnorePointer(
              ignoring: true, // Set this to true to disable interaction
              child: _buildNumberTextField(_selectedCategory, 'category'),
            ),
            _buildImagePicker(),
            SizedBox(height: 20),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  Widget _buildNumberTextField(
      TextEditingController controller, String labelText) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
      keyboardType: TextInputType.number,
    );
  }



  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: () => _selectImage(),
      child: Container(
        color: Colors.grey[200],
        child: _selectedImage == null
            ? Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.add_a_photo),
        )
            : kIsWeb // Vérifie si l'application est exécutée sur le web
            ? Image.network(_selectedImage!.path) // Utilise Image.network pour le web
            : Image.file(_selectedImage!), // Utilise Image.file pour les autres plateformes
      ),
    );
  }


  void _selectImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _callFunctionWhenChoosingImage();
      });
    }
  }

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: () => _handleAddButtonPressed(),
      child: Text('Ajouter'),
    );
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _handleAddButtonPressed() async {
    // Check if all required fields are filled
    if (_titleController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _priceController.text.isEmpty ||
        _selectedCategory.text.isEmpty ||
        _placeController.text.isEmpty ||
        _selectedImage == null) {
      // Show an error message
      _showSnackbar('Please fill in all required fields', Colors.red);
      return;
    }

    print("Button is pressed !!");

    // Create a map of data to add to Firestore
    Map<String, dynamic> activityData = {
      'title': _titleController.text,
      'location': _locationController.text,
      'price': _priceController.text,
      'category': _selectedCategory.text,
      'place': _placeController.text,
    };

    try {
      // Add data to Firestore
      DocumentReference documentReference =
      await _firestore.collection('activities').add(activityData);

      // Upload the image to Firestore and get the download URL
      if (_selectedImage != null) {
        String imageUrl = await _uploadImage(documentReference.id);
        activityData['image'] = imageUrl;
        await documentReference.update(activityData);
      }

      // Clear the text controllers and image after successful addition
      _titleController.clear();
      _locationController.clear();
      _priceController.clear();
      _placeController.clear();
      setState(() {
        _selectedImage = null;
      });

      // Show a success message
      _showSnackbar('Activity added to Firestore!', Colors.green);
    } catch (e) {
      // Handle errors
      print('Error adding activity to Firestore: $e');
      // Show an error message
      _showSnackbar('Failed to add activity. Please try again.', Colors.red);
    }
  }

  void _showSnackbar(String message, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor,
      ),
    );
  }


  Future<String> _uploadImage(String documentId) async {
    try {
      final Reference storageReference = FirebaseStorage.instance.ref().child('activity_images').child('$documentId.jpg');
      final UploadTask uploadTask = storageReference.putFile(_selectedImage!);
      await uploadTask;
      final String imageUrl = await storageReference.getDownloadURL();
      return imageUrl;
    } catch (e) {
      print('Error uploading image to Firestore Storage: $e');
      return ''; // Retourne une chaîne vide en cas d'erreur
    }
  }

  void _callFunctionWhenChoosingImage() async {
    // Your existing code...

    try {
      // Ensure an image is selected
      if (_selectedImage != null) {
        // Create a multipart request
        var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://192.168.11.104:5000/addimage'),
        );

        // Add the image to the request
        request.files.add(
          await http.MultipartFile.fromPath(
            'image',
            _selectedImage!.path,
          ),
        );

        // Send the request
        var response = await request.send();

        // Check the status code
        if (response.statusCode == 200) {
          // Parse the JSON response
          var jsonResponse = json.decode(await response.stream.bytesToString());

          // Retrieve the category from the response
          String category = jsonResponse['result_Predected'];

          // Update the category controller with the received category
          _selectedCategory.text = category;
        } else {
          print('Failed to get category. Status code: ${response.statusCode}');
        }
      }
    } catch (e) {
      print('Error sending image to API: $e');
    }
  }
}