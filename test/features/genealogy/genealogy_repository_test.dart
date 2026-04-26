import 'package:flutter_test/flutter_test.dart';
import 'package:sirah_app/features/genealogy/data/models/family_member.dart';
import 'package:sirah_app/features/genealogy/data/repositories/genealogy_repository.dart';

// Minimal graph covering the key BFS test cases:
// hamza → abdulmuttalib → abdullah → muhammad
// amina → muhammad (via motherId on muhammad's entry)
final _testMembers = [
  const FamilyMember(
    id: 'muhammad',
    arabic: 'مُحَمَّد',
    transliteration: 'Muḥammad',
    role: FamilyRole.prophet,
    parentId: 'abdullah',
    motherId: 'amina',
  ),
  const FamilyMember(
    id: 'abdullah',
    arabic: 'عَبْد ٱللَّٰه',
    transliteration: 'ʿAbd Allāh',
    role: FamilyRole.father,
    parentId: 'abdulmuttalib',
  ),
  const FamilyMember(
    id: 'abdulmuttalib',
    arabic: 'عَبْد ٱلْمُطَّلِب',
    transliteration: 'ʿAbd al-Muṭṭalib',
    role: FamilyRole.paternalAscendant,
    parentId: 'hashim',
  ),
  const FamilyMember(
    id: 'hashim',
    arabic: 'هَاشِم',
    transliteration: 'Hāshim',
    role: FamilyRole.paternalAscendant,
  ),
  const FamilyMember(
    id: 'hamza',
    arabic: 'حَمْزَة',
    transliteration: 'Ḥamza',
    role: FamilyRole.uncle,
    parentId: 'abdulmuttalib',
  ),
  const FamilyMember(
    id: 'amina',
    arabic: 'آمِنَة',
    transliteration: 'Āmina',
    role: FamilyRole.mother,
  ),
  const FamilyMember(
    id: 'khadija',
    arabic: 'خَدِيجَة',
    transliteration: 'Khadīja',
    role: FamilyRole.wife,
    spouseOf: 'muhammad',
  ),
  const FamilyMember(
    id: 'fatima',
    arabic: 'فَاطِمَة',
    transliteration: 'Fāṭima',
    role: FamilyRole.child,
    parentId: 'muhammad',
    motherId: 'khadija',
  ),
  const FamilyMember(
    id: 'ali',
    arabic: 'عَلِيّ',
    transliteration: 'ʿAlī',
    role: FamilyRole.cousin,
    parentId: 'abutalib',
    spouseOf: 'fatima',
  ),
  const FamilyMember(
    id: 'abutalib',
    arabic: 'أَبُو طَالِب',
    transliteration: 'Abū Ṭālib',
    role: FamilyRole.uncle,
    parentId: 'abdulmuttalib',
  ),
  const FamilyMember(
    id: 'hasan',
    arabic: 'ٱلْحَسَن',
    transliteration: 'al-Ḥasan',
    role: FamilyRole.grandchild,
    parentIds: ['fatima', 'ali'],
  ),
];

void main() {
  late GenealogyRepository repo;

  setUp(() {
    repo = GenealogyRepository(_testMembers);
  });

  group('GenealogyRepository — queries', () {
    test('getAll returns all members', () {
      expect(repo.getAll().length, equals(_testMembers.length));
    });

    test('getProphet returns Muḥammad', () {
      final prophet = repo.getProphet();
      expect(prophet.id, equals('muhammad'));
      expect(prophet.role, equals(FamilyRole.prophet));
    });

    test('getById finds khadija', () {
      final khadija = repo.getById('khadija');
      expect(khadija, isNotNull);
      expect(khadija!.transliteration, contains('Khadīja'));
    });

    test('getById returns null for unknown id', () {
      expect(repo.getById('unknown'), isNull);
    });

    test('getByRole returns only wives', () {
      final wives = repo.getByRole(FamilyRole.wife);
      expect(wives.every((m) => m.role == FamilyRole.wife), isTrue);
    });

    test('getChildren with motherId returns correct subset', () {
      final children = repo.getChildren(motherId: 'khadija');
      expect(children.every((m) => m.motherId == 'khadija'), isTrue);
    });

    test('search finds by transliteration', () {
      final results = repo.search('Ḥamza');
      expect(results.any((m) => m.id == 'hamza'), isTrue);
    });
  });

  group('GenealogyRepository — BFS path', () {
    test('path from self to self returns single member', () {
      final path = repo.getPath('muhammad', 'muhammad');
      expect(path.length, equals(1));
      expect(path.first.id, equals('muhammad'));
    });

    test('hamza → muhammad via abdulmuttalib → abdullah', () {
      final path = repo.getPath('hamza', 'muhammad');
      expect(path.isNotEmpty, isTrue);
      expect(path.first.id, equals('hamza'));
      expect(path.last.id, equals('muhammad'));
      // Path must pass through abdulmuttalib and abdullah
      final ids = path.map((m) => m.id).toList();
      expect(ids.contains('abdulmuttalib'), isTrue);
      expect(ids.contains('abdullah'), isTrue);
    });

    test('hasan → muhammad path exists', () {
      // hasan → fatima → muhammad
      final path = repo.getPath('hasan', 'muhammad');
      expect(path.isNotEmpty, isTrue);
      expect(path.first.id, equals('hasan'));
      expect(path.last.id, equals('muhammad'));
    });

    test('returns empty list for disconnected node', () {
      final repoWithIsland = GenealogyRepository([
        ...repo.getAll(),
        const FamilyMember(
          id: 'isolated',
          arabic: 'test',
          transliteration: 'test',
          role: FamilyRole.uncle,
        ),
      ]);
      final path = repoWithIsland.getPath('isolated', 'muhammad');
      expect(path, isEmpty);
    });

    test('path is symmetric (from and to are interchangeable)', () {
      final forward = repo.getPath('hamza', 'muhammad');
      final backward = repo.getPath('muhammad', 'hamza');
      expect(forward.length, equals(backward.length));
    });
  });
}
