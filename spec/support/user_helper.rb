def login_as(user)
  controller.stub!('current_user').and_return(user)
end

def logout
  request.session.delete(:current_user_id)
end
