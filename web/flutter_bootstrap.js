{{flutter_js}}
{{flutter_build_config}}

// Serve CanvasKit from the app's own origin instead of the gstatic CDN so
// the app works fully offline / behind restricted networks.
_flutter.loader.load({
  config: {
    canvasKitBaseUrl: "canvaskit/",
  },
});
