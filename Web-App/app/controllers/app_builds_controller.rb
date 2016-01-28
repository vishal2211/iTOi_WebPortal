class AppBuildsController < ActionController::Base
  before_filter :authenticate_user!, :except => [:show, :manifest]
  layout 'application'

  def index

  end

  def create
    parse_build
  end

  def update
    parse_build
  end

  def show
    @build = nil
    if params[:id] == "debug"
      @build = AppBuild.debug
    elsif params[:id] == "hotfix"
      @build = AppBuild.hotfix
    else
      @build = AppBuild.release
    end
    render :layout => false
  end

  def manifest
    @build = nil
    if params[:id] == "debug"
      @build = AppBuild.debug
    elsif params[:id] == "hotfix"
      @build = AppBuild.hotfix
    else
      @build = AppBuild.release
    end
    render 'manifest', format: 'plist'
  end

  private

  def parse_build
    build = nil
    if params[:app_build][:level].to_i == AppBuild::LEVEL_DEBUG
      build = AppBuild.debug
    elsif params[:app_build][:level].to_i == AppBuild::LEVEL_HOTFIX
      build = AppBuild.hotfix
    else
      build = AppBuild.release
    end

    if params[:app_build][:binary]

      file = params[:app_build][:binary]
      s3 = AWS::S3.new
      bucket = s3.buckets[AWS_CONFIG['aws_bucket']]

      new_file_name = "#{Rails.env}/#{build.level_name}.ipa"

      bucket.objects[new_file_name].write(file.read, {:acl => :public_read, :cache_control => 'max-age=315569000', :content_type => file.content_type})
      s3url = "http://#{AWS_CONFIG['aws_bucket_url']}/#{new_file_name}"
      build.binary_url = s3url

      build.version = params[:app_build][:version]
      build.save

    end

    redirect_to app_builds_path

  end

end
