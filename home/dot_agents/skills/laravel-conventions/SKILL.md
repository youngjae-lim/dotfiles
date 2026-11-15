---
name: laravel-conventions
description: Conventions for PHP/Laravel projects (Herd, Pest/PHPUnit, Pint, Eloquent, Blade). Use when editing or creating code in a Laravel app.
---

# Laravel conventions

Environment: PHP from **Laravel Herd** (`php`, `composer` on PATH). Sites at `<name>.test`.

Before coding: read `composer.json` (Laravel version, Pest vs PHPUnit, Livewire/Inertia), and existing code in the same area. Match it.

- Run: `php artisan test` (or `vendor/bin/pest --filter <name>`); format with `vendor/bin/pint --dirty`; static analysis with `vendor/bin/phpstan` if configured.
- Generate files with artisan (`make:model -mfs`, `make:controller`, `make:request`, `make:test --pest`) rather than by hand.
- Controllers thin; validation in Form Requests; authorization in Policies/Gates; business logic in Actions/Services if the project uses them.
- Eloquent: guard mass assignment (`$fillable`), eager-load to avoid N+1 (`with()`), use casts and enums, scopes for reusable queries. Wrap multi-write operations in `DB::transaction()`.
- Migrations: never edit a migration that has run in shared environments; add a new one. Ask before `migrate:fresh`/`db:wipe` — they destroy data.
- Config via `config()` only; `env()` only inside `config/*.php`. Never read or print `.env`.
- Queue long work (`ShouldQueue`). Use `Http::fake()`, `Queue::fake()`, `Mail::fake()` in tests.
- Blade: escape with `{{ }}`; `{!! !!}` only for trusted HTML.
- Use Laravel helpers/collections idiomatically; type-hint everything; `declare(strict_types=1);` if the project does.
