import 'package:flutter_study/common/model/model_with_id.dart';
import 'package:flutter_study/common/model/pagination_params.dart';
import '../model/cursor_pagination_model.dart';

abstract class IBasePaginationRepository<T extends IModelWithId>{
  Future<CursorPagination<T>> paginate({
    PaginationParams? paginationParams = const PaginationParams(),
  });
}