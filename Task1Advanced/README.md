# Task 1 — Модульная инфраструктура для нескольких сред

Переиспользуемый Terraform-модуль `vm_module` для развёртывания виртуальных машин в Yandex Cloud с разными конфигурациями для окружений **dev**, **stage** и **prod**.

## Структура проекта

```
Task1Advanced/
├── modules/
│   └── vm/
│       ├── main.tf        # Ресурсы: диск + ВМ + сеть
│       ├── variables.tf   # Входные параметры модуля
│       └── outputs.tf     # Выходные значения
├── envs/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   ├── stage/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
└── README.md
```

## Параметры модуля (`modules/vm/variables.tf`)

| Параметр          | Тип      | По умолчанию          | Описание                                   |
|-------------------|----------|------------------------|--------------------------------------------|
| `vm_name`         | `string` | — (**обязательный**)   | Имя виртуальной машины                     |
| `cores`           | `number` | `2`                    | Количество vCPU                            |
| `memory`          | `number` | `2`                    | Объём RAM (ГБ)                             |
| `disk_size`       | `number` | `15`                   | Размер загрузочного диска (ГБ)             |
| `disk_type`       | `string` | `"network-ssd"`        | Тип диска (network-ssd, network-hdd и др.) |
| `zone`            | `string` | — (**обязательный**)   | Зона доступности (например, `ru-central1-a`)|
| `subnet_id`       | `string` | — (**обязательный**)   | ID подсети                                 |
| `image_family`    | `string` | `"ubuntu-2204-lts"`    | Семейство образа ОС                        |
| `ssh_public_key`  | `string` | — (**обязательный**)   | Путь к файлу публичного SSH-ключа          |
| `ssh_user`        | `string` | `"ubuntu"`             | Имя пользователя для SSH                   |
| `nat`             | `bool`   | `true`                 | Назначить публичный IP (NAT)               |
| `platform_id`     | `string` | `"standard-v1"`        | Аппаратная платформа ВМ                    |
| `labels`          | `map`    | `{}`                   | Метки (labels) для ресурсов                |

## Выходные значения (`modules/vm/outputs.tf`)

| Output         | Описание                                       |
|----------------|------------------------------------------------|
| `vm_id`        | Идентификатор виртуальной машины               |
| `vm_name`      | Имя виртуальной машины                         |
| `vm_fqdn`      | Полное доменное имя (FQDN)                     |
| `external_ip`  | Внешний IP-адрес (пустая строка, если NAT выкл)|
| `internal_ip`  | Внутренний IP-адрес                            |
| `disk_id`      | Идентификатор загрузочного диска               |
| `disk_size`    | Размер загрузочного диска (ГБ)                 |
| `zone`         | Зона доступности                               |

## Сравнение окружений

| Параметр     | Dev                  | Stage                | Prod                       |
|--------------|----------------------|----------------------|----------------------------|
| **vCPU**     | 2                    | 4                    | 8                          |
| **RAM**      | 2 ГБ                 | 8 ГБ                 | 16 ГБ                      |
| **Диск**     | 15 ГБ (network-hdd)  | 50 ГБ (network-ssd)  | 100 ГБ (network-ssd-io-m3) |
| **Платформа**| standard-v1          | standard-v2          | standard-v3                |
| **NAT**      | Да (публичный IP)    | Да (публичный IP)    | Нет (только внутренняя сеть)|
| **Зона**     | ru-central1-a        | ru-central1-b        | ru-central1-a              |

## Предварительные требования

1. **Yandex Cloud CLI** — установите и настройте [`yc`](https://cloud.yandex.ru/docs/cli/quickstart):
   ```bash
   yc init
   ```

2. **Terraform** ≥ 1.3 — [инструкция по установке](https://developer.hashicorp.com/terraform/downloads).

3. **Аутентификация** — перед запуском экспортируйте переменные окружения:
   ```bash
   export YC_TOKEN="<ваш IAM-токен>"
   # или
   export YC_SERVICE_ACCOUNT_KEY_FILE="<путь к ключу сервисного аккаунта>"
   export YC_CLOUD_ID="<ID облака>"
   export YC_FOLDER_ID="<ID каталога>"
   ```

4. **SSH-ключ** — убедитесь, что публичный ключ существует:
   ```bash
   ls ~/.ssh/id_rsa.pub
   # Если отсутствует — сгенерируйте:
   ssh-keygen -t rsa -b 4096 -f ~/.ssh/id_rsa
   ```

5. **Подсеть** — замените `<< YOUR_SUBNET_ID >>` в `terraform.tfvars` каждого окружения на реальный ID подсети Yandex Cloud.

## Запуск

### Dev-окружение

```bash
cd envs/dev
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### Stage-окружение

```bash
cd envs/stage
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

### Prod-окружение

```bash
cd envs/prod
terraform init
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

> **Примечание:** для `terraform apply` в prod рекомендуется дополнительно использовать флаг `-auto-approve=false` (по умолчанию) и производить деплой только после ручного подтверждения.

## Удаление ресурсов

```bash
cd envs/<окружение>
terraform destroy -var-file="terraform.tfvars"
```

## Принципы проектирования

- **Никаких захардкоженных значений** — модуль `vm/` полностью параметризован через переменные.
- **Переиспользуемость** — один и тот же модуль вызывается в dev, stage и prod с разными `.tfvars`.
- **Читаемость** — код структурирован, все переменные и выходы документированы.
- **Изоляция окружений** — каждое окружение находится в собственной директории с независимым состоянием Terraform.
