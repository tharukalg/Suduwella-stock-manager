import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'database_helper.dart';
import '../di/locator.dart';
import '../services/device_service.dart';

class DbViewerPage extends StatefulWidget {
  const DbViewerPage({super.key});

  @override
  State<DbViewerPage> createState() => _DbViewerPageState();
}

class _DbViewerPageState extends State<DbViewerPage> {
  // ── Table browser state ───────────────────────────────────────────────────
  List<_TableMeta> _tables = [];
  String? _selectedTable;
  List<Map<String, dynamic>> _rows = [];
  bool _loadingTables = true;
  bool _loadingRows = false;

  // ── Device info state ─────────────────────────────────────────────────────
  String _deviceId = '…';
  String? _deviceBranchCode;
  String? _deviceLabel;
  bool _loadingDevice = true;
  bool _registeringDevice = false;

  @override
  void initState() {
    super.initState();
    _loadTables();
    _loadDeviceInfo();
  }

  // ── Device info ───────────────────────────────────────────────────────────

  Future<void> _loadDeviceInfo() async {
    setState(() => _loadingDevice = true);
    try {
      final deviceService = sl<DeviceService>();
      final id = await deviceService.getOrCreateDeviceId();
      final reg = await DatabaseHelper.instance.database.then((db) =>
          db.query('device_registrations', where: 'id = ?', whereArgs: [id]));

      if (!mounted) return;
      setState(() {
        _deviceId = id;
        if (reg.isNotEmpty) {
          _deviceBranchCode = reg.first['branch_code'] as String?;
          _deviceLabel = reg.first['device_label'] as String?;
        } else {
          _deviceBranchCode = null;
          _deviceLabel = null;
        }
        _loadingDevice = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _loadingDevice = false);
    }
  }

  Future<void> _registerDevice() async {
    // Load available branches
    final db = await DatabaseHelper.instance.database;
    final branchRows = await db.query('branches', orderBy: 'name ASC');
    if (!mounted) return;

    final labelController = TextEditingController(text: _deviceLabel ?? '');
    String? selectedBranch = _deviceBranchCode ?? branchRows.firstOrNull?['id'] as String?;

    final confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.device_hub_rounded, color: Colors.orangeAccent, size: 22),
              SizedBox(width: 10),
              Text('Register Device', style: TextStyle(color: Colors.white, fontSize: 17)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Assign this device to a branch. The active branch will update immediately.',
                style: TextStyle(color: Colors.white54, fontSize: 13),
              ),
              const SizedBox(height: 16),
              // Branch selector
              Text('Branch', style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: selectedBranch,
                dropdownColor: const Color(0xFF2A2A2A),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  isDense: true,
                ),
                style: const TextStyle(color: Colors.white),
                items: branchRows.map((r) {
                  final id = r['id'] as String;
                  final name = r['name'] as String;
                  return DropdownMenuItem(value: id, child: Text('$name ($id)'));
                }).toList(),
                onChanged: (v) => setDialogState(() => selectedBranch = v),
              ),
              const SizedBox(height: 12),
              // Optional label
              Text('Device label (optional)', style: TextStyle(color: Colors.white60, fontSize: 12)),
              const SizedBox(height: 6),
              TextField(
                controller: labelController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'e.g. KH POS 1',
                  hintStyle: const TextStyle(color: Colors.white30),
                  filled: true,
                  fillColor: const Color(0xFF2A2A2A),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
                  isDense: true,
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, false),
              child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: Colors.orange[800]),
              onPressed: selectedBranch == null ? null : () => Navigator.pop(ctx, true),
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );

    final label = labelController.text.trim();
    labelController.dispose();
    if (confirmed != true || selectedBranch == null || !mounted) return;

    // Extract to a non-nullable local — Dart can't promote `selectedBranch`
    // because it was mutated inside a closure (StatefulBuilder onChanged).
    final branch = selectedBranch!;

    setState(() => _registeringDevice = true);
    try {
      await sl<DeviceService>().registerDevice(
        branch,
        deviceLabel: label.isEmpty ? null : label,
      );
      await _loadDeviceInfo();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Device registered to $branch ✓'),
            backgroundColor: Colors.green[700],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Registration failed: $e'),
            backgroundColor: Colors.red[700],
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _registeringDevice = false);
    }
  }

  // ── DB flush ──────────────────────────────────────────────────────────────

  Future<void> _flushDb() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.warning_rounded, color: Colors.red, size: 22),
            SizedBox(width: 10),
            Text('Flush Local DB', style: TextStyle(color: Colors.white, fontSize: 17)),
          ],
        ),
        content: const Text(
          'This will delete ALL local data and recreate the database from scratch.\n\n'
          'Your device ID and branch assignment will be preserved.\n'
          'All products, stock, sales, and other records will be erased.',
          style: TextStyle(color: Colors.white70, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red[800]),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Flush Everything'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    try {
      await DatabaseHelper.instance.clearAndReset();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Database flushed and rebuilt ✓'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload the viewer.
        await _loadTables();
        await _loadDeviceInfo();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Flush failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ── Table browser ─────────────────────────────────────────────────────────

  Future<void> _loadTables() async {
    final db = await DatabaseHelper.instance.database;

    final result = await db.rawQuery(
      "SELECT name FROM sqlite_master "
      "WHERE type='table' AND name NOT LIKE 'sqlite_%' "
      "ORDER BY name",
    );

    final metas = <_TableMeta>[];
    for (final r in result) {
      final name = r['name'] as String;
      final countResult =
          await db.rawQuery('SELECT COUNT(*) AS c FROM "$name"');
      final count = (countResult.first['c'] as int?) ?? 0;
      metas.add(_TableMeta(name: name, rowCount: count));
    }

    if (!mounted) return;
    setState(() {
      _tables = metas;
      _loadingTables = false;
    });

    if (metas.isNotEmpty) {
      await _selectTable(metas.first.name);
    }
  }

  Future<void> _selectTable(String name) async {
    setState(() {
      _selectedTable = name;
      _loadingRows = true;
      _rows = [];
    });
    final db = await DatabaseHelper.instance.database;
    final rows = await db.query(name, limit: 300);
    if (!mounted) return;
    setState(() {
      _rows = rows;
      _loadingRows = false;
    });
  }

  Future<void> _refresh() async {
    setState(() => _loadingTables = true);
    await _loadTables();
    if (_selectedTable != null) await _selectTable(_selectedTable!);
    await _loadDeviceInfo();
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      appBar: AppBar(
        backgroundColor: Colors.red[900],
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Icon(Icons.storage_rounded, size: 20),
            const SizedBox(width: 8),
            const Text(
              'DB Viewer',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'DEV',
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: _refresh,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep_rounded),
            tooltip: 'Flush Local DB',
            onPressed: _flushDb,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: _loadingTables
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent))
          : Column(
              children: [
                // ── Device registration panel ──────────────────────────────
                _DeviceInfoPanel(
                  deviceId: _deviceId,
                  branchCode: _deviceBranchCode,
                  deviceLabel: _deviceLabel,
                  loading: _loadingDevice || _registeringDevice,
                  onRegister: _registerDevice,
                ),
                const Divider(height: 1, color: Colors.white10),
                // ── Table browser ──────────────────────────────────────────
                if (_tables.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text('No tables found',
                          style: TextStyle(color: Colors.white54)),
                    ),
                  )
                else ...[
                  _TableSelector(
                    tables: _tables,
                    selected: _selectedTable,
                    onSelect: _selectTable,
                  ),
                  _RowCountBar(
                    tableName: _selectedTable ?? '',
                    rowCount: _rows.length,
                  ),
                  Expanded(
                    child: _loadingRows
                        ? const Center(
                            child: CircularProgressIndicator(
                                color: Colors.redAccent))
                        : _rows.isEmpty
                            ? const Center(
                                child: Text(
                                  'Empty table',
                                  style: TextStyle(color: Colors.white38),
                                ),
                              )
                            : ListView.builder(
                                padding: const EdgeInsets.only(
                                    left: 12, right: 12, bottom: 24),
                                itemCount: _rows.length,
                                itemBuilder: (_, i) => _RowCard(
                                  index: i,
                                  row: _rows[i],
                                ),
                              ),
                  ),
                ],
              ],
            ),
    );
  }
}

// ── Device info panel ─────────────────────────────────────────────────────────

class _DeviceInfoPanel extends StatelessWidget {
  final String deviceId;
  final String? branchCode;
  final String? deviceLabel;
  final bool loading;
  final VoidCallback onRegister;

  const _DeviceInfoPanel({
    required this.deviceId,
    required this.branchCode,
    required this.deviceLabel,
    required this.loading,
    required this.onRegister,
  });

  @override
  Widget build(BuildContext context) {
    final isRegistered = branchCode != null;
    return Container(
      color: const Color(0xFF141414),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isRegistered ? Icons.device_hub_rounded : Icons.device_unknown_rounded,
                color: isRegistered ? Colors.orangeAccent : Colors.white30,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                'Device Registration',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              loading
                  ? const SizedBox(
                      width: 16, height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orangeAccent),
                    )
                  : GestureDetector(
                      onTap: onRegister,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.orange[900],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          isRegistered ? 'Change Branch' : 'Register Device',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 8),
          // Device ID row (copyable)
          GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: deviceId));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Device ID copied'), duration: Duration(seconds: 1)),
              );
            },
            child: Row(
              children: [
                const Text('ID', style: TextStyle(color: Color(0xFF64B5F6), fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    deviceId,
                    style: const TextStyle(color: Colors.white54, fontSize: 11, fontFamily: 'monospace'),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const Icon(Icons.copy_rounded, size: 12, color: Colors.white24),
              ],
            ),
          ),
          if (isRegistered) ...[
            const SizedBox(height: 4),
            Row(
              children: [
                const Text('Branch', style: TextStyle(color: Color(0xFF64B5F6), fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.orange[900]!.withAlpha(80),
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.orange[700]!.withAlpha(80)),
                  ),
                  child: Text(
                    branchCode!,
                    style: const TextStyle(color: Colors.orangeAccent, fontSize: 11, fontFamily: 'monospace', fontWeight: FontWeight.bold),
                  ),
                ),
                if (deviceLabel != null) ...[
                  const SizedBox(width: 8),
                  Text(
                    deviceLabel!,
                    style: const TextStyle(color: Colors.white38, fontSize: 11, fontStyle: FontStyle.italic),
                  ),
                ],
              ],
            ),
          ] else ...[
            const SizedBox(height: 4),
            const Text(
              'Not registered — tap "Register Device" to assign a branch',
              style: TextStyle(color: Colors.white30, fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }
}

// ── Table selector chip bar ───────────────────────────────────────────────────

class _TableSelector extends StatelessWidget {
  final List<_TableMeta> tables;
  final String? selected;
  final ValueChanged<String> onSelect;

  const _TableSelector({
    required this.tables,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1A1A1A),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: tables.map((t) {
            final isSelected = t.name == selected;
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: GestureDetector(
                onTap: () => onSelect(t.name),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.red[800] : const Color(0xFF2A2A2A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.red[400]! : Colors.white12,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.name,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.white60,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.white24 : Colors.white12,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${t.rowCount}',
                          style: const TextStyle(fontSize: 10, color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Row count bar ─────────────────────────────────────────────────────────────

class _RowCountBar extends StatelessWidget {
  final String tableName;
  final int rowCount;

  const _RowCountBar({required this.tableName, required this.rowCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF141414),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text(
        '$tableName  ·  $rowCount row${rowCount == 1 ? '' : 's'}',
        style: const TextStyle(
          color: Colors.white38,
          fontSize: 11,
          fontFamily: 'monospace',
        ),
      ),
    );
  }
}

// ── Individual row card ───────────────────────────────────────────────────────

class _RowCard extends StatefulWidget {
  final int index;
  final Map<String, dynamic> row;

  const _RowCard({required this.index, required this.row});

  @override
  State<_RowCard> createState() => _RowCardState();
}

class _RowCardState extends State<_RowCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final entries = widget.row.entries.toList();

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF1C1C1C),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row header
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF242424),
                borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 18,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.red[900]!.withAlpha(120),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '#${widget.index + 1}',
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      _previewText(widget.row),
                      style: const TextStyle(color: Colors.white60, fontSize: 11),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Icon(
                    _expanded
                        ? Icons.keyboard_arrow_up_rounded
                        : Icons.keyboard_arrow_down_rounded,
                    color: Colors.white30,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          // Expanded key-value pairs
          if (_expanded)
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: entries
                    .map((e) => _KvRow(
                          key: ValueKey(e.key),
                          column: e.key,
                          value: e.value,
                        ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }

  // Shows the first id-like column as the preview text.
  String _previewText(Map<String, dynamic> row) {
    for (final key in [
      'id', 'bl_number', 'bill_number', 'nic', 'name',
      'd_number', 'serial_no', 'model_no', 'key'
    ]) {
      if (row.containsKey(key) && row[key] != null) {
        return '${row[key]}';
      }
    }
    return row.values.firstWhere((v) => v != null, orElse: () => '—').toString();
  }
}

// ── Key-value row inside a card ───────────────────────────────────────────────

class _KvRow extends StatefulWidget {
  final String column;
  final dynamic value;

  const _KvRow({super.key, required this.column, required this.value});

  @override
  State<_KvRow> createState() => _KvRowState();
}

class _KvRowState extends State<_KvRow> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final raw = widget.value?.toString() ?? 'null';
    final isLong = raw.length > 60;
    final display = (!isLong || _expanded) ? raw : '${raw.substring(0, 60)}…';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column name
          SizedBox(
            width: 130,
            child: Text(
              widget.column,
              style: const TextStyle(
                color: Color(0xFF64B5F6),
                fontSize: 11,
                fontFamily: 'monospace',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 6),
          // Value
          Expanded(
            child: GestureDetector(
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: raw));
              },
              onTap: isLong ? () => setState(() => _expanded = !_expanded) : null,
              child: Text(
                display,
                style: TextStyle(
                  color: widget.value == null ? Colors.white24 : Colors.white70,
                  fontSize: 11,
                  fontFamily: 'monospace',
                  fontStyle: widget.value == null ? FontStyle.italic : FontStyle.normal,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data class ────────────────────────────────────────────────────────────────

class _TableMeta {
  final String name;
  final int rowCount;
  const _TableMeta({required this.name, required this.rowCount});
}
