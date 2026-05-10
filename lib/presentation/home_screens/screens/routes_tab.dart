import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:packare/blocs/account_bloc/account_bloc.dart';
import 'package:packare/config/path.dart';
import 'package:packare/config/typography.dart';
import 'package:packare/presentation/routes_screens/widgets/save_route_sheet.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../../blocs/map_bloc/map_bloc.dart';
import '../../routes_screens/screens/create_route_screen.dart';

class RoutesTab extends StatefulWidget {
  const RoutesTab({Key? key});

  @override
  State<RoutesTab> createState() => _RoutesTabState();
}

class _RoutesTabState extends State<RoutesTab> {
  final routeNameController = TextEditingController();
  final startLocationController = TextEditingController();
  final endLocationController = TextEditingController();

  late String shipperId;

  @override
  void dispose() {
    routeNameController.dispose();
    startLocationController.dispose();
    endLocationController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    shipperId = context.read<AccountBloc>().state.account!.shipper!.shipperId;
    context.read<MapBloc>().add(GetShipperRoutesEvent(shipperId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Routes',
          style: AppTypography(context: context).title3,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Create Route',
            onPressed: () {
              // Navigate to create route screen
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreateRouteScreen()));
            },
          ),
        ],
      ),
      body: BlocBuilder<MapBloc, MapState>(
        builder: (context, state) {
          if (state.status == MapBlocStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state.status == MapBlocStatus.failed ||
              state.routes.isEmpty) {
            return RefreshIndicator(
              onRefresh: () async {
                final account = context.read<AccountBloc>().state.account;

                if (account != null) {
                  context.read<MapBloc>().add(GetShipperRoutesEvent(shipperId));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          'Cannot find your information, please login again',
                          style: AppTypography(context: context).bodyText,
                        ),
                      );
                    },
                  );
                  context.read<AccountBloc>().add(LogoutEvent());
                }
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: SizedBox(
                          height: 150,
                          width: 150,
                          child: SvgPicture.asset(
                            empty_routes,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Text(
                        'No Route Available',
                        style: AppTypography(context: context).title3.copyWith(
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return RefreshIndicator(
              onRefresh: () async {
                final account = context.read<AccountBloc>().state.account;

                if (account != null) {
                  context.read<MapBloc>().add(GetShipperRoutesEvent(shipperId));
                } else {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          'Cannot find your information, please login again',
                          style: AppTypography(context: context).bodyText,
                        ),
                      );
                    },
                  );
                  context.read<AccountBloc>().add(LogoutEvent());
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ListView.separated(
                  itemCount: state.routes.length,
                  separatorBuilder: (context, index) => const Divider(),
                  itemBuilder: (context, index) {
                    final route = state.routes[index];
                    bool isActive = state.routes[index].isActive;
                    routeNameController.text = state.routes[index].routeName!;
                    startLocationController.text =
                        state.routes[index].startLocation;
                    endLocationController.text =
                        state.routes[index].endLocation;
                    return Slidable(
                      endActionPane:
                          ActionPane(motion: const ScrollMotion(), children: [
                        SlidableAction(
                          flex: 1,
                          onPressed: (context) => context.read<MapBloc>().add(
                              DeleteRouteByIdEvent(
                                  state.routes[index].routeId!)),
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ]),
                      child: ListTile(
                        title: Text(
                          route.routeName!,
                          style: AppTypography(context: context).heading1,
                        ),
                        leading: SvgPicture.asset(
                          route_logo,
                          width: 30,
                          height: 30,
                        ),
                        subtitle: Text(
                          'Distance: ${(route.distance / 1000).toStringAsFixed(2)} km \nDuration: ${(route.duration / 60).toStringAsFixed(2)} mins',
                          style: AppTypography(context: context)
                              .bodyText
                              .copyWith(
                                  fontWeight: FontWeight.w400, fontSize: 14.0),
                        ),
                        trailing: Switch(
                          value: isActive,
                          onChanged: (bool value) {
                            context.read<MapBloc>().add(UpdateRouteByIdEvent(
                                state.routes[index].routeId!,
                                state.routes[index].copyWith(isActive: value)));
                            setState(() {
                              isActive = value;
                            });
                          },
                        ),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          builder: (BuildContext context) {
                            return SaveRouteSheet(
                                isUpdate: true,
                                routeId: state.routes[index].routeId,
                                routeNameController: routeNameController,
                                startLocationController:
                                    startLocationController,
                                endLocationController: endLocationController,
                                startCoords:
                                    state.routes[index].startCoordinates,
                                endCoords: state.routes[index].endCoordinates,
                                isActive: state.routes[index].isActive,
                                distance: state.routes[index].distance,
                                duration: state.routes[index].duration,
                                geometry: state.routes[index].geometry);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
