# == Schema Information
#
# Table name: app_builds
#
#  id         :integer          not null, primary key
#  level      :integer          not null
#  binary_url :string(255)      not null
#  version    :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class AppBuild < ActiveRecord::Base

  LEVEL_DEBUG = 0
  LEVEL_RELEASE = 1
  LEVEL_HOTFIX = 2

  class << self

    def debug
      AppBuild.where(level: LEVEL_DEBUG).first_or_initialize
    end

    def release
      AppBuild.where(level: LEVEL_RELEASE).first_or_initialize
    end

    def hotfix
      AppBuild.where(level: LEVEL_HOTFIX).first_or_initialize
    end

  end

  def level_name
    if level == LEVEL_DEBUG
      "debug"
    elsif level == LEVEL_HOTFIX
      "hotfix"
    else
      "release"
    end
  end

  def plist_url
    "plist"
  end

  def download_path(root)
    if level == LEVEL_DEBUG
      "https://" + root + "/app_builds/debug"
    elsif level == LEVEL_HOTFIX
      "https://" + root + "/app_builds/hotfix"
    else
      "https://" + root + "/app_builds/release"
    end
  end

end
