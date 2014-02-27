class BackroomAgreement
  @queue = :agreements_queue

  class << self

    def perform(method, args)
      args.symbolize_keys!
      with_logging method do
        self.new.send(method, args)
      end
    end

    def with_logging(method, &block)
      log("starting...", method)
      time = Benchmark.ms do
        yield block
      end

      log("completed in (%.1fms)" % [time], method)
    end

    def log(message, method = nil)
      now = Time.now.strftime("%Y-%m-%d %H:%M:%S")
      puts "#{now} %s#%s - #{message}" % [self.name, method]
    end

  end

  def handshake(args)
    agreement = Agreement.find(args[:agreement_id])
    agreement.handshake(args[:action], args[:args])
  end

  def settle(args)
    agreement = Agreement.find(args[:agreement_id])
    agreement.settle(args[:subject], args[:args])
  end

end
