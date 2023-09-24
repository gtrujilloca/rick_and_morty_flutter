import 'package:dio/dio.dart';
import 'package:rick_and_morty_app/infrastructure/models/character_model.dart';
import 'package:rick_and_morty_app/infrastructure/models/episode_model.dart';

class CharacterAnswer {
  final _dio = Dio();
  final String baseUrl = 'https://rickandmortyapi.com/api';

  Future<CharacterResponse> getCharacters({int page = 1}) async {
    final response = await _dio
        .get('$baseUrl/character', queryParameters: {'page': page.toString()});
    final charactersModel = CharacterResponse.fromJson(response.data);
    return charactersModel;
  }

  Future<CharacterResponse> getCharacter(String characterName) async {
    final response = await _dio
        .get('$baseUrl/character', queryParameters: {'name': characterName});
    final characters = CharacterResponse.fromJson(response.data);
    return characters;
  }

  Future<Episode> getEpisode(String episodeUrl) async {
    final response = await _dio.get(episodeUrl);
    return Episode.fromJson(response.data);
  }
}
