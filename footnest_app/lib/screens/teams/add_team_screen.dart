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
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: "Nome squadra",
                    ),
                  ),

                  const SizedBox(height: 20),

                  OutlinedButton.icon(
                    onPressed: pickLogo,
                    icon: const Icon(Icons.image),
                    label: Text(
                      selectedLogo == null
                          ? "Seleziona logo"
                          : selectedLogo!.path.split('/').last,
                    ),
                  ),

                if(selectedLogo != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Image.file(
                      selectedLogo!,
                      height: 80,
                    ),
                  ),

                  const SizedBox(height: 20),

                  DropdownButtonFormField<int>(
                    value: selectedCompetitionSeasonId,
                    decoration: const InputDecoration(
                      labelText: "Competizione",
                    ),
                    items: competitionSeasons
                        .map(
                          (cs) => DropdownMenuItem(
                            value: cs.id,
                            child: Text(
                              cs.displayName,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCompetitionSeasonId =
                            value;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  ElevatedButton(
                    onPressed: saving
                        ? null
                        : saveTeam,
                    child: saving
                        ? const CircularProgressIndicator()
                        : const Text(
                            "Salva",
                          ),

                  )

                ],
              ),
            ),
    );
  }

}