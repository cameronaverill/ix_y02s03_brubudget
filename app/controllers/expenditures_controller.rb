class ExpendituresController < ApplicationController
  before_action :require_login

  def require_login
    unless user_signed_in?
      flash[:error] = "You must be logged in to access this section"
      redirect_to new_login_url # halts request cycle
    end
  end

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
    @expenditure = Expenditure.find(params[:id])
  end

  def update
    @expenditure = Expenditure.find(params[:id])

    if @expenditure.update(expenditure_params)
      redirect_to @expenditure
    else
      render 'edit'
    end
  end

  def destroy
    @expenditure = Expenditure.find(params[:id])
    @expenditure.destroy

    redirect_to expenditures_path
  end

  private
    def expenditure_params
      params.require(:expenditure).permit(:name, :price, :quantity, :purchase_date)
    end
end
