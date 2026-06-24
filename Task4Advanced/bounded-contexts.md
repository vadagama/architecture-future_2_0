# Bounded Contexts — «Будущее 2.0»

Разделение системы на ограниченные контексты по DDD. Каждый контекст — независимый домен с собственным языком, данными и Data Product.

```mermaid
graph TB
    subgraph medical["Медицинский контекст"]
        direction TB
        m1["Patient
        Пациент"]
        m2["MedicalRecord
        Медицинская карта"]
        m3["Appointment
        Запись к врачу"]
        m4["Diagnosis
        Диагноз"]
        m1---m2---m3---m4
    end

    subgraph fintech["Финтех-контекст"]
        direction TB
        f1["Account
        Счёт"]
        f2["LoanContract
        Кредитный договор"]
        f3["Payment
        Платёж"]
        f1---f2---f3
    end

    subgraph ai["ИИ-контекст"]
        direction TB
        a1["MLModel
        ML-модель"]
        a2["DiagnosticResult
        Результат диагностики"]
        a1---a2
    end

    subgraph pharma["Фарма-контекст"]
        direction TB
        p1["Medication
        Лекарство"]
        p2["SupplyOrder
        Заказ поставки"]
        p3["Inventory
        Остатки"]
        p1---p2---p3
    end

    subgraph equipment["Контекст оборудования"]
        direction TB
        eq1["Device
        Устройство"]
        eq2["Telemetry
        Телеметрия"]
        eq3["Maintenance
        Обслуживание"]
        eq1---eq2---eq3
    end

    subgraph analytics["Аналитический контекст"]
        direction TB
        an1["Report
        Отчёт"]
        an2["Dashboard
        Дашборд"]
        an1---an2
    end

    medical -->|"PatientRegistered
    DiagnosisCompleted"| fintech
    fintech -->|"PaymentProcessed
    LoanCreated"| medical
    medical -->|"PatientDataSent"| ai
    ai -->|"DiagnosticResultReady"| medical
    pharma -->|"MedicationSupplied
    StockUpdated"| medical
    equipment -->|"DeviceAlertTriggered"| medical
    medical -->|"PatientAggregated"| analytics
    fintech -->|"TransactionAggregated"| analytics
    ai -->|"MLMetricsPublished"| analytics
    pharma -->|"InventoryAggregated"| analytics
    equipment -->|"TelemetryAggregated"| analytics

    style medical fill:#1061B0,color:#fff
    style fintech fill:#1061B0,color:#fff
    style ai fill:#1061B0,color:#fff
    style pharma fill:#1061B0,color:#fff
    style equipment fill:#1061B0,color:#fff
    style analytics fill:#438DD5,color:#fff
```

## Карта контекстов

| Bounded Context | Владелец домена | Data Product | Ключевые агрегаты |
|---|---|---|---|
| **Медицинский** | Медицина | `Patient360` | Patient, MedicalRecord, Appointment, Diagnosis |
| **Финтех** | Банк | `FinancialCore` | Account, LoanContract, Payment |
| **ИИ** | AI-сервисы | `AIDiagnostics` | MLModel, DiagnosticResult |
| **Фарма** | Фарма-компании | `PharmaInventory` | Medication, SupplyOrder, Inventory |
| **Оборудование** | Производитель | `DeviceTelemetry` | Device, Telemetry, Maintenance |
| **Аналитика** | BI-команда | `AnalyticsHub` | Report, Dashboard |

## Типы связей между контекстами

| Тип связи | Паттерн | Пример |
|---|---|---|
| **ACL (Anti-Corruption Layer)** | Изоляция легаси-форматов | Медицинский контекст ↔ DWH через Legacy Bridge |
| **Партнёрство (Partnership)** | Двусторонняя интеграция через события | Медицинский ↔ Финтех (согласованные контракты событий) |
| **Customer/Supplier** | Один поставляет данные, другой потребляет | ИИ-контекст → Медицинский (результаты диагностики) |
| **Conformist** | Потребитель принимает модель поставщика «как есть» | Аналитика ← все домены (агрегированные события) |
| **Shared Kernel** | Общая модель для ограниченного набора | PatientID, AccountID — глобальные идентификаторы |

## Принципы взаимодействия

1. **События как primary integration** — домены не вызывают друг друга синхронно. Все значимые факты публикуются в Event Bus.
2. **Schema Registry** — все события проходят валидацию схемы (Avro). Контракты версионируются.
3. **Global IDs** — сквозные идентификаторы (`patient_id`, `account_id`), единый формат UUID.
4. **Data Product Ownership** — каждый контекст владеет своим Data Product и отвечает за его качество и SLA.
