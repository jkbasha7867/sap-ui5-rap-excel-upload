CLASS zcl_excel_upload_transform DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    CLASS-METHODS map_row
      IMPORTING
        iv_customer_id TYPE string
        iv_material_no TYPE string
        iv_quantity    TYPE string
        iv_amount      TYPE string
      RETURNING
        VALUE(rs_result) TYPE zexcel_upload_row.

    CLASS-METHODS validate_row
      IMPORTING
        is_row TYPE zexcel_upload_row
      RETURNING
        VALUE(rv_valid) TYPE abap_bool.
ENDCLASS.

CLASS zcl_excel_upload_transform IMPLEMENTATION.
  METHOD map_row.
    rs_result-customer_id = iv_customer_id.
    rs_result-material_no = iv_material_no.
    rs_result-quantity = CONV i( iv_quantity ).
    rs_result-amount = CONV decfloat34( iv_amount ).
    rs_result-status = 'PENDING'.
  ENDMETHOD.

  METHOD validate_row.
    rv_valid = abap_true.

    IF is_row-customer_id IS INITIAL.
      rv_valid = abap_false.
    ENDIF.

    IF is_row-material_no IS INITIAL.
      rv_valid = abap_false.
    ENDIF.

    IF is_row-quantity <= 0.
      rv_valid = abap_false.
    ENDIF.

    IF is_row-amount <= 0.
      rv_valid = abap_false.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
