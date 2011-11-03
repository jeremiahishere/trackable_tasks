module NavigationHelpers
  # Maps a name to a path. Used by the
  #
  #   When /^I go to (.+)$/ do |page_name|
  #
  # step definition in web_steps.rb
  #
  def path_to(page_name)
    case page_name

    when /the [h|H]ome\s?page/
           '/'
    when /the task_run index page/
           trackable_tasks_task_runs_path
    when /the task_run show page/
           trackable_tasks_task_runs_path
    #     when /the Log\s?out page/
    #       '/logout'
    # 
    #     when /the u_staff \- homepage/
    #       u_staff_homepage_path
    #     when /the provider_network dashboard/
    #       '/provider_network'
    # 
    #     when /the u_staff \- job_position terminate page for that job position/
    #       u_staff_job_position_terminate_path(JobPosition.last)
    #     when /the u_staff \- job_position transfer page for that job position/
    #       u_staff_job_position_transfer_path(JobPosition.last)
    # 
    #     # in a weird situation here because the models are namespaces
    #     # there is a good change we can use 'email_manager \- email manager managed email'
    #     # to remove this path
    #     when /the email_manager \- managed_email view page for that email manager managed email/
    #       email_manager_managed_email_path(EmailManager::ManagedEmail.last)
    # 
    # 
    #     # ************* IMPORTANT ************************
    #     # The following path steps are for models that aren't namespaced connected 
    #     # to controllers that are namespaced.  This should only be the case for the
    #     # uStaff and Administration models.  All future models should have the same
    #     # namespacing as controllers or some sort of custom path.
    #     #
    #     # Note that we are reading the namespace separately and passing it to polymorphic
    #     # path.  This system is defined by the namespace - model syntax.
    # 
    #     # note the weird hack when matching the model
    #     # in almost every case, it should match only the plural version of the model
    #     # but in the person model, it needs to match people with no plural
    #     when /^the (.+?) \- (.+?[s]*)(?:'s)? index page$/                     
    #       polymorphic_path([$1.to_sym, $2.to_sym])
    # 
    #     when /^the (.+?) \- #{capture_model}(?:'s)? view page for #{capture_model}$/           
    #       polymorphic_path([$1.to_sym, model!($3)])                       
    # 
    #     when /^the (.+?) \- #{capture_model}(?:'s)? edit page for #{capture_model}$/           
    #       polymorphic_path([$1.to_sym, model!($3)], :action => "edit")                       
    # 
    #     # due to pickle limitations, we can't use polymorphic path
    #     # this is better than manually writing out all the new page paths
    #     # but prone to breaking
    #     when /^the (.+?) \- (.+?)(?:'s)? new page$/           
    #       eval("new_" + $1 + "_" + $2.singularize + "_path")
    # 
    #     when /^the (.+?) \- #{capture_model}(?:'s)? (.+?) page$/  
    #       polymorphic_path([$1.to_sym, model!($2)], :action => $3)
    # 
    # 
    #     # ********************** IMPORTANT ************************
    #     # The following path steps are for models that are namespaced with controllers
    #     # that are namespaced.  This should be for all namespaces created after uStaff
    #     # and Administration ncluding the case system.
    #     #
    #     # Instead of specifying a custom model system, we will just use pickle's capture_model
    #     # to determine which model has been selected.
    # 
    #     when /^the #{capture_model} index page$/                     
    #       polymorphic_path($1.pluralize.to_sym)
    # 
    #     when /^the #{capture_model}(?:'s)? view page for #{capture_model}$/           
    #       polymorphic_path(model!($2))                       
    # 
    #     when /^the #{capture_model}(?:'s)? edit page for #{capture_model}$/           
    #       polymorphic_path(model!($2), :action => "edit")                       
    # 
    #     # due to pickle limitations, we can't use polymorphic path
    #     # this is better than manually writing out all the new page paths
    #     # but prone to breaking
    #     when /^the (.+?)(?:'s)? new page$/           
    #       model = $1.singularize.gsub(/\s/, "_").to_sym
    #       polymorphic_path(model, :action => "new")
    # 
    #     when /^the #{capture_model}(?:'s)? (.+?) page$/  
    #       polymorphic_path(model!($1), :action => $2)
    # 
    else
      begin
        page_name =~ /the (.*) page/
        path_components = $1.split(/\s+/)
        self.send(path_components.push('path').join('_').to_sym)
      rescue Object => e
        raise "Can't find mapping from \"#{page_name}\" to a path.\n" +
          "Now, go and add a mapping in #{__FILE__}"
      end
    end
  end
end

World(NavigationHelpers)
