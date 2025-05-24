import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;
  bool _isConnected = false;

  Future<void> connect({required String productVariantId}) async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('accessToken') ?? '';
    final String socketUrl =
        dotenv.env['SOCKET_URL'] ?? 'http://localhost:3000/';

    socket = IO.io(
      '${socketUrl}review',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setExtraHeaders({'authorization': accessToken})
          .build(),
    );

    socket.onConnect((_) {
      _isConnected = true;
      // Join room với product_variant_id
      socket.emit('join_room', {'product_variant_id': productVariantId});
    });

    socket.onDisconnect((_) {
      _isConnected = false;
    });
  }

  void sendReview({
    required String productVariantId,
    required String review,
    required Function(dynamic) onError,
  }) {
    if (_isConnected) {
      socket.emit('add_review', {
        'product_variant_id': productVariantId,
        'content': review,
      });
    } else {
      onError('Socket not connected');
    }
  }

  void sendReviewRating({
    required String productVariantId,
    required String review,
    required int rating,
    required Function(dynamic) onError,
  }) {
    if (_isConnected) {
      socket.emit('add_review', {
        'product_variant_id': productVariantId,
        'rating': rating,
        'content': review,
      });
    } else {
      onError('Socket not connected');
    }
  }

  void onNewReview(Function(Map<String, dynamic>) callback) {
    socket.on('new_review', (data) {
      if (data is Map<String, dynamic>) {
        callback(data);
      } else if (data is Map) {
        callback(Map<String, dynamic>.from(data));
      }
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
