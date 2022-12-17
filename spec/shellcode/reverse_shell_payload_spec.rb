require 'spec_helper'
require 'ronin/payloads/shellcode/reverse_shell_payload'

describe Ronin::Payloads::Shellcode::ReverseShellPayload do
  module TestReverseShellPayload
    class TestReverseShell < Ronin::Payloads::Shellcode::ReverseShellPayload
    end
  end

  let(:host) { 'example.com' }
  let(:port) { 1337 }

  let(:payload_class) { TestReverseShellPayload::TestReverseShell }
  subject do
    payload_class.new(
      params: {
        host: host,
        port: port
      }
    )
  end

  it "must include Ronin::Payloads::Mixins::ReverseShell" do
    expect(described_class).to include(Ronin::Payloads::Mixins::ReverseShell)
  end

  it "must include Ronin::Payloads::Mixins::ResolveHost" do
    expect(described_class).to include(Ronin::Payloads::Mixins::ResolveHost)
  end

  it "must include Ronin::Payloads::Mixins::Network" do
    expect(described_class).to include(Ronin::Payloads::Mixins::Network)
  end

  describe "#packed_ipv4" do
    context "when the 'host' param has an IPv4 address" do
      it "must return the packed IPv4 address in network byte-order" do
        expect(subject.packed_ipv4).to eq(IPAddr.new('93.184.216.34').hton)
      end
    end

    context "when the 'host' param is an IPv4 address" do
      let(:host) { '1.2.3.4' }

      it "must return the packed IPv4 address in network byte-order" do
        expect(subject.packed_ipv4).to eq("\x01\x02\x03\x04".b)
      end
    end

    context "when the 'host' param is an IPv6 address" do
      let(:host) { '::1' }

      it do
        expect {
          subject.packed_ipv4
        }.to raise_error(Ronin::Payloads::ValidationError,"host must be a hostname or an IPv4 address, was an IPv6 address: #{host.inspect}")
      end
    end

    context "when the 'host' param has no IPv4 addresses" do
      let(:host) { 'ipv6.wtfismyip.com' }

      it do
        expect {
          subject.packed_ipv4
        }.to raise_error(Ronin::Payloads::BuildFailed,"host name has no IPv4 addresses: #{host.inspect}")
      end
    end
  end

  describe "#packed_ipv6" do
    context "when the 'host' param has an IPv6 address" do
      let(:host) { 'ipv6.wtfismyip.com' }

      it "must return the packed IPv6 address in network byte-order" do
        expect(subject.packed_ipv6).to eq(
          IPAddr.new('2607:5300:203:17db::6789').hton
        )
      end
    end

    context "when the 'host' param is an IPv4 address" do
      let(:host) { '1.2.3.4' }

      it "must return the packed IPv6-to-IPv4 address in network byte-order" do
        expect(subject.packed_ipv6).to eq(
          IPAddr.new("::ffff:#{host}").hton
        )
      end
    end

    context "when the 'host' param is an IPv6 address" do
      let(:host) { '::1' }

      it do
        expect(subject.packed_ipv6).to eq(
          "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01".b
        )
      end
    end

    context "when the 'host' param has no IPv6 addresses" do
      let(:host) { 'a.resolvers.level3.net' }

      it "must convert the IPv4 address to an IPv6-to-IPv4 address and return the packed IPv6-to-IPv4 address in network byte-order" do
        expect(subject.packed_ipv6).to eq(
          IPAddr.new("::ffff:4.2.2.1").hton
        )
      end
    end
  end

  describe "#packed_port" do
    let(:port) { 0xff00 }

    it "must return the packed port number as a 16bit integer in network byte-ordeR" do
      expect(subject.packed_port).to eq("\xff\x00".b)
    end
  end
end