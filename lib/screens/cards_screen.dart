import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/provider/card_provider.dart';
import '../widgets/my_appbar.dart';
import '../widgets/mobile_wrapper.dart';
import '../widgets/card_tile.dart';
import '../widgets/card_form.dart';

class CardsScreen extends StatelessWidget {
  const CardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MobileWrapper(
      child: Scaffold(
        appBar: MyAppbar.build(context), 
        body: SafeArea(
          child: Consumer<CardProvider>(builder: (context, provider, _) {
            if (provider.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final cards = provider.cards;
            if (cards.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('No cards yet', style: Theme.of(context).textTheme.titleLarge),
                      const SizedBox(height: 12),
                      Text('Tap + to add your first card', textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(12),
              itemCount: cards.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, i) => CardTile(
                card: cards[i],
                onEdit: (c) async {
                  await showDialog(
                      context: context,
                      builder: (_) => CardFormDialog(existing: c));
                },
                onDelete: (id) async {
                  await provider.deleteCard(id);
                },
              ),
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            await showDialog(context: context, builder: (_) => const CardFormDialog());
            // reload
            context.read<CardProvider>().load();
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
