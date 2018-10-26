jQuery(document).on 'turbolinks:load', ->
  $messages = $('#messages')
  $new_message_form = $('#new-message')
  $new_message_body = $new_message_form.find('#message-body')

  if $messages.length > 0
    App.chat = App.cable.subscriptions.create {
      channel: "ChatChannel"
      },
      connected: ->

      disconnected ->

      received: (data) ->
        if data['message']
          $new_message_body.val('')
          $message.append data['message']

      send_message: (message, file_uri, original_name) ->
      # send the message to the server along with file in base64 encoding 
        @perform 'send_message', message: message, file_uri: file_uri, original_name: original_name

      $new_message_form.submit (e) ->
        $this = $(this)
        message_body = $new_message_body.val()
        if $.trim(message_body).length > 0 or $new_message_attachment.get(0).files.length > 0
          if $new_message_attachment.get(0).files.length > 0 # if file is chosen
            reader = new FileReader()  # use FileReader API
            file_name = $new_message_attachment.get(0).files[0].name # get the name of the first chosen file
            reader.addEventListener "loadend", -> # perform the following action after the file is loaded
              App.chat.send_message message_body, reader.result, file_name

            reader.readAsDataURL $new_message_attachment.get(0).files[0] # read the chosen file
          else
            App.chat.send_message message_body

        e.preventDefault()
        return false
