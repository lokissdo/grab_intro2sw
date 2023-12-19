import 'package:grab/data/repository/customer_repository.dart';
import 'package:grab/utils/helpers/injection.dart';

class LoginViewModel{
final CustomerRepository cusRepo = getIt.get<CustomerRepository>();
}  