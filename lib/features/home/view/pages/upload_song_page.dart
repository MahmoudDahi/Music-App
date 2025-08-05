import 'dart:io';

import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/widgets/custom_field.dart';
import 'package:client/core/widgets/loader_widget.dart';
import 'package:client/features/home/view/widgets/audio_wave.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<UploadSongPage> {
  final songNameController = TextEditingController();
  final artistController = TextEditingController();
  Color selectedColor = Pallete.cardColor;
  File? selectedSongFile;
  File? selectedImageFile;
  final formKey = GlobalKey<FormState>();

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImageFile = pickedImage;
      });
    }
  }

  void selectSong() async {
    final pickedSong = await pickAudio();
    if (pickedSong != null) {
      setState(() {
        selectedSongFile = pickedSong;
      });
    }
  }

  @override
  void dispose() {
    songNameController.dispose();
    artistController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(
        homeViewModelProvider.select((value) => value?.isLoading == true));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Song'),
        actions: [
          IconButton(
            onPressed: () async {
              if (formKey.currentState!.validate() &&
                  selectedImageFile != null &&
                  selectedSongFile != null) {
                ref.read(homeViewModelProvider.notifier).uploadSong(
                      selectedAudio: selectedSongFile!,
                      selectedImage: selectedImageFile!,
                      songName: songNameController.text,
                      artist: artistController.text,
                      selectedColor: selectedColor,
                    );
              } else {
                showSnakeBar(
                  context: context,
                  content: 'Missing Fields!',
                  color: Pallete.errorColor,
                );
              }
            },
            icon: const Icon(
              Icons.check,
            ),
          ),
        ],
      ),
      body: isLoading
          ? const LoaderWidget()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: selectImage,
                        child: selectedImageFile != null
                            ? Container(
                                height: 150,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: FileImage(
                                        selectedImageFile!,
                                      ),
                                      fit: BoxFit.cover),
                                ),
                              )
                            : const DottedBorder(
                                options: RoundedRectDottedBorderOptions(
                                  radius: Radius.circular(10),
                                  strokeCap: StrokeCap.round,
                                  dashPattern: [10, 4],
                                  color: Pallete.borderColor,
                                ),
                                child: SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.folder_open,
                                        size: 40,
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text(
                                        'Select the thumbnail for your song',
                                        style: TextStyle(
                                          fontSize: 15,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      selectedSongFile != null
                          ? AudioWave(path: selectedSongFile!.path)
                          : CustomField(
                              hintText: 'Pick Song',
                              controller: null,
                              readOnly: true,
                              onTap: selectSong,
                            ),
                      const SizedBox(height: 20),
                      CustomField(
                          hintText: 'Artist', controller: artistController),
                      const SizedBox(height: 20),
                      CustomField(
                          hintText: 'Song Name',
                          controller: songNameController),
                      const SizedBox(height: 20),
                      ColorPicker(
                        pickersEnabled: const {
                          ColorPickerType.wheel: true,
                        },
                        color: selectedColor,
                        onColorChanged: (value) {
                          selectedColor = value;
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
