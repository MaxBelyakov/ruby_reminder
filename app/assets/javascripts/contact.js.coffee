class @Contact
  constructor: ->
    @search_start('')

    @ADD_CONTACT = ""
    @UPDATE_CONTACT = ""
    @DELETE_CONTACT = ""
    @LOAD_SETTINGS = ""
    @SEARCH_FILE = ""

  search_start: (search_term) ->
    if search_term != ''
      $('#sortable').sortable({ disabled: true; })
    else
      $('#sortable').sortable({ disabled: false; })

    $.post(@SEARCH_FILE,
      {
        search_term: search_term,
        order: 'position'
      },
      (data) =>
        @draw_contacts()
    )


  draw_contacts: (data) ->
    # Display data
    $('#sortable').html(data)
    $('.container').slideDown(1000)

    # Hide settings
    $('.settings').hide()

    # Display edit, delete and update buttons
    $('#sortable div[class*=contact_container_]').hover( ((e) ->
      if $('#container_input', @).length == 0
        $('.contact_edit', @).show()
        $('.contact_delete', @).show()
        $('.contact_update', @).show()
    ), ((e) ->
      $('.contact_edit', @).hide()
      $('.contact_delete', @).hide()
      $('.contact_update', @).hide()
    ) )

    enable = 0

    $('.contact_edit').click (event) ->
      if enable == 0
        enable = 1

        # Save contact name and contact_obj
        contact_text = $(@).parent().find('.contact_name').html()
        contact_obj = $(@).parent().find('.contact_name')

        # Load current settings

