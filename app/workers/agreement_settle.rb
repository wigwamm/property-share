class AgreementSettle
  @queue = :agreements_queue

  def self.perform(agreement_id, subject, args)
    agreement = Agreement.find(agreement_id)
    agreement.settle(subject, args)
  end

end
