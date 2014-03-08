module ApplicationHelper
  
  def time_zone_list
    ["UTC", "Beijing"] + ActiveSupport::TimeZone.us_zones.map(&:name)
  end
  
  def role_tag(role, profile)
    dom_id = "role_#{role.id}"
    %{<label for="#{dom_id}">
      #{check_box_tag(dom_id, role.id, profile.roles.include?(role) ) }
         #{role.name}
      </label><span id="span_#{dom_id}" class="green"></span>}
  end
  
  def role_list(&block)
    c = %{<div class="side300 vmenu2" style="border:1px #577BBF solid;">}
    c << roles(Role.roots, &block)
    c << "</div>"
  end
  
  def view_tabs(selected_index = 1, &block)
     concat(%{<div id="tabViews">})
     yield
     concat(%{</div>})
     unless @view_tab_names.blank?
       concat(%{<script type="text/javascript">
                 initTabs('tabViews',Array(#{@view_tab_names.join(",")}),#{(selected_index||1).to_i - 1}, '100%', '100%');
             </script>})
     end
   end

   def view_tab(title, &block)
     @view_tab_names ||= []
     @view_tab_names << "'#{title}'"
     concat(%{<div class="dhtmlgoodies_aTab">})
     yield
     concat(%{</div>})
   end
   
  private
   def roles(collection, &block)
     c = '<ul style="padding:5px;margin:0px 20px;">'
     collection.each do |role|
       c << %{<li#{" class='active'" if [params[:role_id].to_i, params[:id].to_i].include?(role.id)}>#{link_to role.name, yield(role)}}
       c << roles(role.children, &block) if role.children.size > 0
       c << %{</li>}
     end
     c << "</ul>"
   end
end
