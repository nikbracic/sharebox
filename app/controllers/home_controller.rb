class HomeController < ApplicationController
  def index
    if user_signed_in?
      #show only root folders (which have no parent folders)
      @folders = current_user.folders.roots

      #show only root files which has no "folder_id"
      @assets = current_user.assets.where("folder_id is NULL").order("uploaded_file_file_name desc")
    end
  end

  #this action is for viewing folders
  def browse
    #first find the current folder within own folders
    @current_folder = current_user.folders.find_by_id(params[:folder_id])

    if @current_folder

      #show folders under this current folder
      @folders = @current_folder.children

      #show only files under this current folder
      @assets = @current_folder.assets.order("uploaded_file_file_name desc")

      render :action => "index"
    else
      flash[:error] = "Don't be cheeky! Mind your own assets!"
      redirect_to root_url
    end
  end
end