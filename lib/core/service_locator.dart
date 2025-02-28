import 'package:get_it/get_it.dart';
import 'package:land_house_verify/presentation/widgets/show_dialog.dart';

import '../data/services/add_room_service.dart';
import '../data/services/asset_register_service.dart';
import '../data/services/auth_service.dart';
import '../data/services/cloudinary_file_upload_servise.dart';
import '../data/services/email_service.dart';
import '../data/services/file_picker_service.dart';
import '../data/services/register_validator_service.dart';
import '../data/services/report_service.dart';
import '../data/services/revaluation_report_service.dart';
import '../data/services/validation_data_service.dart';

final getIt = GetIt.instance;

void setupLocator() {
  // Register services as singletons
  getIt.registerLazySingleton<EmailSend>(() => EmailSend());
  getIt.registerLazySingleton<RegisterValidatorService>(
      () => RegisterValidatorService());
  getIt.registerLazySingleton<AssetRegisterService>(
      () => AssetRegisterService());
  getIt.registerLazySingleton<ShowConfirmationDialogClass>(
      () => ShowConfirmationDialogClass());
  getIt.registerLazySingleton<ValidationService>(
    () => ValidationService(),
  );
  getIt.registerLazySingleton(() => ReportService());

  getIt.registerLazySingleton(() => AddRoomService());
  getIt.registerLazySingleton(() => AuthService());
  getIt.registerLazySingleton(() => AssetRegisterService());
  getIt.registerLazySingleton(() => CloudinaryFileUploadService());

  getIt.registerLazySingleton(() => FilePickerService());

  getIt.registerLazySingleton(() => RegisterValidatorService());
  getIt.registerLazySingleton(() => ReportService());
  getIt.registerLazySingleton(() => RevaluationReportService());
}
