import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '/models/user/user.dart';
import '/services/service_locator.dart';
import '/services/user_service.dart';
import '/services/auth_state_service.dart';

class UsersScreen extends StatefulWidget {

  const UsersScreen({
    super.key,
  });

  @override
  State<UsersScreen> createState() => _UsersScreenState();

}

class _UsersScreenState extends State<UsersScreen> {

  final userService = locator<UserService>();
  final authStateService = locator<AuthStateService>();

  List<User> users = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future loadUsers() async {

    setState(() {
      loading = true;
    });

    try {

      final result = await userService.getUsers();

      final currentUsername =
          authStateService.username;

      result.sort((a, b) {

        // Utente corrente sempre primo
        if (a.username == currentUsername) {
          return -1;
        }

        if (b.username == currentUsername) {
          return 1;
        }

        // Poi gli admin
        if (a.admin && !b.admin) {
          return -1;
        }

        if (!a.admin && b.admin) {
          return 1;
        }

        // Infine gli utenti normali
        return a.username
            .toLowerCase()
            .compareTo(
              b.username.toLowerCase(),
            );

      });

      if (!mounted) return;

      setState(() {
        users = result;
        loading = false;
      });

    } catch (e) {

      if (!mounted) return;

      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Errore nel caricamento degli utenti: $e",
          ),
        ),
      );
    }
  }

  Future<void> updateApproval(
    User user,
    bool approved,
  ) async {

    try {

      final updated =
          await userService.updateApproval(
            user.id,
            approved,
          );

      if (!mounted) return;

      setState(() {

        final index =
            users.indexWhere(
              (u) => u.id == user.id,
            );

        if (index != -1) {
          users[index] = updated;
        }

      });

    } catch (e) {

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Errore durante la modifica: $e",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Row(
          children: [

            Icon(
              Icons.people,
            ),

            SizedBox(width: 10),

            Text(
              "Utenti",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),

          ],
        ),
      ),

      body: loading

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : RefreshIndicator(
              onRefresh: loadUsers,

              child: ListView.builder(

                padding: const EdgeInsets.all(20),

                itemCount: users.length,

                itemBuilder: (context, index) {

                  final user = users[index];

                  return _UserTile(
                    user: user,
                    isAdmin: authStateService.admin,
                    isCurrentUser: user.username == authStateService.username,
                    onApprovalChanged: updateApproval,
                    onTap: () {
                      context.push("/profile/user/${user.id}");
                    }
                  );

                },

              ),
            ),

    );

  }

}


class _UserTile extends StatefulWidget {

  final User user;
  final bool isAdmin;
  final bool isCurrentUser;
  final Future<void> Function(User user, bool approved) onApprovalChanged;
  final VoidCallback onTap;

  const _UserTile({
    required this.user,
    required this.isAdmin,
    required this.isCurrentUser,
    required this.onApprovalChanged,
    required this.onTap
  });

  @override
  State<_UserTile> createState() => _UserTileState();

}


class _UserTileState extends State<_UserTile> {

  bool hovered = false;

  @override
  Widget build(BuildContext context) {

    final user = widget.user;

    return MouseRegion(

      cursor: SystemMouseCursors.click,

      onEnter: (_) {
        setState(() {
          hovered = true;
        });
      },

      onExit: (_) {
        setState(() {
          hovered = false;
        });
      },

      child: AnimatedContainer(

        duration: const Duration(
          milliseconds: 180,
        ),

        margin: const EdgeInsets.only(
          bottom: 10,
        ),

        decoration: BoxDecoration(

          color: hovered
              ? Colors.white.withOpacity(0.05)
              : Colors.transparent,

          borderRadius:
              BorderRadius.circular(12),

        ),

        child: Card(
          child: Row(
            children: [

              Expanded(
                child: InkWell(
                  mouseCursor: SystemMouseCursors.click,
                  onTap: widget.onTap,

                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [

                        CircleAvatar(
                          child: Text(
                            user.username
                                .substring(0, 1)
                                .toUpperCase(),
                          ),
                        ),

                        const SizedBox(width: 15),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [

                              Row(
                                children: [

                                  Text(
                                    user.username,
                                    style: const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,
                                    ),
                                  ),

                                  if (widget.isCurrentUser) ...[
                                    const SizedBox(width: 8),

                                    Text(
                                      "(Tu)",
                                      style: TextStyle(
                                        color:
                                            Theme.of(context)
                                                .colorScheme
                                                .primary,
                                        fontWeight:
                                            FontWeight.bold,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],

                                ],
                              ),

                              const SizedBox(height: 4),

                              Text(
                                user.admin
                                    ? "Amministratore"
                                    : "Utente",
                              ),

                            ],
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),

              // CONTROLLI ADMIN
              if (widget.isAdmin && !widget.isCurrentUser)
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Switch(
                        value: user.approved,
                        mouseCursor:
                            SystemMouseCursors.click,
                        onChanged: (value) {
                          widget.onApprovalChanged(
                            user,
                            value,
                          );
                        },
                      ),

                      const SizedBox(width: 10),

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: user.approved
                              ? Colors.green.withOpacity(0.15)
                              : Colors.orange
                                  .withOpacity(0.15),
                          borderRadius:
                              BorderRadius.circular(20),
                        ),
                        child: Text(
                          user.approved
                              ? "Approvato"
                              : "Non approvato",
                          style: TextStyle(
                            color: user.approved
                                ? Colors.green
                                : Colors.orange,
                            fontWeight:
                                FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),

                    ],
                  ),
                )

              else
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16,
                  ),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: user.approved
                          ? Colors.green.withOpacity(0.15)
                          : Colors.orange.withOpacity(0.15),
                      borderRadius:
                          BorderRadius.circular(20),
                    ),
                    child: Text(
                      user.approved
                          ? "Approvato"
                          : "Non approvato",
                      style: TextStyle(
                        color: user.approved
                            ? Colors.green
                            : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),

            ],
          ),
        ),

      ),

    );

  }

}