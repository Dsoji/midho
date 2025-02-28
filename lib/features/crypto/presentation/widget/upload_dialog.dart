import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mdiho/features/withdrawal/presentation/widget/info_widget.dart';

class UploadProofDialog extends HookWidget {
  const UploadProofDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final imageFile = useState<File?>(null);
    final picker = ImagePicker();

    Future<void> pickImage() async {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path);
      }
    }

    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      contentPadding: const EdgeInsets.all(20),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Step 2",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          const Text(
            "Once you’ve sent the BTC, upload your proof of payment below:",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 12),
          InfoWidget(
            theme: theme,
            text:
                "Upload a clear screenshot showing the transaction details as proof.",
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: pickImage,
            child: imageFile.value == null
                ? Container(
                    height: 120,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[100],
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cloud_upload_outlined,
                            size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text("Upload Screenshot or Proof of Payment",
                            textAlign: TextAlign.center),
                      ],
                    ),
                  )
                : Stack(
                    alignment: Alignment.topRight,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.file(imageFile.value!,
                            height: 150, fit: BoxFit.cover),
                      ),
                      GestureDetector(
                        onTap: () => imageFile.value = null,
                        child: const CircleAvatar(
                          radius: 14,
                          backgroundColor: Colors.red,
                          child:
                              Icon(Icons.close, color: Colors.white, size: 16),
                        ),
                      ),
                    ],
                  ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              minimumSize: const Size(double.infinity, 45),
            ),
            onPressed: imageFile.value != null ? () {} : null,
            child: const Text("Submit Proof",
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
