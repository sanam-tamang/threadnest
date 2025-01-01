import 'package:flutter/material.dart';
import 'package:threadnest/features/comment/models/comment.dart';
import 'package:threadnest/features/question/models/question.dart';

class QuestionDetailPage extends StatefulWidget {
  final String questionId;
  const QuestionDetailPage({super.key, required this.questionId});

  @override
  State<QuestionDetailPage> createState() => _QuestionDetailPageState();
}

class _QuestionDetailPageState extends State<QuestionDetailPage> {
  late GetQuestion? question;
  late List<Comment> comments;
  @override
  void initState() {
    question = null;
    comments = [];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: const [
          // QuestionCard(question: question!, questionKey: "",),
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: Text(
          //     'Comments',
          //     style: Theme.of(context).textTheme.headlineSmall,
          //   ),
          // ),
          // ...comments.map((comment) => CommentCard(comment: comment)),
        ],
      ),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.author.imageUrl ?? ''),
                  radius: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  comment.author.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(comment.content),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.thumb_up, size: 16),
                const SizedBox(width: 4),
                Text('${comment.likes} likes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
