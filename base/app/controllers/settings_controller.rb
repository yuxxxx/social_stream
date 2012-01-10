class SettingsController < ApplicationController
    
  before_filter :authenticate_user!
  
  def index
  end

  def update_all
    success = false

    #If no section selected, skips and gives error
    if params[:settings_section].present?
      section = params[:settings_section].to_s

      #Updating notifications settings
      if section.eql? "notifications"
        #Notify by email setting
        if params[:notify_by_email].present?
          notify_by_email = params[:notify_by_email].to_s
          current_subject.notify_by_email = false if notify_by_email.eql? "never"
          current_subject.notify_by_email = true if notify_by_email.eql? "always"
        end
      end

      #Updating language
      if section.eql? "language"
        #Preferred language setting
        if params[:language].present?
          lang = params[:language].to_s
          current_user.language = lang[0..1]
        end
      end

      #Here sections to add
      #if section.eql? "section_name"
      #   blah blah blah
      #end

      # Was everything ok?
      success = current_subject.save && current_user.save
    end

    #Flashing and redirecting
    if success
      flash[:success] = t('settings.success')
    else
      flash[:error] = t('settings.error')
    end
    # render :action => :index

    redirect_to settings_path
  end

end
