require "test_helper"
require "credit_card_detector/detector"

module CreditCardDetector
  describe Detector do
    describe "#valid?" do
      def perform(numbers, expected, *brands)
        numbers.each do |number|
          valid = Detector.new(number).valid?(*brands)
          assert_equal valid, expected, number
        end
      end

      it "validates valid numbers against all of the available brands" do
        VALID_NUMBERS.each do |_, numbers|
          perform numbers, true
        end
      end

      it "validates invalid numbers against all of the available brands" do
        perform INVALID_NUMBERS, false
      end

      it "returns true when numbers belong to the given brand" do
        visa = VALID_NUMBERS.fetch(:visa)
        perform visa, true, :visa
      end

      it "returns false when numbers belong to another brand" do
        mastercard = VALID_NUMBERS.fetch(:mastercard)
        perform mastercard, false, :visa
      end

      it "validates number against multiple brands" do
        visa = VALID_NUMBERS.fetch(:visa)
        mastercard = VALID_NUMBERS.fetch(:mastercard)
        maestro = VALID_NUMBERS.fetch(:maestro)

        perform (visa + maestro), true, :visa, :maestro, :jcb
        perform mastercard, false, :visa, :rupay
      end

      describe "when brand doesn't support luhn check" do
        it "returns true when number fails luhn check" do
          unionpay = VALID_NUMBERS.fetch(:unionpay)
          perform unionpay, true
        end
      end
    end
  end
end
