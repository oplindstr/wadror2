class BreweriesController < ApplicationController
  before_action :set_brewery, only: [:show, :edit, :update, :destroy, :toggle_activity]
  before_action :ensure_that_signed_in, except: [:index, :show, :list]
  before_action :ensure_that_admin, only: [:destroy]
  before_action :expire, only: [:create, :update, :destroy]
  before_action :skip_if_cached, only: [:index]

  # GET /breweries
  # GET /breweries.json
  def index
    @breweries = Brewery.all
    @active_breweries = Brewery.active
    @retired_breweries = Brewery.retired

    @order = params[:order] || 'name'

    @active_breweries = order(@active_breweries)
    @retired_breweries= order(@retired_breweries)
    if session[:ordered].nil?
      session[:ordered] = 1
    else
      session[:ordered] = nil
    end
  end

  def list
  end

  def toggle_activity
    @brewery.active = (not @brewery.active)
    @brewery.save

    if @brewery.active
      redirect_to @brewery, notice: 'Brewery activated!'
    else
      redirect_to @brewery, notice: 'Brewery deactivated!'
    end
  end

  # GET /breweries/1
  # GET /breweries/1.json
  def show
    @ratings = @brewery.ratings
    if !@ratings.empty?
      @average = @brewery.average_rating
    end
  end

  # GET /breweries/new
  def new
    @brewery = Brewery.new
  end

  # GET /breweries/1/edit
  def edit
  end

  # POST /breweries
  # POST /breweries.json
  def create
    @brewery = Brewery.new(brewery_params)

    respond_to do |format|
      if @brewery.save
        format.html { redirect_to @brewery, notice: 'Brewery was successfully created.' }
        format.json { render action: 'show', status: :created, location: @brewery }
      else
        format.html { render action: 'new' }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /breweries/1
  # PATCH/PUT /breweries/1.json
  def update
    respond_to do |format|
      if @brewery.update(brewery_params)
        format.html { redirect_to @brewery, notice: 'Brewery was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @brewery.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /breweries/1
  # DELETE /breweries/1.json
  def destroy
    @brewery.destroy
    respond_to do |format|
      format.html { redirect_to breweries_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_brewery
      @brewery = Brewery.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def brewery_params
      params.require(:brewery).permit(:name, :year, :active)
    end

    def order(list)
      order = params[:order] || 'name'

      if session[:ordered].nil?
        list = case order
        when 'name' then list.sort_by{ |b| b.name }
        when 'year' then list.sort_by{ |b| b.year }
        end
      else
        list = case order
        when 'name' then list.sort_by{ |b| b.name }.reverse
        when 'year' then list.sort_by{ |b| b.year }.reverse
        end
      end
      return list
    end

    def expire
      expire_fragment('brewerylist-name')
      expire_fragment('brewerylist-year')
    end

    def skip_if_cached
      @order = params[:order] || 'name'
      return render :index if fragment_exist?("brewerylist-#{@order}")
    end
end
