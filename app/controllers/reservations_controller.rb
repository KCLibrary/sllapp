class ReservationsController < ApplicationController

  before_filter :authenticate_user!, :except => [ :available ]
  
  def available
    if params['sll-date']
      _date = params_to_date(params['sll-date']).to_formatted_s(:db)
      redirect_to available_reservations_path(_date) and return
    end
    
    @st = SllTime.new(params[:date].try(:to_date) || Date.today)
    
    respond_to do |format|
      format.html 
    end
  end
  
  def index
  
    @reservations = Reservation.where(:user_id => current_user.id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @reservations }
    end
  end

  # GET /reservations/1
  # GET /reservations/1.json
  def show
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/new
  # GET /reservations/new.json
  def new

    sll_times = params['sll-times'] || session['sll-times']    
    if sll_times.blank?
      redirect_to available_reservations_url, 
        :notice => 'Please select times first' and return
    end
    
    st = Time.parse(sll_times.first)
    et = Time.parse(sll_times.last).end_of_hour
        
    @reservation = Reservation.new({ 
      :start_datetime => st, 
      :end_datetime => et
    })

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @reservation }
    end
  end

  # GET /reservations/1/edit
  def edit
    @reservation = Reservation.find(params[:id])
  end

  # POST /reservations
  # POST /reservations.json
  def create
    @reservation = Reservation.new(params[:reservation])
    
    cu = current_user.try(:id)
    re = Resource.first_available(@reservation.start_datetime, @reservation.end_datetime).try(:id)
    
    unless re
      redirect_to available_reservations_url, 
        :notice => 'Sorry, no resources available for those times' and return
    end
    
    @reservation.assign_attributes(:user_id => cu, :resource_id => re)
    
    respond_to do |format|
      if @reservation.save
        format.html { redirect_to reservations_path, notice: 'Reservation was successfully created.' }
        format.json { render json: @reservation, status: :created, location: @reservation }
      else
        format.html { render action: "new" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /reservations/1
  # PUT /reservations/1.json
  def update
    @reservation = Reservation.find(params[:id])

    respond_to do |format|
      if @reservation.update_attributes(params[:reservation])
        format.html { redirect_to @reservation, notice: 'Reservation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @reservation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reservations/1
  # DELETE /reservations/1.json
  def destroy
    @reservation = Reservation.find(params[:id])
    authorize! :manage, @reservation
    @reservation.destroy

    respond_to do |format|
      format.html { redirect_to reservations_url }
      format.json { head :no_content }
    end
  end
  
  private
  
  def params_to_date(ph)
    Date.new(ph['year'].to_i, ph['month'].to_i, ph['day'].to_i) rescue nil
  end
  
end
