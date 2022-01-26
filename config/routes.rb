Rails.application.routes.draw do
  root to: 'organizations#index'

  concern :paginatable do
    get '(page/:page)', action: :index, on: :collection, as: ''
  end

  resources :organizations, only: %i[show destroy], concerns: :paginatable

  get 'download' => 'organizations#download'
  post 'reload' => 'organizations#reload'
end
