require 'rails_helper'

module TagParams
  describe Reader do

    describe '#event_type' do
      let(:tag_param_reader) { Reader.new(params) }

      context 'primary tag matches event type' do
        let(:params) { { first_tag: 'breakfast' } }

        it 'is present' do
          expect(tag_param_reader.event_type).not_to be_nil
        end
      end

      context 'primary tag is not an event type' do
        let(:params) { { first_tag: 'vegan' } }

        it 'is not present' do
          expect(tag_param_reader.event_type).to be_nil
        end
      end

      context 'no primary tag' do
        let(:params) { {} }

        it 'is not present' do
          expect(tag_param_reader.event_type).to be_nil
        end
      end
    end

    describe '#diets' do
      let(:tag_param_reader) { Reader.new(params) }

      context 'primary tag matches diet' do
        context 'no other tags' do
          let(:params) { { first_tag: 'vegan' } }

          it 'contains a single diet' do
            expect(tag_param_reader.diets.size).to eq 1
          end
        end

        context 'has other tags' do
          context 'some match a diet' do
            let(:params) { { first_tag: 'vegan', tags: 'vegetarian,something else' } }

            it 'contains both diets' do
              expect(tag_param_reader.diets.size).to eq 2
            end
          end

          context 'none match diets' do
            let(:params) { { first_tag: 'vegan', tags: 'something else' } }

            it 'contains a single diet' do
              expect(tag_param_reader.diets.size).to eq 1
            end
          end
        end
      end

      context 'primary tag is not diet' do
        context 'no other tags' do
          let(:params) { { first_tag: 'breakfast' } }

          it 'is empty' do
            expect(tag_param_reader.diets).to be_empty
          end
        end

        context 'has other tags' do
          let(:params) { { first_tag: 'breakfast', tags: 'something else' } }

          it 'is empty' do
            expect(tag_param_reader.diets).to be_empty
          end
        end

      end

      context 'no primary tag' do
        context 'has other tags' do

          context 'some match a diet' do
            let(:params) { { tags: 'vegan,something else' } }

            it 'contains a single diet' do
              expect(tag_param_reader.diets.size).to eq 1
            end
          end

          context 'none match diets' do
            let(:params) { { tags: 'something,something else' } }

            it 'is empty' do
              expect(tag_param_reader.diets).to be_empty
            end
          end
        end

        context 'no other tags' do
          let(:params) { {} }

          it 'is empty' do
            expect(tag_param_reader.diets).to be_empty
          end
        end
      end
    end

    describe '#menu_tags' do
      let(:tags) { Reader.new(params).menu_tags }
      before do
        create(:menu_tag, tag: 'hot', is_filter: true)
        create(:menu_tag, tag: 'cold', is_filter: true)
        create(:menu_tag, tag: 'meh', is_filter: false)
      end

      context 'primary tag matches tag' do
        context 'no other tags' do
          let(:params) { { first_tag: 'hot' } }

          it 'contains a single tag' do
            expect(tags.size).to eq 1
          end
        end

        context 'is inactive' do
          let(:params) { { first_tag: 'meh' } }

          it 'contains a single tag' do
            expect(tags).to be_empty
          end
        end

        context 'has other tags' do
          context 'some match a tag' do
            let(:params) { { first_tag: 'hot', tags: 'cold,something else' } }

            it 'contains both tags' do
              expect(tags.size).to eq 2
            end
          end

          context 'none match tags' do
            let(:params) { { first_tag: 'hot', tags: 'something else' } }

            it 'contains a single tag' do
              expect(tags.size).to eq 1
            end
          end
        end
      end

      context 'primary tag is not tag' do
        context 'no other tags' do
          let(:params) { { first_tag: 'breakfast' } }

          it 'is empty' do
            expect(tags).to be_empty
          end
        end

        context 'has other tags' do
          let(:params) { { first_tag: 'breakfast', tags: 'vegan' } }

          it 'is empty' do
            expect(tags).to be_empty
          end
        end

      end

      context 'no primary tag' do
        context 'has other tags' do

          context 'some match a tag' do
            let(:params) { { tags: 'vegan,hot' } }

            it 'contains a single diet' do
              expect(tags.size).to eq 1
            end
          end

          context 'none match tags' do
            let(:params) { { tags: 'something,something else' } }

            it 'is empty' do
              expect(tags).to be_empty
            end
          end
        end

        context 'no other tags' do
          let(:params) { {} }

          it 'is empty' do
            expect(tags).to be_empty
          end
        end
      end
    end

    describe '#add_tag' do
      let(:params) { {} }
      let(:reader) { Reader.new(params) }

      it 'appends the tag to the params it uses' do
        reader.add_tag('vegan')
        expect(reader.diets).not_to be_empty
      end

      it 'does not overwrite the original params' do
        reader.add_tag('vegan')
        expect(params).to be_empty
      end
    end

    describe '#add_tag' do
      let(:params) { { first_tag: 'breakfast', tags: 'vegan' } }
      let(:reader) { Reader.new(params) }

      it 'removes tag from first tag' do
        reader.remove_tag('breakfast')
        expect(reader.event_type).to be_nil
      end

      it 'removes tag from other tags' do
        reader.remove_tag('vegan')
        expect(reader.diets).to be_empty
      end

      it 'does not overwrite the original first tag' do
        reader.remove_tag('breakfast')
        expect(params[:first_tag]).to eq 'breakfast'
      end

      it 'does not overwrite the other tags' do
        expect(params[:tags]).to eq 'vegan'
      end
    end

    describe 'includes_tag?' do
      let(:params) { { first_tag: 'breakfast', tags: 'vegan,hot' } }
      let(:reader) { Reader.new(params) }
      before do
        create(:menu_tag, tag: 'hot', is_filter: true)
      end

      it 'returns true for the event type' do
        expect(reader.includes_tag? 'breakfast').to be true
      end

      it 'returns true for the diet' do
        expect(reader.includes_tag? 'vegan').to be true
      end

      it 'returns true for the menu tag' do
        expect(reader.includes_tag? 'hot').to be true
      end

      it 'returns false for the tag that is not there' do
        expect(reader.includes_tag? 'nothing').to be false
      end
    end
  end
end
