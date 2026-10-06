@EndUserText.label : 'Excel Upload Entity'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.quickInfo: 'Excel Upload Data'
@ObjectModel.usageType:
{
  serviceQuality: #X,
  sizeCategory: #L,
  dataClass: #MASTER
}

define root view entity Z_I_EXCEL_UPLOAD
  as select from zexcel_upload
{
  key customer_id     as CustomerId,
      material_no     as MaterialNo,
      quantity        as Quantity,
      amount          as Amount,
      status          as Status,
      created_at      as CreatedAt,
      created_by      as CreatedBy
}
