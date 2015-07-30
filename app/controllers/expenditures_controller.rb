class ExpendituresController < ApplicationController
  before_action :require_login, only: [:edit, :destroy, :update]

  def index
    @expenditures = Expenditure.all.order(purchase_date: :desc)
  end

  def new
    @expenditure = Expenditure.new
  end

  def create
    @expenditure = Expenditure.new(expenditure_params)
    @expenditure.update user_id: current_user.id
    if @expenditure.save
      redirect_to expenditure_path(@expenditure)
    else
      redirect_to new_expenditure_path
    end
  end

  def show
    @expenditure = Expenditure.find(params[:id])
  end

  def edit
      @expenditure = current_user.expenditures.find(params[:id])
  end

  def update
      @expenditure = current_user.expenditures.find(params[:id])
      if current_user.id == @expenditure.user_id
        if @expenditure.update(expenditure_params)
          redirect_to @expenditure
        else
          render 'edit'
        end
      end
  end

  def destroy
    @expenditure = current_user.expenditures.find(params[:id])

    if current_user.id == @expenditure.user_id 
    @expenditure.destroy

    redirect_to expenditures_path
  end
  end

  private

  def require_login

    #you can do .user and it returns the user
    unless current_user == Expenditure.find(params[:id]).user
      flash[:error] = "You must be logged in to access this section"
      redirect_to expenditures_path # halts request cycle
    end
  end

    def expenditure_params
      params.require(:expenditure).permit(:name, :price, :quantity, :purchase_date)
    end


end
