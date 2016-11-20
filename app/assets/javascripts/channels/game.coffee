$(document).on 'turbolinks:load', ->
  if $('.x_shape_aria').length > 0
    game_id = $('#current_player').data 'game'
    player_id = $('#current_player').data 'player'
    check_for_turn_url = $('#current_player').data 'check-for-turn'

    check_for_winner = ->
      check_for_winner_url = $('#current_player').data 'check-for-winner'
      $.get check_for_winner_url, (data) ->
        console.log "winner is: " + data
        if data == 'x'
          $('.notification-text').css('opacity', 0)
          $('#x_winner_text').css('opacity', 1)
          $('#restart_game').css('opacity', 1)
          $('#replay_game').css('display', '')
          get_players_score()
        else if data == 'o'
          $('.notification-text').css('opacity', 0)
          $('#o_winner_text').css('opacity', 1)
          $('#restart_game').css('opacity', 1)
          $('#replay_game').css('display', '')
          get_players_score()
        else if data == 'draw'
          $('.notification-text').css('opacity', 0)
          $('#draw_text').css('opacity', 1)
          $('#restart_game').css('opacity', 1)
          $('#replay_game').css('display', '')
          get_players_score()

    turn_shape = ->
      turn_shape_url = $('#current_player').data 'check-turn-shape'
      $.get turn_shape_url, (data) ->
        $('.notification-text').css('opacity', 0)
        $("##{data}_turn_text").css('opacity', 1)
        check_for_winner()

    get_players_score = ->
      get_players_score_url = $('#current_player').data 'get-players-score'
      $.get "#{get_players_score_url}?shape=x", (data) ->
        $('#x_player_score').text(data)
      $.get "#{get_players_score_url}?shape=o", (data) ->
        $('#o_player_score').text(data)

    turn_shape()

    App.game = App.cable.subscriptions.create {
      channel: "GameChannel",
      game_id: game_id
    },
      connected: ->
        console.log('WS connected')
        # Called when the subscription is ready for use on the server

      disconnected: ->
        # Called when the subscription has been terminated by the server

      received: (data) ->
        console.log data
        if 'new_player' of data
          $('#o_player_name').text data['player_name']
          turn_shape()
          get_players_score()
        else if 'new_round' of data
          if data = 'true'
            $('#restart_game').css('opacity', 0)
            $('#replay_game').css('display', 'none')
            turn_shape()
            $('.no-pointer').removeClass('no-pointer')
            $('._Y6i .o_shape_aria').css('display', 'none')
            $('._Y6i .x_shape_aria').css('display', 'none')
          else
            console.log 'new round failed'
        else
          cell = $("#cell-#{data['col_num']}x#{data['row_num']}")
          unless $(cell).hasClass('no-pointer')
            $svg = $(cell).find(".#{data['shape']}_shape_aria").drawsvg  duration: 150, stagger: 100
            $(cell).find(".#{data['shape']}_shape_aria").css('display', '')
            $svg.drawsvg('animate')
            $(cell).addClass('no-pointer')
          unless 'replay' of data
            turn_shape()


      play: (col_num, row_num) ->
        @perform 'play', col_num: col_num, row_num: row_num, game_id: game_id, player_id: player_id

      replay: ->
        @perform 'replay', game_id: game_id

    $('._Y6i').click ->
      cell = this
      unless $(cell).hasClass('no-pointer')
        $.get check_for_turn_url, (data) ->
          console.log data
          if data == 'true'
            col_num = $(cell).data('col')
            row_num = $(cell).data('row')
            console.log "#{col_num}, #{row_num}"
            App.game.play col_num, row_num

    $('#restart_game').click ->
      restart_game_url = $('#current_player').data 'restart-game'
      $.get restart_game_url

    $('#replay_game').click ->
      $('.no-pointer').removeClass('no-pointer')
      $('._Y6i .o_shape_aria').css('display', 'none')
      $('._Y6i .x_shape_aria').css('display', 'none')
      App.game.replay()
      $('#replay_game').css('display', 'none')

