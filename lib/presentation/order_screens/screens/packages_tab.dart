import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/order_bloc/create_order_process_state.dart';
import '../widgets/package_form.dart';
import '../../../blocs/order_bloc/create_order_process_cubit.dart';

class PackagesTab extends StatefulWidget {
  final VoidCallback nextPage;
  final VoidCallback previousPage;

  const PackagesTab({
    Key? key,
    required this.nextPage,
    required this.previousPage,
  }) : super(key: key);

  @override
  State<PackagesTab> createState() => _PackagesTabState();
}

class _PackagesTabState extends State<PackagesTab> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<CreateOrderProcessCubit>(context).addPackage([]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<CreateOrderProcessCubit, CreateOrderProcessState>(
        builder: (context, state) {
          bool anyFieldEmpty = state.packages.any((package) =>
              package.packageName.isEmpty ||
              package.packagePrice.toString().isEmpty);

          return Form(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16.0, 16.0, 0, 0),
                        child: Text(
                          'Notice: You should use a delivery service with insurance for high-value orders.',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      ...state.packages.asMap().entries.map(
                        (entry) {
                          int index = entry.key;

                          return Stack(
                            children: [
                              Positioned(
                                top: 2,
                                right: 2,
                                child: state.packages.length > 1
                                    ? IconButton(
                                        onPressed: () {
                                          context
                                              .read<CreateOrderProcessCubit>()
                                              .deletePackage(index);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 20.0,
                                        ),
                                      )
                                    : Container(),
                              ),
                              PackageForm(
                                index: index,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 16.0),
                      ElevatedButton(
                        onPressed: () => context
                            .read<CreateOrderProcessCubit>()
                            .addPackage(state.packages),
                        child: const Text('Add Package'),
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: widget.previousPage,
                            child: const Text('Previous'),
                          ),
                          const SizedBox(width: 16.0),
                          OutlinedButton(
                            onPressed: anyFieldEmpty ? null : widget.nextPage,
                            child: const Text('Next'),
                          ),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
