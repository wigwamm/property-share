class SnippetWorker  
  @queue = :snippets_queue

  class << self

    def perform(method, args)
      args = HashWithIndifferentAccess.new(args)
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

  def highlighter(args)
    snippet = Snippet.find(args[:id])  
    uri = URI.parse('http://pygments.appspot.com/')  
    request = Net::HTTP.post_form(uri, {'lang' => 
      snippet.language, 'code' => snippet.source_code})  
    snippet.update_attribute(:highlighted_code, request.body)  
  end  

end 