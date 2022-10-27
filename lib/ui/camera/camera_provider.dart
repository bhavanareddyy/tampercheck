
import 'package:camera/camera.dart' as camera;
import 'package:injectable/injectable.dart';

abstract class CameraProvider {
  Future<List<camera.CameraDescription>> availableCameras();
}

@Injectable(as: CameraProvider)
class CameraProviderImpl implements CameraProvider {
  @override
  Future<List<camera.CameraDescription>> availableCameras() =>
      camera.availableCameras();
}
