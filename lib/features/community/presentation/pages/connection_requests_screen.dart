import 'dart:ui' show ImageFilter;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../user/domain/entities/person_entity.dart';
import '../../../community/presentation/bloc/community_bloc.dart';
import '../../../community/presentation/bloc/community_event.dart';
import '../../../community/presentation/bloc/community_state.dart';
import '../../../../widgets/zinko_network_image.dart';
import '../../../../utils/glass_theme.dart';
import '../../../../widgets/zinko_background.dart';

class ConnectionRequestsScreen extends StatelessWidget {
  static const String routeName = '/connection-requests';

  const ConnectionRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('CONNECTION REQUESTS',
            style: TextStyle(
                color: GlassTheme.textColor(context),
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.5)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded,
              color: GlassTheme.textColor(context), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ZinkoBackground(
        child: SafeArea(
          child: BlocBuilder<CommunityBloc, CommunityState>(
            builder: (context, state) {
              List<PersonEntity> requests = [];
              if (state is CommunityLoading || state is CommunityInitial) {
                return Center(
                    child: CircularProgressIndicator(
                        color: GlassTheme.textColor(context)));
              }

              if (state is CommunityDataLoaded) {
                requests =
                    state.people.where((p) => !p.isConnected).take(3).toList();
              }

              if (requests.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline_rounded,
                          size: 64,
                          color:
                              GlassTheme.textColor(context).withValues(alpha: 0.2)),
                      const SizedBox(height: 16),
                      Text('No pending requests',
                          style: TextStyle(
                              color: GlassTheme.textColor(context),
                              fontSize: 16,
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final person = requests[index];
                  return _buildGlassRequestCard(context, person);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGlassRequestCard(BuildContext context, PersonEntity person) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: GlassTheme.glassColor(context),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: GlassTheme.glassBorder(context)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  ZinkoNetworkImage(
                      imageUrl: person.avatarUrl,
                      width: 50,
                      height: 50,
                      borderRadius: 25),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(person.name,
                            style: TextStyle(
                                color: GlassTheme.textColor(context),
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                                letterSpacing: -0.5)),
                        Text(person.role,
                            style: TextStyle(
                                color: GlassTheme.secondaryTextColor(context)
                                    .withValues(alpha: 0.8),
                                fontSize: 14,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                            color: GlassTheme.glassColor(context),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: GlassTheme.glassBorder(context))),
                        alignment: Alignment.center,
                        child: Text('IGNORE',
                            style: TextStyle(
                                color: GlassTheme.textColor(context),
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                                letterSpacing: 1.0)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => context
                          .read<CommunityBloc>()
                          .add(ToggleConnectionEvent(person.id)),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'ACCEPT',
                          style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.black
                                  : Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 11,
                              letterSpacing: 1.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms);
  }
}

