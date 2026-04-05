import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/local_furniture_repository.dart';
import '../data/local/local_magazine_repository.dart';
import '../data/local/local_project_repository.dart';
import '../data/local/local_scrap_repository.dart';
import '../data/repositories/furniture_repository.dart';
import '../data/repositories/magazine_repository.dart';
import '../data/repositories/project_repository.dart';
import '../data/repositories/scrap_repository.dart';

final projectRepositoryProvider = Provider<ProjectRepository>(
  (ref) => LocalProjectRepository(),
);

final furnitureRepositoryProvider = Provider<FurnitureRepository>(
  (ref) => LocalFurnitureRepository(),
);

final magazineRepositoryProvider = Provider<MagazineRepository>(
  (ref) => LocalMagazineRepository(),
);

final scrapRepositoryProvider = Provider<ScrapRepository>(
  (ref) => LocalScrapRepository(),
);
