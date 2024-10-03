import 'package:on_stage_app/app/features/artist/domain/models/artist_model.dart';
import 'package:on_stage_app/app/features/notifications/domain/models/stage_notification_model.dart';
import 'package:on_stage_app/app/features/song/domain/enums/structure_item.dart';
import 'package:on_stage_app/app/features/song/domain/models/raw_section.dart';
import 'package:on_stage_app/app/features/song/domain/models/song_model_v2.dart';

class SongDummy {
  static const song = SongModelV2(
    id: 'song123',
    title: 'Esti Marele Eu Sunt',
    rawSections: [
      RawSection(
        structureItem: StructureItem.V1,
        content: 'Esti Marele "Eu sunt" [G] \n'
            'In lumina umbrei Tale ma ascund [Am]\n'
            '[Em]Acoperit de har [G]',
      ),
      RawSection(
        structureItem: StructureItem.C,
        content: 'Esti Marele "Eu sunt" [G] \n'
            'In lumina umbrei Tale ma ascund [Am] dfadsfgd adafasfds afa[A]sdf sadgds g\n'
            '[Em]Acoperit de har [G] \n'
            'Ma odihnesc atunci cand Tu apari [Am]',
      ),
      RawSection(
        structureItem: StructureItem.C1,
        content: 'Nu e munte[G] prea mare [G] \n'
            'Nu-i pustiu prea uscat [D] \n'
            'Nu e vale prea adanca [Am] \n'
            'Nu-i nimic mu[G]lt prea greu [C] \n'
            'Nimic mult prea greu [D]',
      ),
      RawSection(
        structureItem: StructureItem.B,
        content: 'Est[G]e pace in furtuni \n'
            'La Cuvantul Tau si stele se supun \n'
            'Mi-ai dat pu[G]terea Ta \n'
            'Sa fiu mai mu[G]lt decat eu p[G]ot visa',
      ),
    ],
    structure: [
      StructureItem.V1,
      StructureItem.V1,
      StructureItem.V1,
      StructureItem.V1,
      StructureItem.C,
      StructureItem.C,
      StructureItem.C,
      StructureItem.C1,
      StructureItem.C1,
      StructureItem.B,
      StructureItem.C,
      StructureItem.C1,
    ],
    tempo: 120,
    key: 'G',
    createdAt: '2024-10-03T12:00:00Z',
    updatedAt: '2024-10-03T14:30:00Z',
    artist: Artist(id: 'artist456', name: 'John Doe'),
    album: 'Worship Collection',
    capo: 2,
  );
  static final notificationsDummy = <StageNotification>[
    //fill with dummy data
    StageNotification(
      id: 1,
      title: 'Repetitie 1',
      dateTime: DateTime(2024, 9, 11, 20, 0),
      // 8:00 PM
      createdAt: 'today',
      isInvitationConfirmed: false,
      seen: false,
    ),
    StageNotification(
      id: 1,
      title: 'Friend Request',
      dateTime: DateTime(2024, 9, 20, 20, 0),
      createdAt: 'today',
      isInvitationConfirmed: false,
      seen: true,
    ),
    StageNotification(
      id: 1,
      title: 'Repetitie 2',
      dateTime: DateTime(2024, 9, 10, 15, 42),
      // 15:42
      createdAt: 'today',
      isInvitationConfirmed: false,
      seen: false,
    ),
    StageNotification(
      id: 1,
      title: 'Ready to go live?',
      dateTime: DateTime(2024, 9, 22, 18, 30),
      // 6:30 PM
      createdAt: 'today',
      isInvitationConfirmed: true,
      seen: true,
    ),
    StageNotification(
      id: 1,
      title: 'Repetitie 3',
      dateTime: DateTime(2024, 9, 5, 18, 30),
      // 6:30 PM
      createdAt: 'today',
      isInvitationConfirmed: true,
      seen: true,
    ),
    StageNotification(
      id: 1,
      title: 'Old Notification',
      dateTime: DateTime(2024, 7, 10, 18, 30),
      // 6:30 PM
      createdAt: 'today',
      isInvitationConfirmed: false,
      seen: false,
    ),
  ];

// static const List<SongModel> songs = [
//   SongModel(
//     id: 1,
//     title: 'Nu e munte prea mare',
//     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     key: 'C# M',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(
//       id: 1,
//       fullName: 'BBSO',
//       songIds: [1, 2],
//       imageUrl: 'assets/images/band1.png',
//     ),
//     album: 'Tabara 477',
//     capo: 1,
//   ),
//   //add more of these
//   SongModel(
//     id: 2,
//     title: 'Ala bala portocala',
//     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     key: 'C#',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(id: 1, fullName: 'Tabara 477', songIds: [1, 2]),
//     album: 'Tabara 477',
//     capo: 1,
//   ),
//   SongModel(
//     id: 3,
//     title: 'Isus e Rege',
//     lyrics: 'Ana are mere si pere',
//     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     key: 'c#m',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(
//       id: 1,
//       fullName: 'Alin si Emima',
//       songIds: [1, 2],
//       imageUrl: 'assets/images/band3.png',
//     ),
//     capo: 1,
//   ),
//   SongModel(
//     id: 4,
//     title: 'Soarele neprihanirii',
//     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     key: 'C#',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(id: 1, fullName: 'El Shaddai', songIds: [1, 2]),
//     album: 'Tabara 477',
//     capo: 1,
//   ),
//   SongModel(
//     id: 5,
//     title: 'Astazi e craciun',
//     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     key: 'Ab',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(
//       id: 1,
//       fullName: 'Boboc',
//       songIds: [1, 2],
//       imageUrl: 'assets/images/band1.png',
//     ),
//     album: 'Tabara 477',
//     capo: 1,
//   ),
//   SongModel(
//     id: 6,
//     title: 'Yahweh se manifesta',
//     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     key: 'A',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(id: 1, fullName: 'Test 123', songIds: [1, 2]),
//     album: 'Tabara 477',
//     capo: 1,
//   ),
//   SongModel(
//     id: 7,
//     title: 'Soarele neprihanirii',
//     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     key: 'em',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(
//       id: 1,
//       fullName: 'Harvest Arad',
//       songIds: [1, 2],
//       imageUrl: 'assets/images/band2.png',
//     ),
//     album: 'Tabara 477',
//     capo: 1,
//   ),
//   SongModel(
//     id: 8,
//     title: 'Eu sunt mic, dar Isus',
//     lyrics: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     tab: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit',
//     key: 'C# major',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(id: 1, fullName: 'Tabara 477', songIds: [1, 2]),
//     album: 'Tabara 477',
//     capo: 1,
//   ),
// ];

// static const List<SongModel> playlist = [
//   SongModel(
//     id: '8',
//     title: 'Nu e munte prea mare',
//     lyrics: '<V1> Esti Marele "Eu sunt" [G] \n'
//         'In lumina umbrei Tale ma ascund [Am]\n'
//         '[Em]Acoperit de har [G]'
//         '<C> Esti Marele "Eu sunt" [G]'
//         'In lumina umbrei Tale ma ascund [Am]\n'
//         '[Em]Acoperit de har [G] \n'
//         'Ma odihnesc atunci cand Tu apari [Am]'
//         '<C1> Nu e munte[G] prea mare [G] \n'
//         'Nu-i pustiu prea uscat [D] \n'
//         'Nu e vale prea adanca [Am] \n'
//         'Nu-i nimic mu[G]lt prea greu [C] \n'
//         'Nimic mult prea greu [D]'
//         '<B1> Est[G]e pace in furtuni \n'
//         'La Cuvantul Tau si stele se supun \n'
//         'Mi-ai dat pu[G]terea Ta \n'
//         'Sa fiu mai mu[G]lt decat eu p[G]ot visa'
//         '<B> Si or[G]ice s-ar in[G]tampla [C] \n'
//         'Tu ra[G]mai de p[G]artea mea [G] \n'
//         'Nu-i [Em/B7+1]nimic prea [Em]greu, pentru [Em]Domnul meu[Am] Nu-i asdasd  dasd ds dsnimic preaaaaaaaaaaaaaa [Em]greu, pentru [Em]Domnul meu[Am] \n'
//         'Universul de-ar cadea, Tu rescrii istoria [C] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [G] \n'
//         '<B> Si orice s-ar intampla [C] \n'
//         'Tu ramai de partea mea [G/B] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [Am] \n'
//         'Universul de-ar cadea, Tu rescrii istoria [C] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [G] \n'
//         '<V> Si orice s-ar intampla [C] \n'
//         'Tu ramai de partea mea [G/B] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [Am] \n'
//         'Universul de-ar cadea, Tu rescrii istoria [C] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [G] \n'
//         '<V2> Esti Marele "Eu sunt" [G] \n'
//         'In lumina umbrei Tale ma ascund [Am]\n'
//         '[Em]Acoperit de har [G]',
//     key: 'G major',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(id: '', name: 'BBSO', imageUrl: ''),
//     album: 'Tabara 477',
//     capo: 1,
//     songKey: SongKey(
//       name: 'G Major',
//       chord: ChordsEnum.G,
//       isMajor: true,
//       isSharp: false,
//     ),
//     originalKey: SongKey(
//       name: 'G Major',
//       chord: ChordsEnum.G,
//       isMajor: true,
//       isSharp: false,
//     ),
//   ),
//   SongModel(
//     id: '1',
//     title: 'Our Father',
//     lyrics: '<V1> Esti Marele "Eu sunt" [G] \n'
//         'In lumina umbrei Tale ma ascund [Am]\n'
//         '[Em]Acoperit de har [G]'
//         '<C> Esti Marele "Eu sunt" [G]'
//         'In lumina umbrei Tale ma ascund [Am]\n'
//         '[Em]Acoperit de har [G] \n'
//         'Ma odihnesc atunci cand Tu apari [Am]'
//         '<C1> Nu e munte[G] prea mare [G] \n'
//         'Nu-i pustiu prea uscat [D] \n'
//         'Nu e vale prea adanca [Am] \n'
//         'Nu-i nimic mu[G]lt prea greu [C] \n'
//         'Nimic mult prea greu [D]'
//         '<B1> Est[G]e pace in furtuni \n'
//         'La Cuvantul Tau si stele se supun \n'
//         'Mi-ai dat pu[G]terea Ta \n'
//         'Sa fiu mai mu[G]lt decat eu p[G]ot visa'
//         '<B> Si or[G]ice s-ar in[G]tampla [C] \n'
//         'Tu ra[G]mai de p[G]artea mea [G] \n'
//         'Nu-i [Em/B7+1]nimic prea [Em]greu, pentru [Em]Domnul meu[Am] Nu-i asdasd  dasd ds dsnimic preaaaaaaaaaaaaaa [Em]greu, pentru [Em]Domnul meu[Am] \n'
//         'Universul de-ar cadea, Tu rescrii istoria [C] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [G] \n'
//         '<B> Si orice s-ar intampla [C] \n'
//         'Tu ramai de partea mea [G/B] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [Am] \n'
//         'Universul de-ar cadea, Tu rescrii istoria [C] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [G] \n'
//         '<V> Si orice s-ar intampla [C] \n'
//         'Tu ramai de partea mea [G/B] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [Am] \n'
//         'Universul de-ar cadea, Tu rescrii istoria [C] \n'
//         'Nu-i nimic prea greu, pentru Domnul meu [G] \n'
//         '<V2> Esti Marele "Eu sunt" [G] \n'
//         'In lumina umbrei Tale ma ascund [Am]\n'
//         '[Em]Acoperit de har [G]',
//     key: 'A major',
//     createdAt: '2021-08-01T00:00:00.000Z',
//     updatedAt: '2021-08-01T00:00:00.000Z',
//     artist: Artist(id: '', name: 'TEST ARTIST', imageUrl: ''),
//     album: 'Tabara 477',
//     capo: 1,
//     songKey: SongKey(
//       name: 'A Major',
//       chord: ChordsEnum.A,
//       isMajor: true,
//       isSharp: false,
//     ),
//     originalKey: SongKey(
//       name: 'A Major',
//       chord: ChordsEnum.A,
//       isMajor: true,
//       isSharp: false,
//     ),
//   ),
// ];
}
