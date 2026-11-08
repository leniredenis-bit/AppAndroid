import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as tabs;
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'i18n.dart';

/// Abre um link num navegador embutido em **meia tela**, por cima do jogo,
/// sem tirar a pessoa do app (texto bíblico, texto diário…).
///
/// - Android: Partial Custom Tabs (folha inferior, arrastável até tela cheia).
///   Em aparelhos sem suporte, abre a Custom Tab em tela cheia, ainda dentro do app.
/// - iOS: Safari View Controller em folha (meia tela / tela cheia).
/// - Web/desktop: não existe navegador embutido — abre em nova aba.
Future<void> openInAppBrowser(BuildContext context, String url) async {
  final uri = Uri.parse(url);
  final height = MediaQuery.of(context).size.height;
  const bar = Color(0xFF162447);
  try {
    await tabs.launchUrl(
      uri,
      customTabsOptions: tabs.CustomTabsOptions.partial(
        configuration: tabs.PartialCustomTabsConfiguration.bottomSheet(
          initialHeight: height * 0.72,
          cornerRadius: 16,
          activityHeightResizeBehavior: tabs.CustomTabsActivityHeightResizeBehavior.adjustable,
        ),
        colorSchemes: tabs.CustomTabsColorSchemes.defaults(toolbarColor: bar),
        shareState: tabs.CustomTabsShareState.on,
        showTitle: true,
      ),
      safariVCOptions: tabs.SafariViewControllerOptions.pageSheet(
        configuration: const tabs.SheetPresentationControllerConfiguration(
          detents: {tabs.SheetPresentationControllerDetent.medium, tabs.SheetPresentationControllerDetent.large},
          prefersGrabberVisible: true,
          prefersScrollingExpandsWhenScrolledToEdge: true,
        ),
        preferredBarTintColor: bar,
        preferredControlTintColor: Colors.white,
        dismissButtonStyle: tabs.SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (_) {
    // Sem Custom Tabs/Safari disponível: tenta o navegador embutido padrão e, por fim, o externo
    try {
      final ok = await launcher.launchUrl(uri, mode: launcher.LaunchMode.inAppBrowserView);
      if (!ok) await launcher.launchUrl(uri, mode: launcher.LaunchMode.externalApplication);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(t3('Não foi possível abrir o link.', 'Could not open the link.', 'No se pudo abrir el enlace.')),
        ));
      }
    }
  }
}
