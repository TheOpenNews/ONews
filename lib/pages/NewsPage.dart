import 'package:anynews/blocs/NewsPage/news_page_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  void initState() {
    context.read<NewsPageBloc>().add(LoadNewsPage());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NewsPageBloc, NewsPageState>(
      builder: (context, state) {
        return Scaffold(
          appBar: _appbar(),
          body: Column(
            children: [
              state.loadingStatus == PageNewsLoadingStatus.Loading
                  ? CircularProgressIndicator()
                  : Text("NEWSSSS!!"),
            ],
          ),
        );
      },
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: Text(
        "NewsPage",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Color(0xFF13a2cc),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    );
  }
}
