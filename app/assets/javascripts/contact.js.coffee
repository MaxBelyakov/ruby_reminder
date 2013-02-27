class @Contact
  constructor: ->
    @ADD_CONTACT = ""
    @UPDATE_CONTACT = ""
    @DELETE_CONTACT = ""
    @LOAD_SETTINGS = ""
    @SEARCH_FILE = ""

    @search_start('')


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
        $.post(@LOAD_SETTINGS, {
          id: $(contact_obj).attr('id'),
          name: contact_text
        }, (data) ->
          contact_obj.html(data)
          $('#contact_input').focus()

          # Deselect text inside
          $('#contact_input').val($('#contact_input').val())
        )

        # Hide buttons
        $(@).hide()
        $(@).parent().find('.contact_delete').hide()
        enable = 0


    #
    $('.contact_delete').click( (event) ->
      contact_id = $(@).parent().find('.contact_name').attr('id')
      if (confirm('Delete this field?'))
        delete_contact(contact_id)
    )

    $('.contact_update').click( (event) ->
      contact_obj = $(@).parent().parent().find('.contact_name')
      $.post(UPDATE_DATE_FILE, {
        id: $(contact_obj).attr('id')
      }, (data) =>
        @search_start('');
      )
    )


$(document).ready () =>
  contact = new @Contact()
