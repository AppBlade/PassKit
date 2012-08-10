class IssuancesController < ApplicationController
  # GET /issuances
  # GET /issuances.json
  def index
    @issuances = Issuance.all

    @issuances_grouped = @issuances.group_by(&:instance)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @issuances }
    end
  end

  # GET /issuances/1
  # GET /issuances/1.json
  def show
    @issuance = Issuance.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @issuance }
			format.pkpass { send_file @issuance.path }
    end
  end

  # GET /issuances/new
  # GET /issuances/new.json
  def new
    @issuance = Issuance.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @issuance }
    end
  end

  # GET /issuances/1/edit
  def edit
    @issuance = Issuance.find(params[:id])
  end

  # POST /issuances
  # POST /issuances.json
  def create
    @issuance = Issuance.new(params[:issuance])

    respond_to do |format|
      if @issuance.save
        format.html { redirect_to @issuance, notice: 'Issuance was successfully created.' }
        format.json { render json: @issuance, status: :created, location: @issuance }
      else
        format.html { render action: "new" }
        format.json { render json: @issuance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /issuances/1
  # PUT /issuances/1.json
  def update
    @issuance = Issuance.find(params[:id])

    respond_to do |format|
      if @issuance.update_attributes(params[:issuance])
        format.html { redirect_to @issuance, notice: 'Issuance was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @issuance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /issuances/1
  # DELETE /issuances/1.json
  def destroy
    @issuance = Issuance.find(params[:id])
    @issuance.destroy

    respond_to do |format|
      format.html { redirect_to issuances_url }
      format.json { head :no_content }
    end
  end
end
