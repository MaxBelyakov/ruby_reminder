class @Contact
  constructor: ->
    @ADD_CONTACT = ""
    @UPDATE_CONTACT = ""
    @DELETE_CONTACT = ""
    @LOAD_SETTINGS = ""
    @SEARCH_FILE = ""

    @search_start('')
    @run()


  run: ->
    # Search contacts
    $('#search_box').keyup (e) ->
      search_term = $(@).attr('value')
      search_start(search_term)

      # From jQuery API
      $("#sortable").sortable()
      $("#sortable").disableSelection()

      # Triggered when the user stopped sorting and the DOM position has changed
      $('#sortable').sortable().bind 'sortupdate', () ->
        update_list()

      # Add new POST
      $('.answers_box_addnew').keypress (e) ->
        if e.keyCode == 13
          add_new_contact()

      # Click function
      $(@).click (e) ->
        # if click outside the <input> and if <input> exists
        if ($(e.target).parent().attr('class') != 'contact_name' & $('#contact_input').length)
          close_settings()


      # Key press functions
      $(@).keydown( (e) ->
        # Contact name
        if ($(e.target).parent().attr('class') == 'contact_name')
          if (e.keyCode == 13)
            close_settings()
          else if (e.keyCode == 27)
            # Return old value
            $(e.target).parent().html(contact_text)

        # Red mark
        if ($(e.target).attr('id') == 'red_set')
          # Allow: backspace, delete, tab, escape, and enter
          if ( e.keyCode == 46 || e.keyCode == 8 || e.keyCode == 9 || e.keyCode == 27 || e.keyCode == 13 || (e.keyCode == 65 && e.ctrlKey == true) || (e.keyCode >= 35 && e.keyCode <= 39))
            # let it happen, don't do anything
            return
          else
            # Ensure that it is a number and stop the keypress
            if (e.shiftKey || (e.keyCode < 48 || e.keyCode > 57) && (e.keyCode < 96 || e.keyCode > 105 ))
              e.preDefault()
      )

    # Button actions
    $('#add_new_button').click () ->
      add_new_contact()

    # Sort by name
    $('.contacts_title_name').click () ->
      sort_by_name()

    # Sort by last contact
    $('.contacts_title_last_contact').click () ->
      sort_by_last_contact();


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
