import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:threadnest/common/widgets/app_error_widget.dart';
import 'package:threadnest/common/widgets/app_loading_indicator.dart';
import 'package:threadnest/dependency_injection.dart';
import 'package:threadnest/features/home/pages/modern_drawer.dart';
import 'package:threadnest/features/question/blocs/get_question_bloc/get_question_bloc.dart';
import 'package:threadnest/features/question/widgets/question_card.dart';
import 'package:threadnest/router.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GetQuestionBloc _qBloc;
  @override
  void initState() {
    _qBloc = sl<GetQuestionBloc>();
    if (_qBloc is GetQuestionLoaded) {
    } else {
      _qBloc.add(const GetQuestionsEvent());
    }
    super.initState();
  }

  Future<void> _onRefresh() async {
    _qBloc.add(const GetQuestionsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerPage(),
      appBar: AppBar(
        actions: const [
          CircleAvatar(),
          Gap(12),
        ],
      ),
      body: BlocBuilder<GetQuestionBloc, GetQuestionState>(
        builder: (context, state) {
          if (state is GetQuestionLoading) {
            return const AppLoadingIndicator();
          } else if (state is GetQuestionLoaded) {
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView.builder(
                itemCount: state.questions['normal']!.length,
                itemBuilder: (context, index) {
                  final question = state.questions['normal']![index];
                  return GestureDetector(
                      onTap: () => context.pushNamed(
                          AppRouteName.questionDetail,
                          pathParameters: {"questionId": question.id}),
                      child: QuestionCard(
                        question: question,
                        questionKey: 'normal',
                      ));
                },
              ),
            );
          } else if (state is GetQuestionFailure) {
            return AppErrorWidget(failure: state.failure);
          } else {
            return const SizedBox.shrink();
          }
        },
      ),
    );
  }
}
