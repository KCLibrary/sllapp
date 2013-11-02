class ReservationsController < ApplicationController

  before_filter :authenticate_user!, :except => [ :available ]
  
  def available
    if params['sll-date']
      _date = params_to_date(params['sll-date'])
      redirect_to available_reservations_path(_date) and return
    end
    
    @schedule = Sll::DailySchedule.new(params[:date])
    
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

  # GET /reservations/new
  # GET /reservations/new.json
  def new
    unless r = params['reservation-times'] || session['reservation-times']
      return select_times_first
    end
    resource_id = r.keys.first
    sll_times = r[resource_id] 
    return select_times_first if sll_times.blank?

    @reservation = Reservation.new({ 
      :start_datetime => Time.parse(sll_times.first), 
      :end_datetime => Time.parse(sll_times.last).end_of_hour,
      :resource_id => resource_id
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

    @reservation.assign_attributes(:user_id => current_user.try(:id))
    
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
  
  def select_times_first
    redirect_to available_reservations_url, 
      :notice => 'Please select times first'
  end
  
  def params_to_date(ph)
    Date.new(ph['year'].to_i, ph['month'].to_i, ph['day'].to_i).to_formatted_s(:db) rescue nil
  end
  
end
