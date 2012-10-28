class Test
  def one
  end

  def if_test
    until bar
      foo
    end

    if foo
      bar
    end
  end

  private

  def two
  end
end
