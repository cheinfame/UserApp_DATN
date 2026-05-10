import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:packare/blocs/order_bloc/create_order_process_cubit.dart';
import 'package:packare/config/typography.dart';
import 'dart:io';

import '../../../blocs/order_bloc/create_order_process_state.dart';
import '../../../utils/thousands_formatter.dart';
import '../../global_widgets/info_text_field.dart';

class PackageForm extends StatefulWidget {
  final int index;

  const PackageForm({
    required this.index,
  });

  @override
  _PackageFormState createState() => _PackageFormState();
}

class _PackageFormState extends State<PackageForm> {
  late TextEditingController packageNameController;
  late TextEditingController packageDescriptionController;
  late TextEditingController packagePriceController;
  final _picker = ImagePicker();
  XFile? image;

  @override
  void initState() {
    super.initState();
    packageNameController = TextEditingController();
    packageDescriptionController = TextEditingController();
    packagePriceController = TextEditingController();
    // Set initial text for controllers
    packageNameController.text = context
        .read<CreateOrderProcessCubit>()
        .state
        .packages[widget.index]
        .packageName;
    packageDescriptionController.text = context
        .read<CreateOrderProcessCubit>()
        .state
        .packages[widget.index]
        .packageDescription!;
    packagePriceController.text =
        NumberFormat.currency(locale: 'vi_VN', symbol: '').format(context
            .read<CreateOrderProcessCubit>()
            .state
            .packages[widget.index]
            .packagePrice);
  }

  @override
  void dispose() {
    packageNameController.dispose();
    packageDescriptionController.dispose();
    packagePriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateOrderProcessCubit, CreateOrderProcessState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'New Package',
                      style: AppTypography(context: context).heading1,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.55,
                      child: InfoTextField(
                        context: context,
                        isObscure: false,
                        hintText: 'Package Name',
                        label: 'Package Name',
                        isValid: true,
                        textFieldController: packageNameController,
                        onChanged: (value) => context
                            .read<CreateOrderProcessCubit>()
                            .updatePackage(widget.index,
                                packageName: packageNameController.text),
                        formValidator: (value) => value!.isEmpty
                            ? 'Please enter a package name'
                            : null,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: InfoTextField(
                        context: context,
                        isObscure: false,
                        isValid: true,
                        hintText: 'Package Price',
                        label: 'Package Price',
                        keyboardType: TextInputType.number,
                        textFieldController: packagePriceController,
                        onChanged: (value) {
                          String cleanValue = value.replaceAll(
                              RegExp(r'\s+'), ''); // Remove spaces
                          context.read<CreateOrderProcessCubit>().updatePackage(
                                widget.index,
                                price: cleanValue.isNotEmpty
                                    ? double.tryParse(cleanValue) ?? 0
                                    : 0,
                              );
                        },
                        inputFormatters: [
                          ThousandsFormatter(), // Custom formatter
                        ],
                        suffixText: '₫', // Set the suffix to VND symbol
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                InfoTextField(
                  textFieldController: packageDescriptionController,
                  context: context,
                  isObscure: false,
                  hintText: 'Package Description',
                  label: 'Package Description',
                  isValid: true,
                  onChanged: (value) => context
                      .read<CreateOrderProcessCubit>()
                      .updatePackage(widget.index,
                          packageDescription:
                              packageDescriptionController.text),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Add Picture',
                      style: AppTypography(context: context)
                          .bodyText
                          .copyWith(fontSize: 14.0),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () => pickImage(ImageSource.camera),
                      child: const Icon(Icons.camera_alt),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () => pickImage(ImageSource.gallery),
                      child: const Icon(Icons.photo_library),
                    ),
                  ],
                ),
                if (image != null) ...[
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 160,
                    height: 200,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                              height: 150,
                              width: 150,
                              child: Image.file(File(image!.path))),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              setState(() {
                                image = null;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  void pickImage(ImageSource source) async {
    final cubit =
        context.read<CreateOrderProcessCubit>(); // Store cubit instance
    final XFile? pickedImage = await _picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });

      // Store the image path in a local variable
      final imagePath = pickedImage.path;

      // Update the cubit state with the image path
      cubit.updatePackageImage(widget.index, imagePath);
    }
  }
}
