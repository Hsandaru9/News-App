import 'package:flutter/material.dart';
import 'package:news_api_flutter_package/model/article.dart';
import 'package:news_api_flutter_package/news_api_flutter_package.dart';



class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
 late Future<List<Article>> future;
String? searchTerm;
bool isSearching = false;
TextEditingController searchController = TextEditingController();
List<String> categoryItems = [
  "BUSINESS",
      "ENTERTAINMENT",
       "GENERAL",
    "HEALTH",
    "SCIENCE",
    "SPORTS",
    "TECHNOLOGY",
];

late String selectedCategory;

 @override
  void initState() {
    selectedCategory = categoryItems[0];
    future =  getNewsData();
    super.initState();
  }

  Future<List<Article>> getNewsData() async{
    NewsAPI newsAPI = NewsAPI ("1a78f5277c27494696c385dab3123055");
    return await newsAPI.getTopHeadlines(
      country: "us",
      query:  searchTerm,
      category : selectedCategory,
      pageSize: 50,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: SafeArea (
        child: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              builder: (context, snapshot){
               if (snapshot.connectionState==ConnectionState.waiting){
                return const Center(child: CircularProgressIndicator(),
                );
               } else if (snapshot.hasError) {
                return const Center (
                  child: Text("Error Loading the news"),
                );
               } else {
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return _buildNewsListView(snapshot.data as List<Article>);
                } else {
                  return const Center (
                  child: Text("News Not available"),
                  );
                }
               }
            },
            future: future,
            ),
          )
        ],
       )
       
       
       ),
    );
  }

 searchAppBar() {
     return AppBar(
    backgroundColor:  Color.fromARGB(255, 37, 72, 170),
    leading: IconButton(
      icon : const Icon(Icons.arrow_back),
      onPressed: () {
        setState(() {
          isSearching = false;
          searchTerm = null;
          searchController.text= "";
          future = getNewsData();
        });
      },
    ),
    title: TextField(
      controller: searchController,
      style: const TextStyle(color: Colors.white),
      cursorColor: Colors.white,
      decoration: const InputDecoration(
        hintText: "News Search",
        hintStyle: TextStyle(color: Colors.white70),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.transparent),
        ),
      ),
    ),
    actions: [
      IconButton(onPressed: () {
        setState(() {
          searchTerm = searchController.text;
          future = getNewsData();
        });
      }, icon: const Icon(Icons.search)),
    ],
   );
 }

 appBar () {
   return AppBar(
    backgroundColor:  Color.fromARGB(255, 37, 72, 170),
    title: const Text("Today News"),
    actions: [
      IconButton(
        onPressed: () {
        setState(() {
          isSearching = true;
        });
        }, 
        icon: const Icon(Icons.search)),
    ],
   );
 }

  Widget _buildNewsListView(List<Article> articleList) {
    return ListView.builder(
      itemBuilder: (context , index){
       Article article = articleList[index];
       return _buildNewsItem (article);
    }, 
    itemCount: articleList.length,
    );
  }

  Widget _buildNewsItem (Article article) {
      return Card (
        elevation: 4,
        child:Padding (padding: const EdgeInsets.all(8),
        child: Row(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
          SizedBox(
            height: 150,
            width: 150,
            child: Image.network(article.urlToImage ?? "", 
            fit: BoxFit.fitHeight,
            // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
            errorBuilder:(context , error , StackTrace){
              return const Icon(Icons.image_not_supported);
            } ,),
          ),
          const SizedBox(width: 20),
           Expanded(child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text (article.title!,
                maxLines: 4,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Text(article.source.name!,
                 style: const TextStyle(
                    color: Colors.grey
                 ),
                ),
                
            ],
          ))
         ],
        ),
        ) ,
     );
     
  }

}

 
   