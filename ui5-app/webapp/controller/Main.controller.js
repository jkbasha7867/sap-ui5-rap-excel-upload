sap.ui.define([
  "sap/ui/core/mvc/Controller",
  "sap/m/MessageBox",
  "sap/m/MessageToast",
  "sap/ui/model/json/JSONModel"
], function (Controller, MessageBox, MessageToast, JSONModel) {
  "use strict";

  return Controller.extend("zexcelupload.controller.Main", {
    onInit: function () {
      this._parsedRows = [];
      this._uploadInProgress = false;
    },

    onFileUploaderChange: function (oEvent) {
      var file = oEvent.getParameter("files")[0];

      if (!file) {
        return;
      }

      var reader = new FileReader();
      var that = this;

      reader.onload = function (e) {
        try {
          var data = new Uint8Array(e.target.result);
          var workbook = XLSX.read(data, { type: "array" });
          var sheetName = workbook.SheetNames[0];
          var sheet = workbook.Sheets[sheetName];

          var rows = XLSX.utils.sheet_to_json(sheet, { defval: null, raw: false });
          var normalizedRows = that._normalizeRows(rows);

          that._parsedRows = normalizedRows.validRows;
          var oViewModel = that.getView().getModel("viewModel");

          oViewModel.setProperty("/rows", that._parsedRows);
          oViewModel.setProperty("/uploadedCount", that._parsedRows.length);
          oViewModel.setProperty("/errorCount", normalizedRows.errors.length);
          oViewModel.setProperty("/message", "Loaded " + that._parsedRows.length + " valid rows. " + normalizedRows.errors.length + " validation errors found.");

          if (normalizedRows.errors.length > 0) {
            MessageBox.warning("Some rows were rejected during validation. Please review the data before upload.");
          } else {
            MessageToast.show("Excel file loaded successfully.");
          }
        } catch (err) {
          MessageBox.error("Unable to read the uploaded file. Please verify it is a valid Excel file.");
          console.error(err);
        }
      };

      reader.readAsArrayBuffer(file);
    },

    _normalizeRows: function (aRows) {
      var validRows = [];
      var errors = [];

      aRows.forEach(function (row, index) {
        var normalized = {
          customer_id: row.customer_id || row.CUSTOMER_ID || row.customer || "",
          material_no: row.material_no || row.MATERIAL_NO || row.material || "",
          quantity: row.quantity || row.QUANTITY || 0,
          amount: row.amount || row.AMOUNT || 0,
          status: "pending"
        };

        var isValid = true;

        if (!normalized.customer_id || normalized.customer_id === "") {
          isValid = false;
        }

        if (!normalized.material_no || normalized.material_no === "") {
          isValid = false;
        }

        if (isNaN(Number(normalized.quantity)) || Number(normalized.quantity) <= 0) {
          isValid = false;
        }

        if (isNaN(Number(normalized.amount)) || Number(normalized.amount) <= 0) {
          isValid = false;
        }

        if (isValid) {
          validRows.push({
            customer_id: String(normalized.customer_id),
            material_no: String(normalized.material_no),
            quantity: Number(normalized.quantity),
            amount: Number(normalized.amount),
            status: "valid"
          });
        } else {
          errors.push({ rowNumber: index + 2, reason: "Missing or invalid required fields" });
        }
      });

      return { validRows: validRows, errors: errors };
    },

    onUploadToRAP: function () {
      var that = this;
      var oModel = this.getOwnerComponent().getModel();

      if (this._parsedRows.length === 0) {
        MessageBox.error("No valid rows available to upload.");
        return;
      }

      if (this._uploadInProgress) {
        MessageBox.warning("Upload already in progress.");
        return;
      }

      this._uploadInProgress = true;
      var oViewModel = this.getView().getModel("viewModel");
      oViewModel.setProperty("/message", "Uploading " + this._parsedRows.length + " rows to SAP RAP...");

      var batchSize = 50;
      var chunks = [];

      for (var i = 0; i < this._parsedRows.length; i += batchSize) {
        chunks.push(this._parsedRows.slice(i, i + batchSize));
      }

      var runBatch = function (index) {
        if (index >= chunks.length) {
          that._uploadInProgress = false;
          oViewModel.setProperty("/message", "Upload finished successfully.");
          MessageToast.show("Data sent to RAP successfully.");
          return;
        }

        var chunk = chunks[index];
        oModel.setUseBatch(true);

        chunk.forEach(function (row) {
          oModel.create("/ZEXCEL_UPLOAD", row, {
            success: function () {
              // row created successfully
            },
            error: function (oError) {
              that._uploadInProgress = false;
              MessageBox.error("Error while creating a record in RAP.");
              console.error(oError);
            }
          });
        });

        oModel.submitChanges({
          success: function () {
            runBatch(index + 1);
          },
          error: function (oError) {
            that._uploadInProgress = false;
            MessageBox.error("Batch submit failed.");
            console.error(oError);
          }
        });
      };

      runBatch(0);
    }
  });
});
