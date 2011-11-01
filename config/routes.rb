Rails.application.routes.draw do
  namespace :trackable_tasks do
    resources :task_runs
  end
end