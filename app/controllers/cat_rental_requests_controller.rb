class CatRentalRequestsController < ApplicationController

  def new
    @cat_rental_request = CatRentalRequest.new
    render :new
  end

  def create
    @cat_rental_request = CatRentalRequest.new(cat_rental_params)
    if @cat_rental_request.save
      redirect_to cat_url(@cat_rental_request.cat_id)
    else
      render :new
    end
  end

  def cat_rental_params
    params.require(:cat_rental_request).permit(:cat_id, :start_date, :end_date)
  end

  def approve
    @cat_rental_request = CatRentalRequest.find_by(id: params[:id])
    @cat_rental_request.approve!
    # if we don't redefine @cat_rental_request, #deny! doesn't do anything...?
    @cat_rental_request = CatRentalRequest.find_by(id: params[:id])
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end

  def deny
    @cat_rental_request = CatRentalRequest.find_by(id: params[:id])
    @cat_rental_request.deny!
    redirect_to cat_url(@cat_rental_request.cat_id)
  end
end
