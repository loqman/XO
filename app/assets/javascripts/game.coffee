# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on 'turbolinks:load', ->
  $('._Y6i').click ->
    $svg = $(this).find('.iM8ZRnQChF7I-rSO13xo9eCQ').drawsvg  duration: 150, stagger: 100
    $(this).find('.iM8ZRnQChF7I-rSO13xo9eCQ').css('display', '')
    $svg.drawsvg('animate')
