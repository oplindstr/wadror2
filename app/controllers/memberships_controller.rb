class MembershipsController < ApplicationController
  before_action :set_membership, only: [:show, :edit, :update]

  # GET /memberships
  # GET /memberships.json
  def index
    @memberships = Membership.all
  end

  # GET /memberships/1
  # GET /memberships/1.json
  def show
  end

  # GET /memberships/new
  def new
    @membership = Membership.new
    @beer_clubs = BeerClub.find_by_sql("Select * from beer_clubs where id
   not in (Select beer_club_id from memberships where user_id=#{current_user.id})")

  end

  # GET /memberships/1/edit
  def edit
  end

  # POST /memberships
  # POST /memberships.json
  def create
    @membership = Membership.new(membership_params)
    @beer_club = BeerClub.find(@membership.beer_club_id)

    respond_to do |format|
      if @membership.save
        format.html { redirect_to @beer_club, notice: 'Joined club successfully!.' }
        format.json { render action: 'show', status: :created, location: @membership }
      else
        format.html { render action: 'new' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /memberships/1
  # PATCH/PUT /memberships/1.json
  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @membership, notice: 'Membership was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @membership.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /memberships/1
  # DELETE /memberships/1.json
  def destroy
    @user = membership_params[:user_id]
    @beer_club = membership_params[:beer_club_id]
    @memberships = Membership.find_by_sql("Select * from memberships where beer_club_id=#{@beer_club} and user_id=#{@user}")
    @membership = @memberships.first
    @beer_club_name = @membership.beer_club.name

    @membership.destroy
    respond_to do |format|
      format.html { redirect_to current_user, notice: "Ended membership in #{@beer_club_name}" }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:beer_club_id, :user_id)
    end
end
