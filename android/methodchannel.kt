import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "midtrans_payment_channel";

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler((call, result) -> {
                    if (call.method.equals("startPayment")) {
                        // Panggil fungsi untuk memulai pembayaran Midtrans di sini
                        startPayment();
                    } else {
                        result.notImplemented();
                    }
                });
    }

    private void startPayment() {
        // Implementasikan logika untuk memulai pembayaran Midtrans di sini
    }
}
