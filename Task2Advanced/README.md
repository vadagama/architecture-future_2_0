# Task 2 — Интеграция с CI/CD и удалённым хранением состояния

Автоматизация развёртывания инфраструктуры через **GitHub Actions** с хранением состояния Terraform в **Minio** (S3-совместимый backend). Состояние **не хранится локально** — весь `.tfstate` находится в удалённом бакете Minio.

## Структура проекта

```
Task2Advanced/
├── .github/
│   └── workflows/
│       └── terraform.yml       # CI/CD пайплайн (plan + apply)
├── modules/
│   └── vm/                     # Переиспользуемый модуль ВМ (из Task 1)
│       ├── main.tf
│       ├── variables.tf
│       └── outputs.tf
├── envs/
│   ├── dev/                    # Окружение разработки
│   │   ├── main.tf             # backend "s3" + provider + module
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   ├── stage/                  # Предпродуктовое окружение
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── terraform.tfvars
│   └── prod/                   # Продуктовое окружение
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── terraform.tfvars
└── README.md
```

## CI/CD пайплайн (GitHub Actions)

### Триггеры

| Триггер                 | Что происходит                              |
|-------------------------|---------------------------------------------|
| `push` в `main`         | `terraform plan` для **всех** окружений параллельно |
| `workflow_dispatch`     | Ручной запуск: выбор окружения + plan/apply |

### Jobs

#### 1. `plan` — автоматический и ручной запуск

Выполняется для матрицы `[dev, stage, prod]` параллельно.

| Шаг                    | Описание                                                       |
|------------------------|----------------------------------------------------------------|
| `Checkout`             | Клонирование репозитория                                       |
| `Setup Terraform`      | Установка Terraform ≥ 1.3                                      |
| `Terraform fmt`        | Проверка форматирования кода (`-check`)                        |
| `Terraform Init`       | Инициализация с передачей backend-параметров Minio из Secrets  |
| `Terraform Validate`   | Валидация конфигурации                                         |
| `Terraform Plan`       | План изменений с сохранением в `tfplan`                        |
| `Upload Plan Artifact` | Загрузка плана как артефакта (хранится 7 дней)                 |

#### 2. `apply` — только ручной запуск

Запускается **только** при `workflow_dispatch` с `action=apply`.

| Шаг               | Описание                                                    |
|-------------------|-------------------------------------------------------------|
| `Checkout`        | Клонирование репозитория                                    |
| `Setup Terraform` | Установка Terraform                                         |
| `Terraform Init`  | Инициализация с backend из Secrets                          |
| `Terraform Plan`  | Повторный plan перед apply                                  |
| `Terraform Apply` | Применение плана (`-auto-approve`)                          |

### Безопасность

| Механизм                        | Описание                                                                 |
|---------------------------------|--------------------------------------------------------------------------|
| **GitHub Secrets**              | Все чувствительные данные (токены, ключи Minio) хранятся в Secrets, не в коде |
| **Backend-параметры через CLI** | Ни один пароль/эндпоинт не захардкожен — всё через `-backend-config`      |
| **GitHub Environment (prod)**   | Для `prod` требуется approval через GitHub Environment `production`. Можно настроить обязательных ревьюеров и защитные правила |
| **Concurrency**                 | Параллельные запуски одного окружения блокируются                         |
| **Изоляция состояний**          | У каждого окружения свой ключ `terraform.tfstate` в Minio                |

## Необходимые GitHub Secrets

Перед использованием пайплайна добавьте следующие секреты в репозиторий
(`Settings → Secrets and variables → Actions → Secrets`):

| Секрет              | Описание                                     |
|---------------------|----------------------------------------------|
| `MINIO_ENDPOINT`    | URL Minio-сервера (например, `http://minio:9000`) |
| `MINIO_BUCKET`      | Имя бакета для хранения состояний            |
| `MINIO_ACCESS_KEY`  | Access Key пользователя Minio                |
| `MINIO_SECRET_KEY`  | Secret Key пользователя Minio                |
| `YC_TOKEN`          | IAM-токен Yandex Cloud для аутентификации    |

## Настройка GitHub Environment для prod

Для безопасности рекомендуется настроить защищённое окружение:

1. `Settings → Environments → New environment`
2. Название: `production`
3. Включить **Required reviewers** (например, Team Lead)
4. Опционально: **Wait timer**, **Deployment branches** (`main` only)

Теперь при запуске `apply` для prod пайплайн будет ждать подтверждения от ревьюера.

## Запуск вручную

1. Перейти в репозиторий → **Actions** → **Terraform CI/CD** → **Run workflow**
2. Выбрать:
   - `environment`: `dev`, `stage` или `prod`
   - `action`: `plan` (посмотреть изменения) или `apply` (применить)
3. Нажать **Run workflow**

### Локальный запуск (для отладки)

```bash
# Экспорт переменных
export MINIO_ENDPOINT="http://localhost:9000"
export MINIO_BUCKET="terraform-state"
export MINIO_ACCESS_KEY="minioadmin"
export MINIO_SECRET_KEY="minioadmin"
export YC_TOKEN="<ваш IAM-токен>"

# Инициализация с backend
cd Task2Advanced/envs/dev
terraform init \
  -backend-config="endpoint=${MINIO_ENDPOINT}" \
  -backend-config="bucket=${MINIO_BUCKET}" \
  -backend-config="key=envs/dev/terraform.tfstate" \
  -backend-config="access_key=${MINIO_ACCESS_KEY}" \
  -backend-config="secret_key=${MINIO_SECRET_KEY}" \
  -backend-config="region=us-east-1" \
  -backend-config="skip_credentials_validation=true" \
  -backend-config="skip_metadata_api_check=true" \
  -backend-config="skip_region_validation=true" \
  -backend-config="force_path_style=true"

# Plan и apply
terraform plan -var-file="terraform.tfvars"
terraform apply -var-file="terraform.tfvars"
```

## Ключевые решения

- **Состояние не локально** — backend вынесен в Minio, `.tfstate` никогда не попадает в git (добавлен в `.gitignore`).
- **Пароли не в коде** — все секреты только через GitHub Secrets и переменные окружения CI.
- **Изоляция окружений** — отдельные ключи состояния, конфигурации и approval-процессы для dev/stage/prod.
- **Минималистичный workflow** — один файл `.github/workflows/terraform.yml`, одна матрица, два job'а.
