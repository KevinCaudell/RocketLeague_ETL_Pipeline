# Rocket League ETL Pipeline (Databricks + Azure)

## Project Overview

This project is a **data engineering ETL pipeline** built to analyze Rocket League match replay data using **Microsoft Azure and Databricks**.

It demonstrates how raw API data can be ingested, processed, and transformed into analytics-ready datasets using a modern cloud data stack.

---

## Architecture

The pipeline follows a **Medallion Architecture (Bronze → Silver → Gold)**:

Rocket League API  
↓

#### Bronze Layer (Azure Blob Storage)
- Raw JSON replay data stored in cloud storage  

↓

#### Silver Layer (Databricks - PySpark)
- Data cleaning, flattening, and transformation  
- Normalization of replay and player structures  

↓

#### Gold Layer (Databricks / Azure SQL)
- Aggregated analytics tables  
- Player and match-level performance metrics  

---

## Tech Stack

- **Databricks (PySpark)** – Data processing and transformation
- **Microsoft Azure Blob Storage** – Raw data storage (Bronze layer)
- **Azure SQL Database** – Structured analytics storage
- **Python** – API integration + orchestration logic
- **Rocket League API (Ballchasing)** – Data source

---

## ETL Process

### 1. Extract
- Pull replay data from the Rocket League API
- Store raw JSON response

### 2. Load (Bronze Layer)
- Upload raw JSON files into Azure Blob Storage

### 3. Transform (Silver Layer)
- Read raw JSON into Databricks
- Flatten nested structures
- Clean and standardize schema

### 4. Gold Layer
- Aggregate player and match-level metrics
- Prepare datasets for analytics and dashboards

---

## Key Features

- End-to-end ETL pipeline (API → Azure Storage → Databricks → SQL)
- Medallion architecture implementation
- PySpark-based distributed data processing
- Cloud-native data engineering workflow
- Modular and reusable pipeline structure

---

## Data Flow Diagram

(Optional but highly recommended)

API → Blob Storage (Bronze) → Databricks (Silver) → SQL (Gold)

## Security Notice

This repository contains **sanitized and redacted code only**.

- API keys and credentials have been removed
- Environment-specific values are replaced with placeholders
- Actual execution requires a configured Databricks and Azure environment

---

## Execution Note

These notebooks are **exports from a Databricks workspace** and are intended for:

- Code review
- Architecture demonstration
- Portfolio presentation

They are **not directly runnable in a local environment without configuration setup**.

---

## Purpose

This project was built to demonstrate:

- Real-world data engineering pipeline design
- Cloud data processing using Azure + Databricks
- Working with semi-structured JSON data
- ETL best practices using modern tools

---

## Note

This project simulates production-style data workflows used in modern analytics engineering environments.
