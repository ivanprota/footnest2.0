import 'package:flutter/material.dart';

import '/services/service_locator.dart';
import '/services/auth_state_service.dart';

class AppSidebar extends StatelessWidget {

  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onAccountPressed;

  const AppSidebar({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onAccountPressed
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff181B22),
      child: NavigationRail(
        selectedIndex: selectedIndex,
        onDestinationSelected: onItemSelected,
        extended: true,
        minWidth: 80,
        trailing: Expanded(
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Builder(
                  builder: (context) {
                    final auth = locator<AuthStateService>();
                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: onAccountPressed,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

                            const CircleAvatar(
                              radius: 18,
                              child: Icon(
                                Icons.person,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 12),

                            Text(
                              auth.username ?? "Account",
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),

                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
        ),
        leading: Column(
          children: [
            Icon(
              Icons.sports_soccer,
              size: 45,
              color: Theme.of(context)
                  .colorScheme
                  .primary,
            ),

            const SizedBox(height: 10),

            Text(
              "Footnest",
              style: Theme.of(context)
                  .textTheme
                  .titleMedium,
            ),

            const SizedBox(height: 25),
          ],
        ),
        indicatorColor: Theme.of(context)
            .colorScheme
            .primary
            .withOpacity(0.20),
        selectedIconTheme: IconThemeData(
          color: Theme.of(context)
              .colorScheme
              .primary,
        ),
        unselectedIconTheme: const IconThemeData(
          color: Colors.white70,
        ),
        selectedLabelTextStyle: TextStyle(
          color: Theme.of(context)
              .colorScheme
              .primary,
          fontWeight: FontWeight.bold,
        ),
        unselectedLabelTextStyle: const TextStyle(
          color: Colors.white70,
        ),
        destinations: const [
          NavigationRailDestination(
            icon: Icon(Icons.groups),
            label: Text(
              "Squadre",
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.sports_soccer),
            label: Text(
              "Partite",
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.emoji_events),
            label: Text(
              "Competizioni",
            ),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.tips_and_updates),
            label: Text(
              "Pronostici",
            ),
          ),
        ],
      ),
    );
  }

}
