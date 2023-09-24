import 'package:flutter/material.dart';
import 'package:rick_and_morty_app/config/helpers/get_characters.dart';
import 'package:rick_and_morty_app/infrastructure/models/character_model.dart';
import 'package:rick_and_morty_app/infrastructure/models/episode_model.dart';

class ApiProvider with ChangeNotifier {
  final baseUrl = 'https://rickandmortyapi.com/api';
  final ScrollController scrollController = ScrollController();
  final characterAnswer = CharacterAnswer();
  List<Episode> episodes = [];

  CharacterResponse characterResponse = CharacterResponse(
      info: Info(count: 0, pages: 0, next: '', prev: ''), results: []);

  Future<void> getCharacters({int page = 1}) async {
    final response = await characterAnswer.getCharacters(page: page);
    characterResponse.info = response.info;
    characterResponse.results.addAll(response.results);
    notifyListeners();
    // goToBottom();
  }

  Future<CharacterResponse> getCharacter(String name) async {
    final response = await characterAnswer.getCharacter(name);
    return response;
  }

  Future<List<Episode>> getEpisodes(Character character) async {
    episodes = [];
    for (var idx = 0; idx < character.episode.length; idx++) {
      final result = await characterAnswer.getEpisode(character.episode[idx]);
      episodes.add(result);
    }
    notifyListeners();
    return episodes;
  }

  Future<void> goToBottom() async {
    await Future.delayed(const Duration(milliseconds: 100));
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
  }
}
