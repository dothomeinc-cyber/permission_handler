import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
  storage,
  camera,
  location,
  locationAlways,
  locationWhenInUse,
  photos,
  contacts,
  microphone,
  notifications,
  calendar,
  reminders,
  bluetooth,
  sensors,
  sms,
  phone,
}

extension PermissionTypeExtension on PermissionType {
  Permission get permission {
    switch (this) {
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.location:
        return Permission.location;
      case PermissionType.locationAlways:
        return Permission.locationAlways;
      case PermissionType.locationWhenInUse:
        return Permission.locationWhenInUse;
      case PermissionType.photos:
        return Permission.photos;
      case PermissionType.contacts:
        return Permission.contacts;
      case PermissionType.microphone:
        return Permission.microphone;
      case PermissionType.notifications:
        return Permission.notification;
      case PermissionType.calendar:
        return Permission.calendar;
      case PermissionType.reminders:
        return Permission.reminders;
      case PermissionType.bluetooth:
        return Permission.bluetooth;
      case PermissionType.sensors:
        return Permission.sensors;
      case PermissionType.sms:
        return Permission.sms;
      case PermissionType.phone:
        return Permission.phone;
    }
  }

  String get displayName {
    switch (this) {
      case PermissionType.storage:
        return 'Storage';
      case PermissionType.camera:
        return 'Camera';
      case PermissionType.location:
        return 'Location';
      case PermissionType.locationAlways:
        return 'Location (Always)';
      case PermissionType.locationWhenInUse:
        return 'Location (When In Use)';
      case PermissionType.photos:
        return 'Photos';
      case PermissionType.contacts:
        return 'Contacts';
      case PermissionType.microphone:
        return 'Microphone';
      case PermissionType.notifications:
        return 'Notifications';
      case PermissionType.calendar:
        return 'Calendar';
      case PermissionType.reminders:
        return 'Reminders';
      case PermissionType.bluetooth:
        return 'Bluetooth';
      case PermissionType.sensors:
        return 'Sensors';
      case PermissionType.sms:
        return 'SMS';
      case PermissionType.phone:
        return 'Phone';
    }
  }

  String get icon {
    switch (this) {
      case PermissionType.storage:
        return '📁';
      case PermissionType.camera:
        return '📷';
      case PermissionType.location:
      case PermissionType.locationAlways:
      case PermissionType.locationWhenInUse:
        return '📍';
      case PermissionType.photos:
        return '🖼️';
      case PermissionType.contacts:
        return '👥';
      case PermissionType.microphone:
        return '🎤';
      case PermissionType.notifications:
        return '🔔';
      case PermissionType.calendar:
        return '📅';
      case PermissionType.reminders:
        return '⏰';
      case PermissionType.bluetooth:
        return '📶';
      case PermissionType.sensors:
        return '📊';
      case PermissionType.sms:
        return '💬';
      case PermissionType.phone:
        return '📞';
    }
  }
}
