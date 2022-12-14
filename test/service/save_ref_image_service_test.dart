
import 'dart:async';
import 'dart:typed_data';

import 'package:blink_comparison/core/encrypt/encrypt.dart';
import 'package:blink_comparison/core/entity/entity.dart';
import 'package:blink_comparison/core/fs/fs_result.dart';
import 'package:blink_comparison/core/service/generate_thumbnail_job.dart';
import 'package:blink_comparison/core/service/save_ref_image_job.dart';
import 'package:blink_comparison/core/service/save_ref_image_service.dart';
import 'package:blink_comparison/core/service/save_thumbnail_job.dart';
import 'package:blink_comparison/platform/save_ref_image_native_service.dart';
import 'package:cross_file/cross_file.dart';
import 'package:file/file.dart';
import 'package:file/memory.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../mock/mock.dart';

void main() {
  group('Save reference image service |', () {
    late SaveRefImageJob mockSaveJob;
    late GenerateThumbnailJob mockGenerateThumbnailJob;
    late SaveThumbnailJob mockSaveThumbnailJob;
    late SaveRefImageServiceController mockServiceController;
    late SaveRefImageJobController mockJobController;
    late final FileSystem fs;
    late final File srcFile;
    late SaveRefImageService service;

    setUpAll(() async {
      fs = MemoryFileSystem.test();
      final tmp = await fs.systemTempDirectory.createTemp('tmp');
      srcFile = tmp.childFile('srcFile');
      registerFallbackValue(XFile(''));
    });

    setUp(() async {
      mockSaveJob = MockSaveRefImageJob();
      mockServiceController = MockSaveRefImageServiceController();
      mockJobController = MockSaveRefImageJobController();
      mockGenerateThumbnailJob = MockGenerateThumbnailJob();
      mockSaveThumbnailJob = MockSaveThumbnailJob();
      await srcFile.create();
      service = SaveRefImageServiceImpl(
        mockSaveJob,
        fs,
        mockServiceController,
        mockJobController,
        mockGenerateThumbnailJob,
        mockSaveThumbnailJob,
      );
    });

    test('Save', () async {
      final request = ServiceRequest(
        info: RefImageInfo(
          id: '1',
          dateAdded: DateTime(2021),
          encryptSalt: 'salt',
        ),
        srcFile: XFile(srcFile.path),
        key: const SecureKey.password('123'),
      );
      when(
        () => mockJobController.pushQueue(request),
      ).thenAnswer((_) async => {});

      await service.save(
        info: request.info,
        srcImage: request.srcFile,
        key: request.key,
      );
      verify(() => mockJobController.pushQueue(request)).called(1);
    });

    test('Get current status', () async {
      final infoList = [
        RefImageInfo(id: '1', dateAdded: DateTime(2021), encryptSalt: 'salt'),
        RefImageInfo(id: '2', dateAdded: DateTime(2021), encryptSalt: 'salt'),
        RefImageInfo(id: '3', dateAdded: DateTime(2021), encryptSalt: 'salt'),
      ];
      final expectedStatusList = infoList.map(
        (info) => SaveRefImageStatus.inProgress(imageId: info.id),
      );
      when(
        () => mockServiceController.getAllInProgress(),
      ).thenAnswer((_) async => infoList);

      expect(await service.getCurrentStatus(), expectedStatusList);
    });

    test('Observe status', () async {
      final infoList = [
        RefImageInfo(id: '1', dateAdded: DateTime(2021), encryptSalt: 'salt'),
        RefImageInfo(id: '2', dateAdded: DateTime(2021), encryptSalt: 'salt'),
        RefImageInfo(id: '3', dateAdded: DateTime(2021), encryptSalt: 'salt'),
      ];
      final inProgress = infoList
          .map(
            (info) => SaveRefImageStatus.inProgress(imageId: info.id),
          )
          .toList();
      const key = SecureKey.password('123');
      final _controller = StreamController<ServiceResult>();
      _controller.add(
        ServiceResult.fail(
          request: ServiceRequest(
            info: infoList[0],
            srcFile: XFile(srcFile.path),
            key: key,
          ),
          error: ServiceError.saveImage(
            SaveRefImageError.fs(
              path: srcFile.path,
              error: const FsError.io(),
            ),
          ),
        ),
      );

      for (final info in infoList.sublist(1)) {
        _controller.add(
          ServiceResult.success(
            request: ServiceRequest(
              info: info,
              srcFile: XFile(srcFile.path),
              key: key,
            ),
          ),
        );
      }
      when(
        () => mockJobController.observeResult(),
      ).thenAnswer((_) => _controller.stream);
      when(
        () => mockServiceController.getAllInProgress(),
      ).thenAnswer((_) async => infoList);

      expect(
        await service.observeStatus().take(4).toList(),
        [
          inProgress,
          [
            ...inProgress,
            SaveRefImageStatus.completed(
              imageId: infoList[0].id,
              error: SaveRefImageStatusError.saveImage(
                SaveRefImageError.fs(
                  path: srcFile.path,
                  error: const FsError.io(),
                ),
              ),
            ),
          ],
          [
            ...inProgress,
            SaveRefImageStatus.completed(imageId: infoList[1].id),
          ],
          [
            ...inProgress,
            SaveRefImageStatus.completed(imageId: infoList[2].id),
          ],
        ],
      );
      _controller.close();
    });

    group('Job |', () {
      test('Run job', () async {
        const key = SecureKey.password('123');
        final requests = [
          ServiceRequest(
            info: RefImageInfo(
              id: '1',
              dateAdded: DateTime(2021),
              encryptSalt: 'salt',
            ),
            srcFile: XFile(srcFile.path),
            key: key,
          ),
          ServiceRequest(
            info: RefImageInfo(
              id: '2',
              dateAdded: DateTime(2021),
              encryptSalt: 'salt',
            ),
            srcFile: XFile(srcFile.path),
            key: key,
          ),
          ServiceRequest(
            info: RefImageInfo(
              id: '3',
              dateAdded: DateTime(2021),
              encryptSalt: 'salt',
            ),
            srcFile: XFile(srcFile.path),
            key: key,
          ),
        ];
        final thumbnail = Uint8List.fromList([1, 2, 3]);
        when(
          () => mockServiceController.observeQueue(),
        ).thenAnswer((_) => Stream.fromIterable(requests));
        for (final request in requests) {
          when(
            () => mockSaveJob.run(
              info: request.info,
              file: request.srcFile,
              key: key,
            ),
          ).thenAnswer((_) async => const SaveRefImageResult.success());
          when(
            () => mockGenerateThumbnailJob.run(request.srcFile),
          ).thenAnswer(
            (_) async => GenerateThumbnailResult.success(thumbnail: thumbnail),
          );
          when(
            () => mockSaveThumbnailJob.run(
              info: request.info,
              thumbnail: thumbnail,
            ),
          ).thenAnswer(
            (_) async => const SaveThumbnailResult.success(),
          );
          when(
            () => mockServiceController.sendResult(
              ServiceResult.success(request: request),
            ),
          ).thenAnswer((_) async => {});
        }
        when(
          () => mockServiceController.stopService(),
        ).thenAnswer((_) async => {});

        await (service as SaveRefImageServiceImpl).runJob();
        for (final request in requests) {
          verify(
            () => mockServiceController.sendResult(
              ServiceResult.success(request: request),
            ),
          ).called(1);
        }
      });

      test('Save image error', () async {
        const key = SecureKey.password('123');
        final request = ServiceRequest(
          info: RefImageInfo(
            id: '1',
            dateAdded: DateTime(2021),
            encryptSalt: 'salt',
          ),
          srcFile: XFile(srcFile.path),
          key: key,
        );
        final expectedResult = ServiceResult.fail(
          request: request,
          error: ServiceError.saveImage(
            SaveRefImageError.fs(
              path: srcFile.path,
              error: const FsError.io(),
            ),
          ),
        );
        when(
          () => mockServiceController.observeQueue(),
        ).thenAnswer((_) => Stream.value(request));
        when(
          () => mockSaveJob.run(
            info: request.info,
            file: request.srcFile,
            key: key,
          ),
        ).thenAnswer(
          (_) async => SaveRefImageResult.error(
            SaveRefImageError.fs(
              path: srcFile.path,
              error: const FsError.io(),
            ),
          ),
        );
        when(
          () => mockServiceController.sendResult(expectedResult),
        ).thenAnswer((_) async => {});
        when(
          () => mockServiceController.stopService(),
        ).thenAnswer((_) async => {});

        await (service as SaveRefImageServiceImpl).runJob();
        verify(
          () => mockServiceController.sendResult(expectedResult),
        ).called(1);
      });

      test('Generate thumbnail error', () async {
        const key = SecureKey.password('123');
        final request = ServiceRequest(
          info: RefImageInfo(
            id: '1',
            dateAdded: DateTime(2021),
            encryptSalt: 'salt',
          ),
          srcFile: XFile(srcFile.path),
          key: key,
        );
        final expectedResult = ServiceResult.fail(
          request: request,
          error: const ServiceError.generateThumbnail(
            GenerateThumbnailError.fs(FsError.io()),
          ),
        );
        when(
          () => mockServiceController.observeQueue(),
        ).thenAnswer((_) => Stream.value(request));
        when(
          () => mockSaveJob.run(
            info: request.info,
            file: request.srcFile,
            key: key,
          ),
        ).thenAnswer((_) async => const SaveRefImageResult.success());
        when(
          () => mockGenerateThumbnailJob.run(request.srcFile),
        ).thenAnswer(
          (_) async => const GenerateThumbnailResult.fail(
            GenerateThumbnailError.fs(
              FsError.io(),
            ),
          ),
        );
        when(
          () => mockServiceController.sendResult(expectedResult),
        ).thenAnswer((_) async => {});
        when(
          () => mockServiceController.stopService(),
        ).thenAnswer((_) async => {});

        await (service as SaveRefImageServiceImpl).runJob();
        verify(
          () => mockServiceController.sendResult(expectedResult),
        ).called(1);
      });

      test('Save thumbnail error', () async {
        const key = SecureKey.password('123');
        final request = ServiceRequest(
          info: RefImageInfo(
            id: '1',
            dateAdded: DateTime(2021),
            encryptSalt: 'salt',
          ),
          srcFile: XFile(srcFile.path),
          key: key,
        );
        final expectedResult = ServiceResult.fail(
          request: request,
          error: const ServiceError.saveThumbnail(
            SaveThumbnailError.fs(FsError.io()),
          ),
        );
        final thumbnail = Uint8List.fromList([1, 2, 3]);
        when(
          () => mockServiceController.observeQueue(),
        ).thenAnswer((_) => Stream.value(request));
        when(
          () => mockSaveJob.run(
            info: request.info,
            file: request.srcFile,
            key: key,
          ),
        ).thenAnswer((_) async => const SaveRefImageResult.success());
        when(
          () => mockGenerateThumbnailJob.run(request.srcFile),
        ).thenAnswer(
          (_) async => GenerateThumbnailResult.success(thumbnail: thumbnail),
        );
        when(
          () => mockSaveThumbnailJob.run(
            info: request.info,
            thumbnail: thumbnail,
          ),
        ).thenAnswer(
          (_) async => const SaveThumbnailResult.fail(
            SaveThumbnailError.fs(FsError.io()),
          ),
        );
        when(
          () => mockServiceController.sendResult(expectedResult),
        ).thenAnswer((_) async => {});
        when(
          () => mockServiceController.stopService(),
        ).thenAnswer((_) async => {});

        await (service as SaveRefImageServiceImpl).runJob();
        verify(
          () => mockServiceController.sendResult(expectedResult),
        ).called(1);
      });

      test('Timeout', () async {
        when(
          () => mockServiceController.observeQueue(),
        ).thenAnswer((_) => const Stream.empty());
        when(
          () => mockServiceController.stopService(),
        ).thenAnswer((_) async => {});

        final startTime = DateTime.now().toUtc();
        await (service as SaveRefImageServiceImpl).runJob();
        final stopTime = DateTime.now().toUtc();

        expect(
          stopTime.difference(startTime),
          greaterThanOrEqualTo(const Duration(seconds: 1)),
        );
      });
    });

    group('Service controller', () {
      late SaveRefImageNativeService mockNativeService;
      late SaveRefImageServiceController serviceController;

      setUp(() {
        mockNativeService = MockSaveRefImageNativeService();
        serviceController = SaveRefImageServiceController(mockNativeService);
      });

      test('Send result', () async {
        final result = ServiceResult.success(
          request: ServiceRequest(
            info: RefImageInfo(
              id: '1',
              dateAdded: DateTime(2021),
              encryptSalt: 'salt',
            ),
            srcFile: XFile(srcFile.path),
            key: const SecureKey.password('123'),
          ),
        );
        when(
          () => mockNativeService.sendResult(result),
        ).thenAnswer((_) async => {});

        await serviceController.sendResult(result);
        verify(
          () => mockNativeService.sendResult(result),
        ).called(1);
      });

      test('Stop service', () async {
        when(
          () => mockNativeService.stop(),
        ).thenAnswer((_) async => {});

        await serviceController.stopService();
        verify(() => mockNativeService.stop()).called(1);
      });

      test('Get all in progress', () async {
        final request = ServiceRequest(
          info: RefImageInfo(
            id: '1',
            dateAdded: DateTime(2021),
            encryptSalt: 'salt',
          ),
          srcFile: XFile(srcFile.path),
          key: const SecureKey.password('123'),
        );
        when(
          () => mockNativeService.getAllInProgress(),
        ).thenAnswer((_) async => [request]);

        expect(await serviceController.getAllInProgress(), [request.info]);
      });

      test('Observe queue', () async {
        when(
          () => mockNativeService.observeQueue(),
        ).thenAnswer((_) => const Stream.empty());

        await for (final _ in serviceController.observeQueue()) {}
        verify(
          () => mockNativeService.observeQueue(),
        ).called(1);
      });
    });

    group('Job controller', () {
      late SaveRefImageNativeService mockNativeService;
      late SaveRefImageJobController jobController;

      setUp(() {
        mockNativeService = MockSaveRefImageNativeService();
        jobController = SaveRefImageJobController(mockNativeService);
      });

      test('Push queue', () async {
        final request = ServiceRequest(
          info: RefImageInfo(
            id: '1',
            dateAdded: DateTime(2021),
            encryptSalt: 'salt',
          ),
          srcFile: XFile(srcFile.path),
          key: const SecureKey.password('123'),
        );
        when(
          () => mockNativeService.pushQueue(request),
        ).thenAnswer((_) async => {});
        when(
          () => mockNativeService.isRunning(),
        ).thenAnswer((_) async => true);

        await jobController.pushQueue(request);
        verify(
          () => mockNativeService.pushQueue(request),
        ).called(1);
      });

      test('Push queue and start service', () async {
        final request = ServiceRequest(
          info: RefImageInfo(
            id: '1',
            dateAdded: DateTime(2021),
            encryptSalt: 'salt',
          ),
          srcFile: XFile(srcFile.path),
          key: const SecureKey.password('123'),
        );
        when(
          () => mockNativeService.pushQueue(request),
        ).thenAnswer((_) async => {});
        when(
          () => mockNativeService.isRunning(),
        ).thenAnswer((_) async => false);
        when(
          () => mockNativeService.start(callbackDispatcher: callbackDispatcher),
        ).thenAnswer((_) async => {});

        await jobController.pushQueue(request);
        verify(
          () => mockNativeService.pushQueue(request),
        ).called(1);
        verify(
          () => mockNativeService.start(callbackDispatcher: callbackDispatcher),
        ).called(1);
      });

      test('Observe result', () async {
        when(
          () => mockNativeService.observeResult(),
        ).thenAnswer((_) => const Stream.empty());

        await for (final _ in jobController.observeResult()) {}
        verify(
          () => mockNativeService.observeResult(),
        ).called(1);
      });
    });
  });
}
