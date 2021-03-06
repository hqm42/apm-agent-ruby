# Licensed to Elasticsearch B.V. under one or more contributor
# license agreements. See the NOTICE file distributed with
# this work for additional information regarding copyright
# ownership. Elasticsearch B.V. licenses this file to you under
# the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

# frozen_string_literal: true

module ElasticAPM
  RSpec.describe Span::Context do
    describe 'initialize' do
      context 'with no args' do
        its(:db) { should be nil }
        its(:http) { should be nil }
      end

      context 'with db' do
        subject { described_class.new db: { statement: 'asd' } }

        it 'adds a db object' do
          expect(subject.db.statement).to eq 'asd'
        end
      end

      context 'with http' do
        subject { described_class.new http: { url: 'asd' } }

        it 'adds a http object' do
          expect(subject.http.url).to eq 'asd'
        end

        context 'when given auth info' do
          subject do
            described_class.new(
              http: { url: 'https://user%40email.com:pass@example.com/q=a@b' }
              #                         %40 => @
            )
          end

          it 'omits the password' do
            expect(subject.http.url).to eq 'https://user%40email.com@example.com/q=a@b'
          end
        end
      end

      context 'with destination' do
        subject do
          described_class.new(
            destination: { name: 'nam', resource: 'res', type: 'typ' }
          )
        end

        it 'adds a Destination object' do
          expect(subject.destination.name).to eq 'nam'
          expect(subject.destination.resource).to eq 'res'
          expect(subject.destination.type).to eq 'typ'
        end
      end
    end
  end
end
