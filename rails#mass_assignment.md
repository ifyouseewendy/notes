## notes for railscasts.china [#008](railscasts-china.com/episodes/mass-assignment?autoplay=true "mass-assignment") about mass assignment ##

\# model layer

1. **black list**
    `attr_protected :admin`

2. **white list**
    `attr_accessible :name, :email`

3. **white list for all models**
`#config/application.rb
config.active_record.whitelist_attributes = true`

- - - 
\# controller layer

        class UsersController < ApplicationController
          ...
          def update
            @user = User.find(params[:id])
            if @user.update_attributes(user_params)
              flash[:notice] = "Update successfully."
              redirect_to @user
            else
              render :edit
            end
          end

          private
          def user_params
            params[:user].slice(:name, :email)
          end
        end
