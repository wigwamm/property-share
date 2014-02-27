class BackgroundAgreement
  @queue = :agreements_queue

  def self.perform(agreement_id, type, action, args)
    agreement = Agreement.find(agreement_id)
    agreement.send(type, action, args)
  end

end