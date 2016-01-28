class PlansController < ApplicationController

  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @plans = Plan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @plans }
    end
  end

  def show
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @plan }
    end
  end


  def edit
  end


  def update
    respond_to do |format|
      if @plan.update(plan_params)
        format.html { redirect_to plans_path, notice: 'Plan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @plan.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_plan
      @plan = Plan.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def plan_params
      params.require(:plan).permit(:max_video_length_seconds, :total_video_space_minutes, :video_filters, :can_download, :video_quality, :youtube_share, :custom_watermark, :custom_header_graphic, :custom_footer_graphic, :video_analytics, :allow_uploads)
    end
end
