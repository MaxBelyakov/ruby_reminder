class @Contact
  constructor: ->
    # Show all user's contacts
    @search_start('')

    # Search contacts by name
    $('#search_box').keyup (e) =>
      search_term = $(e.target).val()
      @search_start(search_term)

    # From jQuery API
    $("#sortable").sortable()
    $("#sortable").disableSelection()

    # Triggered when the user stopped sorting and the DOM position has changed
    $('#sortable').sortable().bind 'sortupdate', () =>
      @update_list()

    # Listening Enter key when adding new contact
    $('.answers_box_addnew').keypress (e) =>
      if e.keyCode == 13
        @add_new_contact()

    # Click function
    $(document).click (e) =>
      # if click outside the <input> and if <input> exists
      if ($(e.target).parent().attr('class') != 'contact_name' & $('#contact_input').length)
        @close_settings()

    # Key press functions
    $(document).keydown (e) =>
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

    # Button actions
    $('#add_new_button').click () =>
      @add_new_contact()

    # Sort by name
    $('.contacts_title_name').click () =>
      @sort('name')

    # Sort by last contact
    $('.contacts_title_last_contact').click () =>
      @sort('last_date')


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
      success: (data) =>
        @draw_contacts(data['answer'])
    })


  sort: (order) ->
    $.ajax({
      url: gon.contact_path,
      data: {
        search_term: '',
        order: order
      },
      type: 'post',
      success: (data) =>
        @draw_contacts(data['answer'])
    })



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
      success: (data) =>
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
      success: (data) =>
        @search_start('')
    })


  update_list: ->
    $('.contact_name').each (i, element) =>
      id = $(element).parent().parent().attr('id')
      name = $(element).text()

      $.ajax({
        url: gon.update_list_path,
        data: {
          id: id,
          name: name,
          position: i
        },
        type: 'post'
      })


  update_color: (id, red) ->
    $.ajax({
      url: gon.update_color_path,
      data: {
        id: id,
        red: red
      },
      type: 'post',
      success: (data) =>
        $('#' + id).attr('class', 'contact_container_' + data["answer"])
    })


  close_settings: () =>
    # Find active settings
    object = $('#contact_input').parent()
    # Update colors
    contact_red = object.find('#red_set').val()

    if (contact_red == '')
      contact_red = 0

    @update_color(object.parent().parent().attr('id'), contact_red)

    # Close <input> and save new values
    contact_text = object.find('#contact_input').val( )
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
        contact_obj = $(@).parent().find('.contact_name')
        contact_id = $(e.target).parent().parent().parent().attr('id')

        # Load current settings
        $.ajax({
          url: gon.settings_path,
          data: {
            id: contact_id,
            name: contact_obj.html()
          },
          type: 'post',
          success: (data) =>
            
            contact_obj.html(SMT['edit'](data))
            $('#contact_input').focus()
            # Deselect text inside
            $('#contact_input').val($('#contact_input').val())
        })

        # Hide buttons
        $(@).hide()
        $(@).parent().find('.contact_delete').hide()
        enable = 0

    $('.contact_delete').click (e) =>
      contact_id = $(e.target).parent().parent().parent().attr('id')
      if (confirm('Delete this field?'))
        @delete_contact(contact_id)

    $('.contact_update').click (e) =>
      contact_id = $(e.target).parent().parent().parent().attr('id')
      $.ajax({
        url: gon.update_date_path,
        data: {
          id: contact_id
        },
        type: 'post',
        success: (data) =>
          @search_start('')
      })


$(document).ready () =>
  contact = new @Contact()
