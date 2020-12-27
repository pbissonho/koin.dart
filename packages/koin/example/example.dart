import 'package:koin/koin.dart';

class Post {
  final String title;
  final String body;

  Post(this.title, this.body);
}

abstract class PostRepository {
  List<Post> getAll();
}

class RestPostRepository implements PostRepository {
  @override
  List<Post> getAll() {
    return [Post("Title", "BOdy"), Post("Title", "BOdy")];
  }
}

var postModule = Module()..single<PostRepository>((s) => RestPostRepository());

void main() {
  var koin = startKoin((app) {
    app..module(postModule);
  }).koin;

  var postRepository = koin.get<PostRepository>();

  print(postRepository.getAll());
}
