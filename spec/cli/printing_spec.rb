require 'spec_helper'
require 'ronin/payloads/cli/printing'
require 'ronin/payloads/cli/command'

describe Ronin::Payloads::CLI::Printing do
  module TestCLIPrinting
    class TestCommand < Ronin::Payloads::CLI::Command
      include Ronin::Payloads::CLI::Printing
    end
  end

  let(:command_class) { TestCLIPrinting::TestCommand }
  subject { command_class.new }

  describe "#payload_type" do
    {
      Ronin::Payloads::HTMLPayload       => 'HTML',
      Ronin::Payloads::XMLPayload        => 'XML',
      Ronin::Payloads::SQLPayload        => 'SQL',
      Ronin::Payloads::ShellPayload      => 'shell',
      Ronin::Payloads::PowerShellPayload => 'PowerShell',
      Ronin::Payloads::CPayload          => 'C',
      Ronin::Payloads::JavaPayload       => 'Java',
      Ronin::Payloads::ColdFusionPayload => 'ColdFusion',
      Ronin::Payloads::PHPPayload        => 'PHP',
      Ronin::Payloads::ASMPayload        => 'ASM',
      Ronin::Payloads::ShellcodePayload  => 'shellcode',
      Ronin::Payloads::BinaryPayload     => 'binary',
      Ronin::Payloads::Payload           => 'custom'
    }.each do |payload_class,type|
      context "when the class inherits from #{payload_class}" do
        let(:klass) { Class.new(payload_class) }
        let(:type)  { type }

        it "must return '#{type}'" do
          expect(subject.payload_type(klass)).to eq(type)
        end
      end
    end

    context "when the class inherits from Ronin::Payloads::NodeJSPayload" do
      let(:klass) { Class.new(Ronin::Payloads::NodeJSPayload) }

      context "and it inherits Ronin::Payloads::Mixins::TypeScript" do
        let(:klass) do
          klass = super()
          klass.include Ronin::Payloads::Mixins::TypeScript
          klass
        end

        it "must return 'Node.js (TypeScript)'" do
          expect(subject.payload_type(klass)).to eq('Node.js (TypeScript)')
        end
      end

      context "otherwise" do
        it "must return 'Node.js'" do
          expect(subject.payload_type(klass)).to eq('Node.js')
        end
      end
    end

    context "when the class inherits from Ronin::Payloads::JavaScriptPayload" do
      let(:klass) { Class.new(Ronin::Payloads::JavaScriptPayload) }

      context "and it inherits Ronin::Payloads::Mixins::TypeScript" do
        let(:klass) do
          klass = super()
          klass.include Ronin::Payloads::Mixins::TypeScript
          klass
        end

        it "must return 'JavaScript (TypeScript)'" do
          expect(subject.payload_type(klass)).to eq('JavaScript (TypeScript)')
        end
      end

      context "otherwise" do
        it "must return 'JavaScript'" do
          expect(subject.payload_type(klass)).to eq('JavaScript')
        end
      end
    end
  end
end