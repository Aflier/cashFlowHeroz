class BanksController < ApplicationController
  before_action :set_bank, only: %i[ show edit update destroy ]

  # GET /banks or /banks.json
  def index
    @mission = Mission.find(params[:mission_id])
    @banks = Bank.all
  end

  # GET /banks/1 or /banks/1.json
  def show
  end

  # GET /banks/new
  def new
    @mission = Mission.find(params[:mission_id])
    @bank = Bank.new
  end

  # GET /banks/1/edit
  def edit
  end

  # POST /banks or /banks.json
  def create
    @mission = Mission.find(params[:mission_id])
    @bank = @mission.banks.new(bank_params)

    respond_to do |format|
      if @bank.save
        format.html { redirect_to mission_banks_path(@bank.mission), notice: "Bank was successfully created." }
        format.json { render :show, status: :created, location: @bank }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @bank.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /banks/1 or /banks/1.json
  def update
    respond_to do |format|
      if @bank.update(bank_params)
        format.html { redirect_to @bank, notice: "Bank was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @bank }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @bank.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /banks/1 or /banks/1.json
  def destroy
    @bank.destroy!

    respond_to do |format|
      format.html { redirect_to banks_path, notice: "Bank was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_bank
      @bank = Bank.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def bank_params
      params.expect(bank: [ :name, :starting_balance, :starting_balance_on, :current_balance, :current_balance_on, :mission_id ])
    end
end
