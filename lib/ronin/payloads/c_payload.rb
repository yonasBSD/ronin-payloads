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

require 'ronin/payloads/payload'

module Ronin
  module Payloads
    #
    # A {Payload} class that represents all C payloads.
    #
    class CPayload < Payload

      #
      # The default C compiler.
      #
      # @return [String]
      #
      def self.cc
        ENV['CC'] || 'cc'
      end

      param :cc, required: true,
                 default:  ->{ cc },
                 desc:     'The C compiler to use'

      #
      # Compiles one or more source files using `cc`.
      #
      def compile(*source_files, output: , defs: nil)
        args = ['-o', output]

        if defs
          defs.each do |value|
            args << "-D#{value}"
          end
        end

        args.concat(source_files)

        system(params[:cc],*args)
      end

    end
  end
end