class AgreementHandshake
  @queue = :agreements_queue

  def self.perform(agreement_id, action, args)
    agreement = Agreement.find(agreement_id)
    agreement.handshake(action, args)
  end

end
