import 'package:flutter/material.dart';
import 'package:flutter_blog_app/constant.dart';
import 'package:flutter_blog_app/model/api_response.dart';
import 'package:flutter_blog_app/model/comment.dart';
import 'package:flutter_blog_app/screen/login.dart';
import 'package:flutter_blog_app/service/comment_service.dart';
import 'package:flutter_blog_app/service/user_service.dart';

class CommentScreen extends StatefulWidget {
  const CommentScreen({super.key, this.postId});
  final int? postId;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
  int userId = 0;
  int editCommentId = 0;
  TextEditingController _txtCommentController = TextEditingController();

  Future<void> _getComments() async {
    userId = await getUserId();
    ApiResponse response = await getComments(widget.postId ?? 0);
    if (!mounted) return;
    if (response.error == null) {
      setState(() {
        _commentsList = response.data as List<dynamic>;
        _loading = false;
      });
    } else if (response.error == unauthorized) {
      await logout();
      if (!mounted) return;
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

  void _createComments() async {
    ApiResponse response = await createComments(
      widget.postId ?? 0,
      _txtCommentController.text,
    );
    if (!mounted) return;
    if (response.error == null) {
      _txtCommentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      await logout();
      if (!mounted) return;
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

  void _editComments() async {
    ApiResponse response = await editComments(editCommentId, _txtCommentController.text);
    if (!mounted) return;
    if (response.error == null) {
      editCommentId = 0;
      _txtCommentController.clear();
      _getComments();
    } else if (response.error == unauthorized) {
      await logout();
      if (!mounted) return;
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

  void _deleteComments(int commentId) async {
    ApiResponse response = await deleteComments(commentId);
    if (!mounted) return;
    if (response.error == null) {
      _getComments();
    } else if (response.error == unauthorized) {
      await logout();
      if (!mounted) return;
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
    _getComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Comments')),
      body: _loading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () {
                      return _getComments();
                    },
                    child: ListView.builder(
                      itemCount: _commentsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        Comment comment = _commentsList[index];
                        return Container(
                          padding: EdgeInsets.all(10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Colors.black26, width: 0.5),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          image: comment.user!.image != null
                                              ? DecorationImage(
                                                  image: NetworkImage(
                                                    '${comment.user!.image}',
                                                  ),
                                                  fit: BoxFit.cover,
                                                )
                                              : null,
                                          borderRadius: BorderRadius.circular(15),
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Text(
                                        '${comment.user!.name}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  comment.user!.id == userId
                                      ? PopupMenuButton(
                                          child: Padding(
                                            padding: EdgeInsets.only(right: 10),
                                            child: Icon(
                                              Icons.more_vert,
                                              color: Colors.black,
                                            ),
                                          ),
                                          itemBuilder: (context) => [
                                            PopupMenuItem(
                                              value: 'edit',
                                              child: Text('Edit'),
                                            ),
                                            PopupMenuItem(
                                              value: 'delete',
                                              child: Text('Delete'),
                                            ),
                                          ],
                                          onSelected: (val) {
                                            if (val == 'edit') {
                                              setState(() {
                                                editCommentId = comment.id ?? 0;
                                                _txtCommentController.text =
                                                    comment.comment ?? '';
                                              });
                                            } else {
                                              _deleteComments(comment.id ?? 0);
                                            }
                                          },
                                        )
                                      : SizedBox(),
                                ],
                              ),
                              SizedBox(height: 10),
                              Text(comment.comment.toString()),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: Colors.black26, width: 0.5)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          decoration: inputDecoration("Comment"),
                          controller: _txtCommentController,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_txtCommentController.text.isNotEmpty) {
                            setState(() {
                              _loading = true;
                            });
                            if (editCommentId > 0) {
                              _editComments();
                            } else {
                              _createComments();
                            }
                          }
                        },
                        icon: Icon(Icons.send),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
    );
  }
}
