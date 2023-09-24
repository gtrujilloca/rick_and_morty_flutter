import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/infrastructure/models/character_model.dart';
import 'package:rick_and_morty_app/presentation/providers/api_provider.dart';
import 'package:rick_and_morty_app/presentation/widgets/circular_loading.dart';

class CharacterScreen extends StatelessWidget {
  final Character character;

  const CharacterScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text(character.name),
      ),
      body: Column(children: [
        SizedBox(
            height: size.height * 0.3,
            width: double.infinity,
            child: Hero(
                tag: character.id,
                child: Image.network(
                  character.image,
                  fit: BoxFit.cover,
                ))),
        Container(
          height: size.height * 0.14,
          width: double.infinity,
          padding: const EdgeInsets.all(10),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _cardData('Status: ', character.status),
                _cardData('Specie: ', character.species),
                _cardData('Origin: ', character.origin.name),
              ]),
        ),
        const Text(
          'Episodes',
          style: TextStyle(fontSize: 17),
        ),
        EpisodeList(size: size, character: character),
      ]),
    );
  }
}

Widget _cardData(String txt1, String txt2) {
  return Expanded(
    child: Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Text(txt1),
          Text(
            txt2,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    ),
  );
}

class EpisodeList extends StatefulWidget {
  final Size size;
  final Character character;

  const EpisodeList({super.key, required this.size, required this.character});

  @override
  State<EpisodeList> createState() => _EpisodeListState();
}

class _EpisodeListState extends State<EpisodeList> {
  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getEpisodes(widget.character);
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = Provider.of<ApiProvider>(context);
    if (apiProvider.episodes.isEmpty) return circleLoading();
    return SizedBox(
      height: widget.size.height * 0.35,
      child: ListView.builder(
        itemCount: apiProvider.episodes.length,
        itemBuilder: (context, index) {
          final episode = apiProvider.episodes[index];
          return ListTile(
            title: Text(episode.name),
            leading: Text(episode.episode),
            trailing: Text(episode.airDate),
          );
        },
      ),
    );
  }
}
