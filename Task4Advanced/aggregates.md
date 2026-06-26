# Агрегаты — границы, инварианты, ключи

Описание ключевых агрегатов для каждого ограниченного контекста. Агрегат — кластер доменных объектов, с которыми работают как с единым целым. Каждый агрегат имеет корневую сущность (Aggregate Root) и гарантирует соблюдение инвариантов в пределах своей границы.

---

## Медицинский контекст

### Patient (Aggregate Root)

| Характеристика | Значение |
|---|---|
| **Ключ** | `patient_id` (UUID) |
| **Границы** | Patient + MedicalRecord[] + Appointment[] |
| **Инварианты** | Patient.active = true ИЛИ все незавершённые Appointment отменены |

**Правила:**
- Нельзя деактивировать пациента с активными записями к врачу.
- MedicalRecord не существует без Patient.
- При создании Appointment проверяется, что doctor_id доступен в указанное время.

### MedicalRecord

| Характеристика | Значение |
|---|---|
| **Ключ** | `record_id` (UUID) |
| **Принадлежит** | Patient |
| **Инварианты** | record_type ∈ {CONSULTATION, LAB_TEST, IMAGING, PRESCRIPTION} |

### Appointment

| Характеристика | Значение |
|---|---|
| **Ключ** | `appointment_id` (UUID) |
| **Принадлежит** | Patient |
| **Инварианты** | Нет пересечений по времени для одного doctor_id в рамках clinic_id |

---

## Финтех-контекст

### Account (Aggregate Root)

| Характеристика | Значение |
|---|---|
| **Ключ** | `account_id` (UUID) |
| **Границы** | Account + Payment[] |
| **Инварианты** | Account.balance ≥ 0 (если не кредитный); сумма всех Payment = разница баланса |

**Правила:**
- Payment всегда ссылается на существующий Account.
- При закрытии Account: balance == 0 И нет активных кредитных обязательств.

### LoanContract (Aggregate Root)

| Характеристика | Значение |
|---|---|
| **Ключ** | `contract_id` (UUID) |
| **Границы** | LoanContract + PaymentSchedule |
| **Инварианты** | total_paid ≤ contract.amount + interest; payment_due_date > contract.created_at |

**Правила:**
- График платежей генерируется при создании контракта.
- Нельзя создать контракт для незарегистрированного пациента (`patient_id` должен существовать в Patient).

---

## ИИ-контекст

### DiagnosticResult (Aggregate Root)

| Характеристика | Значение |
|---|---|
| **Ключ** | `result_id` (UUID) |
| **Границы** | DiagnosticResult + Finding[] |
| **Инварианты** | confidence ∈ [0.0, 1.0]; model_version ссылается на существующую MLModel |

**Правила:**
- Результат создаётся только после завершения ML-инференса.
- При изменении model_version старые результаты не пересчитываются автоматически (immutable).

### MLModel

| Характеристика | Значение |
|---|---|
| **Ключ** | `model_name` + `version` (составной) |
| **Инварианты** | version монотонно возрастает; deployed_at > предыдущей версии |

---

## Фарма-контекст

### Medication (Aggregate Root)

| Характеристика | Значение |
|---|---|
| **Ключ** | `medication_id` (UUID) |
| **Границы** | Medication + StockLevel |
| **Инварианты** | stock_quantity ≥ 0; при stock < threshold → событие StockLowAlert |

### SupplyOrder

| Характеристика | Значение |
|---|---|
| **Ключ** | `supply_id` (UUID) |
| **Границы** | SupplyOrder + SupplyLineItem[] |
| **Инварианты** | Все line_items ссылаются на существующие Medication; status ∈ {DRAFT, CONFIRMED, RECEIVED, CANCELLED} |

---

## Контекст оборудования

### Device (Aggregate Root)

| Характеристика | Значение |
|---|---|
| **Ключ** | `device_id` (UUID) |
| **Границы** | Device + TelemetryRecord[] + MaintenanceRecord[] |
| **Инварианты** | device_type ∈ допустимый перечень; clinic_id ссылается на существующую клинику |

### TelemetryRecord

| Характеристика | Значение |
|---|---|
| **Ключ** | `telemetry_id` (UUID) |
| **Принадлежит** | Device |
| **Инварианты** | recorded_at в пределах времени жизни устройства (registered_at ≤ recorded_at) |

---

## Аналитический контекст

### Report (Aggregate Root)

| Характеристика | Значение |
|---|---|
| **Ключ** | `report_id` (UUID) |
| **Границы** | Report + ReportParameter[] |
| **Инварианты** | report_type задан; requested_by ссылается на существующего пользователя IAM |

---

## Сквозные правила (Cross-cutting)

| Правило | Контексты | Обеспечение |
|---|---|---|
| **Уникальность Patient** | Medical, Fintech, AI | `patient_id` — глобальный UUID, генерируется в Medical, используется как внешний ключ в других контекстах |
| **Связь Account → Patient** | Fintech → Medical | При создании Account проверяется существование `patient_id` через событие `PatientRegistered` |
| **Консистентность остатков** | Pharma, Medical | При выдаче лекарства пациенту: событие `MedicationDispensed` уменьшает `StockLevel` в Pharma |
| **Неизменяемость событий** | Все | События — immutable. Корректировка только через компенсирующие события (например, `PaymentReversed`) |
