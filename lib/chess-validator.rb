module ChessValidator
  class MoveEvaluator
    # Ranks are numbers are rows, Files are letters are columns
    def evaluate(from, to)
      distance = to[1].to_i - from[1].to_i
      if distance != 3
        true
      else
        false
      end
    end
  end
end
