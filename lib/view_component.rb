# = View component for logicless templates
#
# Providet V layer to list of templates
# not exlusively in ruby language.
#
# Calling (rendering) component example:
#   # app/view/somethig/some.html.erb
#
#   <%= component('MainMenu', current_user: current_user) %>
#
# Rendering component means to call a class of the component to activon.
#
# Rails template example:
#   # app/component/main_menu_component.rb
#
#   class MainMenuComponent < ViewComponent::Base
#     def render
#       if curent_user
#         render_template('main_menu_component/app_menu')
#       else
#         render_template('main_menu_component/guest_menu')
#       end
#     end
#
#     def current_user_avatar_src
#       current_user.avatar || 'defaults/user_avatar.jpg'
#     end
#   end
#
#   # app/view/main_menu_component/app_menu.html.erb
#   <nav>
#     <a href="/dashboard">Dashboard</a>
#     <a href="/profile">Profile</a>
#     <a href="/logout">logout</a>
#     <img src="<%= current_user_avatar_src %>" />
#   </nav>
#
#   # app/view/main_menu_component/guest_menu.erb
#   <nav>
#     <a href="/login">Login</a>
#     <a href="/signup">Sing Up</a>
#   </nav>
#
# Reactjs example:
#   # app/component/main_menu_component.rb
#
#   Class MainMenuComponent < ViewComponent::Base
#     def render
#       render_react_element('MainMenu', current_user: current_user)
#     end
#   end
#
#   # makeup/js/components/MainMenu.jsx
#
#   var = MainMenu = React.createClass({
#     render: function() {
#       return(
#         <nav>
#           {this.prop.current_user ? <AppMenu /><LogoutLink /> <UserAvatar user={this.prop.current_user} /> : <LoginLink /><SignupLink />}
#         </nav>
#       );
#     }
#   });
#
module ViewComponent
end
