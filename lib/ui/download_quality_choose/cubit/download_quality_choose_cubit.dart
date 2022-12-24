import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'download_quality_choose_state.dart';

class DownloadQualityChooseCubit extends Cubit<DownloadQualityChooseState> {
  DownloadQualityChooseCubit() : super(DownloadQualityChooseInitial());
}
