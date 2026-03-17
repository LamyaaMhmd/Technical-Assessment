import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lamyaatask/features/topup/domain/entities/beneficiary.dart';
import 'package:lamyaatask/features/topup/domain/entities/transaction.dart';
import 'package:lamyaatask/features/topup/domain/entities/user.dart';
import 'package:lamyaatask/features/topup/domain/usecases/topup_number.dart';

import '../mock_repository.dart';

void main() {
  late TopupNumber usecase;
  late MockTopupRepository mockRepository;

  // Helpers
  User makeUser({double balance = 5000.0, bool isVerified = true}) =>
      User(id: '1', balance: balance, isVerified: isVerified);

  Beneficiary makeBeneficiary({double monthlyUsed = 0.0}) => Beneficiary(
    id: 'b1',
    nickname: 'Mom',
    phoneNumber: '0501234567',
    monthlyUsed: monthlyUsed,
  );

  Transaction makeTransaction({double amount = 50.0, DateTime? date}) =>
      Transaction(
        id: 't1',
        beneficiaryId: 'b1',
        amount: amount,
        date: date ?? DateTime.now(),
      );

  setUp(() {
    mockRepository = MockTopupRepository();
    usecase = TopupNumber(mockRepository);
  });

  // Default happy-path stub
  void stubSuccess({
    User? user,
    List<Beneficiary>? beneficiaries,
    List<Transaction>? transactions,
  }) {
    when(
      () => mockRepository.getUser(),
    ).thenAnswer((_) async => user ?? makeUser());
    when(
      () => mockRepository.getBeneficiaries(),
    ).thenAnswer((_) async => beneficiaries ?? [makeBeneficiary()]);
    when(
      () => mockRepository.getTransactions(),
    ).thenAnswer((_) async => transactions ?? []);
    when(
      () => mockRepository.topup(
        beneficiaryId: any(named: 'beneficiaryId'),
        amount: any(named: 'amount'),
      ),
    ).thenAnswer((_) async {});
  }

  group('TopupNumber - success', () {
    test('should call repository.topup when all validations pass', () async {
      stubSuccess();

      await usecase(beneficiaryId: 'b1', amount: 50.0);

      verify(
        () => mockRepository.topup(beneficiaryId: 'b1', amount: 50.0),
      ).called(1);
    });
  });

  group('TopupNumber - insufficient balance', () {
    test('should throw when balance is less than amount + fee', () async {
      // balance = 50, amount = 50, fee = 3 → total = 53 > 50
      stubSuccess(user: makeUser(balance: 50.0));

      expect(
        () => usecase(beneficiaryId: 'b1', amount: 50.0),
        throwsA(
          predicate(
            (e) =>
                e is Exception && e.toString().contains('Insufficient balance'),
          ),
        ),
      );
    });

    test('should pass when balance exactly covers amount + fee', () async {
      // balance = 53, amount = 50, fee = 3 → total = 53 == 53 ✅
      stubSuccess(user: makeUser(balance: 53.0));

      await expectLater(usecase(beneficiaryId: 'b1', amount: 50.0), completes);
    });
  });

  group('TopupNumber - per-beneficiary monthly limit', () {
    test('should throw when unverified user exceeds AED 500 limit', () async {
      stubSuccess(
        user: makeUser(isVerified: false),
        beneficiaries: [makeBeneficiary(monthlyUsed: 480.0)],
      );

      // 480 + 30 = 510 > 500
      expect(
        () => usecase(beneficiaryId: 'b1', amount: 30.0),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Monthly limit exceeded'),
          ),
        ),
      );
    });

    test('should pass when unverified user is within AED 500 limit', () async {
      stubSuccess(
        user: makeUser(isVerified: false, balance: 5000.0),
        beneficiaries: [makeBeneficiary(monthlyUsed: 400.0)],
      );

      // 400 + 50 = 450 <= 500 ✅
      await expectLater(usecase(beneficiaryId: 'b1', amount: 50.0), completes);
    });

    test('should throw when verified user exceeds AED 1000 limit', () async {
      stubSuccess(
        user: makeUser(isVerified: true),
        beneficiaries: [makeBeneficiary(monthlyUsed: 980.0)],
      );

      // 980 + 30 = 1010 > 1000
      expect(
        () => usecase(beneficiaryId: 'b1', amount: 30.0),
        throwsA(
          predicate(
            (e) =>
                e is Exception &&
                e.toString().contains('Monthly limit exceeded'),
          ),
        ),
      );
    });

    test('should pass when verified user is within AED 1000 limit', () async {
      stubSuccess(
        user: makeUser(isVerified: true, balance: 5000.0),
        beneficiaries: [makeBeneficiary(monthlyUsed: 900.0)],
      );

      // 900 + 50 = 950 <= 1000 ✅
      await expectLater(usecase(beneficiaryId: 'b1', amount: 50.0), completes);
    });
  });

  group('TopupNumber - total monthly limit', () {
    test(
      'should throw when total monthly transactions exceed AED 3000',
      () async {
        final now = DateTime.now();
        stubSuccess(
          transactions: [
            makeTransaction(amount: 1000.0, date: now),
            makeTransaction(amount: 1000.0, date: now),
            makeTransaction(amount: 900.0, date: now),
          ],
        );

        // total = 2900 + 200 = 3100 > 3000
        expect(
          () => usecase(beneficiaryId: 'b1', amount: 200.0),
          throwsA(
            predicate(
              (e) =>
                  e is Exception &&
                  e.toString().contains('Total monthly limit'),
            ),
          ),
        );
      },
    );

    test(
      'should pass when total monthly transactions are within AED 3000',
      () async {
        final now = DateTime.now();
        stubSuccess(
          transactions: [
            makeTransaction(amount: 1000.0, date: now),
            makeTransaction(amount: 1000.0, date: now),
          ],
        );

        // total = 2000 + 50 = 2050 <= 3000 ✅
        await expectLater(
          usecase(beneficiaryId: 'b1', amount: 50.0),
          completes,
        );
      },
    );

    test('should NOT count transactions from previous months', () async {
      final lastMonth = DateTime(
        DateTime.now().year,
        DateTime.now().month - 1,
        1,
      );
      stubSuccess(
        transactions: [
          // These are from last month — should be ignored
          makeTransaction(amount: 1000.0, date: lastMonth),
          makeTransaction(amount: 1000.0, date: lastMonth),
          makeTransaction(amount: 1000.0, date: lastMonth),
        ],
      );

      // previous month total = 3000, but should not count → passes ✅
      await expectLater(usecase(beneficiaryId: 'b1', amount: 100.0), completes);
    });
  });
}
