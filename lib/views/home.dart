import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blogger/services/crud.dart';
import 'package:flutter_blogger/views/create_blog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  CrudMethods crudMethods = new CrudMethods();

  QuerySnapshot blogSnapshot;
  Widget blogList() {
    return blogSnapshot != null
        ? Container(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return BlogsTile(
                        authorName:
                            blogSnapshot.docs[index].data()['authorName'],
                        description:
                            blogSnapshot.docs[index].data()['description'],
                        imgUrl: blogSnapshot.docs[index].data()['imgUrl'],
                        title: blogSnapshot.docs[index].data()['title'],
                      );
                    },
                    itemCount: blogSnapshot.docs.length,
                  )
                ],
              ),
            ),
          )
        : Center(
            child: Container(
              child: CircularProgressIndicator(),
            ),
          );
  }

  @override
  void initState() {
    crudMethods.getData().then((result) {
      setState(() {
        blogSnapshot = result;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Flutter",
              style: TextStyle(fontSize: 22),
            ),
            Text(
              "Blog",
              style: TextStyle(fontSize: 22, color: Colors.orangeAccent),
            )
          ],
        ),
      ),
      body: blogList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        tooltip: 'create stuff',
        splashColor: Colors.white,
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => CreateBlog()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class BlogsTile extends StatelessWidget {
  String imgUrl, title, description, authorName;
  BlogsTile(
      {@required this.authorName,
      @required this.description,
      @required this.imgUrl,
      @required this.title});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 170,
      child: Stack(
        children: [
          ClipRRect(
            child: Image.network(
              imgUrl,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            borderRadius: BorderRadius.circular(6),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: Colors.black45.withOpacity(0.3),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  authorName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
