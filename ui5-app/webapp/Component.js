sap.ui.define([
  "sap/ui/core/UIComponent",
  "sap/ui/model/json/JSONModel"
], function (UIComponent, JSONModel) {
  "use strict";

  return UIComponent.extend("zexcelupload.Component", {
    metadata: {
      manifest: "json"
    },

    init: function () {
      UIComponent.prototype.init.apply(this, arguments);

      var oModel = new JSONModel({
        rows: [],
        uploadedCount: 0,
        errorCount: 0,
        isBusy: false,
        message: "Upload an Excel file to begin"
      });

      this.setModel(oModel, "viewModel");
      this.getRouter().initialize();
    }
  });
});
