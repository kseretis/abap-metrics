class z_authors_calculator definition public final create public.

  public section.
    constants object_type(4) type c value 'METH'.

    methods constructor
      importing full_name type string.
    methods find_authors
      returning value(return) type i
      raising zcx_metrics_error.

  protected section.

  private section.
    data full_name type string.
    data version_list      type table of vrsd.
    data authors type i value 0.

    methods get_versions
      raising zcx_metrics_error.

endclass.

class z_authors_calculator implementation.

  method constructor.
    me->full_name = full_name.
  endmethod.

  method find_authors.
    get_versions( ).
    data last_author type string.
    loop at version_list reference into data(version).
      if sy-index = 1.
        last_author = version->author.
        authors += 1.
        continue.
      endif.

      if last_author = version->author.
        continue.
      endif.

      last_author = version->author.
      authors += 1.
    endloop.
  endmethod.

  method get_versions.
    data version_managment_list   type standard table of vrsn.
    call function 'SVRS_GET_VERSION_DIRECTORY_46'
      exporting
        objname                = full_name
        objtype                = object_type
      tables
        lversno_list           = version_managment_list
        version_list           = version_list
      exceptions
        no_entry               = 1
        communication_failure_ = 2
        system_failure         = 3
        others                 = 4.
    if sy-subrc <> 0.
      raise exception new zcx_metrics_error( textid = zcx_metrics_error=>empty_version_list ).
    endif.
  endmethod.

endclass.