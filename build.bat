@echo off
setlocal enabledelayedexpansion
set image_name=dotfiles
set container_name=dotfiles
set image_exists=false
set container_exists=false
for /f "tokens=*" %%i in ('docker images --format "{{.Repository}}"') do (
	if %%i==dotfiles (
		set image_exists=true
	)
)
for /f "tokens=*" %%i in ('docker ps -a --format "{{.Names}}"') do (
	if %%i==dotfiles (
		set container_exists=true
	)
)
if !image_exists!==false (
	docker compose build
)
if !container_exists!==false (
	docker compose run --name !container_name! !image_name!
)

