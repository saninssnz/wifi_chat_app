import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:wifi_chat_app/domain/app_service.dart';
import 'package:wifi_chat_app/presentation/app.dart';
import 'package:wifi_chat_app/presentation/components/file_preview.dart';
import 'package:wifi_chat_app/uikit/action_button.dart';

import '../components/device_preview.dart';

class CommunicationView extends StatefulWidget {
  const CommunicationView({super.key});

  @override
  State<CommunicationView> createState() => _CommunicationViewState();
}

class _CommunicationViewState extends State<CommunicationView> {
  String message = '';
  String locationData = '';
  List<PlatformFile> files = [];
  Position? _currentPosition;
  String? _currentAddress;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<AppService>();
    final filesLoadings = service.filesLoadings;
    final device = service.connectedDevice;
    if (device == null) {
      return Center(
        child: ActionButton(
          onTap: context.read<AppService>().stopListeningAll,
          title: 'Restart',
        ),
      );
    }
    final inputBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: kGreenColor),
      borderRadius: BorderRadius.circular(32),
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DevicePreview(device: device, largeView: true),
        const SizedBox(height: 10),
        Flexible(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  onChanged: (value) => setState(() {
                    message = value;
                  }),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    enabledBorder: inputBorder,
                    border: inputBorder,
                    focusedBorder: inputBorder,
                    hintStyle: const TextStyle(color: kGreenColor),
                    hintText: 'Enter a message',
                  ),
                ),
              ),
              Flexible(
                child: ActionButton(
                    title: 'Send',
                    onTap: () {
                      context.read<AppService>().sendTextRequest(
                            message,
                          );
                    }),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Center(child: Text('OR')),
        const SizedBox(height: 10),
        Flexible(
          child: _isLoading
              ? Center(
                  child: const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: ActionButton(
                        type: ActionType.success,
                        title: 'Get current location',
                        onTap: () async {
                            _getCurrentPosition();
                        },
                      ),
                    ),
                    if (_currentPosition != null)
                      Flexible(
                        child: ActionButton(
                            title: 'Send',
                            onTap: () {
                              setState(() {
                                locationData =
                                    "Latitude: ${_currentPosition?.latitude}\nLongitude: ${_currentPosition?.longitude}";
                              });
                              context.read<AppService>().sendTextRequest(
                                    locationData,
                                  );
                            }),
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 40),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_currentPosition != null) ...[
                Row(
                  children: [
                    Icon(
                      Icons.location_on_rounded,
                      color: Colors.red,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Current Location:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Text('Latitude: ${_currentPosition?.latitude}'),
                Text('Longitude: ${_currentPosition?.longitude}'),
              ],
              SizedBox(
                height: 40,
              ),
              if (service.messagesList.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      Icons.message,
                      color: Colors.green,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Received Messages:',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.orange),
                    ),
                  ],
                ),
              if (service.messagesList.isNotEmpty)
                SizedBox(
                  height: 20,
                ),
              if (service.messagesList.isNotEmpty)
                ListView.builder(
                  physics: ScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: service.messagesList.length,
                  itemBuilder: (context, index) {
                    final msg = service.messagesList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Material(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(3)),
                        color: Colors.grey.shade300,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(msg),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ],
    );
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    setState(() {
      _isLoading = true;
    });

    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) {
      setState(() {
        _isLoading = false;
      });
      return;
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() {
        _currentPosition = position;
        _isLoading = false;
      });
    }).catchError((e) {
      debugPrint(e);
      setState(() {
        _isLoading = false;
      });
    });
  }
}
