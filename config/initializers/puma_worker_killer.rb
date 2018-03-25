if Rails.env.production?
  PumaWorkerKiller.start
end
