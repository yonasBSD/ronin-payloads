# frozen_string_literal: true
#
# ronin-payloads - A Ruby micro-framework for writing and running exploit
# payloads.
#
# Copyright (c) 2007-2025 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require 'ronin/payloads/encoders/html_encoder'
require 'ronin/support/encoding/html'

module Ronin
  module Payloads
    module Encoders
      module HTML
        #
        # A HTML encoder that encodes every character in the given String as an
        # HTML special character.
        #
        class Encode < HTMLEncoder

          register 'html/encode'

          summary 'Encodes every character as a HTML special character'

          description <<~DESC
            Encodes every character in the given String as an HTML special character:

              hello world -> &#104;&#101;&#108;&#108;&#111;&#32;&#119;&#111;&#114;&#108;&#100;

          DESC

          #
          # HTML encodes the given data.
          #
          # @param [String] data
          #
          # @return [String]
          #
          def encode(data)
            Support::Encoding::HTML.encode(data)
          end

        end
      end
    end
  end
end
