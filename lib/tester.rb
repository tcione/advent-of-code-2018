# Module to make test declaration less repetitive
module Tester
  module_function

  def test_clause(expected:, result:)
    called_by = caller_locations(1, 1)[0].label
    return "#{called_by} PASSED" if expected == result

    <<-RS
      #{called_by} FAILED :-(.
      SHOULD BE: #{expected.inspect};
      IT IS: #{result.inspect}"
    RS
  end
end
