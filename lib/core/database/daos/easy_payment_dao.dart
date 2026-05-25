import 'package:sqflite/sqflite.dart';
import '../database_helper.dart';
import '../database_utils.dart';

// bill status values
enum BillStatus { active, settled, recovered }

extension BillStatusX on BillStatus {
  String get value => name;
  static BillStatus fromString(String s) =>
      BillStatus.values.firstWhere((e) => e.name == s, orElse: () => BillStatus.active);
}

// transaction_type values
enum EasyPaymentTxType { payment, planAdjustment, settled, recovered }

extension EasyPaymentTxTypeX on EasyPaymentTxType {
  String get value => switch (this) {
        EasyPaymentTxType.payment => 'payment',
        EasyPaymentTxType.planAdjustment => 'plan_adjustment',
        EasyPaymentTxType.settled => 'settled',
        EasyPaymentTxType.recovered => 'recovered',
      };

  static EasyPaymentTxType fromString(String s) => switch (s) {
        'plan_adjustment' => EasyPaymentTxType.planAdjustment,
        'settled' => EasyPaymentTxType.settled,
        'recovered' => EasyPaymentTxType.recovered,
        _ => EasyPaymentTxType.payment,
      };
}

// ── Models ────────────────────────────────────────────────────────────────────

class EasyPaymentBillModel {
  final String id;
  final String billNumber;
  final String? saleId;
  final double currentBalance;
  final double totalPaid;
  final double? lastPaymentAmount;
  final int? lastPaymentDate;
  final int remainingMonths;
  final double monthlyInstallment;
  final bool isActive;
  final BillStatus status;
  final int createdAt;
  final int updatedAt;
  final String syncStatus;

  const EasyPaymentBillModel({
    required this.id,
    required this.billNumber,
    this.saleId,
    required this.currentBalance,
    this.totalPaid = 0,
    this.lastPaymentAmount,
    this.lastPaymentDate,
    required this.remainingMonths,
    required this.monthlyInstallment,
    this.isActive = true,
    this.status = BillStatus.active,
    required this.createdAt,
    required this.updatedAt,
    this.syncStatus = 'pending',
  });

  factory EasyPaymentBillModel.create({
    required String billNumber,
    String? saleId,
    required double currentBalance,
    required int remainingMonths,
    required double monthlyInstallment,
  }) {
    final now = nowMs();
    return EasyPaymentBillModel(
      id: generateId(),
      billNumber: billNumber,
      saleId: saleId,
      currentBalance: currentBalance,
      remainingMonths: remainingMonths,
      monthlyInstallment: monthlyInstallment,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory EasyPaymentBillModel.fromMap(Map<String, dynamic> m) => EasyPaymentBillModel(
        id: m['id'] as String,
        billNumber: m['bill_number'] as String,
        saleId: m['sale_id'] as String?,
        currentBalance: (m['current_balance'] as num).toDouble(),
        totalPaid: (m['total_paid'] as num).toDouble(),
        lastPaymentAmount: m['last_payment_amount'] != null
            ? (m['last_payment_amount'] as num).toDouble()
            : null,
        lastPaymentDate: m['last_payment_date'] as int?,
        remainingMonths: m['remaining_months'] as int,
        monthlyInstallment: (m['monthly_installment'] as num).toDouble(),
        isActive: (m['is_active'] as int) == 1,
        status: BillStatusX.fromString(m['status'] as String),
        createdAt: m['created_at'] as int,
        updatedAt: m['updated_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'bill_number': billNumber,
        'sale_id': saleId,
        'current_balance': currentBalance,
        'total_paid': totalPaid,
        'last_payment_amount': lastPaymentAmount,
        'last_payment_date': lastPaymentDate,
        'remaining_months': remainingMonths,
        'monthly_installment': monthlyInstallment,
        'is_active': isActive ? 1 : 0,
        'status': status.value,
        'created_at': createdAt,
        'updated_at': updatedAt,
        'sync_status': syncStatus,
      };
}

class EasyPaymentTransactionModel {
  final String id;
  final String billId;
  final EasyPaymentTxType transactionType;
  final double? amount;
  final int? remainingMonths;
  final double? newMonthlyInstallment;
  final String? notes;
  final String branchCode;
  final int createdAt;
  final String syncStatus;

  const EasyPaymentTransactionModel({
    required this.id,
    required this.billId,
    required this.transactionType,
    this.amount,
    this.remainingMonths,
    this.newMonthlyInstallment,
    this.notes,
    required this.branchCode,
    required this.createdAt,
    this.syncStatus = 'pending',
  });

  factory EasyPaymentTransactionModel.create({
    required String billId,
    required EasyPaymentTxType transactionType,
    required String branchCode,
    double? amount,
    int? remainingMonths,
    double? newMonthlyInstallment,
    String? notes,
  }) =>
      EasyPaymentTransactionModel(
        id: generateId(),
        billId: billId,
        transactionType: transactionType,
        amount: amount,
        remainingMonths: remainingMonths,
        newMonthlyInstallment: newMonthlyInstallment,
        notes: notes,
        branchCode: branchCode,
        createdAt: nowMs(),
      );

  factory EasyPaymentTransactionModel.fromMap(Map<String, dynamic> m) =>
      EasyPaymentTransactionModel(
        id: m['id'] as String,
        billId: m['bill_id'] as String,
        transactionType: EasyPaymentTxTypeX.fromString(m['transaction_type'] as String),
        amount: m['amount'] != null ? (m['amount'] as num).toDouble() : null,
        remainingMonths: m['remaining_months'] as int?,
        newMonthlyInstallment: m['new_monthly_installment'] != null
            ? (m['new_monthly_installment'] as num).toDouble()
            : null,
        notes: m['notes'] as String?,
        branchCode: m['branch_code'] as String,
        createdAt: m['created_at'] as int,
        syncStatus: m['sync_status'] as String,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'bill_id': billId,
        'transaction_type': transactionType.value,
        'amount': amount,
        'remaining_months': remainingMonths,
        'new_monthly_installment': newMonthlyInstallment,
        'notes': notes,
        'branch_code': branchCode,
        'created_at': createdAt,
        'sync_status': syncStatus,
      };
}

// ── DAO ──────────────────────────────────────────────────────────────────────

class EasyPaymentDao {
  EasyPaymentDao(this._helper);
  final DatabaseHelper _helper;

  Future<Database> get _db => _helper.database;

  Future<EasyPaymentBillModel?> getByBillNumber(String billNumber) async {
    final rows = await (await _db).query(
      'easy_payment_bills',
      where: 'bill_number = ?',
      whereArgs: [billNumber],
    );
    return rows.isEmpty ? null : EasyPaymentBillModel.fromMap(rows.first);
  }

  Future<EasyPaymentBillModel?> getById(String id) async {
    final rows = await (await _db).query(
      'easy_payment_bills',
      where: 'id = ?',
      whereArgs: [id],
    );
    return rows.isEmpty ? null : EasyPaymentBillModel.fromMap(rows.first);
  }

  Future<void> insert(EasyPaymentBillModel bill) async {
    await (await _db).insert('easy_payment_bills', bill.toMap());
  }

  // Adjusts plan and appends a transaction row atomically.
  Future<void> updatePlan({
    required String billId,
    required int remainingMonths,
    required double monthlyInstallment,
    required String branchCode,
  }) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.update(
        'easy_payment_bills',
        {
          'remaining_months': remainingMonths,
          'monthly_installment': monthlyInstallment,
          'updated_at': nowMs(),
          'sync_status': 'pending',
        },
        where: 'id = ?',
        whereArgs: [billId],
      );
      final tx = EasyPaymentTransactionModel.create(
        billId: billId,
        transactionType: EasyPaymentTxType.planAdjustment,
        branchCode: branchCode,
        remainingMonths: remainingMonths,
        newMonthlyInstallment: monthlyInstallment,
      );
      await txn.insert('easy_payment_transactions', tx.toMap());
    });
  }

  // Marks a bill as settled or recovered and appends a transaction row.
  Future<void> closeOut({
    required String billId,
    required BillStatus outcome, // settled or recovered
    required String branchCode,
  }) async {
    final db = await _db;
    await db.transaction((txn) async {
      await txn.update(
        'easy_payment_bills',
        {
          'status': outcome.value,
          'is_active': 0,
          'updated_at': nowMs(),
          'sync_status': 'pending',
        },
        where: 'id = ?',
        whereArgs: [billId],
      );
      final txType = outcome == BillStatus.settled
          ? EasyPaymentTxType.settled
          : EasyPaymentTxType.recovered;
      final tx = EasyPaymentTransactionModel.create(
        billId: billId,
        transactionType: txType,
        branchCode: branchCode,
      );
      await txn.insert('easy_payment_transactions', tx.toMap());
    });
  }

  Future<void> insertTransaction(EasyPaymentTransactionModel tx) async {
    await (await _db).insert('easy_payment_transactions', tx.toMap());
  }

  Future<List<EasyPaymentTransactionModel>> getTransactions(String billId) async {
    final rows = await (await _db).query(
      'easy_payment_transactions',
      where: 'bill_id = ?',
      whereArgs: [billId],
      orderBy: 'created_at DESC',
    );
    return rows.map(EasyPaymentTransactionModel.fromMap).toList();
  }
}