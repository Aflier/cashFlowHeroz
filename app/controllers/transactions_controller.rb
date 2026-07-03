class TransactionsController < ApplicationController
  before_action :set_transaction, only: %i[ show edit update destroy duplicate ]

  load_and_authorize_resource :mission, parent_action: :update, only: [ :new, :create ]
  load_and_authorize_resource :transaction, through: :mission, shallow: true
  load_and_authorize_resource only: [ :update, :destroy ]
  # GET /transactions or /transactions.json
  def index
    @transactions = Transaction.all
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  # GET /transactions/new
  def new
    @mission = Mission.find(params[:mission_id])
    @transaction = @mission.transactions.build
    @path = [ @mission, @transaction ]
  end

  # GET /transactions/1/edit
  def edit
  end

  # POST /transactions or /transactions.json
  def create
    @mission = Mission.find(params[:mission_id])
    @transaction = @mission.transactions.new(transaction_params)

    respond_to do |format|
      if @transaction.save
        @transaction.calculate_cumulative_total
        format.html { redirect_to @transaction.mission, notice: "Transaction was successfully created." }
        format.json { render :show, status: :created, location: @transaction }
      else
        format.html { render :new, status: :unprocessable_content }
        format.turbo_stream do
          @path = [ @mission, @transaction ]
          render :new
        end
        format.json { render json: @transaction.errors, status: :unprocessable_content }
      end
    end
  end

  def duplicate
    transaction__new = @transaction.dup
    transaction__new.transaction_at = transaction__new.transaction_at + params[:months].to_i.month
    transaction__new.parent_id = @transaction.id
    transaction__new.save!

    redirect_to @transaction.mission
  end

  # PATCH/PUT /transactions/1 or /transactions/1.json
  def update
    respond_to do |format|
      if @transaction.update(transaction_params)
        @transaction.calculate_cumulative_total
        format.html { redirect_to @transaction.mission, notice: "Transaction was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @transaction }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.turbo_stream do
          render :edit
        end
        format.json { render json: @transaction.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /transactions/1 or /transactions/1.json
  def destroy
    @transaction.destroy!

    respond_to do |format|
      format.html { redirect_to @transaction.mission, notice: "Transaction was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_transaction
    @transaction = Transaction.find(params.expect(:id))
  end

  # Only allow a list of trusted parameters through.
  def transaction_params
    params.expect(transaction: [ :paid, :transaction_at, :why, :amount, :operation, :business_account_balance, :vatable, :vat, :mission_id ])
  end
end
