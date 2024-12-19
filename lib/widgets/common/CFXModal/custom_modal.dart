import 'package:catchmflixx/constants/styles/text_styles.dart';
import 'package:catchmflixx/widgets/common/buttons/full_button.dart';
import 'package:catchmflixx/widgets/common/buttons/secondary_full_button.dart';
import 'package:flutter/material.dart';

class CustomModal extends StatelessWidget {
  final String mainMessage;
  final String detailedMessage;
  final VoidCallback? primaryFunction;
  final String primary;
  final String? secondary;
  final VoidCallback? secondaryFunction;
  const CustomModal(
      {super.key,
      required this.mainMessage,
      required this.detailedMessage,
      required this.primaryFunction,
      required this.primary,
      this.secondary,
      this.secondaryFunction});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: GestureDetector(
          child: SizedBox(
            height: size.height,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.black,
                          border: Border.all(color: Colors.white38),
                          borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              mainMessage,
                              style: TextStyles.headingsForSections,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              detailedMessage,
                              style: TextStyles.detailsMobile,
                            ),
                            FullButton(
                                content: primary,
                                fn: () {
                                  primaryFunction!();
                                }),
                            secondary != null
                                ? SecondaryFullButton(
                                    content: secondary!,
                                    fn: () {
                                      secondaryFunction!();
                                    })
                                : const SizedBox.shrink()
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
