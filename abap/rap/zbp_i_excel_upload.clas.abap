CLASS zbp_i_excel_upload DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF z_i_excel_upload.
ENDCLASS.

CLASS zbp_i_excel_upload IMPLEMENTATION.
  METHOD save.
    "This sample demonstrates validation and transformation hooks for uploaded Excel content.
    "The logic can be extended to include duplicate checks, material existence, and user validation.
  ENDMETHOD.

  METHOD validate.
    "Example validation logic executed by the RAP behavior layer.
    "Each incoming row is checked before save.
    LOOP AT create FOR z_i_excel_upload INTO DATA(ls_row).
      IF ls_row-customerid IS INITIAL.
        APPEND VALUE #( %tky = ls_row-%tky ) TO failed.
      ENDIF.

      IF ls_row-materialno IS INITIAL.
        APPEND VALUE #( %tky = ls_row-%tky ) TO failed.
      ENDIF.

      IF ls_row-quantity <= 0.
        APPEND VALUE #( %tky = ls_row-%tky ) TO failed.
      ENDIF.

      IF ls_row-amount <= 0.
        APPEND VALUE #( %tky = ls_row-%tky ) TO failed.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD calculate.
    "Example derived field logic.
    LOOP AT create FOR z_i_excel_upload INTO DATA(ls_row).
      ls_row-status = 'VALID'.
      MODIFY ENTITIES IN LOCAL MODE
        ENTITY z_i_excel_upload
          UPDATE FIELDS ( status )
          WITH VALUE #( ( %tky = ls_row-%tky status = ls_row-status ) ).
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
