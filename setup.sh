#!/bin/bash

if [ -z "$2" ] || [ -z "$3" ]; then
	echo "error: missing input."
	echo "       good command -> sh ./setup.sh <virtual_env_name> <project_name> <application_name>"
	exit 1

elif [ -d ./created/"$1" ]; then
    echo " error: virtual_env_name alreadly exist."
	exit 1
fi

echo ""
echo "----- SELECT FRAMEWORK -----"

select framework in "fastapi" "django" "no_framework"; do
    [ -n "$framework" ] && break
done

echo ""
echo "----- SERVER START ? -----"
select  server_start_flag in "YES" "NO"; do
    [ -n "$server_start_flag" ] && break
done

echo "--- $framework setup start ---"
echo "virtual_env creating..."
mkdir -p "created/$1"
cd "created/$1" || exit
python -m venv venv
mkdir "$2"
cd "../../"
echo "virtual_env created!"

echo "start venv..."
source ./created/$1/venv/Scripts/activate

if [ "$framework" = "django" ]; then
    cd ./created/"$1"/"$2" || exit
    pip install django
    pip install djangorestframework
    django-admin startproject config .
    python manage.py startapp "$3"

    if [ "$server_start_flag" = "YES" ]; then
        python manage.py runserver
    fi

elif [ "$framework" = "fastapi" ]; then
    cd ./created/"$1"/"$2" || exit
    pip install fastapi
    pip install "uvicorn[standard]"
    touch main.py

    if [ "$server_start_flag" = "YES" ]; then
        uvicorn main:app --reload
    fi
fi

echo "--- $1 setup successful ---"
