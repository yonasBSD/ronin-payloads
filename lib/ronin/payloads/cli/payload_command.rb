#
# ronin-payloads - A Ruby micro-framework for writing and running exploit
# payloads.
#
# Copyright (c) 2007-2022 Hal Brodigan (postmodern.mod3 at gmail.com)
#
# ronin-payloads is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# ronin-payloads is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with ronin-payloads.  If not, see <https://www.gnu.org/licenses/>.
#

require 'ronin/payloads/cli/command'
require 'ronin/payloads/cli/payload_methods'
require 'ronin/core/cli/param_option'

module Ronin
  module Payloads
    class CLI
      #
      # Base class for all commands which load a payload.
      #
      class PayloadCommand < Command

        include Core::CLI::ParamOption
        include PayloadMethods

        usage '[options] NAME'

        option :file, short: '-f',
                      value: {
                        type: String,
                        usage: 'FILE'
                      },
                      desc: 'The payload file to load'

        argument :name, required: true,
                        desc:     'The payload name to load'

        # The loaded payload class.
        #
        # @return [Class<Payload>, nil]
        attr_reader :payload_class

        # The initialized payload object.
        #
        # @return [Payload, nil]
        attr_reader :payload

        #
        # Loads the payload and sets {#payload_class}.
        #
        # @param [String] id
        #   The payload name to load.
        #
        def load_payload(id)
          @payload_class = super(id,options[:file])
        end

        #
        # Initializes the payload and sets {#payload}.
        #
        # @param [Hash{Symbol => Object}] kwargs
        #   Additional keyword arguments for {Payload#initialize}.
        #
        def initialize_payload(**kwargs)
          @payload = super(@payload_class,**kwargs)
        end

        #
        # Validates the payload.
        #
        # @raise [Ronin::Core::Params::RequiredParam]
        #   One of the required params was not set.
        #
        # @raise [ValidationError]
        #   Another payload validation error occurred.
        #
        def validate_payload
          super(@payload)
        end

      end
    end
  end
end
