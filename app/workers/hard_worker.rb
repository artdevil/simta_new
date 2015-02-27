class HardWorker
  include Sidekiq::Worker
  include Sidetiq::Schedulable
  recurrence {minutely(1)}

  def perform
    system 'rake update_waybill_status'
  end
end