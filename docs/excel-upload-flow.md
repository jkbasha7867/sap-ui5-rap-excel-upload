# Excel Upload Flow

This document explains the architecture behind the sample app.

## 1. Browser-Level Parsing

The UI5 app uses SheetJS (`XLSX.read`) to parse the Excel file after upload. The rows are converted to JSON so the app can validate and normalize them before sending.

## 2. Front-End Validation

The controller validates required values such as:

- customer ID must exist
- material code must exist
- quantity > 0
- amount > 0

Any invalid row is rejected before calling `create()`.

## 3. Batch Upload to RAP

The UI5 app sends rows in batches (default: 50 records per request) to ensure performance for large files.

## 4. RAP Layer Validation

The ABAP behavior implementation checks each row before save and rejects invalid entries with application-specific logic.

## 5. Data Transformation

The transformation class maps Excel values into ABAP-friendly structures and ensures conversion to the correct types.

## 6. Batch Processing Pattern

The sample class `zcl_excel_upload_batch` demonstrates how to split large data sets into smaller groups for processing and insertion.

## Recommended Additions

- Duplicate detection
- Material master validation
- Customer existence check
- Error log table for failed rows
- Parallel or asynchronous upload handling for very large files
