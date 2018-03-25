require 'rails_helper'

describe PollResults do
  let(:poll_results) do
    PollResults.new(
      { poll_id: 0, poll_answer_id: 1, answer_text: 2, votes: 3 },
      [[
        '06adb15f-fadb-4ed7-9122-6d534e1925fc',
        'db3231cc-9aa0-4020-ab77-1f708aec4a46',
        'Yes',
        '1'
      ]]
    )
  end
  let(:results) { poll_results.collect { |result| result } }

  it 'enumerates hashes of the results' do
    expect(results).to include(
      poll_id: '06adb15f-fadb-4ed7-9122-6d534e1925fc',
      poll_answer_id: 'db3231cc-9aa0-4020-ab77-1f708aec4a46',
      answer_text: 'Yes',
      votes: '1'
    )
  end

  it 'returns the correct size' do
    expect(results.size).to eq 1
  end
end
