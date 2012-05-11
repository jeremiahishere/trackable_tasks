Rails.application.routes.draw do
  namespace :trackable_tasks do
    resources :task_runs
    root :to => "task_runs#stats", :as => :root
  end
end
