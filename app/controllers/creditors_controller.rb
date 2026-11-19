class CreditorsController < ApplicationController
  before_action :set_creditor, only: %i[ show edit update destroy ]

  # GET /creditors or /creditors.json
  def index
    @mission = Mission.find(params[:mission_id])
    @creditors = Creditor.all
  end

  # GET /creditors/1 or /creditors/1.json
  def show
  end

  # GET /creditors/new
  def new
    @mission = Mission.find(params[:mission_id])
    @creditor = Creditor.new
  end

  # GET /creditors/1/edit
  def edit
  end

  # POST /creditors or /creditors.json
  def create
    @mission = Mission.find(params[:mission_id])
    @creditor = @mission.creditors.new(creditor_params)

    respond_to do |format|
      if @creditor.save
        format.html { redirect_to mission_creditors_path(@creditor.mission), notice: "Creditor was successfully created." }
        format.json { render :show, status: :created, location: @creditor }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @creditor.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /creditors/1 or /creditors/1.json
  def update
    respond_to do |format|
      if @creditor.update(creditor_params)
        format.html { redirect_to @creditor, notice: "Creditor was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @creditor }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @creditor.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /creditors/1 or /creditors/1.json
  def destroy
    @creditor.destroy!

    respond_to do |format|
      format.html { redirect_to creditors_path, notice: "Creditor was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_creditor
      @creditor = Creditor.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def creditor_params
      params.expect(creditor: [ :name, :starting_balance, :starting_balance_on, :current_balance, :current_balance_on, :mission_id, :monthly_payment ])
    end
end
