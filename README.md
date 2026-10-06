# SAP UI5 + RAP Excel Upload Sample

This repository contains a complete sample architecture for:

- Uploading an XLSX file from SAP UI5
- Reading and validating the Excel content in the browser
- Sending the parsed rows to a RAP OData service
- Processing the data in ABAP using RAP behavior and custom transformation logic
- Handling batch processing for large files

## Project Structure

```text
sap-ui5-rap-excel-upload/
├─ README.md
├─ .gitignore
├─ ui5-app/
│  ├─ package.json
│  ├─ webapp/
│  │  ├─ Component.js
│  │  ├─ index.html
│  │  ├─ manifest.json
│  │  ├─ controller/
│  │  │  └─ Main.controller.js
│  │  ├─ view/
│  │  │  └─ Main.view.xml
│  │  └─ css/
│  │     └─ style.css
│  └─ ui5.yaml
├─ abap/
│  └─ rap/
│     ├─ z_i_excel_upload.ddls.asddls
│     ├─ zbp_i_excel_upload.clas.abap
│     ├─ zcl_excel_upload_transform.clas.abap
│     ├─ z_excel_upload.srv
│     └─ zcl_excel_upload_batch.clas.abap
└─ docs/
   └─ excel-upload-flow.md
```

## UI5 Flow

1. User picks an `.xlsx` file from UI5
2. SheetJS parses the file in browser
3. Data is validated before sending
4. Records are posted to the RAP OData service in batches
5. RAP entity behavior validates and transforms the incoming data
6. Data is persisted in the ABAP backend

## RAP Flow

- `Z_I_EXCEL_UPLOAD` is the root entity exposed to UI5
- Behavior definition validates fields and calculates derived values
- Transformation class converts uploaded row data into correct ABAP values
- Batch processing class demonstrates chunked inserts for large datasets

## How to Use

### UI5 app

1. Open the `ui5-app` folder
2. Run the UI5 app using UI5 tooling or a local server
3. Upload an Excel file with headers like:
   - `customer_id`
   - `material_no`
   - `quantity`
   - `amount`

### RAP backend

1. Import the ABAP files into your SAP system
2. Activate the CDS, behavior definition, and service binding
3. Ensure you have the OData service path configured in the UI5 `manifest.json`

## Notes

This is a sample architecture for learning and prototyping. You should adapt the field names, service names, and validation logic to your SAP RAP project and business requirements.

## Typical Excel Row Example

```text
customer_id | material_no | quantity | amount
1001        | MAT-001     | 5        | 250.00
1002        | MAT-002     | 3        | 180.50
```

The RAP layer can then perform checks such as:

- quantity > 0
- amount must be numeric
- customer must exist
- duplicate rows may be rejected

---

For more detail, see the provided docs and sample ABAP code in the repo.
