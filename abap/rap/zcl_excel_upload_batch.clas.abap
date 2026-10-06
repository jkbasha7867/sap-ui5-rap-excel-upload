CLASS zcl_excel_upload_batch DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    TYPES: BEGIN OF ty_row,
             customer_id TYPE string,
             material_no TYPE string,
             quantity    TYPE i,
             amount      TYPE decfloat34,
           END OF ty_row.

    TYPES ty_rows TYPE STANDARD TABLE OF ty_row WITH DEFAULT KEY.

    CLASS-METHODS process_in_batches
      IMPORTING
        it_rows TYPE ty_rows
        iv_batch_size TYPE i DEFAULT 50.
      RETURNING
        VALUE(rv_processed) TYPE i.
ENDCLASS.

CLASS zcl_excel_upload_batch IMPLEMENTATION.
  METHOD process_in_batches.
    DATA lv_offset TYPE i.
    DATA lv_batch_count TYPE i.

    DO.
      EXIT WHEN lv_offset >= lines( it_rows ).

      lv_batch_count = lines( it_rows ) - lv_offset.
      IF lv_batch_count > iv_batch_size.
        lv_batch_count = iv_batch_size.
      ENDIF.

      "Loop through the current chunk and call the RAP create/update logic here.
      "This sample intentionally keeps the logic abstract for business customization.
      "In production, insert only valid rows and log failures for invalid ones."

      lv_offset = lv_offset + lv_batch_count.
    ENDDO.

    rv_processed = lines( it_rows ).
  ENDMETHOD.
ENDCLASS.
