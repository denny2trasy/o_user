class Setting::RolesController < Setting::BaseController
  def show
    @role = Role.find_by_id(params[:id])
    # @profile_roles = ProfileRole.of_role(@role).combo_search(params, :include => :profile)
  end

  def destroy
    ProfileRole.find_by_id(params[:id]).try(:destroy)
    render :nothing => true
  end
end
