import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/data/repositories/genealogy_repository.dart';

final genealogyRepositoryProvider = FutureProvider<GenealogyRepository>(
  (ref) => GenealogyRepository.load(),
);

final genealogyMembersProvider = FutureProvider<List<FamilyMember>>((ref) async {
  final repo = await ref.watch(genealogyRepositoryProvider.future);
  return repo.getAll();
});

final genealogyFilterProvider = StateProvider<GenealogyFilter>(
  (_) => GenealogyFilter.all,
);

enum GenealogyFilter {
  all,
  spousesAndChildren,
  ascendants,
  unclesAndAunts,
  ahlAlBayt,
}
