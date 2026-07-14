import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:file_picker/file_picker.dart';

import '/models/team/team_create_request.dart';
import '/models/competitionseason/competition_season.dart';

import '/services/team_service.dart';
import '/services/competition_season_service.dart';
import '/services/service_locator.dart';
import '/services/upload_service.dart';

import 'dart:io';


class AddTeamScreen extends StatefulWidget {

  const AddTeamScreen({
    super.key,
  });

  @override
  State<AddTeamScreen> createState() => _AddTeamScreenState();

}

class _AddTeamScreenState extends State<AddTeamScreen> {

  final TeamService teamService = locator();
  final CompetitionSeasonService competitionSeasonService = locator();
  final UploadService uploadService = locator();
  final TextEditingController nameController = TextEditingController();

  File? selectedLogo;
  String? uploadedLogoPath;

  List<CompetitionSeason> competitionSeasons = [];
  int? selectedCompetitionSeasonId;
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    loadCompetitionSeasons();
  }

  Future<void> loadCompetitionSeasons() async {
    try {
      final data = await competitionSeasonService.getCompetitionSeasons();

      setState(() {
        competitionSeasons = data;
        loading = false;
      });
    } catch(e) {
      setState(() {
        loading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(
                e.toString(),
              ),
            ),
          );
    }

  }

  Future<void> saveTeam() async {
    if(nameController.text.isEmpty ||
       selectedCompetitionSeasonId == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            const SnackBar(
              content: Text(
                "Inserire nome e competizione",
              ),
            ),
          );

      return;
    }

    final competitionSeasonId = selectedCompetitionSeasonId!;

    setState(() {
      saving = true;
    });

    try {
      String logoPath = "";

      if (selectedLogo != null) {
        final uploadResponse = 
          await uploadService.uploadTeamLogo(selectedLogo!, competitionSeasonId);

        logoPath = uploadResponse.logoPath;
      }

      final request = TeamCreateRequest(
        name: nameController.text,
        logoPath: logoPath,
        competitionSeasonId: selectedCompetitionSeasonId!,
      );
      await teamService.createTeam(request);

      if(mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(
              const SnackBar(
                content: Text(
                  "Squadra aggiunta",
                ),
              ),
            );

        context.pop(true);
      }
    } catch(e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: Text(
                e.toString(),
              ),
            ),
          );
    } finally {
      setState(() {
        saving = false;
      });
    }
  }

  Future pickLogo() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if(result != null && result.files.single.path != null) {
      setState(() {
        selectedLogo = File(
          result.files.single.path!,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Aggiungi squadra",
        ),
      ),
      body: loading
        ? const Center(
        child: CircularProgressIndicator(),
        )
        : Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
              maxWidth: 600,
            ),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                  Text(
                    "Nuova squadra",
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Inserisci le informazioni della squadra",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 25),

                  const Divider(),

                  const SizedBox(height: 30),

                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nome squadra",
                      prefixIcon: Icon(Icons.groups),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  const SizedBox(height: 28),

                  Text(
                    "Logo",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade300,
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        if (selectedLogo == null) ...[
                          const Icon(
                            Icons.image_outlined,
                            size: 60,
                            color: Colors.grey,
                          ),

                          const SizedBox(height: 10),

                          const Text("Nessun logo selezionato"),
                        ] else ...[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              selectedLogo!,
                              height: 110,
                              fit: BoxFit.contain,
                            ),
                          ),

                          const SizedBox(height: 12),

                          Text(
                            selectedLogo!.path.split('/').last,
                            textAlign: TextAlign.center,
                          ),
                        ],

                        const SizedBox(height: 18),

                        FilledButton.icon(
                          onPressed: pickLogo,
                          icon: const Icon(Icons.upload),
                          label: Text(
                            selectedLogo == null
                                ? "Seleziona logo"
                                : "Cambia logo",
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Competizione",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),

                  const SizedBox(height: 12),

                  DropdownButtonFormField<int>(
                    value: selectedCompetitionSeasonId,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.emoji_events),
                      labelText: "Competizione",
                    ),
                    items: competitionSeasons
                        .map(
                          (cs) => DropdownMenuItem(
                            value: cs.id,
                            child: Text(cs.displayName),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCompetitionSeasonId = value;
                      });
                    },
                  ),

                  const SizedBox(height: 36),

                  SizedBox(
                    height: 52,
                    child: FilledButton(
                      onPressed: saving ? null : saveTeam,
                      child: saving
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Salva squadra",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),

                  ],
                ),
              ),
            ),
          ),
        )
      ),
    );
  }

}