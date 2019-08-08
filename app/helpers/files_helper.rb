module FilesHelper
  def is_question?(resource)
    resource.is_a? Question
  end
end
