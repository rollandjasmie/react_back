class PromotionsController < ApplicationController
  before_action :authorized, only: [:create, :update, :destroy]
  before_action :set_promotion, only: [:show, :update, :destroy]

  # GET /promotions
  def index
    @promotions = Promotion.where(logement_id:params[:logement_id])
    render json: {promotion:@promotions}
  end

  # GET /promotions/1
  def show
    render json: @promotion
  end

  # POST /promotions
  def create
    @promotion = Promotion.new(types:params[:types], temps:params[:temps], reduction:params[:reduction], datedebut:params[:datedebut], datefin:params[:datefin], name_promotion:params[:name_promotion], datevuedebut:params[:datevuedebut], datevuefin:params[:datevuefin])
    @promotion.logement_id = params[:logement_id]
    if @promotion.save
      render json: {promotion:@promotion}
    else
      render json: @promotion.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /promotions/1
  def update
    if @promotion.update(promotion_params)
      render json: @promotion
    else
      render json: @promotion.errors, status: :unprocessable_entity
    end
  end

  # DELETE /promotions/1
  def destroy
    @promotion.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_promotion
      @promotion = Promotion.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def promotion_params
      params.require(:promotion).permit(:types, :vu, :temps, :reduction, :datedebut, :datefin, :name_promotion, :datevuedebut, :datevuefin)
    end
end
