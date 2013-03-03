class @Contact
  constructor: ->
    @LOAD_SETTINGS = ""

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
      $('#sortable').sortable().bind 'sortupdate', () =>
        @update_list()

      # Add new POST
      $('.answers_box_addnew').keypress (e) =>
        if e.keyCode == 13
          @add_new_contact()

      # Click function
      $(@).click (e) =>
        # if click outside the <input> and if <input> exists
        if ($(e.target).parent().attr('class') != 'contact_name' & $('#contact_input').length)
          @close_settings()


      # Key press functions
      $(@).keydown( (e) =>
        # Contact name
        if ($(e.target).parent().attr('class') == 'contact_name')
          if (e.keyCode == 13)
            @close_settings()
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
    $('#add_new_button').click () =>
      @add_new_contact()

    # Sort by name
    $('.contacts_title_name').click () =>
      @sort_by_name()

    # Sort by last contact
    $('.contacts_title_last_contact').click () =>
      @sort_by_last_contact();


  search_start: (search_term) ->
    # Enable and disable (if you use search) the jQuery sortable UI
    if (search_term != '')
      $('#sortable').sortable({ disabled: true })
    else
      $('#sortable').sortable({ disabled: false })

    # Search contacts
    $.ajax({
      url: gon.contact_path,
      data: {
        search_term: search_term,
        order: 'position'
      },
      type: 'post',
      success: (obj) =>
        @draw_contacts(obj['answer'])
    })


  sort_by_name: ->
    $.post(@SEARCH, {
      search_term: '',
      order: 'name'
    }, (data) =>
      @draw_contacts(data)
    )


  sort_by_last_contact: ->
    $.post(@SEARCH, {
      search_term: '',
      order: 'last_date'
    }, (data) =>
      @draw_contacts(data)
    )


  add_new_contact: ->
    new_contact = $('.answers_box_addnew').val()
    if (new_contact == '')
      return false

    # Find last position
    position = $('.contact_name').length
    $.ajax({
      url: gon.addnew_path,
      data: {
        name: new_contact,
        position: position
      },
      type: 'post',
      success: (msg) =>
        @search_start('')
        $('.answers_box_addnew').val('')
    })


  delete_contact: (contact_id) ->
    $.ajax({
      url: gon.delete_path,
      data: {
        id: contact_id
      },
      type: 'post',
      success: (msg) =>
        @search_start('')
    })


  update_list: ->
    # Forming the variables for ajax request
    $('.contact_name').each( (i,name) =>
      id = $(this).attr('id')
      name = $(name).text()
      $.post(@UPDATE_LIST, {
        id: id,
        name: name,
        position: i
      })
    )


  update_colors: (id, red) ->
    $.post(@UPDATE_COLOR, {
      id: id,
      red: red
    }, (data) ->
      $('#contact_container_'+id).attr('class',data)
    )


  close_settings: () ->
    # Find active settings
    object = $('#contact_input').parent()
    # Update colors
    contact_red = object.find('#red_set').attr('value')

    if (contact_red == '')
      contact_red = 0

    update_colors(object.attr('id'), contact_red)
    # Close <input> and save new values
    contact_text = object.find('#contact_input').attr('value')
    object.html(contact_text)

    # Update list
    @update_list()


  draw_contacts: (data) ->
    $('#sortable').html('')

    for i in [0...data.length]
      # Display data  
      $('#sortable').append(SMT['singlecontact'](data[i]))

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

    $('.contact_edit').click (e) ->
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

    $('.contact_delete').click( (e) =>
      contact_id = $(e.target).parent().parent().parent().attr('id')
      if (confirm('Delete this field?'))
        @delete_contact(contact_id)
    )

    $('.contact_update').click( (e) =>
      contact_id = $(e.target).parent().parent().parent().attr('id')
      $.ajax({
        url: gon.update_path,
        data: {
          id: contact_id
        },
        type: 'post',
        success: (msg) =>
          @search_start('')
      })
    )


$(document).ready () =>
  contact = new @Contact()
