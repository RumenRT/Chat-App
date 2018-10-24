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

      send_message: (message) ->
        @perform 'send_message', message: message

      $new_message_form.submit (e) ->
        $this = $(this)
        message_body = $new_message_body.val()
        if $.trim(message_body).length > 0
          App.chat.send_message message_body

        e.preventDefault()
        return false
