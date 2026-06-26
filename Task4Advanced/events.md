# Каталог доменных событий

Перечень ключевых событий, публикуемых доменами «Будущее 2.0» через Event Bus (Kafka). Для каждого события указан контекст-источник, семантика и минимальный контракт.

## Медицинский контекст

| Событие | Источник | Семантика | Ключевые поля (минимальный контракт) |
|---|---|---|---|
| `PatientRegistered` | Medical | Новый пациент зарегистрирован в системе | `event_id`, `patient_id`, `full_name`, `birth_date`, `registered_at`, `clinic_id` |
| `PatientUpdated` | Medical | Данные пациента изменены (адрес, телефон и т.п.) | `event_id`, `patient_id`, `changed_fields[]`, `updated_at` |
| `AppointmentScheduled` | Medical | Запись пациента к врачу создана | `event_id`, `appointment_id`, `patient_id`, `doctor_id`, `scheduled_at`, `clinic_id` |
| `AppointmentCancelled` | Medical | Запись отменена | `event_id`, `appointment_id`, `reason`, `cancelled_at` |
| `DiagnosisCompleted` | Medical | Врач поставил диагноз | `event_id`, `diagnosis_id`, `patient_id`, `doctor_id`, `icd10_code`, `description`, `completed_at` |
| `MedicalRecordCreated` | Medical | Создана новая запись в мед. карте | `event_id`, `record_id`, `patient_id`, `record_type`, `content_ref`, `created_at` |

## Финтех-контекст

| Событие | Источник | Семантика | Ключевые поля |
|---|---|---|---|
| `AccountOpened` | Fintech | Открыт новый счёт | `event_id`, `account_id`, `patient_id`, `account_type`, `currency`, `opened_at` |
| `LoanContractCreated` | Fintech | Создан кредитный договор | `event_id`, `contract_id`, `patient_id`, `amount`, `currency`, `rate`, `term_months`, `created_at` |
| `PaymentProcessed` | Fintech | Платёж проведён | `event_id`, `payment_id`, `account_id`, `amount`, `currency`, `direction` (IN/OUT), `processed_at` |
| `LoanPaymentDue` | Fintech | Наступил срок платежа по кредиту | `event_id`, `contract_id`, `patient_id`, `due_amount`, `due_date` |
| `AccountClosed` | Fintech | Счёт закрыт | `event_id`, `account_id`, `reason`, `closed_at` |

## ИИ-контекст

| Событие | Источник | Семантика | Ключевые поля |
|---|---|---|---|
| `DiagnosticResultReady` | AI | ML-модель завершила анализ и выдала результат | `event_id`, `result_id`, `patient_id`, `study_id`, `model_version`, `findings`, `confidence`, `completed_at` |
| `MLModelDeployed` | AI | Новая версия ML-модели развёрнута | `event_id`, `model_name`, `version`, `deployed_at` |
| `MLMetricsPublished` | AI | Метрики качества модели обновлены | `event_id`, `model_name`, `version`, `accuracy`, `precision`, `recall`, `published_at` |

## Фарма-контекст

| Событие | Источник | Семантика | Ключевые поля |
|---|---|---|---|
| `MedicationSupplied` | Pharma | Поставка лекарств получена | `event_id`, `supply_id`, `medication_id`, `quantity`, `supplier_id`, `received_at` |
| `StockUpdated` | Pharma | Остатки лекарства изменились | `event_id`, `medication_id`, `previous_qty`, `new_qty`, `updated_at` |
| `StockLowAlert` | Pharma | Остаток лекарства ниже порога | `event_id`, `medication_id`, `current_qty`, `threshold`, `alerted_at` |

## Контекст оборудования

| Событие | Источник | Семантика | Ключевые поля |
|---|---|---|---|
| `DeviceRegistered` | Equipment | Новое устройство зарегистрировано | `event_id`, `device_id`, `device_type`, `clinic_id`, `registered_at` |
| `TelemetryRecorded` | Equipment | Получены телеметрические данные | `event_id`, `device_id`, `metric_name`, `value`, `unit`, `recorded_at` |
| `DeviceAlertTriggered` | Equipment | Устройство сообщило о неисправности | `event_id`, `device_id`, `alert_type`, `severity`, `message`, `triggered_at` |
| `MaintenanceScheduled` | Equipment | Запланировано обслуживание устройства | `event_id`, `device_id`, `maintenance_type`, `scheduled_at`, `engineer_id` |

## Аналитический контекст

| Событие | Источник | Семантика | Ключевые поля |
|---|---|---|---|
| `ReportGenerated` | Analytics | Отчёт сформирован | `event_id`, `report_id`, `report_type`, `requested_by`, `generated_at` |
| `DataProductPublished` | Analytics | Data Product обновлён и доступен | `event_id`, `product_name`, `version`, `row_count`, `published_at` |

## Нотация и соглашения

- **Именование**: `<Сущность><Глагол в Past Participle>` — отражает свершившийся факт.
- **Ключи**: `event_id` (UUID) — уникальный идентификатор события для идемпотентности.
- **Версионирование**: все схемы событий хранятся в Schema Registry, обратная совместимость обязательна.
- **Формат**: Avro, обязательные поля всегда non-nullable, опциональные — nullable union.
