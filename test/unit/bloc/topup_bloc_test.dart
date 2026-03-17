// ignore_for_file: unused_local_variable

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:lamyaatask/features/topup/domain/entities/beneficiary.dart';
import 'package:lamyaatask/features/topup/domain/entities/user.dart';
import 'package:lamyaatask/features/topup/domain/usecases/add_beneficiary.dart';
import 'package:lamyaatask/features/topup/domain/usecases/get_beneficiaries.dart';
import 'package:lamyaatask/features/topup/domain/usecases/get_user.dart';
import 'package:lamyaatask/features/topup/domain/usecases/topup_number.dart';
import 'package:lamyaatask/features/topup/presentation/bloc/topup_bloc.dart';
import 'package:lamyaatask/features/topup/presentation/bloc/topup_event.dart';
import 'package:lamyaatask/features/topup/presentation/bloc/topup_state.dart';

import '../mock_repository.dart';

// Mock use cases
class MockGetUser extends Mock implements GetUser {}

class MockGetBeneficiaries extends Mock implements GetBeneficiaries {}

class MockAddBeneficiary extends Mock implements AddBeneficiary {}

class MockTopupNumber extends Mock implements TopupNumber {}

void main() {
  late TopupBloc bloc;
  late MockGetUser mockGetUser;
  late MockGetBeneficiaries mockGetBeneficiaries;
  late MockAddBeneficiary mockAddBeneficiary;
  late MockTopupNumber mockTopupNumber;
  late MockTopupRepository mockRepository;

  final tUser = User(id: '1', balance: 5000.0, isVerified: true);

  final tBeneficiaries = [
    Beneficiary(
      id: 'b1',
      nickname: 'Mom',
      phoneNumber: '0501234567',
      monthlyUsed: 0.0,
    ),
  ];

  setUp(() {
    mockRepository = MockTopupRepository();
    mockGetUser = MockGetUser();
    mockGetBeneficiaries = MockGetBeneficiaries();
    mockAddBeneficiary = MockAddBeneficiary();
    mockTopupNumber = MockTopupNumber();

    bloc = TopupBloc(
      getUser: mockGetUser,
      getBeneficiaries: mockGetBeneficiaries,
      addBeneficiary: mockAddBeneficiary,
      topupNumber: mockTopupNumber,
    );
  });

  tearDown(() => bloc.close());

  group('LoadInitialData', () {
    blocTest<TopupBloc, TopupState>(
      'emits [TopupLoading, TopupLoaded] on success',
      build: () {
        when(() => mockGetUser()).thenAnswer((_) async => tUser);
        when(
          () => mockGetBeneficiaries(),
        ).thenAnswer((_) async => tBeneficiaries);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadInitialData()),
      expect: () => [isA<TopupLoading>(), isA<TopupLoaded>()],
    );

    blocTest<TopupBloc, TopupState>(
      'emits [TopupLoading, TopupError] on failure',
      build: () {
        when(() => mockGetUser()).thenThrow(Exception('Network error'));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadInitialData()),
      expect: () => [isA<TopupLoading>(), isA<TopupError>()],
    );

    blocTest<TopupBloc, TopupState>(
      'TopupLoaded contains correct user and beneficiaries',
      build: () {
        when(() => mockGetUser()).thenAnswer((_) async => tUser);
        when(
          () => mockGetBeneficiaries(),
        ).thenAnswer((_) async => tBeneficiaries);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadInitialData()),
      expect: () => [
        isA<TopupLoading>(),
        predicate<TopupState>((state) {
          if (state is TopupLoaded) {
            return state.user.id == '1' && state.beneficiaries.length == 1;
          }
          return false;
        }),
      ],
    );
  });

  group('AddBeneficiaryEvent', () {
    blocTest<TopupBloc, TopupState>(
      'emits [TopupLoading, TopupLoaded] on success',
      build: () {
        when(
          () => mockAddBeneficiary(
            nickname: any(named: 'nickname'),
            phone: any(named: 'phone'),
          ),
        ).thenAnswer((_) async {});
        when(() => mockGetUser()).thenAnswer((_) async => tUser);
        when(
          () => mockGetBeneficiaries(),
        ).thenAnswer((_) async => tBeneficiaries);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(AddBeneficiaryEvent(nickname: 'Mom', phone: '0501234567')),
      expect: () => [isA<TopupLoading>(), isA<TopupLoaded>()],
    );

    blocTest<TopupBloc, TopupState>(
      'emits [TopupLoading, TopupError] on failure',
      build: () {
        when(
          () => mockAddBeneficiary(
            nickname: any(named: 'nickname'),
            phone: any(named: 'phone'),
          ),
        ).thenThrow(Exception('Maximum of 5 beneficiaries allowed'));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(AddBeneficiaryEvent(nickname: 'Mom', phone: '0501234567')),
      expect: () => [isA<TopupLoading>(), isA<TopupError>()],
    );
  });

  group('TopupEventRequested', () {
    blocTest<TopupBloc, TopupState>(
      'emits [TopupLoading, TopupSuccess] on success',
      build: () {
        when(
          () => mockTopupNumber(
            beneficiaryId: any(named: 'beneficiaryId'),
            amount: any(named: 'amount'),
          ),
        ).thenAnswer((_) async {});
        when(() => mockGetUser()).thenAnswer((_) async => tUser);
        return bloc;
      },
      act: (bloc) =>
          bloc.add(TopupEventRequested(beneficiaryId: 'b1', amount: 50.0)),
      expect: () => [isA<TopupLoading>(), isA<TopupSuccess>()],
    );

    blocTest<TopupBloc, TopupState>(
      'TopupSuccess contains updated balance',
      build: () {
        when(
          () => mockTopupNumber(
            beneficiaryId: any(named: 'beneficiaryId'),
            amount: any(named: 'amount'),
          ),
        ).thenAnswer((_) async {});
        when(() => mockGetUser()).thenAnswer(
          (_) async => User(id: '1', balance: 4947.0, isVerified: true),
        );
        return bloc;
      },
      act: (bloc) =>
          bloc.add(TopupEventRequested(beneficiaryId: 'b1', amount: 50.0)),
      expect: () => [
        isA<TopupLoading>(),
        predicate<TopupState>((state) {
          if (state is TopupSuccess) {
            return state.balance == 4947.0;
          }
          return false;
        }),
      ],
    );

    blocTest<TopupBloc, TopupState>(
      'emits [TopupLoading, TopupError] on failure',
      build: () {
        when(
          () => mockTopupNumber(
            beneficiaryId: any(named: 'beneficiaryId'),
            amount: any(named: 'amount'),
          ),
        ).thenThrow(Exception('Insufficient balance'));
        return bloc;
      },
      act: (bloc) =>
          bloc.add(TopupEventRequested(beneficiaryId: 'b1', amount: 50.0)),
      expect: () => [isA<TopupLoading>(), isA<TopupError>()],
    );
  });

  group('AddBeneficiaryPressed', () {
    blocTest<TopupBloc, TopupState>(
      'emits [CanAddBeneficiary] when under limit',
      build: () => bloc,
      seed: () => TopupLoaded(user: tUser, beneficiaries: tBeneficiaries),
      act: (bloc) => bloc.add(AddBeneficiaryPressed()),
      expect: () => [isA<CanAddBeneficiary>()],
    );

    blocTest<TopupBloc, TopupState>(
      'emits [BeneficiaryLimitReached] when 5 beneficiaries exist',
      build: () => bloc,
      seed: () => TopupLoaded(
        user: tUser,
        beneficiaries: List.generate(
          5,
          (i) => Beneficiary(
            id: 'b$i',
            nickname: 'Nick$i',
            phoneNumber: '050000000$i',
            monthlyUsed: 0.0,
          ),
        ),
      ),
      act: (bloc) => bloc.add(AddBeneficiaryPressed()),
      expect: () => [isA<BeneficiaryLimitReached>()],
    );
  });
}
