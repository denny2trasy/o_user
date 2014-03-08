class Setting::RightsController < Setting::BaseController
  before_filter :find_right, :only => [:edit, :update, :destroy, :show]

  def new
    render :layout => false
  end

  def create
    ManuallyAddedRight.create(:name => params[:name], :parent_id => params[:parent_id])
    redirect_to setting_right_path(params[:parent_id])
  end
  
  def index
    @role = Role.find_by_id(params[:role_id]||params[:id])
    
    @right_lists = Right.eleutian_rights
    if params[:right_id]
      @right = Right.find params[:right_id]
    else
      @right = @right_lists.first || 0      
    end
    
  end
  
  def edit
    render :layout => false
  end

  def update
    @right.reset_roles(params[:role].keys)
    redirect_to :action => :index, :right_id => @right.root.id
  end

  def destroy
    @right.try(:destroy)
    render :nothing => true
  end

  def list
    render :layout => false
  end

  private
  def find_right
    @right = Right.find_by_id(params[:id])
  end
end
