import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CastCard extends StatelessWidget {
  final String name;
  final String role;
  final String image;
  const CastCard(
      {super.key, required this.name, required this.role, required this.image});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        width: 90,
        margin: const EdgeInsets.only(right: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                image,
                height: 80,
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return const Center(
                      child: CupertinoActivityIndicator(
                        color: Colors.white,
                        radius: 8,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              name,
              style: TextStyles.headingsForSectionsForSmallerScreens,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            Text(
              role,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyles.formSubTitle,
            ),
          ],
        ),
      ),
    );
  }
}
