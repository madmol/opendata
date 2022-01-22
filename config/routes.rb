Rails.application.routes.draw do
  root to: 'organizations#index'

  resources :organizations, only: %i[show index destroy]

  get 'download' => 'organizations#download'

end
