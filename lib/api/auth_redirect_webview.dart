import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:valoralysis/providers/user_data_provider.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class WebViewPopup extends StatefulWidget {
  WebViewPopup({Key? key}) : super(key: key);

  @override
  _WebViewPopupState createState() => _WebViewPopupState();
}

class _WebViewPopupState extends State<WebViewPopup> {
  final _controller = WebviewController();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> initPlatformState() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      await _controller.initialize();
      await _controller.openDevTools();
      await _controller.setBackgroundColor(Colors.transparent);
      await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
      await _controller.loadUrl(
          'https://auth.riotgames.com/authorize?redirect_uri=https%3A%2F%2Fplayvalorant.com%2Fopt_in&client_id=play-valorant-web-prod&response_type=token%20id_token&nonce=\'1\'&scope=account%20openid'); //listen for url changes and get the token

      //listen for url changes and get the token
      _controller.url.listen((url) async {
        if (url.contains('access_token')) {
          final uri = Uri.parse(url);
          final accessToken = uri.fragment.split('&')[0].split('=')[1];

          final puuid = JwtDecoder.decode(accessToken)['sub'];
          print(puuid);
        }
      });
      if (!mounted) {
        return;
      }
      setState(() {});
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  title: const Text('Error'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Code: ${e.code}'),
                      Text('Message: ${e.message}'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Continue'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                ));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_controller.value.isInitialized) {
      return const Center(
        child: SizedBox(
          width: 64,
          height: 64,
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Stack(
      children: [
        Webview(
          _controller,
          permissionRequested: _onPermissionRequested,
        ),
        StreamBuilder<LoadingState>(
          stream: _controller.loadingState,
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data == LoadingState.loading) {
              return const Center(
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
