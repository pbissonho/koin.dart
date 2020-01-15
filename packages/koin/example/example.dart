
import 'package:koin/koin.dart';

class Post {}

abstract class PostRepository {
  List<Post> getAll();
}

class RestPostRepository implements PostRepository {
  @override
  List<Post> getAll() {
    return [Post(), Post()];
  }
}

var postModule = Module()
  ..single<PostRepository>((s, p) => RestPostRepository());

void main() {
  var koin = startKoin((app) {
    app..module(postModule);
  }).koin;

  var postRepository = koin.get<PostRepository>();
}
