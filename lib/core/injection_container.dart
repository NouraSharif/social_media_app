
import 'package:get_it/get_it.dart';
import 'package:social_media_app/features/create_post/data/datasources/create_post_remote_datasource.dart';
import 'package:social_media_app/features/create_post/data/repositories/create_post_repository_impl.dart';
import 'package:social_media_app/features/create_post/domain/repositories/create_post_repository.dart';

import '../../features/post_details/data/datasources/comment_local_datasource.dart';
import '../../features/post_details/data/repositories/comment_repository_impl.dart';
import '../../features/post_details/domain/repositories/comment_repository.dart';
import '../../features/post_details/domain/usecases/get_comments_usecase.dart';
import '../../features/post_details/domain/usecases/add_comment_usecase.dart';
import '../../features/post_details/domain/usecases/toggle_comment_like_usecase.dart';
import '../features/create_post/domain/usecases/create_post_usecase.dart';
import 'data/datasources/post_local_datasource.dart';
import 'data/repositories/post_repository_impl.dart';
import 'domain/repositories/post_repository.dart';
import 'domain/usecases/get_post_by_id_usecase.dart';
import 'domain/usecases/get_posts_usecase.dart';
import 'domain/usecases/toggle_post_like_usecase.dart';

final GetIt sl = GetIt.instance;
void setupDependencies(){
  // datasources - lazy singletons
  sl.registerLazySingleton<PostLocalDataSource>(
        () => PostLocalDatasourceImpl(),
  );
  sl.registerLazySingleton<CommentLocalDatasource>(
        () => CommentLocalDataSourceImpl(),
  );
   sl.registerLazySingleton<CreatePostRemoteDataSource>(
       () => CreatePostLocalDataSourceImpl(),
   );

  // repositories
  sl.registerLazySingleton<PostRepository>(() => PostRepositoryImpl(sl()));
  sl.registerLazySingleton<CommentRepository>(
        () => CommentRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<CreatePostRepository>(
      ()=> CreatePostRepositoryImpl(sl())
  );

  // usecases - factory new instance in each call
  sl.registerFactory(() => GetPostsUseCase(sl()));
  sl.registerFactory(() => GetPostByIdUseCase(sl()));
  sl.registerFactory(() => TogglePostLikeUseCase(sl()));
  sl.registerFactory(() => CreatePostUseCase(sl()));
  //------------------
  sl.registerFactory(() => GetCommentsUseCase(sl()));
  sl.registerFactory(() => AddCommentUseCase(sl()));
  sl.registerFactory(() => ToggleCommentLikeUseCase(sl()));
}