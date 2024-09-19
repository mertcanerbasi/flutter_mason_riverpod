import 'dart:io';
import '../../../core/res/icons.dart';
import '../../../core/res/l10n/app_localizations.dart';
import '../../../core/res/l10n/l10n.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import '../../../feature/providers/locale_provider.dart';
import '../../../feature/providers/siren_provider.dart';
import '../../../feature/providers/theme_provider.dart';
import 'package:route_map/route_map.dart';

@RouteMap(name: "settings")
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProviderNotifier = ref.watch(themeViewModelProvider.notifier);
    final themeProvider = ref.watch(themeViewModelProvider);
    final localeProviderNotifier = ref.watch(localeViewModelProvider.notifier);
    final sirenProviderNotifier = ref.read(sirenViewModelProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ListTile(
                onTap: () {
                  if (Platform.isIOS) {
                    AppSettings.openAppSettings(
                        type: AppSettingsType.appLocale);
                  } else if (Platform.isAndroid) {
                    showModalBottomSheet<Locale?>(
                        showDragHandle: true,
                        context: context,
                        useRootNavigator: true,
                        builder: (c) => ListView.builder(
                            shrinkWrap: true,
                            itemCount: AppLocalizations.supportedLocales.length,
                            itemBuilder: (c, i) {
                              var item = AppLocalizations.supportedLocales[i];
                              return ListTile(
                                onTap: () {
                                  Navigator.pop(c, item);
                                },
                                title: Text(item.fullName()),
                              );
                            })).then((value) async {
                      if (value != null) {
                        await localeProviderNotifier.setLocale(value);
                      }
                    });
                  }
                },
                title: Text(context.l10n.language),
                leading: const Icon(AppIcons.language),
                trailing: const Icon(AppIcons.chevronRight),
              ),
              ListTile(
                leading: const Icon(AppIcons.darkMode),
                title: Text(context.l10n.appearance),
                trailing: Switch(
                  value: themeProvider == ThemeMode.dark,
                  onChanged: (value) {
                    themeProviderNotifier.toggleTheme();
                  },
                ),
              ),
              ListTile(
                title: Text(context.l10n.version),
                leading: const Icon(AppIcons.version),
                subtitle: Text(sirenProviderNotifier.currentVersion),
              ),
              ListTile(
                title: Text(context.l10n.licenses),
                leading: const Icon(AppIcons.license),
                trailing: const Icon(AppIcons.chevronRight),
                onTap: () {
                  showLicensePage(
                      context: context,
                      useRootNavigator: true,
                      applicationName: "App Name",
                      applicationVersion: sirenProviderNotifier.currentVersion,
                      applicationLegalese: "Mertcan Erbaşı");
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
