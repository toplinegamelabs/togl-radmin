class ContestSeedsController < ApplicationController
  before_filter :require_user
  before_filter :get_games, except: [:index, :destroy]
  def index
    @contest_seeds = ContestSeed.all.sort_by do |contest_seed|
      [contest_seed.game_identifier, contest_seed.size, contest_seed.buy_in]
    end
  end

  def new
    @contest_seed = ContestSeed.new
  end

  def create
    @contest_seed = ContestSeed.new(params[:contest_seed].permit(:game_identifier, :size, :buy_in, :minutes_before_lock_cutoff))
    if @contest_seed.save
      flash.keep[:notice] = "Contest seed created!"
      redirect_to contest_seeds_path
    else
      flash.now[:error] = @contest_seed.errors.full_messages.join(", ")
      render :new
    end
  end

  def edit
    @contest_seed = ContestSeed.find(params[:id])
  end

  def update
    @contest_seed = ContestSeed.find(params[:id])
    @contest_seed.update(params[:contest_seed].permit(:game_identifier, :size, :buy_in, :minutes_before_lock_cutoff))
    if @contest_seed.save
      flash.keep[:notice] = "Contest seed updated!"
      redirect_to contest_seeds_path
    else
      flash.now[:error] = @contest_seed.errors.full_messages.join(", ")
      render :new
    end
  end

  def destroy
    @contest_seed = ContestSeed.find(params[:id])
    @contest_seed.destroy!
    flash.keep[:notice] = "Contest seed DESTROYED!"
    redirect_to contest_seeds_path
  end

private
  def get_games
    rapi_response = RapiManager.new.list_games
    @games = rapi_response["games"].collect do |game|
      game["identifier"]
    end
  end
end
