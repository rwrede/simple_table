module SimpleTable
  class Foot < Rows
    self.level = 1
    self.tag_name = :tfoot

    def render(*args)
      super(rows.map { |row| row.render(*args) })
    end
  end
end
