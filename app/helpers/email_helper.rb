module EmailHelper
  def error_def(email, attribute)
    result_string = ""
    if email.errors.invalid?(attribute)
      email.errors[attribute].each do |msg|
        result_string << '<dd class="error">'
        result_string << msg
        result_string << '</dd>'
      end
    end
    return result_string
  end
end
