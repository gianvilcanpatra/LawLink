import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cross_file/cross_file.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lawyer_appointment_app/providers/user_provider.dart';

class UpdateProfilePage extends StatefulWidget {
  @override
  _UpdateProfilePageState createState() => _UpdateProfilePageState();
}

class _UpdateProfilePageState extends State<UpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _email;
  XFile? _image;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = pickedFile;
        //_image = File(pickedFile.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: user?.name,
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) {
                  _name = value;
                },
              ),
              TextFormField(
                initialValue: user?.email,
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) {
                  _email = value;
                },
              ),

              SizedBox(height: 20),
              _image == null
                  ? Text('No image selected.')
                  : kIsWeb
                      ? Image.network(_image!.path, height: 100, width: 100)
                      : Image.file(File(_image!.path), height: 100, width: 100),
                  //: Image.file(_image!, height: 100, width: 100),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Select Image'),
              ),
              
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    bool success = await userProvider.updateUser(_name, _email);
                    if (_image != null) {
                      success = await userProvider.uploadPhoto(File(_image!.path));
                    }
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully')));
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update profile')));
                    }
                  }
                },
                child: Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
