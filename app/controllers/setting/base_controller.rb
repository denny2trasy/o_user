class Setting::BaseController < ApplicationController
  # before_filter :root_required
  # before_filter :find_role
  # cache_sweeper :setting_sweeper

  # protected
  # def find_role
  #   @role = Role.find_by_id(params[:role_id]||params[:id])
  # end
end
