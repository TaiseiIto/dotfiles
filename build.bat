@echo off
setlocal enabledelayedexpansion
set image_name=dotfiles
set container_name=dotfiles
set image_exists=false
set container_exists=false
for /f "delims=" %%i in ('git config --get remote.origin.url') do (
	for /f "tokens=2 delims=:/" %%j in ("%%i") do (
		set user_name=%%j
	)
)
for /f "tokens=*" %%i in ('docker images --format "{{.Repository}}"') do (
	if %%i==!image_name! (
		set image_exists=true
	)
)
for /f "tokens=*" %%i in ('docker ps -a --format "{{.Names}}"') do (
	if %%i==!container_name! (
		set container_exists=true
	)
)
if !image_exists!==false (
	docker compose build --build-arg USERNAME=!user_name!
)
if !container_exists!==false (
	docker compose run --name !container_name! !image_name!
) else (
	docker start !container_name!
	docker exec -it !container_name! /entrypoint.sh
)

