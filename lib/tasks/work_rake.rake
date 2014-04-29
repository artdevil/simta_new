task :update_waybill_status => :environment do
  SendSms.send_to_all
end