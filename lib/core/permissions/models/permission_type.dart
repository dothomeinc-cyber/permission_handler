import 'package:permission_handler/permission_handler.dart';

enum PermissionType {
  // Storage & Media
  storage,
  photos,
  videos,
  audio,

  // Communication
  camera,
  microphone,
  contacts,

  // Location
  location,
  locationAlways,
  locationWhenInUse,

  // Notifications
  notifications,

  // Calendar & Reminders
  calendar,
  reminders,

  // Connectivity
  bluetooth,

  // Sensors
  sensors,

  // Phone & SMS
  phone,
  sms,

  // App-specific
  appTrackingTransparency,
  criticalAlerts,
  scheduleExactAlarm,
  ignoreBatteryOptimizations,
  manageExternalStorage,
  systemAlertWindow,
  requestInstallPackages,
  accessNotificationPolicy,
}

extension PermissionTypeExtension on PermissionType {
  Permission get permission {
    switch (this) {
      // Storage & Media
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.photos:
        return Permission.photos;
      case PermissionType.videos:
        return Permission.videos;
      case PermissionType.audio:
        return Permission.audio;

      // Communication
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.microphone:
        return Permission.microphone;
      case PermissionType.contacts:
        return Permission.contacts;

      // Location
      case PermissionType.location:
        return Permission.location;
      case PermissionType.locationAlways:
        return Permission.locationAlways;
      case PermissionType.locationWhenInUse:
        return Permission.locationWhenInUse;

      // Notifications
      case PermissionType.notifications:
        return Permission.notification;

      // Calendar & Reminders
      case PermissionType.calendar:
        return Permission.calendar;
      case PermissionType.reminders:
        return Permission.reminders;

      // Connectivity
      case PermissionType.bluetooth:
        return Permission.bluetooth;

      // Sensors
      case PermissionType.sensors:
        return Permission.sensors;

      // Phone & SMS
      case PermissionType.phone:
        return Permission.phone;
      case PermissionType.sms:
        return Permission.sms;

      // App-specific
      case PermissionType.appTrackingTransparency:
        return Permission.appTrackingTransparency;
      case PermissionType.criticalAlerts:
        return Permission.criticalAlerts;
      case PermissionType.scheduleExactAlarm:
        return Permission.scheduleExactAlarm;
      case PermissionType.ignoreBatteryOptimizations:
        return Permission.ignoreBatteryOptimizations;
      case PermissionType.manageExternalStorage:
        return Permission.manageExternalStorage;
      case PermissionType.systemAlertWindow:
        return Permission.systemAlertWindow;
      case PermissionType.requestInstallPackages:
        return Permission.requestInstallPackages;
      case PermissionType.accessNotificationPolicy:
        return Permission.accessNotificationPolicy;
    }
  }

  PermissionGroup get group {
    switch (this) {
      // Storage & Media Group
      case PermissionType.storage:
      case PermissionType.photos:
      case PermissionType.videos:
      case PermissionType.audio:
        return PermissionGroup.media;

      // Communication Group
      case PermissionType.camera:
      case PermissionType.microphone:
      case PermissionType.contacts:
        return PermissionGroup.communication;

      // Location Group
      case PermissionType.location:
      case PermissionType.locationAlways:
      case PermissionType.locationWhenInUse:
        return PermissionGroup.locationServices;

      // Calendar Group
      case PermissionType.calendar:
      case PermissionType.reminders:
        return PermissionGroup.calendar;

      // Connectivity Group
      case PermissionType.bluetooth:
        return PermissionGroup.bluetooth;

      // Sensors Group
      case PermissionType.sensors:
        return PermissionGroup.sensors;

      // Phone Group
      case PermissionType.phone:
      case PermissionType.sms:
        return PermissionGroup.phone;

      // Default group
      default:
        return PermissionGroup.other;
    }
  }

  String get displayName {
    switch (this) {
      // Storage & Media
      case PermissionType.storage:
        return 'Storage';
      case PermissionType.photos:
        return 'Photos';
      case PermissionType.videos:
        return 'Videos';
      case PermissionType.audio:
        return 'Audio';

      // Communication
      case PermissionType.camera:
        return 'Camera';
      case PermissionType.microphone:
        return 'Microphone';
      case PermissionType.contacts:
        return 'Contacts';

      // Location
      case PermissionType.location:
        return 'Location';
      case PermissionType.locationAlways:
        return 'Location (Always)';
      case PermissionType.locationWhenInUse:
        return 'Location (While Using)';

      // Notifications
      case PermissionType.notifications:
        return 'Notifications';

      // Calendar & Reminders
      case PermissionType.calendar:
        return 'Calendar';
      case PermissionType.reminders:
        return 'Reminders';

      // Connectivity
      case PermissionType.bluetooth:
        return 'Bluetooth';

      // Sensors
      case PermissionType.sensors:
        return 'Sensors';

      // Phone & SMS
      case PermissionType.phone:
        return 'Phone';
      case PermissionType.sms:
        return 'SMS';

      // App-specific
      case PermissionType.appTrackingTransparency:
        return 'App Tracking';
      case PermissionType.criticalAlerts:
        return 'Critical Alerts';
      case PermissionType.scheduleExactAlarm:
        return 'Exact Alarms';
      case PermissionType.ignoreBatteryOptimizations:
        return 'Battery Optimization';
      case PermissionType.manageExternalStorage:
        return 'External Storage';
      case PermissionType.systemAlertWindow:
        return 'System Alerts';
      case PermissionType.requestInstallPackages:
        return 'Install Packages';
      case PermissionType.accessNotificationPolicy:
        return 'Notification Policy';
    }
  }

  String get icon {
    switch (this) {
      // Storage & Media
      case PermissionType.storage:
        return '💾';
      case PermissionType.photos:
        return '🖼️';
      case PermissionType.videos:
        return '🎥';
      case PermissionType.audio:
        return '🎵';

      // Communication
      case PermissionType.camera:
        return '📷';
      case PermissionType.microphone:
        return '🎤';
      case PermissionType.contacts:
        return '👥';

      // Location
      case PermissionType.location:
      case PermissionType.locationAlways:
      case PermissionType.locationWhenInUse:
        return '📍';

      // Notifications
      case PermissionType.notifications:
        return '🔔';

      // Calendar & Reminders
      case PermissionType.calendar:
        return '📅';
      case PermissionType.reminders:
        return '⏰';

      // Connectivity
      case PermissionType.bluetooth:
        return '📶';

      // Sensors
      case PermissionType.sensors:
        return '📊';

      // Phone & SMS
      case PermissionType.phone:
        return '📞';
      case PermissionType.sms:
        return '💬';

      // App-specific
      default:
        return '🔧';
    }
  }

  String get description {
    switch (this) {
      case PermissionType.photos:
        return 'Access to your photos and images';
      case PermissionType.videos:
        return 'Access to your video library';
      case PermissionType.audio:
        return 'Access to your audio and music files';
      case PermissionType.storage:
        return 'Access to device storage for reading and writing files';
      default:
        switch (group) {
          case PermissionGroup.media:
            return 'Access to photos, videos, audio, and files on your device';
          case PermissionGroup.communication:
            return 'Access to camera, microphone, and contacts for communication features';
          case PermissionGroup.locationServices:
            return 'Access to your location for maps and location-based services';
          case PermissionGroup.calendar:
            return 'Access to calendar events and reminders';
          case PermissionGroup.bluetooth:
            return 'Access to Bluetooth for connecting to nearby devices';
          case PermissionGroup.sensors:
            return 'Access to device sensors for health and fitness tracking';
          case PermissionGroup.phone:
            return 'Access to phone and SMS features';
          default:
            return 'This permission is required for app functionality';
        }
    }
  }
}

enum PermissionGroup {
  media,
  communication,
  locationServices,
  calendar,
  bluetooth,
  sensors,
  phone,
  other,
}

extension PermissionGroupExtension on PermissionGroup {
  String get displayName {
    switch (this) {
      case PermissionGroup.media:
        return 'Media & Files';
      case PermissionGroup.communication:
        return 'Communication';
      case PermissionGroup.locationServices:
        return 'Location Services';
      case PermissionGroup.calendar:
        return 'Calendar';
      case PermissionGroup.bluetooth:
        return 'Bluetooth';
      case PermissionGroup.sensors:
        return 'Sensors';
      case PermissionGroup.phone:
        return 'Phone';
      case PermissionGroup.other:
        return 'Other Permissions';
    }
  }

  String get icon {
    switch (this) {
      case PermissionGroup.media:
        return '🎬';
      case PermissionGroup.communication:
        return '💬';
      case PermissionGroup.locationServices:
        return '📍';
      case PermissionGroup.calendar:
        return '📅';
      case PermissionGroup.bluetooth:
        return '📶';
      case PermissionGroup.sensors:
        return '📊';
      case PermissionGroup.phone:
        return '📞';
      case PermissionGroup.other:
        return '🔧';
    }
  }

  List<PermissionType> get permissions {
    switch (this) {
      case PermissionGroup.media:
        return [
          PermissionType.storage,
          PermissionType.photos,
          PermissionType.videos,
          PermissionType.audio,
        ];
      case PermissionGroup.communication:
        return [
          PermissionType.camera,
          PermissionType.microphone,
          PermissionType.contacts,
        ];
      case PermissionGroup.locationServices:
        return [
          PermissionType.location,
          PermissionType.locationAlways,
          PermissionType.locationWhenInUse,
        ];
      case PermissionGroup.calendar:
        return [
          PermissionType.calendar,
          PermissionType.reminders,
        ];
      case PermissionGroup.bluetooth:
        return [PermissionType.bluetooth];
      case PermissionGroup.sensors:
        return [PermissionType.sensors];
      case PermissionGroup.phone:
        return [PermissionType.phone, PermissionType.sms];
      case PermissionGroup.other:
        return [];
    }
  }
}
