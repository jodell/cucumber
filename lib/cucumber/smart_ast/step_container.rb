require 'cucumber/smart_ast/comments'
require 'cucumber/smart_ast/tags'
require 'cucumber/smart_ast/step'

module Cucumber
  module SmartAst
    class StepContainer
      attr_accessor :steps
      attr_reader :kw, :description, :line

      def initialize(kw, description, line, parent)
        @kw, @description, @line, @parent = kw, description, line, parent
        @steps = []
      end

      def steps
        @steps ||= []
      end

      def table(table)
        steps.last.argument = table
      end

      def py_string(py_string)
        steps.last.argument = py_string
      end         

      def language
        @parent.language
      end
    end
  end
end