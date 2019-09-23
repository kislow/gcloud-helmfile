#!/bin/bash
set -e

if [ -z "$DATABASE_NAME" ]; then
  exit 0
fi
if [ -z "$DATABASE_PASSWORD" ]; then
  echo "Environment variable DATABASE_PASSWORD not set!"
  exit 1
fi
if [ -z "$PGPASSWORD" ]; then
  echo "Environment variable PGPASSWORD not set!"
  exit 1
fi

# Run Cloud SQL Proxy in background
trap "kill 0" EXIT
kubectl port-forward -n cloud-sql svc/cloud-sql 5432 &
sleep 2 # Short delay to allow for connection to be established

# Try to create database and username; ignore failure in case they already exist
psql --host=127.0.0.1 --user postgres --command="CREATE DATABASE \"$DATABASE_NAME\";" || true
psql --host=127.0.0.1 --user postgres --command="CREATE USER \"$DATABASE_NAME\";" || true

# Update user password and privileges
psql --host=127.0.0.1 --user=postgres --command="ALTER USER \"$DATABASE_NAME\" WITH PASSWORD '$DATABASE_PASSWORD'; GRANT ALL PRIVILEGES ON DATABASE \"$DATABASE_NAME\" TO \"$DATABASE_NAME\";"
