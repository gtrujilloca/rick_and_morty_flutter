import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
// import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_app/infrastructure/models/character_model.dart';
import 'package:rick_and_morty_app/presentation/providers/api_provider.dart';
import 'package:rick_and_morty_app/presentation/widgets/search_delegate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int page = 1;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    final apiProvider = Provider.of<ApiProvider>(context, listen: false);
    apiProvider.getCharacters();
    apiProvider.scrollController.addListener(() async {
      if (apiProvider.scrollController.position.pixels ==
          apiProvider.scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        page++;
        await apiProvider.getCharacters(page: page);
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final apiProvider = context.watch<ApiProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Home screen',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showSearch(context: context, delegate: SearchCharacter());
              },
              icon: const Icon(Icons.search))
        ],
      ),
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: apiProvider.characterResponse.results.isNotEmpty
              ? _CharacterList(
                  characters: apiProvider.characterResponse.results,
                  scrollController: apiProvider.scrollController,
                  isLoading: isLoading,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                )),
    );
  }
}

class _CharacterList extends StatelessWidget {
  final List<Character> characters;
  final ScrollController scrollController;
  final bool isLoading;

  const _CharacterList(
      {required this.characters,
      required this.scrollController,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    final int characterLength = characters.length;

    return Center(
        child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.87,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            controller: scrollController,
            itemCount: isLoading ? characterLength + 2 : characterLength,
            itemBuilder: (context, index) {
              if (index >= characterLength) {
                return const Center(child: CircularProgressIndicator());
              }
              final character = characters[index];
              return GestureDetector(
                onTap: () => context.go('/character', extra: character),
                child: Card(
                  child: Column(children: [
                    Hero(
                      tag: character.id,
                      child: FadeInImage(
                        placeholder:
                            const AssetImage('assets/images/portal.gif'),
                        image: NetworkImage(character.image),
                      ),
                    ),
                    Text(
                      character.name,
                      style: const TextStyle(
                          fontSize: 16, overflow: TextOverflow.ellipsis),
                    ),
                  ]),
                ),
              );
            }));
  }
}
