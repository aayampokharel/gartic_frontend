
import 'package:http/http.dart' as http;

class AnimationService {
  Future<String> forProgressBar() async {
    var response =
        await http.get(Uri.parse("http://localhost:8080/progressbar"));
    return response.body;
  }
}
