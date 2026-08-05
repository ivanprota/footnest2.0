import 'package:flutter/material.dart';

import '/config/api_config.dart';


class TeamLogoBox extends StatelessWidget {

  final String name;
  final String logo;

  const TeamLogoBox({
    super.key,
    required this.name,
    required this.logo,
  });


  String logoUrl(String path) {
    if(path.startsWith("http")) {
      return path;
    }

    return "${ApiConfig.baseUrl}/uploads/$path";
  }


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Container(
          width:90,
          height:90,

          padding: const EdgeInsets.all(12),

          decoration: BoxDecoration(
            color:
              Theme.of(context)
                  .colorScheme
                  .surface,

            shape: BoxShape.circle,

            border: Border.all(
              color:
                Theme.of(context)
                    .colorScheme
                    .outline,
            ),
          ),

          child: Image.network(
            logoUrl(logo),

            fit: BoxFit.contain,

            errorBuilder:
              (_,__,___) =>
                const Icon(
                  Icons.shield,
                  size:45,
                ),
          ),

        ),


        const SizedBox(height:12),


        SizedBox(
          width:120,

          child: Text(
            name,

            textAlign: TextAlign.center,

            maxLines:1,

            overflow:
              TextOverflow.ellipsis,

            style:
              const TextStyle(
                fontSize:17,
                fontWeight:
                  FontWeight.bold,
              ),
          ),
        )

      ],
    );
  }
}