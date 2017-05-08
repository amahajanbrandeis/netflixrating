Rails.application.routes.draw do
  get 'welcome/index'
  post 'welcome/repopulate'

  get 'rating_chart/show'

  root 'welcome#index'

end
