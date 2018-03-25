module Asset
  extend ActiveSupport::Concern

  def asset_exists?(file)
    if assets_precompiled?
      asset_path = ActionController::Base.helpers.asset_path(file)
      File.exist? File.join(Rails.public_path, asset_path)
    else
      !Rails.application.assets.find_asset(file).nil?
    end
  end

  def assets_precompiled?
    # If on-the-fly asset compilation is disabled,
    # we must be precompiling assets.
    !Rails.configuration.assets.compile rescue false
  end
end
