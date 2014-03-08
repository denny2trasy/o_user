class Setting::LinkGroupsController < Setting::BaseController
  in_place_edit_for :link, :name_en, :name_zh, :app, :path, :target_page, :description_en, :description_zh
  in_place_edit_for :link_group, :name_en, :name_zh
  in_place_edit_for :link_group_link, :position

  def index
    if params[:role_id]
      @role = Role.find params[:role_id]
    end
  end
  
  def new
    render :layout => false
  end
    # 
    # def set_link_group_name_en
    # end

  def create
    @link_group = @role.link_groups.new(params[:link_group])
    if @link_group.save
      redirect_to setting_role_link_groups_path(@role)
    else
      render :action => :new, :layout => true
    end
  end

  def destroy
    LinkGroup.find_by_id(params[:id]).try(:destroy)
    redirect_to setting_role_link_groups_path(@role)
  end
end
