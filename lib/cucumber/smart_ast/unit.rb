require 'cucumber/ast/tags'
require 'cucumber/smart_ast/result'
require 'cucumber/smart_ast/listeners_broadcaster'

module Cucumber
  module SmartAst
    class Unit 
      attr_reader :steps, :language, :scenario

      def initialize(scenario)
        @scenario = scenario
        @language = scenario.language
        @steps    = scenario.all_steps
        @tags     = scenario.all_tags.map { |tag| "@#{tag.name}" }
        @statuses = []
      end
      
      def accept_hook?(hook)
        Cucumber::Ast::Tags.matches?(@tags, hook.tag_name_lists)
      end

      def status
        @statuses.last # Not really right, but good enough for now
      end
      
      def fail!(exception)
        puts "Unit failed!"
        raise exception
      end
      
      def execute(step_mother, listeners)
        listeners.before_unit(self)

        step_mother.before_and_after(self) do
          steps.each do |step|
            listeners.before_step(step)
            
            result = execute_step(step, step_mother)
            @statuses << result.status
            
            skip_step_execution! if result.failure?
            
            listeners.after_step(result)
          end
        end

        listeners.after_unit(self)
      end
      
      private
      
      def skip_step_execution!
        @skip = true
      end

      def execute_step(step, step_mother)
        Result.new(:skipped, step) if @skip
        step_mother.execute(step)
      end
    end
  end
end