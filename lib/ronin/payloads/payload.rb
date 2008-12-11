#
#--
# Ronin Exploits - A Ruby library for Ronin that provides exploitation and
# payload crafting functionality.
#
# Copyright (c) 2007-2008 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#++
#

require 'ronin/payloads/ability'
require 'ronin/payloads/payload_author'
require 'ronin/object_context'
require 'ronin/license'

module Ronin
  module Payloads
    class Payload

      include ObjectContext

      objectify :payload

      # Name of the specific payload
      property :name, String, :index => true

      # Version of the payload
      property :version, String, :default => '0.1', :index => true

      # Description of the payload
      property :description, Text

      # Content license
      belongs_to :license

      # Author(s) of the payload
      has n, :authors, :class_name => 'PayloadAuthor'

      # Abilities the payload provides
      has n, :abilities

      # Validations
      validates_present :name
      validates_is_unique :version, :scope => [:name]

      # Encoders to apply to the payload
      attr_reader :encoders

      # Payload package
      attr_accessor :built_payload

      # Encoded payload package
      attr_accessor :encoded_payload

      #
      # Creates a new Payload object with the given _attributes_. If a
      # _block_ is given, it will be passed the newly created Payload
      # object.
      #
      def initialize(attributes={},&block)
        super(attributes)

        @encoders = []
        @is_built = false

        block.call(self) if block
      end

      #
      # Finds all payloads with names like the specified _name_.
      #
      def self.named(name)
        self.all(:name.like => "%#{name}%")
      end

      #
      # Finds all payloads with descriptions like the specified
      # _description_.
      #
      def self.describing(description)
        self.all(:description.like => "%#{description}%")
      end

      #
      # Finds the payload with the most recent vesion.
      #
      def self.latest
        self.first(:order => [:version.desc])
      end

      #
      # Adds a new Ability to the payload that provides the behavior
      # with the specified _name_.
      #
      def provides(name)
        self.abilities << Ability.new(
          :behavior => Vulnerability::Behavior.first_or_create(
            :name => name.to_s
          ),
          :payload => self
        )
      end

      #
      # Adds a new PayloadAuthor with the given _attributes_ and _block_.
      #
      def author(attributes={},&block)
        authors << PayloadAuthor.first_or_create(attributes,&block)
      end

      #
      # Add the specified _encoder_object_ to the encoders.
      #
      def encoder(encoder_object)
        @encoders << encoder_object
      end

      #
      # Default builder method.
      #
      def builder
      end

      #
      # Returns +true+ if the payload is built, returns +false+ otherwise.
      #
      def is_built?
        @is_built == true
      end

      #
      # Performs a clean build of the payload. If a _block_ is given, it
      # will be passed the built and encoded payload.
      #
      def build(&block)
        @is_built = false
        @built_payload = ''

        builder()

        @is_built = true
        @encoded_payload = @built_payload

        @encoders.each do |encoder|
          @encoded_payload = encoder.encode(@encoded_payload)
        end

        block.call(@encoded_payload) if block
        return @encoded_payload
      end

      #
      # Default method to call after the payload has been deployed.
      #
      def deploy(&block)
      end

      #
      # Returns a String form of the payload containing the payload's name
      # and version.
      #
      def to_s
        return "#{@name} #{@version}" if @version
        return @name.to_s
      end

    end
  end
end
