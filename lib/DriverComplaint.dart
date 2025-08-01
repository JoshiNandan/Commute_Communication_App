import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class Drivercomplaint extends StatefulWidget {
  const Drivercomplaint({super.key});

  @override
  State<Drivercomplaint> createState() => _DrivercomplaintState();
}

class _DrivercomplaintState extends State<Drivercomplaint> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _employeeCodeController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _busNoController = TextEditingController();
  final TextEditingController _driverNameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final _picker = ImagePicker();
  List<XFile> imageFileList = [];
  File? _image;
  String? _selectedItem;
  final List<String> _dropdownItems = [
    "Driver's Behaviour",
    "Bus Late Arrival/Departure",
    "Maintenance (AC/Handrest/Recliner)",
    "Cleanliness/Hygiene",
    "Breakdown",
  ];

  // gallery - image picker
  void selectImage() async {
    if (imageFileList.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only select up to 3 images.")),
      );
      return;
    }

    final List<XFile> selectedImages = await _picker.pickMultiImage();

    if (selectedImages != null && selectedImages.isNotEmpty) {
      int availableSlots = 3 - imageFileList.length;
      imageFileList.addAll(selectedImages.take(availableSlots));
      setState(() {});
    }
  }

  // camera - image picker
  void clickImage() async {
    if (imageFileList.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can only upload up to 3 images.")),
      );
      return;
    }

    final clickedImage = await _picker.pickImage(source: ImageSource.camera);

    if (clickedImage != null) {
      imageFileList.add(XFile(clickedImage.path));
      setState(() {});
    }
  }

  // date picker
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2300),
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  // submit button
  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      if (imageFileList == null || imageFileList.length != 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please upload exactly 3 images.")),
        );
        return;
      }

      var uri = Uri.parse(
        "http://103.80.225.210:8080/commute_application/api/vehicle_complaint.php",
      );
      var request = http.MultipartRequest('POST', uri);

      // Add form fields
      request.fields['emp_code'] = _employeeCodeController.text;
      request.fields['complaint_date'] =
          _dateController.text; // Use YYYY-MM-DD if required by backend
      request.fields['vehicle_number'] = _busNoController.text;
      request.fields['driver_name'] = _driverNameController.text;
      request.fields['complaint_issue'] = _selectedItem!;
      request.fields['complaint_description'] = _descriptionController.text;

      // Add images
      for (int i = 0; i < imageFileList.length; i++) {
        var file = await http.MultipartFile.fromPath(
          'complaint_images[]', // adjust this if your API expects specific keys
          imageFileList[i].path,
          filename: path.basename(imageFileList[i].path),
        );
        request.files.add(file);
      }

      // Send request
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Submitting complaint...")));

      try {
        var response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Complaint submitted successfully!")),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Submission failed. Please try again.")),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("An error occurred: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Driver Complaint ", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blueAccent,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Employee Code",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextFormField(
                  controller: _employeeCodeController,
                  decoration: InputDecoration(
                    hintText: "Enter your Employee Code",
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Employee Code is required" : null,
                ),
                SizedBox(height: 16),
                Text(
                  'When did the Incident took place?',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 6),
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelText: 'DATE',
                    filled: true,
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  validator:
                      (value) => value!.isEmpty ? "Date is required" : null,
                ),
                SizedBox(height: 16),
                Text(
                  "Vehicle No.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextFormField(
                  controller: _busNoController,
                  decoration: InputDecoration(hintText: "Enter your Bus No."),
                  validator:
                      (value) => value!.isEmpty ? "Bus No. is required" : null,
                ),
                SizedBox(height: 16),
                Text(
                  "Driver Name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextFormField(
                  controller: _driverNameController,
                  decoration: InputDecoration(hintText: "Enter Driver's Name"),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Driver Name is required" : null,
                ),
                SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _selectedItem,
                  decoration: InputDecoration(
                    labelText: 'Select Issue',
                    border: OutlineInputBorder(),
                  ),
                  items:
                      _dropdownItems.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedItem = newValue;
                    });
                  },
                  validator:
                      (value) =>
                          value == null ? 'Please select an option' : null,
                ),

                SizedBox(height: 16),
                Text(
                  "Complaint Description",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 1,
                  decoration: InputDecoration(hintText: "Describe the issue"),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Description is required" : null,
                ),
                SizedBox(height: 16),
                Text(
                  'Upload 3 Images only ',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                // Center(child:Image.file(_image!),),
                Row(
                  children: [
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            selectImage();
                          },
                          child: Icon(Icons.photo_camera_back_outlined),
                        ),
                        Text('Gallery'),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            clickImage();
                          },
                          child: Icon(Icons.camera_alt),
                        ),
                        Text('Camera'),
                      ],
                    ),
                  ],
                ),
                if (imageFileList.isNotEmpty)
                  SizedBox(
                    height: 130,
                    child: GridView.builder(
                      itemCount: imageFileList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                // Replace this image
                                final XFile? newImage = await _picker.pickImage(
                                  source: ImageSource.gallery,
                                );
                                if (newImage != null) {
                                  setState(() {
                                    imageFileList[index] = newImage;
                                  });
                                }
                              },
                              child: Container(
                                margin: EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Image.file(
                                  File(imageFileList[index].path),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              right: 0,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    imageFileList.removeAt(index);
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                  ),
                  child: Center(
                    child: Text(
                      "Submit",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
