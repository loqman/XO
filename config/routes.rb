Rails.application.routes.draw do
  root to: 'players#new'
  resources :players
  match '/' => 'players#create', via: :post
  match '/games' => 'game#index', via: :get, as: 'game_index'
  match '/games/new' => 'game#new', via: :post, as: 'game_new'
  match '/games/error/full' => 'game#full', via: :get, as: 'game_error_full'
  match '/game/:id/play' => 'game#play', via: :get, as: 'game_play'
  match '/game/:id/is_current_player_turn' => 'game#is_current_player_turn', via: :get, as: 'game_is_current_player_turn'
  match '/game/:id/check_for_winner' => 'game#check_for_winner', via: :get, as: 'game_check_for_winner'
  match '/game/:id/turn_shape' => 'game#turn_shape', via: :get, as: 'game_turn_shape'
  match '/game/:id/player_score' => 'game#player_score', via: :get, as: 'game_player_score'
  match '/game/:id/new_round' => 'game#new_round', via: :get, as: 'game_new_round'

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
