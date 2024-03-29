class UsersController < ApplicationController
  
  rescue_from ActiveRecord::RecordInvalid do
    render :action => "new"
  end

  def new
    @user = User.new
    @company = Company.new
    @location = Location.new
  end

  def create
    if params[:employee_registration] == 'false'
      
      @company = Company.new(company_params)
      @user = @company.users.new(user_params)
      @location = @company.locations.new(location_params)

      @user.save!
      @company.save!
      @location.save!

        if @company.save!
          @company.generate_serial
        end

      flash[:notice] = "Created new user!"
      redirect_to root_path

    else
      @user = User.new(user_params)

      @user.save!

      flash[:notice] = "Thank you! You've been registered as an employee"
      redirect_to root_path

    end

    auto_login(@user)


  end

  # Custom route to show user control panel. Different depending on if the current user is an employee or manager.
  def cp
    @user = current_user
  end


  def index
    if current_user && current_user.manager
      @users = User.all
    elsif current_user 
      redirect_to user_path(current_user)
    else
      redirect_to root_path
    end
  end

  def show
    @current_week = Date.today.beginning_of_week
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  def edit
     @user = current_user  
     @unavailabilities = @user.unavailabilities.build
  end


  private

  def user_params
    params.require(:user).permit(:fname, :lname, :email, :password, :image, :company_id, :address, :phone_number, :manager, :role)
  end

  def company_params
    params.require(:company).permit(:name)
  end

  def location_params
    params.require(:location).permit(:name, :address, :monday_open, :monday_close, :tuesday_open, :tuesday_close, :wednesday_open, :wednesday_close, :thursday_open, :thursday_close, :friday_open, :friday_close, :saturday_open, :saturday_close, :sunday_open, :sunday_close, )
  end


end
