require 'spec_helper'

module Turbine::Pipeline
  describe 'Pipeline' do
    context 'Transform -> Filter' do
      let(:pipeline) do
        pump      = Pump.new([1, 2, 3, 4, 5])
        transform = Transform.new { |x| x * 10 }
        filter    = Filter.new    { |x| x > 30 }

        (pump | transform | filter)
      end

      it 'runs the pipeline for each value' do
        expect(pipeline.next).to eql(40)
        expect(pipeline.next).to eql(50)
      end

      it 'does not return untransformed values' do
        array = pipeline.to_a

        [1, 2, 3, 4, 5].each do |source|
          expect(array).to_not include(source)
        end
      end

      it 'does not return filtered values' do
        array = pipeline.to_a

        [10, 20, 30].each do |source|
          expect(array).to_not include(source)
        end
      end
    end # Transform -> Filter

    context 'Filter -> Transform' do
      let(:pipeline) do
        pump      = Pump.new((40..50).to_a)
        filter    = Filter.new    { |x| x == 42 }
        transform = Transform.new { |x| x / 2 }

        (pump | filter | transform)
      end

      it 'runs the pipeline for each value' do
        expect(pipeline.next).to eql(21)
      end

      it 'does not return untransformed values' do
        array = pipeline.to_a

        (40..50).each do |source|
          expect(array).to_not include(source)
        end
      end
    end # Filter -> Transform
  end # Pipeline
end # Turbine::Pipeline