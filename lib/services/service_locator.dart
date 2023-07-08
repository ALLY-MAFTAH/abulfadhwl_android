import 'package:audio_service/audio_service.dart';
import '../views/components/page_manager.dart';
import 'audio_handler.dart';
import 'playlist_repository.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;
// final DataProvider dataProvider = DataProvider();

Future<void> setupServiceLocator() async {
  // services
  getIt.registerSingleton<AudioHandler>(await initAudioService());
  getIt.registerLazySingleton<DemoPlaylist>(() => DemoPlaylist());

  // page state
  getIt.registerLazySingleton<PageManager>(() => PageManager());
}
