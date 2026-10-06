import 'package:flutter/material.dart';
import 'package:flutter_blog_app/model/api_response.dart';
import 'package:flutter_blog_app/model/post.dart';
import 'package:flutter_blog_app/screen/login.dart';
import 'package:flutter_blog_app/service/post_service.dart';
import 'package:flutter_blog_app/service/user_service.dart';

import '../constant.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  List<dynamic> _postList = [];
  int userId = 0;
  bool _loading = true;

  Future<void> retrievePosts() async {
    userId = await getUserId();
    ApiResponse response = await getPosts();
    if (!mounted) return;
    if (response.error == null) {
      setState(() {
        _postList = response.data as List<dynamic>;
        _loading = false;
      });
    } else if (response.error == unauthorized) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${response.error}')));
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  void initState() {
    retrievePosts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: retrievePosts,
            child: ListView.builder(
              itemCount: _postList.length,
              itemBuilder: (BuildContext context, int index) {
                Post post = _postList[index];
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Row(
                              children: [
                                Container(
                                  width: 38,
                                  height: 38,
                                  decoration: BoxDecoration(
                                    image: post.user!.image != null
                                        ? DecorationImage(
                                            image: NetworkImage("${post.user!.image}"),
                                          )
                                        : null,
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.amber,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  '${post.user!.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 17,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          post.user!.id == userId
                              ? PopupMenuButton(
                                  child: Padding(
                                    padding: EdgeInsets.only(right: 10),
                                    child: Icon(Icons.more_vert, color: Colors.black),
                                  ),
                                  itemBuilder: (context) => [
                                    PopupMenuItem(value: 'edit', child: Text('Edit')),
                                    PopupMenuItem(value: 'delete', child: Text('Delete')),
                                  ],
                                  onSelected: (val) {
                                    if (val == 'edit') {
                                    } else {}
                                  },
                                )
                              : SizedBox(),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text('${post.body}'),
                      post.image != null
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: 180,
                              margin: EdgeInsets.only(top: 5),
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage('${post.image}'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : SizedBox(height: post.image != null ? 0 : 15),
                      Row(
                        children: [
                          likeAndCommentsBtn(
                            post.likesCount ?? 0,
                            post.selfLiked == true
                                ? Icons.favorite
                                : Icons.favorite_outline,
                            post.selfLiked == true ? Colors.red : Colors.black38,
                            () {},
                          ),
                          Container(height: 25, width: 0.5, color: Colors.black38),
                          likeAndCommentsBtn(
                            post.commentsCount ?? 0,
                            Icons.sms_outlined,
                            Colors.black54,
                            () {},
                          ),
                        ],
                      ),
                      Container(
                        height: 0.5,
                        width: MediaQuery.of(context).size.width,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
