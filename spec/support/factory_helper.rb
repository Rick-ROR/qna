module FactoryHelper
  def file_fixture(fixture_name)
    path = Pathname.new(Rails.root.join('spec/fixtures/files', fixture_name))

    if path.exist?
      path
    else
      msg = "the directory '%s' does not contain a file named '%s'"
      raise ArgumentError, msg % ['spec/fixtures/files', fixture_name]
    end
  end
end
