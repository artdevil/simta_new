class HardWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  recurrence {daily}

  def perform
    system 'rake update_waybill_status'
  end
end