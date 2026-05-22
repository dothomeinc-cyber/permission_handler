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

  // Calendar & Reminders - Using non-deprecated versions
  calendarWriteOnly,
  calendarFullAccess,
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
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.photos:
        return Permission.photos;
      case PermissionType.videos:
        return Permission.videos;
      case PermissionType.audio:
        return Permission.audio;
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.microphone:
        return Permission.microphone;
      case PermissionType.contacts:
        return Permission.contacts;
      case PermissionType.location:
        return Permission.location;
      case PermissionType.locationAlways:
        return Permission.locationAlways;
      case PermissionType.locationWhenInUse:
        return Permission.locationWhenInUse;
      case PermissionType.notifications:
        return Permission.notification;
      case PermissionType.calendarWriteOnly:
        return Permission.calendarWriteOnly;
      case PermissionType.calendarFullAccess:
        return Permission.calendarFullAccess;
      case PermissionType.reminders:
        return Permission.reminders;
      case PermissionType.bluetooth:
        return Permission.bluetooth;
      case PermissionType.sensors:
        return Permission.sensors;
      case PermissionType.phone:
        return Permission.phone;
      case PermissionType.sms:
        return Permission.sms;
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
      case PermissionType.storage:
      case PermissionType.photos:
      case PermissionType.videos:
      case PermissionType.audio:
        return PermissionGroup.media;
      case PermissionType.camera:
      case PermissionType.microphone:
      case PermissionType.contacts:
        return PermissionGroup.communication;
      case PermissionType.location:
      case PermissionType.locationAlways:
      case PermissionType.locationWhenInUse:
        return PermissionGroup.locationServices;
      case PermissionType.calendarWriteOnly:
      case PermissionType.calendarFullAccess:
      case PermissionType.reminders:
        return PermissionGroup.calendar;
      case PermissionType.bluetooth:
        return PermissionGroup.bluetooth;
      case PermissionType.sensors:
        return PermissionGroup.sensors;
      case PermissionType.phone:
      case PermissionType.sms:
        return PermissionGroup.phone;
      default:
        return PermissionGroup.other;
    }
  }

  String get displayName {
    switch (this) {
      case PermissionType.storage:
        return 'Storage';
      case PermissionType.photos:
        return 'Photos';
      case PermissionType.videos:
        return 'Videos';
      case PermissionType.audio:
        return 'Audio';
      case PermissionType.camera:
        return 'Camera';
      case PermissionType.microphone:
        return 'Microphone';
      case PermissionType.contacts:
        return 'Contacts';
      case PermissionType.location:
        return 'Location';
      case PermissionType.locationAlways:
        return 'Location (Always)';
      case PermissionType.locationWhenInUse:
        return 'Location (While Using)';
      case PermissionType.notifications:
        return 'Notifications';
      case PermissionType.calendarWriteOnly:
        return 'Calendar (Write Only)';
      case PermissionType.calendarFullAccess:
        return 'Calendar (Full Access)';
      case PermissionType.reminders:
        return 'Reminders';
      case PermissionType.bluetooth:
        return 'Bluetooth';
      case PermissionType.sensors:
        return 'Sensors';
      case PermissionType.phone:
        return 'Phone';
      case PermissionType.sms:
        return 'SMS';
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
      case PermissionType.storage:
        return '💾';
      case PermissionType.photos:
        return '🖼️';
      case PermissionType.videos:
        return '🎥';
      case PermissionType.audio:
        return '🎵';
      case PermissionType.camera:
        return '📷';
      case PermissionType.microphone:
        return '🎤';
      case PermissionType.contacts:
        return '👥';
      case PermissionType.location:
      case PermissionType.locationAlways:
      case PermissionType.locationWhenInUse:
        return '📍';
      case PermissionType.notifications:
        return '🔔';
      case PermissionType.calendarWriteOnly:
      case PermissionType.calendarFullAccess:
        return '📅';
      case PermissionType.reminders:
        return '⏰';
      case PermissionType.bluetooth:
        return '📶';
      case PermissionType.sensors:
        return '📊';
      case PermissionType.phone:
        return '📞';
      case PermissionType.sms:
        return '💬';
      default:
        return '🔧';
    }
  }

  String get description {
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
          PermissionType.calendarWriteOnly,
          PermissionType.calendarFullAccess,
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
