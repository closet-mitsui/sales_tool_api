.DEFAULT_GOAL := help

.PHONY := help
# INFO: 参考サイト - https://postd.cc/auto-documented-makefile/
help: ## makeコマンドのサブコマンドリストと、各コマンドの説明を表示
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY := init
init: ## 初回のみ実行してください。
	@docker compose build --no-cache --force-rm
	@docker compose up -d
	@docker compose exec app cp .env.example .env
	@docker compose exec app composer install
	@docker compose exec app php artisan key:generate
	@docker compose exec app npm install
	@docker compose exec app npm run dev
	@docker compose exec app chmod 777 -Rc storage

.PHONY := clean
clean: ## WARN: プロジェクトのデータを完全削除
	@docker compose exec app rm -rf .env node_modules vendor
	@docker compose down
	@docker volume rm sales_tool_api_db
	@docker image rm sales_tool_api-app sales_tool_api-db sales_tool_api-web

.PHONY := reset
reset: ## プロジェクトの状態を完全にリセットします。
	@make clean
	@make init

.PHONY := ps
ps: ## docker compose ps
	@docker compose ps

.PHONY := start
start: ## docker compose start
	@docker compose start

.PHONY := stop
stop: ## docker compose start
	@docker compose stop

.PHONY := phpunit
phpunit: ## phpunitの実行
	@docker compose exec app vendor/bin/phpunit

.PHONY := db
db: ## db login
	@docker compose exec db mysql -u sales_tool_app -p

.PHONY := app
app: ## into app container
	@docker compose exec app bash
