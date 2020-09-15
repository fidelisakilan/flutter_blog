import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blogger/services/crud.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  bool _isLoading = false;
  File selectedImage;
  final picker = ImagePicker();
  String authorName, title, desc;
  CrudMethods crudMethods = new CrudMethods();
  Future getImage() async {
    var image = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image.path);
    });
  }

  uploadBlog() async {
    if (selectedImage != null) {
      setState(() {
        _isLoading == true;
      });
      //uploading image firebse storage
      StorageReference firebaseStorageRef = FirebaseStorage.instance
          .ref()
          .child("blogImages")
          .child("${randomAlphaNumeric(9)}.jpg");
      final StorageUploadTask task = firebaseStorageRef.putFile(selectedImage);
      var downloadUrl = await (await task.onComplete).ref.getDownloadURL();
      print("this is the url of the image: $downloadUrl");
      Map<String, dynamic> blogMap = {
        "imgUrl": downloadUrl,
        "authorName": authorName,
        "title": title,
        "description": desc,
      };
      crudMethods.addData(blogMap).then((result) {
        Navigator.pop(context);
      });
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(AntDesign.arrowleft),
            onPressed: () => Navigator.pop(context)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: IconButton(
                icon: Icon(AntDesign.upload),
                onPressed: () {
                  uploadBlog();
                }),
          )
        ],
        title: Row(
          children: <Widget>[
            Text(
              "Add your ",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.orangeAccent),
            )
          ],
        ),
      ),
      body: _isLoading == true
          ? Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      getImage();
                    },
                    child: selectedImage != null
                        ? Container(
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(6)),
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.file(
                                selectedImage,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                                color: Colors.black38,
                                borderRadius: BorderRadius.circular(6)),
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            child: Icon(AntDesign.picture),
                          ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Author Name"),
                    onChanged: (val) {
                      authorName = val;
                    },
                  ),
                  TextField(
                    decoration:
                        InputDecoration(hintText: "Give it a catchy Title"),
                    onChanged: (val) {
                      title = val;
                    },
                  ),
                  TextField(
                    decoration: InputDecoration(hintText: "Description"),
                    onChanged: (val) {
                      desc = val;
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
