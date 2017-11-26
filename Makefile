WD := $(shell pwd)
APP_NAME := UnityNativeC
DIR_BUILD := $(WD)/Build
LOG_FILE := $(WD)/Build.log
PROJECT_PATH := $(WD)/UnitySrc
DIR_PLUGIN := $(PROJECT_PATH)/Assets/NaPl/Plugins
SCENE := $(PROJECT_PATH)/Assets/NaPl/Demo/Demo.unity
CFLAGS := -shared

ifeq ($(OS),Windows_NT)
	UNITY_APP := $(PROGRAMFILES)/Unity/Editor/Unity.exe
	CC := x86_64-w64-mingw32-gcc
	PLUGIN_OUTPUT := NaPlContent.dll
else ifeq ($(shell uname -s),Darwin)
	UNITY_APP := /Applications/Unity/Unity.app/Contents/MacOS/Unity
	CC := cc
	PLUGIN_OUTPUT := /NaPlContent.bundle/Contents/MacOS/NaPlContent
	CFLAGS := $(CFLAGS) -undefined dynamic_lookup -arch i386 -arch x86_64
	BIN := $(DIR_BUILD)/macos/$(APP_NAME).app/Contents/MacOS/$(APP_NAME)
endif

####################################################

.PHONY: help clean plugin macos win webgl

all: clean plugin macos win webgl

help:
	@"$(MAKE)" -pq | grep -v Makefile | \
		awk -F: '/^[a-zA-Z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /); for (i in A) print A[i]}' | \
		sort

clean:
	rm -rf Build/*/*

show_log:
	cat $(LOG_FILE)
	rm $(LOG_FILE)

plugin:
	$(CC) $(CFLAGS) -o $(DIR_PLUGIN)/$(PLUGIN_OUTPUT) $(DIR_PLUGIN)/NaPlContent.c

demo:
	$(BIN) -logFile Run.log
	cat Run.log | grep OUTPUT
	rm Run.log

demo_webgl:
	docker run \
		--rm \
		--detach \
		--name "unity_napl_webgl_demo" \
		-p 8080:80 \
		-v $(DIR_BUILD)/webgl/public:/usr/share/nginx/html:ro \
		nginx:alpine \
		sh -c "nginx -g 'daemon off;'"
	open -a "Google Chrome" http://localhost:8080/
	sleep 20
	docker kill unity_napl_webgl_demo

macos:
	$(UNITY_APP) \
		-batchmode \
		-nographics \
		-silent-crashes \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(PROJECT_PATH)" \
			-executeMethod BuildManager.RunMacOS \
			-output "$(DIR_BUILD)/macos/$(APP_NAME).app" \
			-scene "$(SCENE)" \
			-development \
			-debug \
		-quit
	$(MAKE) show_log

win:
	$(UNITY_APP) \
		-batchmode \
		-nographics \
		-silent-crashes \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(PROJECT_PATH)" \
			-executeMethod BuildManager.RunWin \
			-output "$(DIR_BUILD)/win/$(APP_NAME).exe" \
			-scene "$(SCENE)" \
			-development \
			-debug \
		-quit
	$(MAKE) show_log

webgl:
	$(UNITY_APP) \
		-batchmode \
		-nographics \
		-silent-crashes \
		-logFile "$(LOG_FILE)" \
		-projectPath "$(PROJECT_PATH)" \
			-executeMethod BuildManager.RunWebGL \
			-output "$(DIR_BUILD)/webgl/public" \
			-scene "$(SCENE)" \
			-development \
			-debug \
		-quit
	$(MAKE) show_log

