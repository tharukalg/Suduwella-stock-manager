// SQL CREATE TABLE statements for every table in the local SQLite cache.
// Each table mirrors its Firebase Firestore collection with the same field names
// so the sync layer stays 1-to-1.  All timestamps are Unix milliseconds (INTEGER).
// sync_status values: 'synced' | 'pending' | 'conflict'

const int kDbVersion = 3;

// ─── 1. branches ────────────────────────────────────────────────────────────
const String tableCreateBranches = '''
  CREATE TABLE IF NOT EXISTS branches (
    id        TEXT PRIMARY KEY,
    name      TEXT NOT NULL,
    is_active INTEGER NOT NULL DEFAULT 1
  )
''';

// ─── 2. products ─────────────────────────────────────────────────────────────
const String tableCreateProducts = '''
  CREATE TABLE IF NOT EXISTS products (
    id           TEXT PRIMARY KEY,
    product_name TEXT NOT NULL,
    model_no     TEXT NOT NULL UNIQUE,
    price        REAL NOT NULL DEFAULT 0,
    image_path   TEXT,
    created_at   INTEGER NOT NULL,
    updated_at   INTEGER NOT NULL,
    sync_status  TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexProductsModelNo =
    'CREATE INDEX IF NOT EXISTS idx_products_model_no ON products(model_no)';

// ─── 3. stock_items ───────────────────────────────────────────────────────────
// One row per physical unit (serial number).
// status: 'available' | 'sold' | 'b2b_transit' | 'recovered' | 'written_off'
const String tableCreateStockItems = '''
  CREATE TABLE IF NOT EXISTS stock_items (
    id          TEXT PRIMARY KEY,
    product_id  TEXT NOT NULL REFERENCES products(id),
    serial_no   TEXT NOT NULL UNIQUE,
    branch_code TEXT NOT NULL REFERENCES branches(id),
    status      TEXT NOT NULL DEFAULT 'available',
    created_at  INTEGER NOT NULL,
    updated_at  INTEGER NOT NULL,
    sync_status TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexStockBranch =
    'CREATE INDEX IF NOT EXISTS idx_stock_branch  ON stock_items(branch_code, status)';
const String indexStockSerial =
    'CREATE INDEX IF NOT EXISTS idx_stock_serial  ON stock_items(serial_no)';
const String indexStockProduct =
    'CREATE INDEX IF NOT EXISTS idx_stock_product ON stock_items(product_id)';

// ─── 4. customers ─────────────────────────────────────────────────────────────
const String tableCreateCustomers = '''
  CREATE TABLE IF NOT EXISTS customers (
    id          TEXT PRIMARY KEY,
    nic         TEXT NOT NULL UNIQUE,
    name        TEXT NOT NULL,
    phone       TEXT NOT NULL,
    description TEXT,
    created_at  INTEGER NOT NULL,
    updated_at  INTEGER NOT NULL,
    sync_status TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexCustomersNic =
    'CREATE INDEX IF NOT EXISTS idx_customers_nic   ON customers(nic)';
const String indexCustomersPhone =
    'CREATE INDEX IF NOT EXISTS idx_customers_phone ON customers(phone)';

// ─── 5. customer_photos ───────────────────────────────────────────────────────
// photo_type: 'id_photo' | 'selfie'
const String tableCreateCustomerPhotos = '''
  CREATE TABLE IF NOT EXISTS customer_photos (
    id          TEXT PRIMARY KEY,
    customer_id TEXT NOT NULL REFERENCES customers(id),
    photo_type  TEXT NOT NULL,
    local_path  TEXT NOT NULL,
    remote_url  TEXT,
    created_at  INTEGER NOT NULL
  )
''';

const String indexPhotosCustomer =
    'CREATE INDEX IF NOT EXISTS idx_photos_customer ON customer_photos(customer_id)';

// ─── 6. sales ─────────────────────────────────────────────────────────────────
// payment_plan: 'interest_free' | 'direct_easy_payment'
// status:       'active' | 'settled' | 'recovered'
const String tableCreateSales = '''
  CREATE TABLE IF NOT EXISTS sales (
    id                  TEXT PRIMARY KEY,
    bl_number           TEXT NOT NULL UNIQUE,
    branch_code         TEXT NOT NULL REFERENCES branches(id),
    stock_item_id       TEXT NOT NULL REFERENCES stock_items(id),
    payment_plan        TEXT NOT NULL,
    down_payment        REAL NOT NULL,
    total_amount        REAL NOT NULL,
    financed_amount     REAL NOT NULL,
    duration_months     INTEGER,
    monthly_installment REAL,
    status              TEXT NOT NULL DEFAULT 'active',
    created_at          INTEGER NOT NULL,
    updated_at          INTEGER NOT NULL,
    sync_status         TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexSalesBl =
    'CREATE INDEX IF NOT EXISTS idx_sales_bl     ON sales(bl_number)';
const String indexSalesBranch =
    'CREATE INDEX IF NOT EXISTS idx_sales_branch ON sales(branch_code, status)';
const String indexSalesStock =
    'CREATE INDEX IF NOT EXISTS idx_sales_stock  ON sales(stock_item_id)';

// ─── 7. sale_customers ────────────────────────────────────────────────────────
// Junction table — one sale can have multiple customers (guarantors).
// is_primary = 1 means this is the main buyer.
const String tableCreateSaleCustomers = '''
  CREATE TABLE IF NOT EXISTS sale_customers (
    id          TEXT PRIMARY KEY,
    sale_id     TEXT NOT NULL REFERENCES sales(id),
    customer_id TEXT NOT NULL REFERENCES customers(id),
    is_primary  INTEGER NOT NULL DEFAULT 0,
    sort_order  INTEGER NOT NULL DEFAULT 0
  )
''';

const String indexScSale =
    'CREATE INDEX IF NOT EXISTS idx_sc_sale     ON sale_customers(sale_id)';
const String indexScCustomer =
    'CREATE INDEX IF NOT EXISTS idx_sc_customer ON sale_customers(customer_id)';

// ─── 8. easy_payment_bills ────────────────────────────────────────────────────
// Current snapshot of a payment plan.  Linked to the originating sale row.
// status: 'active' | 'settled' | 'recovered'
const String tableCreateEasyPaymentBills = '''
  CREATE TABLE IF NOT EXISTS easy_payment_bills (
    id                  TEXT PRIMARY KEY,
    bill_number         TEXT NOT NULL UNIQUE,
    sale_id             TEXT REFERENCES sales(id),
    current_balance     REAL NOT NULL,
    total_paid          REAL NOT NULL DEFAULT 0,
    last_payment_amount REAL,
    last_payment_date   INTEGER,
    remaining_months    INTEGER NOT NULL,
    monthly_installment REAL NOT NULL,
    is_active           INTEGER NOT NULL DEFAULT 1,
    status              TEXT NOT NULL DEFAULT 'active',
    created_at          INTEGER NOT NULL,
    updated_at          INTEGER NOT NULL,
    sync_status         TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexBillsNumber =
    'CREATE INDEX IF NOT EXISTS idx_bills_number ON easy_payment_bills(bill_number)';
const String indexBillsStatus =
    'CREATE INDEX IF NOT EXISTS idx_bills_status ON easy_payment_bills(is_active, status)';

// ─── 9. easy_payment_transactions ────────────────────────────────────────────
// Append-only ledger — never update rows, only insert.
// transaction_type: 'payment' | 'plan_adjustment' | 'settled' | 'recovered'
const String tableCreateEasyPaymentTransactions = '''
  CREATE TABLE IF NOT EXISTS easy_payment_transactions (
    id                      TEXT PRIMARY KEY,
    bill_id                 TEXT NOT NULL REFERENCES easy_payment_bills(id),
    transaction_type        TEXT NOT NULL,
    amount                  REAL,
    remaining_months        INTEGER,
    new_monthly_installment REAL,
    notes                   TEXT,
    branch_code             TEXT NOT NULL REFERENCES branches(id),
    created_at              INTEGER NOT NULL,
    sync_status             TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexEptBill =
    'CREATE INDEX IF NOT EXISTS idx_ept_bill ON easy_payment_transactions(bill_id)';

// ─── 10. b2b_orders ───────────────────────────────────────────────────────────
// status: 'pending' | 'dispatched' | 'received' | 'cancelled'
const String tableCreateB2bOrders = '''
  CREATE TABLE IF NOT EXISTS b2b_orders (
    id                 TEXT PRIMARY KEY,
    order_ref          TEXT NOT NULL UNIQUE,
    source_branch      TEXT NOT NULL REFERENCES branches(id),
    destination_branch TEXT NOT NULL REFERENCES branches(id),
    status             TEXT NOT NULL DEFAULT 'pending',
    notes              TEXT,
    created_at         INTEGER NOT NULL,
    updated_at         INTEGER NOT NULL,
    sync_status        TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexB2bStatus =
    'CREATE INDEX IF NOT EXISTS idx_b2b_status ON b2b_orders(status)';

// ─── 11. b2b_order_items ─────────────────────────────────────────────────────
// stock_item_id is nullable — scanned items may not exist in stock_items yet.
const String tableCreateB2bOrderItems = '''
  CREATE TABLE IF NOT EXISTS b2b_order_items (
    id            TEXT PRIMARY KEY,
    order_id      TEXT NOT NULL REFERENCES b2b_orders(id),
    stock_item_id TEXT REFERENCES stock_items(id),
    serial_no     TEXT NOT NULL,
    model_no      TEXT NOT NULL,
    notes         TEXT,
    sort_order    INTEGER NOT NULL DEFAULT 0
  )
''';

const String indexB2biOrder =
    'CREATE INDEX IF NOT EXISTS idx_b2bi_order ON b2b_order_items(order_id)';

// ─── 12. cris_records ─────────────────────────────────────────────────────────
// customer_id is nullable — CRIS records may arrive before a customer is matched.
// status: 'overdue' | 'review' | 'settled'
const String tableCreateCrisRecords = '''
  CREATE TABLE IF NOT EXISTS cris_records (
    id          TEXT PRIMARY KEY,
    customer_id TEXT REFERENCES customers(id),
    d_number    TEXT NOT NULL UNIQUE,
    b_number    TEXT NOT NULL,
    balance     REAL NOT NULL,
    status      TEXT NOT NULL DEFAULT 'overdue',
    created_at  INTEGER NOT NULL,
    updated_at  INTEGER NOT NULL,
    sync_status TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexCrisCustomer =
    'CREATE INDEX IF NOT EXISTS idx_cris_customer ON cris_records(customer_id)';
const String indexCrisStatus =
    'CREATE INDEX IF NOT EXISTS idx_cris_status   ON cris_records(status)';
const String indexCrisDNumber =
    'CREATE INDEX IF NOT EXISTS idx_cris_d_number ON cris_records(d_number)';

// ─── 13. incoming_stock_log ───────────────────────────────────────────────────
// Audit trail for every item that physically arrives at a branch.
// log_type: 'new_item' | 'recovered_item'
// reference_id links to the original sale_id or cris_record id if recovered.
const String tableCreateIncomingStockLog = '''
  CREATE TABLE IF NOT EXISTS incoming_stock_log (
    id           TEXT PRIMARY KEY,
    log_type     TEXT NOT NULL,
    serial_no    TEXT NOT NULL,
    model_no     TEXT NOT NULL,
    product_name TEXT NOT NULL,
    branch_code  TEXT NOT NULL REFERENCES branches(id),
    reference_id TEXT,
    notes        TEXT,
    created_at   INTEGER NOT NULL,
    sync_status  TEXT NOT NULL DEFAULT 'pending'
  )
''';

const String indexIncomingBranch =
    'CREATE INDEX IF NOT EXISTS idx_incoming_branch ON incoming_stock_log(branch_code)';
const String indexIncomingSerial =
    'CREATE INDEX IF NOT EXISTS idx_incoming_serial ON incoming_stock_log(serial_no)';

// ─── 14. device_registrations ─────────────────────────────────────────────────
// One row per physical device.  id = the UUID generated on first launch and
// stored permanently in app_settings('device_id').
// branch_code tells the app which branch this device belongs to.
// Populated from Firebase on every launch; also written on admin registration.
const String tableCreateDeviceRegistrations = '''
  CREATE TABLE IF NOT EXISTS device_registrations (
    id           TEXT PRIMARY KEY,
    branch_code  TEXT NOT NULL,
    device_label TEXT,
    created_at   INTEGER NOT NULL,
    updated_at   INTEGER NOT NULL
  )
''';

// ─── 15. sync_queue ───────────────────────────────────────────────────────────
// Outbox pattern — every local write appends a row here.
// The sync service reads pending rows and pushes them to Firebase.
// operation: 'insert' | 'update' | 'delete'
// payload:   JSON-encoded map of the full row
const String tableCreateSyncQueue = '''
  CREATE TABLE IF NOT EXISTS sync_queue (
    id            TEXT PRIMARY KEY,
    table_name    TEXT NOT NULL,
    record_id     TEXT NOT NULL,
    operation     TEXT NOT NULL,
    payload       TEXT NOT NULL,
    created_at    INTEGER NOT NULL,
    synced_at     INTEGER,
    error_message TEXT,
    retry_count   INTEGER NOT NULL DEFAULT 0
  )
''';

const String indexSyncPending =
    'CREATE INDEX IF NOT EXISTS idx_sync_pending ON sync_queue(synced_at, table_name)';

// ─── 15. app_settings ─────────────────────────────────────────────────────────
// Key-value store for local config (active branch, last sync time, etc.)
const String tableCreateAppSettings = '''
  CREATE TABLE IF NOT EXISTS app_settings (
    key        TEXT PRIMARY KEY,
    value      TEXT NOT NULL,
    updated_at INTEGER NOT NULL
  )
''';

// Ordered list used by DatabaseHelper._onCreate to run every statement.
const List<String> kAllTableStatements = [
  tableCreateBranches,
  tableCreateProducts,
  indexProductsModelNo,
  tableCreateStockItems,
  indexStockBranch,
  indexStockSerial,
  indexStockProduct,
  tableCreateCustomers,
  indexCustomersNic,
  indexCustomersPhone,
  tableCreateCustomerPhotos,
  indexPhotosCustomer,
  tableCreateSales,
  indexSalesBl,
  indexSalesBranch,
  indexSalesStock,
  tableCreateSaleCustomers,
  indexScSale,
  indexScCustomer,
  tableCreateEasyPaymentBills,
  indexBillsNumber,
  indexBillsStatus,
  tableCreateEasyPaymentTransactions,
  indexEptBill,
  tableCreateB2bOrders,
  indexB2bStatus,
  tableCreateB2bOrderItems,
  indexB2biOrder,
  tableCreateCrisRecords,
  indexCrisCustomer,
  indexCrisStatus,
  indexCrisDNumber,
  tableCreateIncomingStockLog,
  indexIncomingBranch,
  indexIncomingSerial,
  tableCreateDeviceRegistrations,
  tableCreateSyncQueue,
  indexSyncPending,
  tableCreateAppSettings,
];

// Seed data executed once on first open.
const List<String> kSeedStatements = [
  "INSERT OR IGNORE INTO branches (id, name, is_active) VALUES ('KH', 'Kalawana Head Office', 1)",
  "INSERT OR IGNORE INTO branches (id, name, is_active) VALUES ('KL', 'Kegalle Branch', 1)",
  "INSERT OR IGNORE INTO branches (id, name, is_active) VALUES ('JK', 'Ja-Ela Branch', 1)",
  "INSERT OR IGNORE INTO branches (id, name, is_active) VALUES ('KK', 'Kurunegala Branch', 1)",
  "INSERT OR IGNORE INTO branches (id, name, is_active) VALUES ('HH', 'Horana Branch', 1)",
  "INSERT OR IGNORE INTO branches (id, name, is_active) VALUES ('LL', 'Loluwagoda Branch', 1)",
  "INSERT OR IGNORE INTO app_settings (key, value, updated_at) VALUES ('active_branch', 'KH', 0)",
  "INSERT OR IGNORE INTO app_settings (key, value, updated_at) VALUES ('last_synced_at', '0', 0)",
  "INSERT OR IGNORE INTO app_settings (key, value, updated_at) VALUES ('app_user_id', '', 0)",
];
